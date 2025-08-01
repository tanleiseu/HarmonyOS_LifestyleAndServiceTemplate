export interface IOrder {
  orderId: string;
  status: OrderStatus;
  license: string;
  siteId: string;
  spot: string;
  start: number;
  end?: number;
  cost?: number;
}

export enum OrderStatus {
  PARKING = '0', // 停车中
  PENDING = '1', // 待离场
  LEAVING = '2', // 已离场
}