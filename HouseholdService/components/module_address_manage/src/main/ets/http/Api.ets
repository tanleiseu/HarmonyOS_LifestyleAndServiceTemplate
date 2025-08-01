import { IAddrInfo, } from './Type';
import { CommonUtils } from '../common/Utils';

export class AddrMgtApi {
  static ADDRESS_LIST: IAddrInfo[] = [
    {
      id: 123456,
      name: '宜悦城',
      address: '江苏省南京市雨花台区安德门大街36号',
      contactName: '张三',
      contactPhone: '12345678901',
    },
  ];

  static getAddressList(): Promise<IAddrInfo[]> {
    return Promise.resolve(AddrMgtApi.ADDRESS_LIST);
  }

  static getAddress(addrId: number): Promise<IAddrInfo | undefined> {
    return Promise.resolve(AddrMgtApi.ADDRESS_LIST.find(v => v.id === addrId));
  }

  static updateAddress(data: IAddrInfo): Promise<boolean> {
    const target = AddrMgtApi.ADDRESS_LIST.find(v => v.id === data.id);
    if (target) {
      CommonUtils.assign(target, data);
    }
    return Promise.resolve(true);
  }

  static deleteAddress(id: number): Promise<boolean> {
    const targetIndex = AddrMgtApi.ADDRESS_LIST.findIndex(v => v.id === id);
    if (targetIndex !== -1) {
      AddrMgtApi.ADDRESS_LIST.splice(targetIndex, 1);
    }
    return Promise.resolve(true);
  }

  static addAddress(data: IAddrInfo): Promise<boolean> {
    data.id = new Date().getTime();
    AddrMgtApi.ADDRESS_LIST.splice(0, 0, data);
    return Promise.resolve(true);
  }
}
