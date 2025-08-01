import { PreView, SwiperParams } from '../utils/PreView';
import { UIContext } from '@kit.ArkUI';
import { BasicParkInfo, CollectUtil, DetailParkInfo, RouterMap, RouterModule } from 'commonlib';
import { Https } from 'network';

@ObservedV2
export class SiteDetailPageVM {
  @Trace detail?: DetailParkInfo;
  @Trace swiperParams?: SwiperParams;
  @Trace swiperIndex: number = 0;
  @Trace isCollect: boolean = false;
  private static _instance: SiteDetailPageVM;

  public static get instance() {
    if (!SiteDetailPageVM._instance) {
      SiteDetailPageVM._instance = new SiteDetailPageVM();
    }
    return SiteDetailPageVM._instance;
  }

  /**
   * 初始化
   * 1.重置参数
   * 2.获取详情
   * 3.更新预览图
   */
  public init(ctx: UIContext) {
    this._resetData();
    this._getDetail().then(() => {
      this.swiperParams = new SwiperParams(this.detail!.basicPic, 0);
      this.swiperParams.slideDown = () => {
        PreView.closeDialog();
      };
      this.swiperParams.change = (index: number) => {
        this.swiperIndex = index;
      };
      PreView.init(ctx, this.swiperParams);
    });
  }

  /** 收藏 or 取消 **/
  public collectOrCancel() {
    if (!this.isCollect) {
      const basic = RouterModule.getNavParam({ url: RouterMap.SITE_DETAIL }) as BasicParkInfo;
      CollectUtil.addCollect(basic);
    } else {
      CollectUtil.cancelCollect(this.detail!.siteId);
    }
    this.isCollect = !this.isCollect;
  }

  /** 重置详情页面参数 **/
  private _resetData() {
    this.swiperIndex = 0;
    this.isCollect = false;
    this.detail = undefined;
  }

  /** 获取停车场详情 **/
  private async _getDetail() {
    const basic = RouterModule.getNavParam({ url: RouterMap.SITE_DETAIL }) as BasicParkInfo;
    this.isCollect = CollectUtil.isCollected(basic.siteId);
    const res = await Https.getParkingDetail({ id: basic.siteId });
    // mock数据-前后保持一致
    this.detail = {
      siteId: basic.siteId,
      name: basic.name,
      addr: basic.addr,
      location: basic.location,
      distance: basic.distance,
      totalSpots: basic.totalSpots,
      leftSpots: basic.leftSpots,
      chargeSpots: basic.chargeSpots,
      leftChargeSpots: basic.leftChargeSpots,
      basicPic: res.data.basicPic,
      parkTime: res.data.parkTime,
      phone: res.data.phone,
      payType: res.data.payType,
      chargeRules: res.data.chargeRules,
    };
  }
}