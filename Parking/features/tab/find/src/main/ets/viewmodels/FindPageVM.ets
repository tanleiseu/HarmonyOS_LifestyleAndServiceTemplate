import { map, mapCommon, site } from '@kit.MapKit';
import { AsyncCallback, emitter } from '@kit.BasicServicesKit';
import { EmitterConstants } from 'commonlib/src/main/ets/constants/CommonContants';
import {
  AddressModel,
  AppStorageMap,
  BasicParkInfo,
  CommonUtil,
  LocationStatus,
  LocationUtil,
  Logger,
} from 'commonlib';
import { common } from '@kit.AbilityKit';

const TAG = '[FindPageVM]';

@ObservedV2
export class FindPageVM {
  // 地图中心
  @Trace center: mapCommon.LatLng = { latitude: 39.9, longitude: 116.4 };
  // 查询地点
  @Trace query: string = '';
  // 附近停车场
  @Trace spots: BasicParkInfo[] = [];
  // 排序停车场
  @Trace sortedSpots: BasicParkInfo[] = [];
  // 选中停车场
  @Trace selectedSpot: BasicParkInfo | undefined = undefined;
  // 排序方式(0-距离近;1-空位多)
  @Trace sort: number = 0;
  // 当前列表索引
  @Trace curIndex: number = 0;
  // 标记点
  marks: map.Marker[] = [];
  // 选中标记点
  selectedMark: map.Marker | undefined = undefined;
  controller: Scroller = new Scroller();

  @Monitor('spots', 'sort')
  private _sortedSpotsChange() {
    const newSortedSpots = [...this.spots];
    newSortedSpots.sort((a, b) => this.sort ? b.leftSpots - a.leftSpots : a.distance - b.distance);
    this.sortedSpots = newSortedSpots;
  }

  // 地图初始回调
  public mapInitCallback: AsyncCallback<map.MapComponentController> = async (err, mapController) => {
    if (!err) {
      this.mapController = mapController;
      emitter.on(EmitterConstants.TO_FIND, this._toFindCallback);
      this.mapController.setMyLocationEnabled(true);
      this.mapController.setMyLocationControlsEnabled(true);
      this.mapEventManager = this.mapController.getEventManager();
      this.mapEventManager.on('markerClick', this._markClickCallback);
      this.mapEventManager.on('cameraChange', this._cameraChangeCallback);
      this.init();
    }
  };
  // 标记点击回调
  private _markClickCallback = (marker: map.Marker) => {
    const index = this.marks.findIndex(item => item === marker);
    if (index === -1) {
      return;
    }
    if (this.selectedMark && this.selectedSpot) {
      this.selectedMark.setIcon(this._getIcon(this.selectedSpot.leftSpots));
    }
    this.selectedMark = this.marks[index];
    this.selectedSpot = this.spots[index];
    this.selectedMark.setIcon(this._getIcon(this.selectedSpot.leftSpots, true));
    const sortedIndex = this.sortedSpots.findIndex(item => item.siteId === this.selectedSpot?.siteId);
    if (sortedIndex !== -1) {
      this.controller.scrollToIndex(sortedIndex, true);
    }
  };
  // 常用地址回调
  private _toFindCallback = () => {
    const address: AddressModel | undefined = AppStorage.get(AppStorageMap.SELECTED_ADDRESS);
    AppStorage.set(AppStorageMap.SELECTED_ADDRESS, undefined);
    if (address?.location) {
      this.query = address.name;
      this.moveCamera(address.location);
    }
  };
  // 相机移动回调
  private _cameraChangeCallback = (position: mapCommon.LatLng) => {
    this.center = position;
    this._searchParking();
  };
  // 相机移动回调(防抖)
  private _cameraChangeCallbackWithDebounce = CommonUtil.debounce(((position: mapCommon.LatLng) => {
    this.center = position;
    this._searchParking();
  }), 100);
  mapOptions: mapCommon.MapOptions = { position: { target: this.center, zoom: 16 } };
  mapController?: map.MapComponentController;
  mapEventManager?: map.MapEventManager;
  private static _instance: FindPageVM;

  public static get instance() {
    if (!FindPageVM._instance) {
      FindPageVM._instance = new FindPageVM();
    }
    return FindPageVM._instance;
  }

  /**
   * 初始化-移动地图中心
   * I.常用地址跳转(目标位置)
   * II.点击Tab页找车位跳转(当前位置)
   */
  public async init() {
    const address: AddressModel | undefined = AppStorage.get(AppStorageMap.SELECTED_ADDRESS);
    AppStorage.set(AppStorageMap.SELECTED_ADDRESS, undefined);
    if (address?.location) {
      this.query = address.name;
      this.moveCamera(address.location);
      return;
    }
    const ctx = getContext() as common.UIAbilityContext;
    const res = await LocationUtil.getCachedGCJ02Location(ctx);
    if (res.result === LocationStatus.SUCCESS) {
      this.moveCamera(res.gcj02LatLng!);
    }
  }

  /** 移动相机中心 **/
  public moveCamera(center: mapCommon.LatLng) {
    this.mapController?.moveCamera(map.newCameraPosition({ target: center, zoom: 16 }));
  }

  /** 搜索附件停车场 **/
  private async _searchParking() {
    try {
      let params: site.SearchByTextParams = {
        query: '停车场',
        location: this.center,
        poiTypes: ['PARKING_LOT'],
        language: 'zh',
      };
      const result = await site.searchByText(params);
      if (result.sites) {
        // mock 车位信息
        this.spots.length = 0;
        this.selectedSpot = undefined;
        const newSpots: BasicParkInfo[] = [];
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
        this.spots = newSpots;
        this.controller.scrollToIndex(0);
        this._setMarks();
        Logger.info(TAG, 'Succeeded in searching by text.');
      }
    } catch (error) {
      Logger.error(TAG, 'Failed in searching by text:' + JSON.stringify(error));
    }
  }

  /** 标记停车场 **/
  private async _setMarks() {
    if (!this.mapController) {
      return;
    }
    this.mapController.clear();
    this.marks.length = 0;
    for (let i = 0; i < this.spots.length; i++) {
      const item = this.spots[i];
      let markerOptions: mapCommon.MarkerOptions = {
        position: item.location,
        rotation: 0,
        icon: this._getIcon(item.leftSpots),
        clickable: true,
        visible: true,
        draggable: false,
        zIndex: 0,
      };
      const marker = await this.mapController!.addMarker(markerOptions);
      this.marks.push(marker);
    }
  }


  /** 获取停车车库图标 **/
  private _getIcon(left: number, max: boolean = false): ResourceStr {
    if (left > 20) {
      return max ? $r('app.media.ic_park_blue_max') : $r('app.media.ic_park_blue_min');
    } else if (left > 10) {
      return max ? $r('app.media.ic_park_yellow_max') : $r('app.media.ic_park_yellow_min');
    } else {
      return max ? $r('app.media.ic_park_red_max') : $r('app.media.ic_park_red_min');
    }
  }
}