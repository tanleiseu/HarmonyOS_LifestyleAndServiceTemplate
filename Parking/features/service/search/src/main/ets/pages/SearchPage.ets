import { CommonHeader } from 'componentlib';
import { CommonUtil, IAddressInfo, WindowUtil } from 'commonlib';
import { HistoryUtil } from '../utils';
import { SearchPageVM } from '../viewmodels/SearchPageVM';
import { CommonConstants } from 'commonlib/src/main/ets/constants/CommonContants';

@ComponentV2
export struct SearchPage {
  vm: SearchPageVM = SearchPageVM.instance;

  aboutToAppear() {
    this.vm.init();
  }

  build() {
    NavDestination() {
      /** 标题栏 **/
      CommonHeader({ title: '搜索列表' })

      /** 搜索框 **/
      Search({ value: this.vm.text, placeholder: '输入地址' })
        .margin({ bottom: $r('app.string.margin_8') })
        .searchButton('搜索')
        .onChange(CommonUtil.debounce((res: string) => {
          this.vm.text = res.trim();
          this.vm.autoCompleteAddress();
        }, 200))
        .width('calc(100% - 32vp)')

      Scroll() {
        Column() {
          if (!this.vm.text) {
            /** 搜索历史 **/
            this.historyBuilder()
          } else if (this.vm.searchList.length) {
            /** 补全列表 **/
            this.searchListBuilder()
          } else if (!this.vm.searching) {
            /** 搜索为空 **/
            this.nullBuilder()
          }
          Blank().layoutWeight(1)
        }
        .padding({ left: $r('app.string.padding_16'), right: $r('app.string.padding_16') })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .backgroundColor($r('app.color.system_color_background_gray'))
    .padding({ bottom: WindowUtil.getAvoidArea().bottom })
    .hideTitleBar(true)
  }

  @Builder
  searchListBuilder() {
    if (this.vm.searchList.length) {
      Column() {
        List({ space: 16 }) {
          ForEach(this.vm.searchList, (item: IAddressInfo) => {
            this.searchItemBuilder(item)
          }, (item: IAddressInfo, index) => JSON.stringify(item) + '_' + index)
        }
        .containerStyle()
        .scrollBar(BarState.Off)
      }
    }
  }

  @Builder
  nullBuilder() {
    Column() {
      Text('搜索结果')
        .fontWeight(FontWeight.Medium)
        .width(CommonConstants.FULL_WIDTH)
        .fontSize($r('sys.float.Body_M'))
        .fontColor($r('sys.color.font_primary'))

      Divider()
        .color($r('sys.color.comp_divider'))
        .margin({ top: $r('app.string.margin_12'), bottom: $r('app.string.margin_12') })

      Image($r('app.media.ic_null_history')).width(120).aspectRatio(1)
      Text('未搜索到相关地址')
        .fontSize($r('sys.float.Caption_M'))
        .fontColor($r('sys.color.font_tertiary'))
        .margin({ top: $r('app.string.margin_4'), bottom: $r('app.string.margin_10') })
    }
    .containerStyle()
  }

  @Builder
  historyBuilder() {
    Column() {
      Text('搜索记录')
        .fontWeight(FontWeight.Medium)
        .width(CommonConstants.FULL_WIDTH)
        .fontSize($r('sys.float.Body_M'))
        .fontColor($r('sys.color.font_primary'))

      Divider()
        .color($r('sys.color.comp_divider'))
        .margin({ top: $r('app.string.margin_12'), bottom: $r('app.string.margin_12') })

      if (this.vm.historyList.list.length) {
        List({ space: 16 }) {
          ForEach(this.vm.historyList.list, (item: IAddressInfo) => {
            this.searchItemBuilder(item)
          }, (item: IAddressInfo, index) => JSON.stringify(item) + '_' + index)
        }
        .scrollBar(BarState.Off)

        Text('清空历史记录')
          .fontSize($r('sys.float.Caption_L'))
          .fontColor($r('sys.color.font_tertiary'))
          .margin({ top: $r('app.string.margin_24') })
          .onClick(() => {
            HistoryUtil.clearList();
          })
      } else {
        Image($r('app.media.ic_null_history')).width(120).aspectRatio(1)
        Text('暂无搜索记录')
          .fontSize($r('sys.float.Caption_M'))
          .fontColor($r('sys.color.font_tertiary'))
          .margin({ top: $r('app.string.margin_4'), bottom: $r('app.string.margin_10') })
      }
    }
    .containerStyle()
  }

  @Builder
  searchItemBuilder(address: IAddressInfo) {
    Row({ space: 8 }) {
      Image($r('app.media.ic_location')).width(16)
      Column({ space: 4 }) {
        Text(address.name)
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.Body_M'))
          .fontColor($r('sys.color.font_primary'))
          .textStyle()
        Text(address.addr)
          .fontSize($r('sys.float.Caption_M'))
          .fontColor($r('sys.color.font_tertiary'))
          .textStyle()
      }.alignItems(HorizontalAlign.Start).layoutWeight(1)
    }
    .alignItems(VerticalAlign.Top)
    .justifyContent(FlexAlign.Start)
    .width(CommonConstants.FULL_WIDTH)
    .onClick(async () => {
      await this.vm.clickCardNextDo(address);
    })
  }

  @Styles
  containerStyle() {
    .padding($r('app.string.padding_12'))
    .borderRadius($r('app.string.border_radius_16'))
    .backgroundColor($r('app.color.system_color_background_white'))
    .width(CommonConstants.FULL_WIDTH)
  }
}

@Extend(Text)
function textStyle() {
  .maxLines(1)
  .textOverflow({ overflow: TextOverflow.Ellipsis })
}

@Builder
export function SearchPageBuilder() {
  SearchPage()
}