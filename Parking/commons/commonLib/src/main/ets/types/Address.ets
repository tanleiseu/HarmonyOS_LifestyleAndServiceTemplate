import { mapCommon } from '@kit.MapKit';

export interface IAddressInfo {
  siteId: string;
  name: string;
  addr: string;
  location: mapCommon.LatLng;
  type?: AddressType;
  distance?: number;
}

@ObservedV2
export class AddressModel implements IAddressInfo {
  @Trace siteId: string = '';
  @Trace name: string = '';
  @Trace addr: string = '';
  @Trace location: mapCommon.LatLng = { latitude: 39.9, longitude: 116.4 };
  @Trace type: AddressType = AddressType.CUSTOM;
}

export enum AddressType {
  CUSTOM = 0, // 自定义
  HOME = 1, // 回家
  WORK = 2, // 上班
  DINNER = 3, // 餐饮
}

export interface CommonAddressItem {
  iconOuter: string;
  iconInner: string;
  textOuter: string;
  textInner: string;
}