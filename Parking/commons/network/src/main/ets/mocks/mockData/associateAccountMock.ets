import { BaseResponse } from '../../types/BaseResponse';
import { AssociateAccountResp } from '../../types/responseTypes';

export const associateAccountMock: BaseResponse<AssociateAccountResp> = {
  code: 0,
  data: {
    cellphone: '10000000001',
  },
};