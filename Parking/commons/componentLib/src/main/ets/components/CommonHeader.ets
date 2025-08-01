import { CommonConstants, RouterModule, WindowUtil } from 'commonlib';
import { HeaderConstant } from '../constants';

@ComponentV2
export struct CommonHeader {
  // 标题文字
  @Param title: string = '';
  // 返回动画
  @Param backAnimation: boolean = true;
  @Param showBackButton: boolean = true;
  headerHeight: number = HeaderConstant.HEIGHT;

  build() {
    Row() {
      if (this.showBackButton) {
        Row() {
          Image($r('app.media.ic_back')).width(HeaderConstant.ICON_SIZE_INNER)
        }
        .aspectRatio(1)
        .borderRadius('50%')
        .justifyContent(FlexAlign.Center)
        .width(HeaderConstant.ICON_SIZE_OUTER)
        .margin({ right: HeaderConstant.MARGIN })
        .backgroundColor(HeaderConstant.ICON_BG_COLOR)
        .onClick(() => {
          RouterModule.pop(this.backAnimation);
        })
      }
      Text(this.title)
        .fontWeight(this.showBackButton ? FontWeight.Bold : FontWeight.Medium)
        .fontSize(this.showBackButton ? $r('sys.float.Title_S') : $r('sys.float.Title_M'))
        .fontColor(HeaderConstant.FONT_COLOR)
        .padding({ left: this.showBackButton ? 0 : 8 })
    }
    .height(this.headerHeight)
    .width(CommonConstants.FULL_WIDTH)
    .justifyContent(FlexAlign.Start)
    .backgroundColor(Color.Transparent)
    .padding({ left: HeaderConstant.PADDING })
    .margin({ bottom: 4, top: WindowUtil.getAvoidArea().top })
  }
}