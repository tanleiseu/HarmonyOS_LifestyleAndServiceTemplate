import { BaseResponse } from '../../types/BaseResponse';
import { GetParkingDetailResp } from '../../types/responseTypes';
import { CLOUD_STORAGE_URL } from '../Constants';

export const getParkingDetailMock: BaseResponse<GetParkingDetailResp> = {
  code: 0,
  data: {
    basicPic: [
      CLOUD_STORAGE_URL + 'ic_park0.jpg?token=a7fb227d-3a1b-44b6-9f8a-51a804a8fffa',
      CLOUD_STORAGE_URL + 'ic_park1.jpg?token=0d21ef96-c1b5-4123-bf48-7a55c3a479d0',
      CLOUD_STORAGE_URL + 'ic_park2.jpg?token=6a616aa4-edbc-417b-8b3f-48053cdaf9ee',
    ],
    parkTime: '周一至周日 00:00-24:00',
    phone: '01201000100',
    payType: '华为支付',
    chargeRules: '实际收费标准以停车场实际情况为准',
  },
};