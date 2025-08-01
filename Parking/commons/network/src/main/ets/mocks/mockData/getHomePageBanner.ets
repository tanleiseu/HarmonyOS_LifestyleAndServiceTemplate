import { BaseResponse } from '../../types/BaseResponse';
import { GetHomePageBannerResp } from '../../types/responseTypes';
import { CLOUD_STORAGE_URL } from '../Constants';

export const getHomePageBannerMock: BaseResponse<GetHomePageBannerResp> = {
  code: 0,
  data: {
    banner: CLOUD_STORAGE_URL + '%E8%92%99%E7%89%88(2).png?token=7177b033-345b-4801-8a33-f7b58dd5265f',
  },
};