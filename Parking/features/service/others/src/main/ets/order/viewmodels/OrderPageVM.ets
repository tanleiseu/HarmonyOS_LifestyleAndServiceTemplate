import { IOrder, Logger } from 'commonlib';
import { getId, Https } from 'network';

@ObservedV2
export class OrderPageVM {
  @Trace sortedMap: Map<string, IOrder[]> = new Map<string, IOrder[]>();
  private static _instance: OrderPageVM;

  public static get instance() {
    if (!OrderPageVM._instance) {
      OrderPageVM._instance = new OrderPageVM();
    }
    return OrderPageVM._instance;
  }

  /** 获取所有订单 **/
  public async getAllOrder() {
    const res = await Https.getAllOrder({ id: getId() });
    if (res.code === 0 && res.data.info) {
      this.sortedMap = this._groupByYearMonth(res.data.info);
    }
  }

  /** 确定订单删除 **/
  public deleteOrder(orderId: string, group: string, index: number) {
    AlertDialog.show({
      message: '删除后将无法恢复，是否删除？',
      alignment: DialogAlignment.Center,
      height: 125,
      primaryButton: {
        value: '取消',
        fontColor: '#1a1a1a',
        action: () => {
          Logger.info('取消删除');
        },
      },
      secondaryButton: {
        value: '确定',
        fontColor: $r('app.color.delete_red'),
        action: () => {
          Https.deleteOrder({ id: orderId }).then(res => {
            if (res.code === 0) {
              const orderList = this.sortedMap.get(group);
              orderList?.splice(index, 1);
              if (orderList?.length) {
                this.sortedMap.set(group, orderList);
              } else {
                this.sortedMap.delete(group);
              }
            }
          });
        },
      },
    });
  }

  /** 根据年月分组 **/
  private _groupByYearMonth(items: IOrder[]): Map<string, IOrder[]> {
    const groupedMap = new Map<string, IOrder[]>();
    items.forEach(item => {
      const date = new Date(item.start);
      const yearMonth = `${date.getFullYear()}年${String(date.getMonth() + 1).padStart(2, '0')}月`;
      if (groupedMap.has(yearMonth)) {
        groupedMap.get(yearMonth)?.push(item);
      } else {
        groupedMap.set(yearMonth, [item]);
      }
    });
    const sortedKeys = Array.from(groupedMap.keys()).sort().reverse();
    const sortedMap = new Map<string, IOrder[]>();
    sortedKeys.forEach(key => {
      const group = groupedMap.get(key)!;
      group.sort((a, b) => b.start - a.start);
      sortedMap.set(key, group);
    });
    return sortedMap;
  }
}
