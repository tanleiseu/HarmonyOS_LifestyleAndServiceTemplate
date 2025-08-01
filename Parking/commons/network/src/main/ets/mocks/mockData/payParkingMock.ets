import { BaseResponse } from '../../types/BaseResponse';
import { PayParkingResp } from '../../types/responseTypes';

export const payParkingMock: BaseResponse<PayParkingResp> = {
  code: 0,
  data: {
    mercNo: '',
    orderStr: '',
    timestamp: '',
  },
};