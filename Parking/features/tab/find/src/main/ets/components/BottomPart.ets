import { BasicParkInfo, CommonConstants } from 'commonlib';
import { CommonSpotItem } from 'componentlib';
import { HeightEnum } from '../types';
import { FindPageVM } from '../viewmodels/FindPageVM';

@ComponentV2
export struct BottomPart {
  // 高度档位
  @Local iHeight: HeightEnum = HeightEnum.LEVEL1;
  vm: FindPageVM = FindPageVM.instance;

  /** 修改高度档位 **/
  changeHeight(offset: number) {
    if (offset > 0 && this.iHeight !== HeightEnum.LEVEL1) {
      this.iHeight = this.iHeight === HeightEnum.LEVEL2 ? HeightEnum.LEVEL1 : HeightEnum.LEVEL2;
    } else if (offset < 0 && this.iHeight !== HeightEnum.LEVEL3) {
      this.iHeight = this.iHeight === HeightEnum.LEVEL2 ? HeightEnum.LEVEL3 : HeightEnum.LEVEL2;
    }
    this.vm.controller.scrollToIndex(this.vm.curIndex, true);
  }

  aboutToAppear(): void {
    this.vm.curIndex = 0;
  }

  build() {
    Column({ space: 8 }) {
      // 控制条
      this.barBuilder()

      // 描述标题
      this.descTextBuilder()

      // 排序方式
      this.sortBuilder()

      // 附近列表
      this.listBuilder()
    }
    .clip(true)
    .height(this.iHeight)
    .width(CommonConstants.FULL_WIDTH)
    .animation({ duration: 300 })
    .padding({ left: 12, right: 12, bottom: 12 })
    .backgroundColor($r('app.color.system_color_background_white'))
    .border({ width: { bottom: 1 }, color: $r('app.color.system_color_background_gray') })
    .borderRadius({ topLeft: $r('app.string.border_radius_16'), topRight: $r('app.string.border_radius_16') })
    .gesture(
      PanGesture({ direction: PanDirection.Vertical }).onActionStart((event: GestureEvent) => {
        this.changeHeight(event.offsetY);
      }),
    )
  }

  @Builder
  barBuilder() {
    Row() {
      Row()
        .height(4)
        .width(48)
        .backgroundColor($r('sys.color.icon_fourth'))
        .borderRadius($r('app.string.border_radius_2'))
    }
    .height(28)
    .width(88)
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Top)
    .padding({ top: $r('app.string.padding_8') })
    .onClick(() => {
      if (this.iHeight !== HeightEnum.LEVEL2) {
        this.iHeight = HeightEnum.LEVEL2;
      }
    })
  }

  @Builder
  descTextBuilder() {
    Text('附近停车场')
      .fontWeight(FontWeight.Medium)
      .width(CommonConstants.FULL_WIDTH)
      .fontSize($r('sys.float.Body_M'))
      .fontColor($r('sys.color.font_primary'))
  }

  @Builder
  sortBuilder() {
    Row({ space: 8 }) {
      Text('距离最近').btnStyle(this.vm.sort === 0).onClick(() => {
        this.vm.sort = 0;
      })
      Text('余位最多').btnStyle(this.vm.sort === 1).onClick(() => {
        this.vm.sort = 1;
      })
    }.justifyContent(FlexAlign.Start).width(CommonConstants.FULL_WIDTH)
  }

  @Builder
  listBuilder() {
    List({ space: 8, scroller: this.vm.controller }) {
      ForEach(this.vm.sortedSpots, (item: BasicParkInfo) => {
        ListItem() {
          CommonSpotItem({ item: item, selected: item.siteId === this.vm.selectedSpot?.siteId })
        }
      }, (item: BasicParkInfo, index) => JSON.stringify(item) + '_' + index)
    }
    .layoutWeight(1)
    .scrollBar(BarState.Off)
    .border({ width: 1, color: $r('app.color.border_gray'), radius: $r('app.string.border_radius_16') })
    .divider({ strokeWidth: 1, color: 'rgba(0,0,0,0.20)' })
    .padding($r('app.string.padding_6'))
    .onScrollIndex((start) => {
      this.vm.curIndex = start;
    })
  }
}

@Extend(Text)
function btnStyle(isActive: boolean) {
  .fontSize($r('sys.float.Body_M'))
  .fontColor($r('sys.color.font_primary'))
  .borderRadius($r('app.string.border_radius_10'))
  .backgroundColor(isActive ? '#cedefd' : ' #f3f3f3')
  .padding({
    left: 10,
    right: 10,
    top: 6,
    bottom: 6,
  })
}