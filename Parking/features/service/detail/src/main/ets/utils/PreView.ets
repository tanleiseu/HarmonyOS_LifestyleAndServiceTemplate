import { ComponentContent, promptAction } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from 'commonlib';

const TAG = '[PreView]';

export class PreView {
  private static _ctx: UIContext;
  private static _contentNode: ComponentContent<Object>;
  private static _options: promptAction.BaseDialogOptions;
  private static _hasInit: boolean;

  public static init(ctx: UIContext, params: SwiperParams) {
    if (PreView._hasInit) {
      PreView._contentNode.update(params);
      return;
    }
    PreView._ctx = ctx;
    PreView._contentNode = new ComponentContent(PreView._ctx, wrapBuilder(swiperPhotoView), params);
    PreView._options = {
      alignment: DialogAlignment.Center,
      transition: TransitionEffect.OPACITY,
      autoCancel: false,
    };
    PreView._hasInit = true;
  }

  public static openDialogWithParams(params: SwiperParams) {
    PreView._contentNode.update(params);
    if (PreView._contentNode !== null) {
      PreView._ctx.getPromptAction()
        .openCustomDialog(PreView._contentNode, PreView._options)
        .then(() => {
          Logger.info(TAG, 'OpenCustomDialog complete.');
        })
        .catch((error: BusinessError) => {
          let message = (error as BusinessError).message;
          let code = (error as BusinessError).code;
          Logger.error(TAG, `OpenCustomDialog args error code is ${code}, message is ${message}`);
        });
    }
  }

  public static closeDialog() {
    if (PreView._contentNode !== null) {
      PreView._ctx.getPromptAction()
        .closeCustomDialog(PreView._contentNode)
        .then(() => {
          Logger.info(TAG, 'CloseCustomDialog complete.');
        })
        .catch((error: BusinessError) => {
          let message = (error as BusinessError).message;
          let code = (error as BusinessError).code;
          Logger.error(TAG, `CloseCustomDialog args error code is ${code}, message is ${message}`);
        });
    }
  }
}

@Builder
export function swiperPhotoView(params: SwiperParams) {
  Column() {
    Swiper() {
      ForEach(params.imgList, (item: ResourceStr) => {
        Image(item)
          .width('100%')
          .objectFit(ImageFit.Contain)
          .gesture(PanGesture({ direction: PanDirection.Down }).onActionEnd(() => {
            params.slideDown?.();
          }))
      }, (item: ResourceStr, index) => JSON.stringify(item) + '_' + index)
    }
    .width('100%')
    .height('100%')
    .clip(false)
    .index(params.index)
    .loop(false)
    .autoPlay(false)
    .indicator(false)
    .onChange(index => {
      params.change?.(index);
    })
  }
  .justifyContent(FlexAlign.Center)
  .backgroundColor(Color.Black)
}

export class SwiperParams {
  imgList: ResourceStr[];
  index: number;
  slideDown?: () => void;
  change?: (index: number) => void;

  constructor(imgList: ResourceStr[], index: number) {
    this.imgList = imgList;
    this.index = index;
  }
}