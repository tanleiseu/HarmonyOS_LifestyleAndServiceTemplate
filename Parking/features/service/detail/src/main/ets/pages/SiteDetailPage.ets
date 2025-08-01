import { CommonConstants, FormatUtil, LocationUtil, WindowUtil } from 'commonlib';
import { CommonCall, CommonHeader } from 'componentlib';
import { SiteDetailPageVM } from '../viewmodels/SiteDetailPageVM';
import { common } from '@kit.AbilityKit';
import { PreView } from '../utils/PreView';

@ComponentV2
struct SiteDetailPage {
  @Local showCall: boolean = false;
  vm: SiteDetailPageVM = SiteDetailPageVM.instance;
  controller: SwiperController = new SwiperController();

  getMargin(index: number): Padding {
    if (index === 0) {
      return { left: 16, right: 6 };
    } else if (index + 1 === this.vm.detail?.basicPic.length) {
      return { left: 6, right: 16 };
    }
    return { left: 6, right: 6 };
  }

  aboutToAppear() {
    this.vm.init(this.getUIContext());
  }

  build() {
    NavDestination() {
      /** 标题 **/
      CommonHeader({ title: '停车详情' })

      Scroll() {
        if (this.vm.detail) {
          Column({ space: 12 }) {
            // 基本信息
            this.basicInfoBuilder()

            // 轮播图
            this.swiperBuilder()

            //车位信息
            this.numBuilder()

            //收费标准
            this.chargeBuilder()

            Blank().layoutWeight(1)
          }
        }
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)
    }
    .padding({ bottom: WindowUtil.getAvoidArea().bottom })
    .backgroundColor($r('app.color.system_color_background_gray'))
    .hideTitleBar(true)
  }

  @Builder
  basicInfoBuilder() {
    Column({ space: 12 }) {
      Row() {
        Column({ space: 8 }) {
          Text(this.vm.detail!.name)
            .fontWeight(FontWeight.Medium)
            .fontSize($r('sys.float.Subtitle_M'))
            .fontColor($r('sys.color.font_primary'))
          Text() {
            Span('营业时间 ').fontColor($r('sys.color.font_primary'))
            Span(this.vm.detail!.parkTime).fontColor($r('sys.color.font_secondary'))
          }.fontSize($r('sys.float.Caption_M'))
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        Image($r('app.media.ic_collect'))
          .width(24)
          .fillColor(this.vm.isCollect ? $r('app.color.icon_collect') : $r('app.color.icon_no_collect'))
          .onClick(() => {
            this.vm.collectOrCancel();
          })
      }.alignItems(VerticalAlign.Top)

      Divider().color($r('sys.color.comp_divider'))

      Row() {
        Column({ space: 8 }) {
          Text(`驾车${FormatUtil.distanceDisplay(this.vm.detail?.distance ?? 0)}`)
            .fontWeight(FontWeight.Medium)
            .fontSize($r('sys.float.Caption_L'))
            .fontColor($r('sys.color.font_primary'))
          Text(this.vm.detail!.addr)
            .fontSize($r('sys.float.Caption_M'))
            .fontColor($r('sys.color.font_secondary'))
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        Image($r('app.media.ic_nav')).width(24).onClick(() => {
          LocationUtil.navWithLatLng(this.vm.detail!.location, getContext(this) as common.UIAbilityContext);
        })

        Image($r('app.media.ic_call')).width(24).onClick(() => {
          this.showCall = true;
        }).margin({ left: $r('app.string.margin_16') })
          .bindSheet($$this.showCall, this.callBuilder, { height: SheetSize.FIT_CONTENT })
      }.alignItems(VerticalAlign.Center)
    }
    .containerStyle()
  }

  @Builder
  swiperBuilder() {
    Swiper(this.controller) {
      ForEach(this.vm.detail!.basicPic, (item: ResourceStr, index: number) => {
        Image(item)
          .margin(this.getMargin(index))
          .onClick(() => {
            if (this.vm.swiperParams) {
              this.vm.swiperParams.index = index;
              PreView.openDialogWithParams(this.vm.swiperParams);
            }
          })
          .borderRadius($r('app.string.border_radius_16'))
      }, (item: ResourceStr, index) => JSON.stringify(item) + '_' + index)
    }
    .height(120)
    .width(CommonConstants.FULL_WIDTH)
    .index(this.vm.swiperIndex)
    .autoPlay(false)
    .indicator(false)
    .loop(false)
    .nextMargin(50, true)
    .prevMargin(50, true)
  }

  @Builder
  numBuilder() {
    Column({ space: 8 }) {
      Text('车位信息').titleStyle()
      Text(`共${this.vm.detail!.totalSpots}停车位，${this.vm.detail!.chargeSpots}充电桩（车位信息仅供参考，具体以实际为准）`)
        .textStyle()
      Row({ space: 8 }) {
        this.numItemBuilder(0, this.vm.detail?.leftSpots ?? 0)
        if (this.vm.detail?.chargeSpots) {
          this.numItemBuilder(1, this.vm.detail?.leftChargeSpots ?? 0)
        }
      }
    }.containerStyle().alignItems(HorizontalAlign.Start)
  }

  @Builder
  chargeBuilder() {
    Column({ space: 4 }) {
      Text('收费标准').titleStyle()
      Column({ space: 12 }) {
        Text(this.vm.detail!.chargeRules).textStyle()
        this.chargeItemBuilder(0, 1)
        this.chargeItemBuilder(1, 2)
        Row() {
          Text('收费时间: 全天')
            .fontSize($r('sys.float.Caption_M'))
            .fontColor($r('sys.color.font_primary'))
          Text('停车不满15分钟免费')
            .fontSize($r('sys.float.Caption_M'))
            .fontColor($r('sys.color.font_secondary'))
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width(CommonConstants.FULL_WIDTH)
      }
    }.containerStyle()
  }

  @Builder
  numItemBuilder(type: number, value: number) {
    Row() {
      Text(type ? '桩' : 'P')
        .width(24)
        .aspectRatio(1)
        .textAlign(TextAlign.Center)
        .fontSize($r('sys.float.Body_M'))
        .fontColor($r('sys.color.font_on_primary'))
        .borderRadius($r('app.string.border_radius_8'))
        .backgroundColor(type ? $r('app.color.icon_bg_green') : $r('app.color.icon_bg_blue'))
      Text((type ? '闲桩 ' : '余位 ') + value)
        .fontWeight(FontWeight.Medium)
        .height(CommonConstants.FULL_HEIGHT)
        .borderRadius({ topRight: $r('app.string.border_radius_8'), bottomRight: $r('app.string.border_radius_8') })
        .padding({ left: $r('app.string.padding_4'), right: $r('app.string.padding_4') })
        .backgroundColor(type ? $r('app.color.text_bg_green') : $r('app.color.text_bg_blue'))
        .fontSize($r('sys.float.Caption_M'))
        .fontColor(type ? $r('app.color.icon_bg_green') : $r('app.color.icon_bg_blue'))
    }
    .height(24)
  }

  @Builder
  chargeItemBuilder(type: number, value: number) {
    Row() {
      Image(type ? $r('app.media.ic_car_max') : $r('app.media.ic_car_min')).width(24).margin({ right: 4 })
      Text(type ? '大型车' : '小型车')
        .fontSize(8)
        .padding($r('app.string.padding_4'))
        .borderRadius($r('app.string.border_radius_16'))
        .fontColor($r('app.color.icon_bg_blue'))
        .backgroundColor($r('app.color.text_bg_blue'))
      Blank().layoutWeight(1)
      Text() {
        Span('¥ ')
        Span(value.toString()).fontWeight(FontWeight.Medium).fontSize(14)
        Span('/15分钟')
      }
      .fontSize(12)
      .fontColor($r('app.color.icon_bg_blue'))
    }
  }

  @Builder
  callBuilder() {
    CommonCall({
      phoneNum: this.vm.detail?.phone,
      title: '联系客服',
      cancel: () => {
        this.showCall = false;
      },
    })
  }

  @Styles
  containerStyle() {
    .padding($r('app.string.padding_12'))
    .borderRadius($r('app.string.border_radius_16'))
    .backgroundColor($r('app.color.system_color_background_white'))
    .width('calc(100% - 32vp)')
  }
}

@Extend(Text)
function titleStyle() {
  .fontWeight(FontWeight.Medium)
  .width(CommonConstants.FULL_WIDTH)
  .fontSize($r('sys.float.Body_M'))
  .fontColor($r('sys.color.font_primary'))
}


@Extend(Text)
function textStyle() {
  .width(CommonConstants.FULL_WIDTH)
  .fontSize($r('sys.float.Caption_M'))
  .fontColor($r('sys.color.font_secondary'))
}

@Builder
export function SiteDetailPageBuilder() {
  SiteDetailPage()
}