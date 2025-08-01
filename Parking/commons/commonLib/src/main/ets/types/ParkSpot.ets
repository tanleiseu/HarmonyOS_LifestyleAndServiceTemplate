import { mapCommon } from '@kit.MapKit';

export interface BasicParkInfo {
  siteId: string;
  name: string;
  addr: string;
  location: mapCommon.LatLng;
  distance: number;
  totalSpots: number;
  leftSpots: number;
  chargeSpots: number;
  leftChargeSpots: number;
}

export class BasicParkInfoModel implements BasicParkInfo {
  siteId: string = '';
  name: string = '';
  addr: string = '';
  location: mapCommon.LatLng = { latitude: 39.9, longitude: 116.4 };
  distance: number = 0;
  totalSpots: number = 0;
  leftSpots: number = 0;
  chargeSpots: number = 0;
  leftChargeSpots: number = 0;
}

export interface DetailParkInfo extends BasicParkInfo {
  basicPic: ResourceStr[];
  parkTime: string;
  phone: string;
  payType: string;
  chargeRules: string;
}