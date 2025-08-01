import { BaseResponse } from '../../types/BaseResponse';
import { GetDefaultLicenseNumberResp } from '../../types/responseTypes';
import { getId } from '../../utils';

export const getDefaultLicenseNumberMock: BaseResponse<GetDefaultLicenseNumberResp> = {
  code: 0,
  data: {
    id: getId(),
    default: '苏A654321',
  },
};