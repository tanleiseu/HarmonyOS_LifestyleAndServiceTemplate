import { BasicParkInfoModel } from '../../types';
import { Type } from '@kit.ArkUI';

@ObservedV2
export class CollectListModel {
  // 此处保存基本信息=>保存数据一致性
  // 实际只需要保存停车场id
  @Type(BasicParkInfoModel)
  @Trace list: BasicParkInfoModel[] = [];
}