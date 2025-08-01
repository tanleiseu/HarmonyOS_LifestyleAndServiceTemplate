import { RouterMap } from 'commonlib';
import { SettingItem } from '../types';

export const SETTING_LIST: SettingItem[] = [
  {
    icon: $r('app.media.ic_my_car'),
    label: '我的车牌',
    url: RouterMap.MY_LICENSE,
    group: 1,
  },
  {
    icon: $r('app.media.ic_my_order'),
    label: '我的订单',
    url: RouterMap.ORDER_LIST,
    group: 1,
  },
  {
    icon: $r('app.media.ic_my_collect'),
    label: '我的收藏',
    url: RouterMap.MY_COLLECT,
    group: 1,
  },
  {
    icon: $r('app.media.ic_to_call'),
    label: '联系客服',
    url: 'CallPhone',
    group: 1,
  },

  {
    icon: $r('app.media.ic_setting'),
    label: '个人设置',
    url: RouterMap.PROFILE_EDIT,
    group: 2,
  },
  {
    icon: $r('app.media.ic_security'),
    label: '隐私协议',
    url: RouterMap.PRIVACY_POLICY,
    group: 3,
  },
];

export class ButtonStyle {
  public static readonly buttonTextColorBound: ResourceStr = $r('app.color.btn_text_blue');
  public static readonly buttonTextColorUnbound: ResourceStr = $r('sys.color.font_primary');
  public static readonly buttonBgColorBound: ResourceStr = $r('app.color.btn_blue2');
  public static readonly buttonBgColorUnbound: ResourceStr = $r('sys.color.comp_background_tertiary');
  public static readonly buttonTextSize: ResourceStr = $r('sys.float.Body_M');
  public static readonly buttonWidth: Length = 92;
  public static readonly buttonHeight: Length = 28;
}