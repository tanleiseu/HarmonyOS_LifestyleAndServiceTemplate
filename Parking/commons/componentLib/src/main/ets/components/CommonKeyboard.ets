import { window } from '@kit.ArkUI';
import { KeyboardConstant } from '../constants';

class CustomKeyItem {
  key: string;
  disable: boolean;

  constructor(key: string, disable: boolean) {
    this.key = key;
    this.disable = disable;
  }
}

@ComponentV2
export struct CommonKeyboard {
  // 初始是否激活键盘
  @Param intFocus: boolean = false;
  // 设置默认车牌显示
  @Param defaultNumbers: string = '';
  // 变化时回调操作
  @Event onChange: (carNumber: string[], isComplete: boolean) => void;
  @Local inputValue: string[] = new Array(8).fill('');
  @Local focusMark: boolean[] = new Array(8).fill(false);
  @Local keyBordTotal: CustomKeyItem[][] = [[], [], [], []];
  @Local inputIndex: number = 0;
  @Local windowWidth: number = 360;
  @Local inputWidth: number = 0;
  @Local inputHeight: number = 0;
  @Local avoidAreaHeight: number = 28;
  @Local isInput: boolean = false;
  controller: TextInputController = new TextInputController();
  provincesKeyBoard: string[][] = [
    ['京', '津', '沪', '渝', '冀', '豫', '云', '辽', '黑'],
    ['湘', '皖', '鲁', '新', '苏', '浙', '赣', '鄂', '桂'],
    ['甘', '晋', '蒙', '陕', '吉', '闽', '贵', '粤', '青'],
    ['藏', '川', '宁', '琼', '删'],
  ];
  commonKeys: string[][] = [
    ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
    ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'O', 'P', '港'],
    ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', '澳'],
    ['Z', 'X', 'C', 'V', 'B', 'N', 'M', '学', '警', '删'],
  ];
  layoutOptions: GridLayoutOptions = {
    regularSize: [1, 1],
    irregularIndexes: [34],
    onGetIrregularSizeByIndex: () => {
      return [1, 2];
    },
  };

  @Monitor('inputValue.0', 'inputValue.1', 'inputValue.2', 'inputValue.3', 'inputValue.4', 'inputValue.5', 'inputValue.6', 'inputValue.7')
  onInputValueChange() {
    let isComplete = true;
    this.inputValue.forEach((item: string, index) => {
      if (!item && index !== 7) {
        isComplete = false;
      }
    });
    if (isComplete) {
      const bak = [...this.inputValue];
      if (!bak[bak.length - 1]) {
        bak.pop();
      }
      this.onChange(bak, isComplete);
    } else {
      this.onChange(this.inputValue, isComplete);
    }
    this.isInput = this.inputValue.some(item => item !== '');
  }

  @Monitor('defaultNumbers')
  numbersChange() {
    for (let i = 0; i < this.inputValue.length; i++) {
      this.inputValue[i] = this.defaultNumbers.charAt(i);
    }
  }

  handleInputFocus(index: number) {
    this.focusMark.fill(false);
    this.focusMark[index] = true;
  }

  updateView() {
    this.handleInputFocus(this.inputIndex);
    this.intDisableKey(this.inputIndex);
  }

  intDisableKey(inputIndex: number) {
    switch (inputIndex) {
      case 1:
        this.setForbiddenKey(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '港', '澳', '学', '警']);
        break;
      case 2:
      case 3:
      case 4:
      case 5:
      case 7:
        this.setForbiddenKey(['O', '港', '澳', '学', '警']);
        break;
      case 6:
        this.setForbiddenKey(['O']);
        break;
      default:
        break;
    }
  }

  setForbiddenKey(forbiddenKeys: string[]) {
    this.commonKeys.forEach((item, i) => {
      item.forEach((v, j) => {
        if (forbiddenKeys.includes(v)) {
          this.keyBordTotal[i][j] = new CustomKeyItem(v, true);
        } else {
          this.keyBordTotal[i][j] = new CustomKeyItem(v, false);
        }
      });
    });
  }

  aboutToAppear(): void {
    if (this.intFocus) {
      this.focusMark[0] = true;
    }
    for (let i = 0; i < this.inputValue.length; i++) {
      this.inputValue[i] = this.defaultNumbers.charAt(i);
    }
  }

  build() {
    Row() {
      TextInput({ controller: this.controller })
        .width(0)
        .customKeyboard(this.customKeyboardBuilder(), { supportAvoidance: true })
        .height(0)
        .padding(0)
        .id('customKeyboardInput')
        .defaultFocus(this.intFocus)
      Row() {
        ForEach(this.inputValue, (item: string, index) => {
          if (index === 2) {
            Row()
              .width(6)
              .height(6)
              .backgroundColor($r('sys.color.ohos_id_color_text_primary'))
              .borderRadius(3)
              .margin({ right: 4 })
          }
          if (index === 7) {
            Row() {
              Text(item ? item : '新能源')
                .fontColor(item ? $r('sys.color.ohos_id_color_connected') : $r('sys.color.ohos_id_color_palette4'))
                .fontSize(item ? $r('sys.float.ohos_id_text_size_headline8') :
                $r('sys.float.ohos_id_text_size_caption'))
                .fontFamily($r('sys.string.ohos_id_text_font_family_regular'))
                .width('100%')
                .height('100%')
                .padding(this.focusMark[index] ? { top: 2 } : '')
                .textAlign(TextAlign.Center)
                .border({
                  width: { bottom: this.focusMark[index] ? 2 : 0 },
                  color: $r('sys.color.ohos_id_color_connected'),
                })
            }
            .width(this.inputWidth)
            .height(this.inputHeight)
            .backgroundColor(KeyboardConstant.NEW_ENERGY_BACKGROUND)
            .justifyContent(FlexAlign.Center)
            .padding({
              right: 4,
              left: 4,
              top: 5,
              bottom: 5,
            })
            .borderRadius(6)
            .onClick(() => {
              this.inputIndex = index;
              this.updateView();
              focusControl.requestFocus('customKeyboardInput');
            })
          } else {
            Row() {
              Text(item)
                .fontColor(this.focusMark[index] ? $r('sys.color.ohos_id_color_text_primary_activated') :
                $r('sys.color.ohos_id_color_text_primary'))
                .fontSize($r('sys.float.ohos_id_text_size_headline8'))
                .fontFamily(this.focusMark[index] ? $r('sys.string.ohos_id_text_font_family_medium') : '')
                .width('100%')
                .height('100%')
                .fontWeight(this.focusMark[index] ? FontWeight.Medium : FontWeight.Normal)
                .padding(this.focusMark[index] ? { top: 2 } : '')
                .textAlign(TextAlign.Center)
                .border({
                  width: { bottom: this.focusMark[index] ? 2 : 0 },
                  color: $r('sys.color.ohos_id_color_emphasize'),
                })
            }
            .width(this.inputWidth)
            .height(this.inputHeight)
            .backgroundColor(KeyboardConstant.KEYBORD_NORMAL_BACKGROUND)
            .margin({ right: 4 })
            .justifyContent(FlexAlign.Center)
            .padding({
              left: 4,
              right: 4,
              top: 5,
              bottom: 5,
            })
            .borderRadius(6)
            .onClick(() => {
              this.inputIndex = index;
              this.updateView();
              focusControl.requestFocus('customKeyboardInput');
            })
          }
        }, (item: string, index) => item + '_' + index)
      }.padding({ left: 4, right: 4 })
    }
    .width('100%')
    .onSizeChange((o, n) => {
      this.windowWidth = n.width as number;
      this.inputWidth = (this.windowWidth - 40 - 6) / 8;
      this.inputHeight = this.inputWidth * 1.3;
      window.getLastWindow(getContext(this)).then((data) => {
        const avoidArea = data.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
        const indicatorHeight = avoidArea.bottomRect.height;
        this.avoidAreaHeight = px2vp(indicatorHeight);
      });
    })
  }

  @Builder
  customKeyboardBuilder() {
    Column() {
      Row() {
        Text(this.isInput ? '完成' : '收起')
          .fontSize($r('sys.float.ohos_id_text_size_headline9'))
          .fontFamily($r('sys.string.ohos_id_text_font_family_regular'))
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
      }
      .height(38)
      .width('100%')
      .justifyContent(FlexAlign.End)
      .padding({
        right: 3,
        left: 3,
      })
      .margin({
        bottom: 5,
      })
      .onClick(() => {
        this.controller.stopEditing();
      })

      if (this.inputIndex === 0) {
        this.provinceKeyBoardBuilder();
      }
      ForEach([1, 2, 3, 4, 5, 6, 7], (num: number) => {
        if (this.inputIndex === num) {
          this.commKeyBordBuilder();
        }
      }, (num: number) => num.toString())
    }.backgroundColor(KeyboardConstant.KEYBORD_BACKGROUND).padding({ bottom: this.avoidAreaHeight })
  }

  @Builder
  commKeyBordBuilder() {
    Grid() {
      ForEach(this.keyBordTotal, (v: CustomKeyItem[]) => {
        ForEach(v, (item: CustomKeyItem) => {
          GridItem() {
            if (item.key === '删') {
              Row() {
                Image($r('app.media.ic_key_delete')).width(24).fillColor($r('sys.color.ohos_id_color_primary'))
              }
              .width('100%')
              .justifyContent(FlexAlign.Center)
              .height(46)
              .onClick(() => {
                if (this.inputValue[this.inputIndex]) {
                  this.inputValue[this.inputIndex] = '';
                } else {
                  this.inputIndex--;
                  this.inputValue[this.inputIndex] = '';
                }
                this.updateView();
              })
            } else {
              Text(item.key)
                .fontFamily($r('sys.string.ohos_id_text_font_family_regular'))
                .textAlign(TextAlign.Center)
                .height(46)
                .width('100%')
                .opacity(item.disable ? $r('sys.float.ohos_id_alpha_disabled') : 1)
                .fontSize($r('sys.float.ohos_id_text_size_headline9'))
                .fontColor($r('sys.color.ohos_id_color_text_primary'))
                .onClick(() => {
                  if (!item.disable) {
                    this.inputValue[this.inputIndex] = item.key;
                    if (this.inputIndex <= 6) {
                      this.inputIndex++;
                    }
                    this.updateView();
                  }
                })
            }
          }
          .backgroundColor(item.key === '删' ? KeyboardConstant.DEL_BACKGROUND : KeyboardConstant.KEY_BACKGROUND)
          .borderRadius(6)
          .shadow({ radius: vp2px(0.6), color: KeyboardConstant.KEY_SHADOW, offsetY: vp2px(1.2) })

        }, (item: CustomKeyItem, index: number) => {
          return item.key + index;
        })
      }, (v: CustomKeyItem, i) => i.toString())
    }
    .width('100%')
    .maxCount(10)
    .columnsGap(2)
    .rowsGap(5)
    .padding({ bottom: 5, left: 3, right: 3 })
    .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr')

  }

  @Builder
  provinceKeyBoardBuilder() {
    Grid(undefined, this.layoutOptions) {
      ForEach(this.provincesKeyBoard, (v: string[]) => {
        ForEach(v, (item: string) => {
          if (item === '删') {
            ForEach([1, 2, 3], () => {
              GridItem()
            }, (val: number) => val.toString())
            GridItem() {
              Row() {
                Image($r('app.media.ic_key_delete')).width(24).fillColor($r('sys.color.ohos_id_color_primary'))
              }
              .width('100%')
              .justifyContent(FlexAlign.Center)
              .height(46)
              .backgroundColor(KeyboardConstant.DEL_BACKGROUND)
              .shadow({ radius: vp2px(0.6), color: KeyboardConstant.KEY_SHADOW, offsetY: vp2px(1.2) })
              .borderRadius(6)
              .onClick(() => {
                this.inputValue[0] = '';
              })
            }
          } else {
            GridItem() {
              Text(item)
                .width('100%')
                .fontSize($r('sys.float.ohos_id_text_size_headline9'))
                .fontFamily($r('sys.string.ohos_id_text_font_family_regular'))
                .fontColor($r('sys.color.ohos_id_color_text_primary'))
                .textAlign(TextAlign.Center)
                .height(46)
                .backgroundColor(KeyboardConstant.KEY_BACKGROUND)
                .shadow({ radius: vp2px(0.6), color: KeyboardConstant.KEY_SHADOW, offsetY: vp2px(1.2) })
                .borderRadius(6)
                .onClick(() => {
                  this.inputValue[0] = item;
                  this.inputIndex = 1;
                  this.updateView();
                })
            }
          }

        }, (item: string, index: number) => {
          return item + index;
        })
      }, (v: string[], i) => i.toString())
    }
    .width('100%')
    .maxCount(9)
    .columnsGap(3)
    .rowsGap(5)
    .padding({ bottom: 5, left: 3, right: 3 })
    .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr')
  }
}