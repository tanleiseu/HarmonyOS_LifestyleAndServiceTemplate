import { PersistenceV2 } from '@kit.ArkUI';
import { BasicParkInfo, BasicParkInfoModel } from '../../types';
import { CollectListModel } from './models';

@ObservedV2
export class CollectUtil {
  // 本地收藏列表
  private static _collectList: CollectListModel =
    PersistenceV2.connect(CollectListModel, 'collectList', () => new CollectListModel())!;

  public static getCollectList() {
    return CollectUtil._collectList;
  }

  public static cancelCollect(id: string) {
    const index = CollectUtil._collectList.list.findIndex(item => item.siteId === id);
    if (index !== -1) {
      CollectUtil._collectList.list.splice(index, 1);
    }
  }

  public static addCollect(info: BasicParkInfo) {
    const model: BasicParkInfoModel = {
      siteId: info.siteId,
      name: info.name,
      addr: info.addr,
      location: info.location,
      distance: info.distance,
      totalSpots: info.totalSpots,
      leftSpots: info.leftSpots,
      chargeSpots: info.chargeSpots,
      leftChargeSpots: info.leftChargeSpots,
    };
    CollectUtil._collectList.list.push(model);
  }

  public static isCollected(id: string): boolean {
    const index = CollectUtil._collectList.list.findIndex(item => item.siteId === id);
    return index !== -1;
  }
}

export * from './models';