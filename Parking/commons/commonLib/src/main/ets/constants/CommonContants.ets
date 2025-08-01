import { emitter } from '@kit.BasicServicesKit';

export class CommonConstants {
  // 域名
  public static readonly BASE_URL = '';
  // 全屏宽度
  public static readonly FULL_WIDTH = '100%';
  // 全屏高度
  public static readonly FULL_HEIGHT = '100%';
}

export class EmitterConstants {
  // 事件0：跳转至找车位
  public static readonly TO_FIND: emitter.InnerEvent = { eventId: 0 };
}

// 缴费出场时间限制,此处直接固定600秒/10分钟
export const DEPARTURE_TIME = 600000;