import { mapCommon } from '@kit.MapKit';

export interface AssociateAccountRequest {
  id: string;
  code: string;
}

export interface SetDefaultLicenseNumberRequest {
  id: string;
  new: string;
}

export interface AddNewLicenseNumberRequest {
  id: string;
  new: string;
  isDfault: boolean;
}

export interface DeleteOldLicenseNumberRequest {
  id: string;
  old: string;
}

export interface QueryParkingRequest {
  id: string;
  license: string;
}

export interface PayParkingRequest {
  id: string;
  orderId: string;
  siteId: string;
  license: string;
}

export interface GetAllOrderRequest {
  id: string;
}

export interface DeleteOrderRequest {
  id: string;
}

export interface AddCommonAddressesRequest {
  id: string;
  siteId: string;
  name: string;
  addr: string;
  location: mapCommon.LatLng;
  type: number;
}

export interface UpdateCommonAddressesRequest {
  id: string;
  siteId: string;
  oldSiteId: string;
  name: string;
  addr: string;
  location: mapCommon.LatLng;
  type: number;
}


export interface DeleteCommonAddressesRequest {
  id: string;
  siteId: string;
}

export interface GetParkingDetailRequest {
  id: string;
}

export interface GetParkingEvaluationRequest {
  id: string;
}