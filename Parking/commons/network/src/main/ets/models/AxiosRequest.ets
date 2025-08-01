import { AxiosHttpRequest } from './AxiosHttp';
import { AxiosRequestHeaders, AxiosResponse } from '@ohos/axios';
import { BusinessError } from '@kit.BasicServicesKit';
import { AccountUtil, FullLoading } from 'commonlib';

const axiosClient = new AxiosHttpRequest(
  {
    baseURL: '',
    timeout: 10 * 3000,
    headers: {} as AxiosRequestHeaders,
    interceptorHooks: {
      requestInterceptor: async (config) => {
        if (config.showLoading) {
          FullLoading.showLoading();
        }
        config.headers.authorization = AccountUtil.getAuthorization();
        return config;
      },
      requestInterceptorCatch: (err: BusinessError) => {
        if (FullLoading.isLoading) {
          FullLoading.hideLoading();
        }
        return err;
      },
      responseInterceptor: (response: AxiosResponse) => {
        if (FullLoading.isLoading) {
          FullLoading.hideLoading();
        }
        if (response.status === 200) {
          return Promise.resolve(response.data);
        } else {
          return Promise.reject(response);
        }
      },
      responseInterceptorCatch: (error: BusinessError) => {
        if (FullLoading.isLoading) {
          FullLoading.hideLoading();
        }
        return Promise.reject(error);
      },
    },
  },
  true,
);

export default axiosClient;