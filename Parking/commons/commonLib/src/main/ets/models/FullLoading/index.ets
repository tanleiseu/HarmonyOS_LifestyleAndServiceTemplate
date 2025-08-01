import { ComponentContent, promptAction } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from '../../utils/Logger';

const TAG = '[FullLoading]';

export class FullLoading {
  public static isLoading: boolean = false;
  private static _ctx: UIContext;
  private static _contentNode: ComponentContent<Object>;
  private static _options: promptAction.BaseDialogOptions;
  private static _count: number = 0;

  public static init(ctx: UIContext) {
    FullLoading._ctx = ctx;
    FullLoading._contentNode = new ComponentContent(FullLoading._ctx, wrapBuilder(fullLoading));
    FullLoading._options = {
      alignment: DialogAlignment.Center,
      autoCancel: false,
    };
  }

  public static showLoading(doNext?: () => void) {
    FullLoading._count++;
    if (FullLoading.isLoading || FullLoading._count > 1) {
      return;
    }
    if (FullLoading._contentNode !== null) {
      FullLoading._ctx.getPromptAction()
        .openCustomDialog(FullLoading._contentNode, FullLoading._options)
        .then(() => {
          FullLoading.isLoading = true;
          doNext?.();
        })
        .catch((error: BusinessError) => {
          Logger.error(TAG, `OpenCustomDialog args error code is ${error.code}, message is ${error.message}`);
        });
    }
  }

  public static hideLoading(doNext?: () => void) {
    if (!FullLoading.isLoading) {
      return;
    }
    FullLoading._count--;
    if (FullLoading._contentNode !== null && FullLoading.isLoading && FullLoading._count === 0) {
      FullLoading._ctx.getPromptAction()
        .closeCustomDialog(FullLoading._contentNode)
        .then(() => {
          Logger.info(TAG, 'CloseCustomDialog complete.');
          FullLoading.isLoading = false;
          FullLoading._count = 0;
          doNext?.();
        })
        .catch((error: BusinessError) => {
          Logger.error(TAG, `CloseCustomDialog args error code is ${error.code}, message is ${error.message}`);
        });
    }
  }
}

@Builder
export function fullLoading() {
  Stack({ alignContent: Alignment.Center }) {
    Column() {
      LoadingProgress().size({ width: 40, height: 40 }).color($r('sys.color.icon_on_primary'))
    }
    .justifyContent(FlexAlign.Center)
    .width(100)
    .height(100)
    .backgroundColor('#88000000')
    .borderRadius(8)
  }
  .width('100%')
  .height('100%')
  .backgroundColor(Color.Transparent)
}