import { AppStorageV2 } from '@kit.ArkUI';
import { AddressType, CommonAddressItem, IAddressInfo } from '../../types';
import { CommonAddressListModel } from './models';

@ObservedV2
export class AddressUtil {
  // 常用地址信息
  private static _commonAddresses: CommonAddressListModel =
    AppStorageV2.connect(CommonAddressListModel, 'commonAddresses', () => new CommonAddressListModel())!;

  public static getCommonAddresses() {
    return AddressUtil._commonAddresses;
  }

  public static initAddress(list: IAddressInfo[]) {
    AddressUtil._commonAddresses.list.length = 0;
    list.forEach(item => {
      AddressUtil._commonAddresses.list.push({
        siteId: item.siteId,
        name: item.name,
        addr: item.addr,
        location: item.location,
        type: item.type ?? AddressType.CUSTOM,
      });
    });
  }

  public static addAddress(address: IAddressInfo) {
    AddressUtil._commonAddresses.list.push({
      siteId: address.siteId,
      name: address.name,
      addr: address.addr,
      location: address.location,
      type: address.type ?? AddressType.CUSTOM,
    });
  }

  public static updateAddress(address: IAddressInfo, oldSiteId: string) {
    let index = -1;
    if (oldSiteId) {
      index = AddressUtil._commonAddresses.list.findIndex(item => item.siteId === oldSiteId);
    } else {
      index = AddressUtil._commonAddresses.list.findIndex(item => item.type === address.type);
    }
    AddressUtil._commonAddresses.list.splice(index, 1, {
      siteId: address.siteId,
      name: address.name,
      addr: address.addr,
      location: address.location,
      type: address.type ?? AddressType.CUSTOM,
    });
  }

  public static deleteAddress(id: string) {
    const index = AddressUtil._commonAddresses.list.findIndex(item => item.siteId === id);
    AddressUtil._commonAddresses.list.splice(index, 1);
  }

  public static readonly CONFIG_LIST: CommonAddressItem[] = [
    {
      iconOuter: 'app.media.ic_add_outer',
      iconInner: 'app.media.ic_add_inner',
      textOuter: '添加地点',
      textInner: '',
    },
    {
      iconOuter: 'app.media.ic_home_outer',
      iconInner: 'app.media.ic_home_inner',
      textOuter: '回家',
      textInner: '住址',
    },
    {
      iconOuter: 'app.media.ic_work_outer',
      iconInner: 'app.media.ic_work_inner',
      textOuter: '上班',
      textInner: '公司',
    },
    {
      iconOuter: 'app.media.ic_dinner_outer',
      iconInner: 'app.media.ic_dinner_inner',
      textOuter: '去吃饭',
      textInner: '餐饮',
    },
  ];
}

export * from './models';