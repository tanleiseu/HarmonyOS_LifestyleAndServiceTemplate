import { AddressModel, AddressUtil, IAddressInfo, Logger, RouterMap, RouterModule } from 'commonlib';
import { HistoryListModel, HistoryUtil } from '../utils';
import { site } from '@kit.MapKit';
import { getId, Https } from 'network';
import { promptAction } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = '[AddressPageVM]';

@ObservedV2
export class SearchPageVM {
  // 当前文本
  @Trace text: string = '';
  // 来源页面(0~3:新增地址页;-1:地图页)
  @Trace type: number = 0;
  // 修改地址id
  @Trace oldSiteId: string = '';
  // 搜索历史结果
  @Trace historyList: HistoryListModel = HistoryUtil.getHistoryList();
  // 搜索补全结果
  @Trace searchList: IAddressInfo[] = [];
  // 正在搜索
  @Trace searching: boolean = false;
  // 上下文
  private static _instance: SearchPageVM;

  public static get instance() {
    if (!SearchPageVM._instance) {
      SearchPageVM._instance = new SearchPageVM();
    }
    return SearchPageVM._instance;
  }

  /** 初始化 **/
  public init() {
    this._resetSearchData();
    this._setTypeWithParams();
  }

  /** 点击搜索结果卡片操作 **/
  public async clickCardNextDo(address: IAddressInfo) {
    if (this.type === -1) {
      // 调整地图
      RouterModule.popWithRes(address);
    } else {
      if (this.type === 0 && this.oldSiteId === '') {
        // 新增自定义
        await this._addAddress(address);
      } else {
        // 更新地址
        await this._updateAddress(address);
      }
    }
    HistoryUtil.addOne(address);
    RouterModule.pop();
  }

  /** 自动补全地址 **/
  public async autoCompleteAddress() {
    if (!this.text) {
      return;
    }
    this.searching = true;
    let params: site.QueryAutoCompleteParams = { query: this.text, language: 'zh' };
    site.queryAutoComplete(params)
      .then(res => {
        if (res.sites) {
          this.searchList = res.sites.map(item => {
            return {
              siteId: item.siteId,
              name: item.name,
              addr: item.formatAddress,
              location: item.location,
            } as IAddressInfo;
          });
        }
        Logger.info(TAG, 'Succeeded in querying.');
        this.searching = false;
      })
      .catch((err: BusinessError) => {
        // 搜索结果为空时 报错异常码
        if (err.code === 1002603001) {
          this.searchList.length = 0;
        }
        Logger.error(TAG, 'Failed in querying:' + JSON.stringify(err));
        this.searching = false;
      })
  }

  /** 新增地址 **/
  private async _addAddress(info: IAddressInfo) {
    const index = AddressUtil.getCommonAddresses().list.findIndex(item => item.siteId === info.siteId);
    if (index !== -1) {
      promptAction.showToast({ message: '已存在相同地址!' });
      return;
    }
    const res = await Https.addCommonAddresses({
      id: getId(),
      siteId: info.siteId!,
      name: info.name,
      addr: info.addr,
      location: info.location,
      type: this.type,
    });

    if (res.code === 0) {
      AddressUtil.addAddress({
        siteId: info.siteId!,
        name: info.name,
        addr: info.addr,
        location: info.location,
        type: this.type,
      });
    }
  }

  /** 更新地址 **/
  private async _updateAddress(info: IAddressInfo) {
    const index = AddressUtil.getCommonAddresses().list.findIndex(item => item.siteId === info.siteId);
    if (index !== -1) {
      promptAction.showToast({ message: '已存在相同地址!' });
      return;
    }
    const res = await Https.updateCommonAddresses({
      id: getId(),
      siteId: info.siteId!,
      oldSiteId: this.oldSiteId,
      name: info.name,
      addr: info.addr,
      location: info.location,
      type: this.type,
    });

    if (res.code === 0) {
      AddressUtil.updateAddress({
        siteId: info.siteId!,
        name: info.name,
        addr: info.addr,
        location: info.location,
        type: this.type,
      }, this.oldSiteId);
    }
  }

  /** 重置搜索页面参数 **/
  private _resetSearchData() {
    this.text = '';
    this.type = 0;
    this.oldSiteId = '';
    this.searchList.length = 0;
    this.searching = false;
  }

  /** 设置来源页面 **/
  private _setTypeWithParams() {
    const obj = RouterModule.getNavParam({ url: RouterMap.SEARCH_LIST }) as number | string | AddressModel;
    if (typeof obj === 'number') {
      this.type = obj;
    } else if (typeof obj === 'string') {
      this.type = -1;
      this.text = obj;
    } else {
      this.type = obj.type;
      this.oldSiteId = obj.siteId;
    }
  }
}
