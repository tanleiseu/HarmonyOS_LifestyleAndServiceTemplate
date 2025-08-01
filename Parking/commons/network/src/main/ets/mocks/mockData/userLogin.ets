import { BaseResponse } from '../../types/BaseResponse';
import { UserLoginResp } from '../../types/responseTypes';
import { getId } from '../../utils';

export const userLoginMock: BaseResponse<UserLoginResp> = {
  code: 0,
  data: {
    loginToken: 'xxx',
    id: getId(),
    avatar: '',
    nickname: '',
    cellphone: '',
    bonusPoint: 0,
    coupons: 0,
  },
};