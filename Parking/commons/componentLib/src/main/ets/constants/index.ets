export class ButtonConstant {
  // 背景颜色
  static readonly BG_COLOR: ResourceColor = '#387BF1';
  // 按钮高度
  static readonly HEIGHT: Length = 40;
  // 标题字体大小
  static readonly TITLE_SIZE: Length = $r('sys.float.Body_L');
  // 标题字体颜色
  static readonly FONT_COLOR: ResourceColor = $r('sys.color.font_on_primary');
}

export class HeaderConstant {
  // 返回图标尺寸_内
  static readonly ICON_SIZE_INNER: Length = 24;
  // 返回图标尺寸_外
  static readonly ICON_SIZE_OUTER: Length = 40;
  //返回图标背景色
  static readonly ICON_BG_COLOR: Length = $r('sys.color.comp_background_tertiary');
  // 标题字体颜色
  static readonly FONT_COLOR: ResourceStr = $r('sys.color.font_primary');
  // 基础高度
  static readonly HEIGHT: number = 56;
  // 内边距
  static readonly PADDING: Length = 16;
  // 外边距
  static readonly MARGIN: Length = 8;
}

export class KeyboardConstant {
  // 车牌显示新能源背景色
  static readonly NEW_ENERGY_BACKGROUND: ResourceColor = '#1A64BB5C';
  // 车牌显示正常键盘背景色
  static readonly KEYBORD_NORMAL_BACKGROUND: ResourceColor = '#FFFFFF';
  // 车牌显示背景色
  static readonly KEYBORD_BACKGROUND: ResourceColor = '#DEE0E6';
  // 自定义删除键背景色
  static readonly DEL_BACKGROUND: ResourceColor = '#BCC0C7';
  // 自定义键盘阴影色
  static readonly KEY_SHADOW: ResourceColor = '#90949C';
  // 自定义键盘背景色
  static readonly KEY_BACKGROUND: ResourceColor = '#FFFFFF';
}

export class TabConstant {
  // 占满全宽
  static readonly FULL_WIDTH: string = '100%';
  // 占满全高
  static readonly FULL_HEIGHT: string = '100%';
  // 页签摩擦系数
  static readonly FRICTION: number = 2;
  // 导航区间隙
  static readonly SPACE: number = 20;
  // TabBar栏左边距
  static readonly OFFSET_LEFT: number = 12;
  // TabBar栏右边距
  static readonly OFFSET_RIGHT: number = 12;
  // 选中颜色: Tab文字
  static readonly ACTIVE_COLOR: ResourceColor = '#387BF1';
  // 待选颜色: Tab文字
  static readonly FROZEN_COLOR: ResourceColor = '#606162';
  // 选中大小: Tab文字
  static readonly ACTIVE_SIZE: string | number | Resource = 16;
  // 待选大小: Tab文字
  static readonly FROZEN_SIZE: string | number | Resource = 16;
  // 导航区背景颜色
  static readonly TAB_BAR_BGCOLOR: ResourceColor = '#F1F3F5';
  // 内容背景颜色
  static readonly TAB_CONTENT_BGCOLOR: ResourceColor = '#F1F3F5';
  // 选中文字粗细
  static readonly ACTIVE_WEIGHT: number | string | FontWeight = FontWeight.Medium;
  // 待选文字粗细
  static readonly FROZEN_WEIGHT: number | string | FontWeight = FontWeight.Normal;
  // 动画时长
  static readonly ANIMATION_DURATION: number = 300;
  // 导航区高度
  static readonly TAB_BAR_HEIGHT: number = 56;
  // 条形高度
  static readonly LINE_HEIGHT: number = 1;
  // 条形距离顶部位置
  static readonly RELATIVE_Y: number = 44;
}