import { BaseResponse } from '../../types/BaseResponse';
import { AllLicenseInfoResp } from '../../types/responseTypes';
import { getId } from '../../utils';

export const allLicenseInfoMock: BaseResponse<AllLicenseInfoResp> = {
  code: 0,
  data: {
    id: getId(),
    licenses: ['京A12345', '苏A654321'],
  },
};