import { CommonConstants, EmitterConstants, WidgetUtil, RouterModule } from 'commonlib';
import { TabStyle } from '../constants';
import { TabListItem } from '../types/index';
import { MainEntryVM } from '../viewmodels/MainEntryVM';
import { emitter } from '@kit.BasicServicesKit';

@Entry
@ComponentV2
struct MainEntry {
  vm: MainEntryVM = MainEntryVM.instance;

  async aboutToAppear() {
    emitter.on(EmitterConstants.TO_FIND, () => {
      this.vm.controller.changeIndex(1);
    });
    WidgetUtil.subscribeFormId(getContext());
    await this.vm.init(this.getUIContext());
  }

  build() {
    Navigation(RouterModule.stack) {
      Column() {
        Tabs({ barPosition: BarPosition.End, index: $$this.vm.curIndex, controller: this.vm.controller }) {
          ForEach(this.vm.tabList, (item: TabListItem, index: number) => {
            TabContent() {
              item.component.builder();
            }
            .tabBar(this.tabBarBuilder(item, index))
          }, (item: TabListItem, index) => JSON.stringify(item) + '_' + index)
        }
        .scrollable(false)
        .barMode(BarMode.Fixed)
        .barHeight(TabStyle.BAR_HEIGHT)
        .height(CommonConstants.FULL_HEIGHT)
        .animationDuration(TabStyle.ANIMATION_DURATION)
      }
      .backgroundColor($r('app.color.system_color_background_white'))
    }
    .hideToolBar(true)
    .hideTitleBar(true)
    .hideBackButton(true)
    .mode(NavigationMode.Stack)
  }

  @Builder
  tabBarBuilder(item: TabListItem, index: number) {
    Column({ space: 4 }) {
      Image(this.vm.curIndex === index ? item.iconChecked : item.icon)
        .width(TabStyle.ICON_SIZE)
        .height(TabStyle.ICON_SIZE)
      Text(item.label)
        .fontSize($r('sys.float.Caption_M'))
        .fontColor(this.vm.curIndex === index ?
        $r('app.color.icon_bg_blue') : $r('sys.color.icon_secondary'))
    }
    .justifyContent(FlexAlign.Start)
    .width(CommonConstants.FULL_WIDTH)
    .height(CommonConstants.FULL_HEIGHT)
    .padding({ top: $r('app.string.padding_10') })
  }
}