import { FindPageBuilder } from 'find';
import { HomePageBuilder } from 'home';
import { MinePageBuilder } from 'mine';
import { TabListItem } from '../types';

export const TAB_CONFIG: TabListItem[] = [
  {
    label: '首页',
    icon: $r('app.media.ic_home'),
    iconChecked: $r('app.media.ic_home_checked'),
    component: wrapBuilder(HomePageBuilder),
  },
  {
    label: '找车位',
    icon: $r('app.media.ic_find'),
    iconChecked: $r('app.media.ic_find_checked'),
    component: wrapBuilder(FindPageBuilder),
  },
  {
    label: '我的',
    icon: $r('app.media.ic_mine'),
    iconChecked: $r('app.media.ic_mine_checked'),
    component: wrapBuilder(MinePageBuilder),
  },
];

export class TabStyle {
  static readonly BAR_HEIGHT = 80;
  static readonly ANIMATION_DURATION = 0;
  static readonly ICON_SIZE = 24;
}