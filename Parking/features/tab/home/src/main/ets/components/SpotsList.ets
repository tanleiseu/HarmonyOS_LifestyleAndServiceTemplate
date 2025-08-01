import { BasicParkInfo, CommonConstants } from 'commonlib';
import { HomePageVM } from '../viewmodels/HomePageVM';
import { CommonSpotItem, CommonTab } from 'componentlib';

@ComponentV2
export struct SpotsList {
  @Local index: number = 0;
  vm: HomePageVM = HomePageVM.instance;
  maxHeight: Length = '64%';

  build() {
    Column() {
      CommonTab({
        tabBar: ['附近停车场', '收藏停车场'],
        index: this.index!!,
        start: true,
        offsetLeft: 28,
        space: 16,
        tabBarHeight: 40,
        relativeY: 30,
        activeSize: $r('sys.float.Body_M'),
        frozenSize: $r('sys.float.Body_M'),
        activeColor: $r('app.color.btn_text_blue'),
        frozenColor: $r('sys.color.font_secondary'),
        contentUi: (index) => {
          this.listBuilder(index)
        },
      })
    }
    .constraintSize({ maxHeight: this.maxHeight })
  }

  @Builder
  listBuilder(index: number) {
    Column() {
      if ((index ? this.vm.collectList.list : this.vm.nearbyList).length === 0) {
        Column({ space: 4 }) {
          Image($r('app.media.ic_null_spots')).width(120)
          Text(index ? '暂无收藏停车场' : '暂无附近停车场')
            .fontSize($r('sys.float.Caption_M'))
            .fontColor($r('sys.color.font_tertiary'))
        }
        .height(180).containerStyle()
      } else {
        Refresh({ refreshing: $$this.vm.refreshing }) {
          List({ space: 26 }) {
            ForEach(index ? this.vm.collectList.list : this.vm.nearbyList, (item: BasicParkInfo) => {
              ListItem() {
                CommonSpotItem({ item: item, pad: 0 })
              }
            }, (item: BasicParkInfo, index) => JSON.stringify(item) + '_' + index)
          }
          .scrollBar(BarState.Off)
          .divider({ strokeWidth: 1, color: $r('sys.color.comp_divider') })
          .nestedScroll({ scrollForward: NestedScrollMode.PARENT_FIRST, scrollBackward: NestedScrollMode.SELF_FIRST })
          .containerStyle()
        }
        .clip(false)
        .onRefreshing(() => {
          this.vm.refreshNewNearby();
        })
      }
      Blank().layoutWeight(1)
    }.width('calc(100% - 32vp)')
  }

  @Styles
  containerStyle() {
    .padding($r('app.string.padding_12'))
    .borderRadius($r('app.string.border_radius_16'))
    .backgroundColor($r('app.color.system_color_background_white'))
    .width(CommonConstants.FULL_WIDTH)
  }
}