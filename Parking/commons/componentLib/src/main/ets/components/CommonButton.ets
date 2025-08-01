import { ButtonConstant } from '../constants';

@ComponentV2
export struct CommonButton {
  // 按钮文字
  @Param title: string = '';
  // 按钮操作
  @Event handleClick: () => void;

  build() {
    Button(this.title)
      .fontWeight(FontWeight.Medium)
      .height(ButtonConstant.HEIGHT)
      .fontSize(ButtonConstant.TITLE_SIZE)
      .fontColor(ButtonConstant.FONT_COLOR)
      .backgroundColor(ButtonConstant.BG_COLOR)
      .width('calc(100% - 56vp)')
      .onClick(() => {
        this.handleClick();
      })
  }
}