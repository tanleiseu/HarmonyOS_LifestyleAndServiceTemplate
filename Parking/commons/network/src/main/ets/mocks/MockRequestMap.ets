import { httpsMock } from './HttpRequestApiMock';
import { promptAction } from '@kit.ArkUI';
import { FullLoading, Logger } from 'commonlib';
import { BaseResponse } from '../types/BaseResponse';
import { RequestUrl } from './Constants';

type MockMap = Record<string, (...args: ESObject[]) => Promise<BaseResponse>>;

// 创建 URL 到 Mock 方法的映射对象
const mockMap: MockMap = {
  /**
   * 用户相关
   */
  [RequestUrl.URL_USER_LOGIN]: httpsMock.userLogin,
  [RequestUrl.URL_USER_INFO]: httpsMock.getUserInfo,
  [RequestUrl.URL_USER_ASSOCIATE]: httpsMock.associateAccount,
  [RequestUrl.URL_USER_DISASSOCIATE]: httpsMock.disassociateAccount,
  /**
   * 用户常用地址
   */
  [RequestUrl.URL_ADDRESS_GET]: httpsMock.getCommonAddresses,
  [RequestUrl.URL_ADDRESS_ADD]: httpsMock.addCommonAddresses,
  [RequestUrl.URL_ADDRESS_UPDATE]: httpsMock.updateCommonAddresses,
  [RequestUrl.URL_ADDRESS_DELETE]: httpsMock.deleteCommonAddresses,

  /**
   * 车牌相关
   */
  [RequestUrl.URL_LICENSE_LIST]: httpsMock.getLicenseNumbers,
  [RequestUrl.URL_LICENSE_DEFAULT_GET]: httpsMock.getDefaultLicenseNumber,
  [RequestUrl.URL_LICENSE_DEFAULT_SET]: httpsMock.setDefaultLicenseNumber,
  [RequestUrl.URL_LICENSE_ADD]: httpsMock.addNewLicenseNumber,
  [RequestUrl.URL_LICENSE_DELETE]: httpsMock.deleteOldLicenseNumber,

  /**
   * 订单相关
   */
  [RequestUrl.URL_ORDER_QUERY]: httpsMock.queryParking,
  [RequestUrl.URL_ORDER_PAY]: httpsMock.payParking,
  [RequestUrl.URL_ORDER_LIST]: httpsMock.getAllOrder,
  [RequestUrl.URL_ORDER_DELETE]: httpsMock.deleteOrder,

  /**
   * 首页配置
   */
  [RequestUrl.URL_BANNER_GET]: httpsMock.getHomePageBanner,

  /**
   * 车场信息
   */
  [RequestUrl.URL_DETAIL_GET]: httpsMock.getParkingDetail,
};

export async function replaceMockData(url: string | undefined, args: Object): Promise<Object | string> {
  const arr = Object.entries(mockMap);
  if (url) {
    // url严格一致
    const func = arr.find((item) => url === item[0]);
    if (func) {
      const response: BaseResponse = await func[1](args);
      const delayResponse: BaseResponse = await simulateDelay(response, 500);
      FullLoading.hideLoading();
      return Promise.resolve(delayResponse);
    }
    return mockErrorHandler('cannot find mock function.');
  }
  return mockErrorHandler('cannot find url.');
}

function simulateDelay<T>(data: T, delay: number): Promise<T> {
  return new Promise<T>((resolve) => {
    setTimeout(() => {
      resolve(data);
    }, delay);
  });
}

function mockErrorHandler(msg?: string): Promise<string> {
  const errMsg: string = 'replace mock data failed!';
  FullLoading.hideLoading();
  promptAction.showToast({ message: errMsg });
  Logger.error('[MockRequest]', msg ?? '', errMsg);
  return Promise.reject(errMsg);
}