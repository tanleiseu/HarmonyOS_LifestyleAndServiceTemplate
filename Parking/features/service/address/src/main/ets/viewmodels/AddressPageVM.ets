import { AddressModel, AddressType, AddressUtil, CommonAddressListModel, RouterMap, RouterModule } from 'commonlib';
import { getId, Https } from 'network';

@ObservedV2
export class AddressPageVM {
  // 常去地址
  @Trace commonAddresses: CommonAddressListModel = AddressUtil.getCommonAddresses();

  // 基础地址
  @Computed
  public get basicList() {
    return this.commonAddresses.list.filter(item => item.type);
  }

  // 常用地址
  @Computed
  public get customList() {
    return this.commonAddresses.list.filter(item => !item.type);
  }

  // 选中地址
  @Trace selectedAddress?: AddressModel;
  @Trace showBasicOpt: boolean = false;
  @Trace showCustomOpt: boolean = false;
  private static _instance: AddressPageVM;

  public static get instance() {
    if (!AddressPageVM._instance) {
      AddressPageVM._instance = new AddressPageVM();
    }
    return AddressPageVM._instance;
  }

  /** 更多操作 **/
  public moreOpt(address: AddressModel) {
    this.selectedAddress = address;
    if (!this.selectedAddress.siteId) {
      RouterModule.push({ url: RouterMap.SEARCH_LIST, param: this.selectedAddress.type });
      return;
    }
    if (this.selectedAddress.type) {
      this.showBasicOpt = true;
    } else {
      this.showCustomOpt = true;
    }
  }

  /** 去修改地址 **/
  public toUpdateAddress() {
    RouterModule.push({ url: RouterMap.SEARCH_LIST, param: this.selectedAddress });
    this.showBasicOpt = false;
    this.showCustomOpt = false;
  }

  /** 清空或删除地址 **/
  public clearOrDeleteAddress(isClear: boolean) {
    if (!this.selectedAddress) {
      return;
    }
    if (isClear) {
      this._clearAddress(this.selectedAddress.type);
      this.showBasicOpt = false;
    } else {
      this._deleteAddress(this.selectedAddress.siteId);
      this.showCustomOpt = false;
    }
  }

  /** 删除地址 **/
  private async _deleteAddress(siteId: string) {
    const res = await Https.deleteCommonAddresses({ id: getId(), siteId: siteId });

    if (res.code === 0) {
      AddressUtil.deleteAddress(siteId);
    }
  }

  /** 清空地址 **/
  private async _clearAddress(type: AddressType) {
    const res = await Https.updateCommonAddresses({
      id: getId(),
      siteId: '',
      oldSiteId: '',
      name: '',
      addr: '',
      location: { latitude: 39.9, longitude: 116.4 },
      type: type,
    });

    if (res.code === 0) {
      AddressUtil.updateAddress({
        siteId: '',
        name: '',
        addr: '',
        location: { latitude: 39.9, longitude: 116.4 },
        type: type,
      }, '');
    }
  }
}
