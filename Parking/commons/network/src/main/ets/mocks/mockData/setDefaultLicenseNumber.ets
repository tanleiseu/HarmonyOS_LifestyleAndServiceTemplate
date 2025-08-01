import { BaseResponse } from '../../types/BaseResponse';
import { GetDefaultLicenseNumberResp } from '../../types/responseTypes';
import { getId } from '../../utils';

export const setDefaultLicenseNumberMock: BaseResponse<GetDefaultLicenseNumberResp> = {
  code: 0,
  data: {
    id: getId(),
    default: '',
  },
};