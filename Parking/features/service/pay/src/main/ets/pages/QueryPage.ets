import { CommonConstants, UsedLicenseUtil, WindowUtil } from 'commonlib';
import { CommonButton, CommonHeader, CommonKeyboard } from 'componentlib';
import { LengthUnit } from '@kit.ArkUI';
import { QueryPayPageVM } from '../viewmodels/QueryPayPageVM';

@ComponentV2
export struct QueryPage {
  vm: QueryPayPageVM = QueryPayPageVM.instance;

  aboutToAppear(): void {
    this.vm.resetQueryParams();
  }

  getBgColor(license: string, canDelete: boolean): ResourceStr {
    if (canDelete) {
      return $r('sys.color.background_primary');
    } else if (license.length < 8) {
      return $r('sys.color.brand');
    }
    return '';
  }

  build() {
    NavDestination() {
      /** 标题栏 **/
      CommonHeader({ title: '停车缴费' })

      Scroll() {
        Column() {
          /** 车牌显示 **/
          CommonKeyboard({
            defaultNumbers: this.vm.license,
            onChange: (numbers, full) => {
              this.vm.license = numbers.join('');
              this.vm.isFull = full;
            },
          }).margin({ top: 18 }).width('calc(100% - 24vp)')

          Column() {
            if (this.vm.licenseInfo.all.length) {
              Text('我的车牌').titleStyle()
              this.myLicensesBuilder()
            }

            if (this.vm.usedLicenses.all.length) {
              Text('最近使用').titleStyle()
              this.usedLicensesBuilder()
            }
            Blank().layoutWeight(1)
          }
          .padding({ left: $r('app.string.padding_16'), right: $r('app.string.padding_16') })
        }
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .margin({ bottom: $r('app.string.margin_8') })

      /** 查询按钮 **/
      CommonButton({
        title: '查询',
        handleClick: () => {
          this.vm.goToQuery();
        },
      }).padding({ left: 10, right: 10, top: 6 })
    }
    .hideTitleBar(true)
    .backgroundColor($r('app.color.system_color_background_gray'))
    .padding({ bottom: WindowUtil.getAvoidArea().bottom })
  }

  @Builder
  myLicensesBuilder() {
    Flex({
      wrap: FlexWrap.Wrap,
      space: { main: { value: 10, unit: LengthUnit.VP }, cross: { value: 10, unit: LengthUnit.VP } },
    }) {
      ForEach(this.vm.licenseInfo.all, (license: string) => {
        this.licenseItemBuilder(license, false)
      }, (license: string) => license)
    }
  }

  @Builder
  usedLicensesBuilder() {
    Flex({
      wrap: FlexWrap.Wrap,
      space: { main: { value: 10, unit: LengthUnit.VP }, cross: { value: 10, unit: LengthUnit.VP } },
    }) {
      ForEach(this.vm.usedLicenses.all, (license: string) => {
        this.licenseItemBuilder(license, true)
      }, (license: string) => license)
    }
  }

  @Builder
  licenseItemBuilder(text: string, canDelete: boolean) {
    Column() {
      Text(text)
        .textAlign(TextAlign.Center)
        .fontWeight(FontWeight.Medium)
        .width(CommonConstants.FULL_WIDTH)
        .fontSize($r('sys.float.Body_M'))
        .fontColor(!canDelete && text.length < 8 ? $r('sys.color.font_on_primary') : $r('sys.color.font_primary'))
      if (canDelete) {
        Image($r('app.media.ic_used_delete'))
          .width(10)
          .position({ right: -4, top: -10 })
          .onClick(() => {
            UsedLicenseUtil.deleteLicense(text);
          })
      }
    }
    .width(96)
    .backgroundColor(this.getBgColor(text, canDelete))
    .linearGradient({
      angle: 90,
      colors: canDelete || text.length < 8 ? [] : [
        ['#7FDE3C', 0],
        ['#DDFFB8', 1],
      ],
    })
    .borderRadius($r('app.string.border_radius_8'))
    .padding({ top: 6, bottom: 6 })
    .onClick(() => {
      this.vm.license = text;
    })
  }
}

@Extend(Text)
function titleStyle() {
  .fontWeight(FontWeight.Medium)
  .width(CommonConstants.FULL_WIDTH)
  .fontSize($r('sys.float.Subtitle_M'))
  .fontColor($r('sys.color.font_primary'))
  .margin({ top: $r('app.string.margin_24'), bottom: $r('app.string.margin_12') })
}

@Builder
export function QueryPageBuilder() {
  QueryPage()
}