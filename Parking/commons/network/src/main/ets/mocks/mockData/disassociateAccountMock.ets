import { BaseResponse } from '../../types/BaseResponse';
import { DisassociateAccountResp } from '../../types/responseTypes';

export const associateAccountMock: BaseResponse<DisassociateAccountResp> = {
  code: 0,
  data: {
    cellphone: '',
  },
};