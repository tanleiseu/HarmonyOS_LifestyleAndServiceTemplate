import { CommonConstants, IOrder, WindowUtil } from 'commonlib';
import { CommonHeader, AssociateUtil } from 'componentlib';
import { OrderCardItem } from '../components/OrderCardItem';
import { OrderPageVM } from '../viewmodels/OrderPageVM';

@ComponentV2
export struct OrderListPage {
  @Local refresh: boolean = false;
  vm: OrderPageVM = OrderPageVM.instance;

  aboutToAppear() {
    this.vm.getAllOrder();
  }

  build() {
    NavDestination() {
      /** 标题 **/
      CommonHeader({ title: '全部订单' })

      /** 列表 **/
      this.orderListBuilder()
    }
    .backgroundColor($r('app.color.system_color_background_gray'))
    .padding({ bottom: WindowUtil.getAvoidArea().bottom })
    .hideTitleBar(true)
  }

  @Builder
  orderListBuilder() {
    Refresh({ refreshing: $$this.refresh }) {
      List({ space: 16 }) {
        ForEach(Array.from(this.vm.sortedMap.entries()), (group: [string, IOrder[]]) => {
          ListItemGroup({ space: 12, header: () => this.headBuilder(group[0]) }) {
            ForEach(group[1], (order: IOrder, index) => {
              ListItem() {
                OrderCardItem({
                  order: order,
                  delete: () => {
                    AssociateUtil.checkBindPhone(() => {
                      this.vm.deleteOrder(order.orderId, group[0], index);
                    });
                  },
                })
              }
            }, (order: IOrder) => order.orderId)
          }
        }, (group: [string, IOrder[]], index) => JSON.stringify(group[1]) + '_' + index)
      }
      .width(CommonConstants.FULL_WIDTH)
      .height(CommonConstants.FULL_HEIGHT)
      .padding({ left: 16, right: 16, top: 8 })
    }
    .layoutWeight(1)
    .onRefreshing(() => {
      this.vm.getAllOrder().then(() => {
        this.refresh = false;
      });
    })
  }

  @Builder
  headBuilder(text: string) {
    Row({ space: 6 }) {
      Text(text)
        .fontSize($r('sys.float.Caption_L'))
        .fontColor($r('sys.color.font_primary'))
      Image($r('app.media.ic_arrow_down')).width(10).fillColor($r('sys.color.icon_secondary'))
    }
    .margin({ bottom: $r('app.string.margin_8') })
  }
}

@Builder
export function OrderListPageBuilder() {
  OrderListPage()
}