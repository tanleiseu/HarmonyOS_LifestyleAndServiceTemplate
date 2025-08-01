import {
  BasicParkInfo,
  BasicParkInfoModel,
  CollectListModel,
  CollectUtil,
  CommonConstants,
  EmitterConstants,
  RouterMap,
  RouterModule,
  WindowUtil,
} from 'commonlib';
import { CommonHeader } from 'componentlib';
import { emitter } from '@kit.BasicServicesKit';

@ComponentV2
export struct CollectPage {
  // 收藏列表
  collectList: CollectListModel = CollectUtil.getCollectList();

  build() {
    NavDestination() {
      /** 标题 **/
      CommonHeader({ title: '我的收藏' })

      if (this.collectList.list.length) {
        /** 列表内容 **/
        this.collectListBuilder()
      } else {
        /** 为空占位 **/
        this.nullBuilder()
      }
    }
    .hideTitleBar(true)
    .padding({ bottom: WindowUtil.getAvoidArea().bottom })
    .backgroundColor($r('app.color.system_color_background_gray'))
  }

  @Builder
  collectListBuilder() {
    List({ space: 12 }) {
      ForEach(this.collectList.list, (item: BasicParkInfoModel) => {
        this.collectItemBuilder(item)
      }, (item: BasicParkInfoModel, index) => JSON.stringify(item) + '_' + index)
    }
    .padding({ left: $r('app.string.padding_16'), right: $r('app.string.padding_16') })
    .layoutWeight(1)
  }

  @Builder
  nullBuilder() {
    Column() {
      Image($r('app.media.ic_null_collect')).width(120)
      Text('暂无收藏')
        .fontSize($r('sys.float.Caption_M'))
        .fontColor($r('sys.color.font_tertiary'))
    }
    .margin({ top: $r('app.string.margin_48') })
    .justifyContent(FlexAlign.Start)
    .onClick(() => {
      emitter.emit(EmitterConstants.TO_FIND);
      RouterModule.pop();
    })
  }

  @Builder
  collectItemBuilder(info: BasicParkInfo) {
    ListItem() {
      Row({ space: 12 }) {
        Column({ space: 4 }) {
          Text(info.name)
            .fontWeight(FontWeight.Medium)
            .fontSize($r('sys.float.Body_M'))
            .fontColor($r('sys.color.font_primary'))
          Text(info.addr)
            .fontSize($r('sys.float.Caption_M'))
            .fontColor($r('sys.color.font_secondary'))
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        Image($r('app.media.ic_collect'))
          .width(24)
          .onClick(() => {
            // 取消收藏
            CollectUtil.cancelCollect(info.siteId);
          })
      }
    }
    .height(60)
    .containerStyle()
    .onClick(() => {
      RouterModule.push({ url: RouterMap.SITE_DETAIL, param: info });
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

@Builder
export function CollectPageBuilder() {
  CollectPage()
}