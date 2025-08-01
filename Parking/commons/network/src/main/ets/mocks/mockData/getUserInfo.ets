import { BaseResponse } from '../../types/BaseResponse';
import { GetUserInfoResp } from '../../types/responseTypes';
import { getId } from '../../utils';

export const getUserInfoMock: BaseResponse<GetUserInfoResp> = {
  code: 0,
  data: {
    id: getId(),
    avatar: '',
    nickname: '',
    cellphone: '',
  },
};