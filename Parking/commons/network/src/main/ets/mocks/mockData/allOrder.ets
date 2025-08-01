import { DEPARTURE_TIME, IOrder, OrderStatus } from 'commonlib';
import { BaseResponse } from '../../types/BaseResponse';
import { AllOrderResp } from '../../types/responseTypes';

const allOrderNullErrorMock: BaseResponse<AllOrderResp> = {
  code: 404,
  msg: '未找到对应车牌入场信息',
  data: {},
};

const allOrderNormalMock: BaseResponse<AllOrderResp> = {
  code: 0,
  data: {},
};

const MAP_ORDER: Map<string, IOrder[]> = new Map();
const NOW = Date.now();
// 待出场
const ORDER_TO_OUT: IOrder = {
  orderId: '9078689001000',
  status: OrderStatus.PENDING,
  license: '京A12345',
  siteId: '1',
  spot: '地下停车库A',
  start: NOW - 7200000,
  end: NOW,
};
let countdown = DEPARTURE_TIME;
const timer = setInterval(() => {
  countdown -= 1000;
  if (countdown <= 0) {
    clearInterval(timer);
    // 服务端修改订单为正停车
    ORDER_TO_OUT.status = OrderStatus.PARKING;
    ORDER_TO_OUT.end = undefined;
  }
}, 1000);

// 正停车
const ORDER_PARKING: IOrder = {
  orderId: '9078689001001',
  status: OrderStatus.PARKING,
  license: '苏A654321',
  siteId: '1',
  spot: '地下停车库B',
  start: NOW - 7200000,
};

// 已出场
const ORDER_HAS_OUT_0: IOrder = {
  orderId: '9078689000000',
  status: OrderStatus.LEAVING,
  license: '京A12345',
  siteId: '1',
  spot: '地下停车库C',
  start: NOW - 86433000 - 1296000000,
  end: NOW - 54011000 - 1296000000,
};
const ORDER_HAS_OUT_1: IOrder = {
  orderId: '9078689000001',
  status: OrderStatus.LEAVING,
  license: '苏A654321',
  siteId: '1',
  spot: '地下停车库C',
  start: NOW - 77733000 - 86400000,
  end: NOW - 54411000 - 86400000,
};

const ORDER_HAS_OUT_2: IOrder = {
  orderId: '9078689000002',
  status: OrderStatus.LEAVING,
  license: '苏A654321',
  siteId: '1',
  spot: '地下停车库C',
  start: NOW - 96433000 - 2592000000,
  end: NOW - 34011000 - 2592000000,
};

MAP_ORDER.set('京A12345', [ORDER_HAS_OUT_0, ORDER_TO_OUT]);
MAP_ORDER.set('苏A654321', [ORDER_HAS_OUT_1, ORDER_HAS_OUT_2, ORDER_PARKING]);

export { allOrderNullErrorMock, allOrderNormalMock, MAP_ORDER };