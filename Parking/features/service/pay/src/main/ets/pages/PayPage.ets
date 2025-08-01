import { CommonConstants, FormatUtil, OrderStatus, WindowUtil } from 'commonlib';
import { CommonButton, CommonHeader, AssociateUtil } from 'componentlib';
import { QueryPayPageVM } from '../viewmodels/QueryPayPageVM';

@ComponentV2
export struct PayPage {
  vm: QueryPayPageVM = QueryPayPageVM.instance;

  aboutToAppear(): void {
    this.vm.resetPayParams();
    this.vm.queryParking();
  }

  build() {
    NavDestination() {
      /** 标题栏 **/
      CommonHeader({ title: '缴费详情' })

      if (this.vm.hasInit) {
        Column() {
          Refresh({ refreshing: $$this.vm.refresh }) {
            Scroll() {
              Column() {
                if (this.vm.order) {
                  /** 缴费详情 **/
                  this.payBuilder()
                } else {
                  /** 为空占位 **/
                  this.nullBuilder()
                }
              }
            }
            .scrollBar(BarState.Off)
            .layoutWeight(1)
          }
          .layoutWeight(1)
          .onRefreshing(() => {
            this.vm.queryParking();
          })

          if (this.vm.order && this.vm.order.status === OrderStatus.PARKING) {
            Text() {
              Span('还需支付:  ')
              Span('¥' + this.vm.order?.cost?.toFixed(2)).fontColor($r('sys.color.multi_color_08'))
            }
            .fontWeight(FontWeight.Medium)
            .fontSize($r('sys.float.Body_L'))
            .fontColor($r('sys.color.font_primary'))
            .margin({ top: $r('app.string.margin_8'), bottom: $r('app.string.margin_16') })

            CommonButton({
              title: '立即支付',
              handleClick: () => {
                AssociateUtil.checkBindPhone(() => {
                  this.vm.payParking();
                });
              },
            })
          } else if (this.vm.order && this.vm.order.status === OrderStatus.PENDING) {
            Text() {
              Span('已支付:  ')
              Span('¥' + this.vm.order?.cost?.toFixed(2)).fontColor($r('sys.color.multi_color_08'))
              Span('  ,请尽快离场!')
            }
            .fontWeight(FontWeight.Medium)
            .fontSize($r('sys.float.Body_L'))
            .fontColor($r('sys.color.font_primary'))
            .margin({ top: $r('app.string.margin_8') })
          }
        }.layoutWeight(1)
      }
    }
    .backgroundColor($r('app.color.system_color_background_gray'))
    .padding({ bottom: WindowUtil.getAvoidArea().bottom })
    .height(CommonConstants.FULL_HEIGHT)
    .hideTitleBar(true)
  }

  @Builder
  nullBuilder() {
    Column() {
      Image($r('app.media.ic_null_pay')).width(120)
      Text('未查询到车辆信息，请检查车牌号是否正确或再次刷新～')
        .fontSize($r('sys.float.Caption_M'))
        .fontColor($r('sys.color.font_tertiary'))
    }.margin({ top: $r('app.string.margin_48') })
  }

  @Builder
  payBuilder() {
    Column() {
      Text('车辆信息')
        .fontWeight(FontWeight.Medium)
        .width('calc(100% - 32vp)')
        .fontSize($r('sys.float.Subtitle_M'))
        .fontColor($r('sys.color.font_primary'))
        .margin({ bottom: $r('app.string.margin_12'), top: $r('app.string.margin_8') })

      Column({ space: 24 }) {
        this.itemBuilder('车牌号', this.vm.order?.license ?? '')
        this.itemBuilder('停车场', this.vm.order?.spot ?? '')
        this.itemBuilder('入场时间', FormatUtil.dateTimeDisplay(new Date(this.vm.order?.start ?? ''), true, false))
        this.itemBuilder('停留时间',
          FormatUtil.durationDisplay(this.vm.order?.start ?? Date.now(), this.vm.order?.end ?? Date.now()))
        this.itemBuilder('本次应付', '¥ ' + this.vm.order?.cost?.toFixed(2), true)
      }.containerStyle()
    }
  }

  @Builder
  itemBuilder(desc: string, value: string, red: boolean = false) {
    Row() {
      Text(desc).textStyle(true, false)
      Text(value).textStyle(red, red)
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
function textStyle(medium: boolean, red: boolean) {
  .fontWeight(medium ? FontWeight.Medium : FontWeight.Regular)
  .fontSize($r('sys.float.Body_M'))
  .fontColor(red ? $r('sys.color.multi_color_08') : $r('sys.color.font_primary'))
}

@Builder
export function PayPageBuilder() {
  PayPage()
}