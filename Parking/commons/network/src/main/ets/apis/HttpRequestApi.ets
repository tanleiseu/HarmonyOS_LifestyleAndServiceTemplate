import {
  AddCommonAddressesRequest,
  AddNewLicenseNumberRequest,
  AssociateAccountRequest,
  DeleteCommonAddressesRequest,
  DeleteOldLicenseNumberRequest,
  DeleteOrderRequest,
  GetAllOrderRequest,
  GetParkingDetailRequest,
  PayParkingRequest,
  QueryParkingRequest,
  SetDefaultLicenseNumberRequest,
  UpdateCommonAddressesRequest,
} from '../types/AxiosRequestParam';
import { getId } from '../utils';
import axiosClient from '../models/AxiosRequest';
import {
  AllCommonAddressesResp,
  AllLicenseInfoResp,
  AllOrderResp,
  AssociateAccountResp,
  DisassociateAccountResp,
  GetDefaultLicenseNumberResp,
  GetHomePageBannerResp,
  GetParkingDetailResp,
  GetUserInfoResp,
  PayParkingResp,
  SetDefaultLicenseNumberResp,
  UserLoginResp,
} from '../types/responseTypes';
import { BaseResponse } from '../types/BaseResponse';
import { AxiosRequestHeaders } from '@ohos/axios';
import { RequestUrl } from '../mocks/Constants';

class HttpsApi {
  /** 用户登录信息 **/
  public userLogin(): Promise<BaseResponse<UserLoginResp>> {
    return axiosClient.post({
      url: RequestUrl.URL_USER_LOGIN,
      showLoading: false,
      headers: {} as AxiosRequestHeaders,
      data: {
        id: getId(),
      },
    });
  }

  /** 获取用户信息 **/
  public getUserInfo(): Promise<BaseResponse<GetUserInfoResp>> {
    return axiosClient.get({
      url: RequestUrl.URL_USER_INFO,
      showLoading: false,
      headers: {} as AxiosRequestHeaders,
      params: {
        id: getId(),
      },
    });
  }

  /** 关联用户账号 **/
  public associateAccount(data: AssociateAccountRequest): Promise<BaseResponse<AssociateAccountResp>> {
    return axiosClient.post({
      url: RequestUrl.URL_USER_ASSOCIATE,
      showLoading: true,
      headers: {} as AxiosRequestHeaders,
      data: data,
    });
  }

  /** 取消关联账号 **/
  public disassociateAccount(): Promise<BaseResponse<DisassociateAccountResp>> {
    return axiosClient.post({
      url: RequestUrl.URL_USER_DISASSOCIATE,
      showLoading: true,
      headers: {} as AxiosRequestHeaders,
    });
  }

  /** 获取首页banner图 **/
  public getHomePageBanner(): Promise<BaseResponse<GetHomePageBannerResp>> {
    return axiosClient.get({
      url: RequestUrl.URL_BANNER_GET,
      showLoading: false,
      headers: {} as AxiosRequestHeaders,
    });
  }

  /** 获取所有车牌号 **/
  public getLicenseNumbers(): Promise<BaseResponse<AllLicenseInfoResp>> {
    return axiosClient.get({
      url: RequestUrl.URL_LICENSE_LIST,
      showLoading: false,
      headers: {} as AxiosRequestHeaders,
      params: {
        id: getId(),
      },
    });
  }

  /** 获取默认车牌 **/
  public getDefaultLicenseNumber(): Promise<BaseResponse<GetDefaultLicenseNumberResp>> {
    return axiosClient.get({
      url: RequestUrl.URL_LICENSE_DEFAULT_GET,
      showLoading: false,
      headers: {} as AxiosRequestHeaders,
      params: {
        id: getId(),
      },
    });
  }

  /** 修改默认车牌 **/
  public setDefaultLicenseNumber(data: SetDefaultLicenseNumberRequest):
    Promise<BaseResponse<SetDefaultLicenseNumberResp>> {
    return axiosClient.put({
      url: RequestUrl.URL_LICENSE_DEFAULT_SET,
      showLoading: true,
      headers: {} as AxiosRequestHeaders,
      data: data,
    });
  }

  /** 添加新车牌 **/
  public addNewLicenseNumber(data: AddNewLicenseNumberRequest): Promise<BaseResponse<AllLicenseInfoResp>> {
    return axiosClient.post({
      url: RequestUrl.URL_LICENSE_ADD,
      showLoading: true,
      headers: {} as AxiosRequestHeaders,
      data: data,
    });
  }

  /** 删除旧车牌 **/
  public deleteOldLicenseNumber(params: DeleteOldLicenseNumberRequest): Promise<BaseResponse<AllLicenseInfoResp>> {
    return axiosClient.delete({
      url: RequestUrl.URL_LICENSE_DELETE,
      showLoading: true,
      headers: {} as AxiosRequestHeaders,
      params: params,
    });
  }

  /** 查询入场订单 **/
  public queryParking(params: QueryParkingRequest): Promise<BaseResponse<AllOrderResp>> {
    return axiosClient.get({
      url: RequestUrl.URL_ORDER_QUERY,
      showLoading: true,
      headers: {} as AxiosRequestHeaders,
      params: params,
    });
  }

  /** 支付入场订单 **/
  public payParking(data: PayParkingRequest): Promise<BaseResponse<PayParkingResp>> {
    return axiosClient.post({
      url: '/api/order/pay',
      showLoading: true,
      headers: {} as AxiosRequestHeaders,
      data: data,
    });
  }

  /** 查询所有订单 **/
  public getAllOrder(params: GetAllOrderRequest): Promise<BaseResponse<AllOrderResp>> {
    return axiosClient.get({
      url: RequestUrl.URL_ORDER_LIST,
      showLoading: false,
      headers: {} as AxiosRequestHeaders,
      params: params,
    });
  }

  /** 删除指定订单 **/
  public deleteOrder(params: DeleteOrderRequest): Promise<BaseResponse<AllOrderResp>> {
    return axiosClient.delete({
      url: RequestUrl.URL_ORDER_DELETE,
      showLoading: true,
      headers: {} as AxiosRequestHeaders,
      params: params,
    });
  }

  /** 获取常用地址 **/
  public getCommonAddresses(): Promise<BaseResponse<AllCommonAddressesResp>> {
    return axiosClient.get({
      url: RequestUrl.URL_ADDRESS_GET,
      showLoading: false,
      headers: {} as AxiosRequestHeaders,
      params: {
        id: getId(),
      },
    });
  }

  /** 新增常用地址 **/
  public addCommonAddresses(data: AddCommonAddressesRequest): Promise<BaseResponse<AllCommonAddressesResp>> {
    return axiosClient.post({
      url: RequestUrl.URL_ADDRESS_ADD,
      showLoading: false,
      headers: {} as AxiosRequestHeaders,
      data: data,
    });
  }

  /** 更新常用地址 **/
  public updateCommonAddresses(data: UpdateCommonAddressesRequest): Promise<BaseResponse<AllCommonAddressesResp>> {
    return axiosClient.put({
      url: RequestUrl.URL_ADDRESS_UPDATE,
      showLoading: false,
      headers: {} as AxiosRequestHeaders,
      data: data,
    });
  }

  /** 删除常用地址 **/
  public deleteCommonAddresses(params: DeleteCommonAddressesRequest): Promise<BaseResponse<AllCommonAddressesResp>> {
    return axiosClient.delete({
      url: RequestUrl.URL_ADDRESS_DELETE,
      showLoading: false,
      headers: {} as AxiosRequestHeaders,
      params: params,
    });
  }

  /** 获取停车场详情 **/
  public getParkingDetail(params: GetParkingDetailRequest): Promise<BaseResponse<GetParkingDetailResp>> {
    return axiosClient.get({
      url: RequestUrl.URL_DETAIL_GET,
      showLoading: true,
      headers: {} as AxiosRequestHeaders,
      params: params,
    });
  }
}

const https = new HttpsApi();

export { https as Https };