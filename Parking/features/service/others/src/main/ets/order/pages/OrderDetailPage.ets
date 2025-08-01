import { CommonConstants, FormatUtil, IOrder, RouterMap, RouterModule, WindowUtil } from 'commonlib';
import { CommonHeader } from 'componentlib';

@ComponentV2
export struct OrderDetailPage {
  @Local order?: IOrder;

  aboutToAppear() {
    // 此处用相同数据,模拟调用接口获取订单详情
    this.order = RouterModule.getNavParam({ url: RouterMap.ORDER_DETAIL });
  }

  build() {
    NavDestination() {
      /** 标题 **/
      CommonHeader({ title: '订单详情' })

      Scroll() {
        Column() {
          Text('订单信息')
            .fontWeight(FontWeight.Medium)
            .width('calc(100% - 32vp)')
            .fontSize($r('sys.float.Subtitle_M'))
            .fontColor($r('sys.color.font_primary'))
            .margin({ bottom: $r('app.string.margin_12'), top: $r('app.string.margin_8') })

          Column({ space: 24 }) {
            this.itemBuilder('车牌号', this.order?.license ?? '')
            this.itemBuilder('停车场', this.order?.spot ?? '')
            this.itemBuilder('入场时间', FormatUtil.dateTimeDisplay(new Date(this.order?.start ?? ''), true, false))
            this.itemBuilder('停留时间', FormatUtil.durationDisplay(this.order?.start ?? 0, this.order?.end ?? 0))
            this.itemBuilder('支付金额', '¥ ' + this.order?.cost?.toFixed(2), true)
            this.itemBuilder('支付方式', '华为支付')
            this.itemBuilder('订单号', this.order?.orderId ?? '')
          }.containerStyle()

          Blank().layoutWeight(1)
        }
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .backgroundColor($r('app.color.system_color_background_gray'))
    .padding({ bottom: WindowUtil.getAvoidArea().bottom })
    .hideTitleBar(true)
  }

  @Builder
  itemBuilder(desc: string, value: string, medium: boolean = false) {
    Row() {
      Text(desc).textStyle(true)
      Text(value).textStyle(medium)
    }
    .width(CommonConstants.FULL_WIDTH)
    .justifyContent(FlexAlign.SpaceBetween)
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
function textStyle(medium: boolean) {
  .fontWeight(medium ? FontWeight.Medium : FontWeight.Regular)
  .fontSize($r('sys.float.Body_M'))
  .fontColor($r('sys.color.font_primary'))
}

@Builder
export function OrderDetailPageBuilder() {
  OrderDetailPage()
}