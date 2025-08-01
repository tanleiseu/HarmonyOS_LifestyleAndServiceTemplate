import {
  AddressUtil,
  BasicParkInfo,
  CollectListModel,
  CollectUtil,
  CommonAddressListModel,
  CommonUtil,
  LicenseModel,
  LicenseUtil,
  LocationStatus,
  LocationUtil,
  Logger,
  WidgetUtil,
} from 'commonlib';
import {
  AllCommonAddressesResp,
  AllLicenseInfoResp,
  BaseResponse,
  GetDefaultLicenseNumberResp,
  GetHomePageBannerResp,
  getId,
  Https,
} from 'network';
import { mapCommon, site } from '@kit.MapKit';
import { common } from '@kit.AbilityKit';

const TAG = '[HomePageVM]';

@ObservedV2
export class HomePageVM {
  // banner
  @Trace banner: ResourceStr = '';
  // 车牌信息
  @Trace licenseInfo: LicenseModel = LicenseUtil.getLicenseInfo();
  // 常去地址
  @Trace commonAddresses: CommonAddressListModel = AddressUtil.getCommonAddresses();
  // 附件停车场
  @Trace nearbyList: BasicParkInfo[] = [];
  // 收藏停车场
  @Trace collectList: CollectListModel = CollectUtil.getCollectList();
  @Trace refreshing: boolean = false;
  private _limit: number = 60000;
  private _count: number = -1;
  private _timer: number = -1;
  private static _instance: HomePageVM;

  public static get instance() {
    if (!HomePageVM._instance) {
      HomePageVM._instance = new HomePageVM();
    }
    return HomePageVM._instance;
  }

  @Monitor('licenseInfo.default')
  private _defaultChange() {
    WidgetUtil.updateWidgetsWhenChange(getContext(), true);
  }

  /**
   * 初始化
   * 1.获取首页配置
   * 2.搜索附近停车场
   */
  public init() {
    this._handleHomePageConfig();
    this._getNearBySpots();
  }

  /** 删除车牌 **/
  public async deleteLicense(license: string) {
    const res = await Https.deleteOldLicenseNumber({ id: getId(), old: license });
    if (res.code === 0) {
      LicenseUtil.deleteLicense(license);
    }
  }

  /** 查询车辆入场 **/
  public async queryParking(license: string) {
    const res = await Https.queryParking({ id: getId(), license: license });
    if (res.code === 0) {
      return res.data.info?.pop();
    }
    return undefined;
  }

  /** 刷新获取附近停车场 **/
  public refreshNewNearby() {
    if (this._timer > 0) {
      let timerTemp = setTimeout(() => {
        this.refreshing = false;
        clearTimeout(timerTemp);
      }, 1000);
      return;
    }
    this._getNearBySpots(() => {
      this.refreshing = false;
      this._count = this._limit;
      this._timer = setInterval(() => {
        this._count -= 1000;
        if (this._count === 0) {
          clearInterval(this._timer);
          this._timer = -1;
        }
      }, 1000)
    })
  }

  /** 处理首页相关配置 **/
  private async _handleHomePageConfig() {
    const promises = [
      Https.getHomePageBanner(),
      Https.getLicenseNumbers(),
      Https.getDefaultLicenseNumber(),
      Https.getCommonAddresses(),
    ];
    const results = await Promise.allSettled(promises);
    results.forEach((res, index) => {
      switch (index) {
        case 0:
          const res0 = res as PromiseSettledResult<BaseResponse<GetHomePageBannerResp>>;
          if (res0.status === 'fulfilled' && res0.value.code === 0) {
            this.banner = res0.value.data.banner;
          }
          break;
        case 1:
          const res1 = res as PromiseSettledResult<BaseResponse<AllLicenseInfoResp>>;
          if (res1.status === 'fulfilled' && res1.value.code === 0) {
            LicenseUtil.updateAllLicenses(res1.value.data.licenses);
          }
          break;
        case 2:
          const res2 = res as PromiseSettledResult<BaseResponse<GetDefaultLicenseNumberResp>>;
          if (res2.status === 'fulfilled' && res2.value.code === 0) {
            LicenseUtil.updateDefaultLicense(res2.value.data.default);
          }
          break;
        case 3:
          const res3 = res as PromiseSettledResult<BaseResponse<AllCommonAddressesResp>>;
          if (res3.status === 'fulfilled' && res3.value.code === 0) {
            AddressUtil.initAddress(res3.value.data.addresses);
          }
          break;
        default:
          break;
      }
    });
  }

  /** 获取附近停车场 **/
  private _getNearBySpots(callback?: () => void) {
    const ctx = getContext() as common.UIAbilityContext;
    LocationUtil.getGCJ02Location(ctx).then(res => {
      if (res.result === LocationStatus.SUCCESS && res.gcj02LatLng) {
        this._searchParking(res.gcj02LatLng).then(callback);
      }
    });
  }

  /** 搜索附件停车场 **/
  private async _searchParking(center: mapCommon.LatLng) {
    try {
      let params: site.SearchByTextParams = {
        query: '停车场',
        location: center,
        poiTypes: ['PARKING_LOT'],
        language: 'zh',
      };
      const result = await site.searchByText(params);
      if (result.sites) {
        const newSpots: BasicParkInfo[] = [];
        // mock 车位信息
        for (let i = 0; i < result.sites.length; i++) {
          const item = result.sites[i];
          const distance = await LocationUtil.calDistanceFromMy(item.location!);
          const totalSpots = CommonUtil.generateRandomInRange(30, 50);
          const leftSpots = CommonUtil.generateRandomInRange(0, totalSpots);
          let chargeSpots = 0;
          let leftChargeSpots = 0;
          const canCharge = CommonUtil.generateRandomBoolean();
          if (canCharge) {
            chargeSpots = Math.floor(totalSpots / CommonUtil.generateRandomInRange(2, 3));
            leftChargeSpots = CommonUtil.generateRandomInRange(0, Math.min(leftSpots, chargeSpots));
          }
          const spot = {
            siteId: item.siteId,
            name: item.name,
            addr: item.formatAddress,
            location: item.location,
            distance: distance,
            totalSpots: totalSpots,
            leftSpots: leftSpots,
            chargeSpots: chargeSpots,
            leftChargeSpots: leftChargeSpots,
          } as BasicParkInfo;
          newSpots.push(spot);
        }
        this.nearbyList = newSpots;
        Logger.info(TAG, 'Succeeded in searching by text.');
      }
    } catch (error) {
      Logger.error(TAG, 'Failed in searching by text:' + JSON.stringify(error));
    }
  }
}