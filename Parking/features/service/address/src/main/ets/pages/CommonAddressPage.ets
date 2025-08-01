import { AddressModel, CommonConstants, RouterMap, RouterModule, WindowUtil } from 'commonlib';
import { CommonButton, CommonHeader } from 'componentlib';
import { CommonAddressListItem } from '../components/CommonAddressListItem';
import { AddressPageVM } from '../viewmodels/AddressPageVM';

@ComponentV2
export struct CommonAddressPage {
  vm: AddressPageVM = AddressPageVM.instance;

  build() {
    NavDestination() {
      /** 标题栏 **/
      CommonHeader({ title: '常用目的地' })

      Scroll() {
        Column() {
          /** 基本地址 **/
          this.basicBuilder()

          /** 自定义地址 **/
          if (this.vm.customList.length) {
            this.customBuilder()
          }

          Blank().layoutWeight(1)
        }
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .margin({ bottom: $r('app.string.margin_8') })

      /** 新增地址按钮 **/
      CommonButton({
        title: '+新增常用地址',
        handleClick: () => {
          // 新增自定义地址
          RouterModule.push({ url: RouterMap.SEARCH_LIST, param: 0 });
        },
      })
    }
    .padding({ bottom: WindowUtil.getAvoidArea().bottom })
    .backgroundColor($r('app.color.system_color_background_gray'))
    .hideTitleBar(true)
  }

  @Builder
  basicBuilder() {
    List({ space: 20 }) {
      ForEach(this.vm.basicList, (item: AddressModel) => {
        CommonAddressListItem({ address: item })
      }, (item: AddressModel, index) => JSON.stringify(item) + '_' + index)
    }
    .divider({ strokeWidth: 1, color: $r('sys.color.ohos_id_divider_color') })
    .margin({ bottom: $r('app.string.margin_12') })
    .containerStyle()
    .bindSheet($$this.vm.showBasicOpt, this.optionBuilder(true), { height: SheetSize.FIT_CONTENT })
  }

  @Builder
  customBuilder() {
    Column({ space: 20 }) {
      Text('更多常用目的地')
        .fontWeight(FontWeight.Medium)
        .width(CommonConstants.FULL_WIDTH)
        .fontSize($r('sys.float.Body_M'))
        .fontColor($r('sys.color.font_primary'))
      List({ space: 20 }) {
        ForEach(this.vm.customList, (item: AddressModel) => {
          CommonAddressListItem({ address: item })
        }, (item: AddressModel, index) => JSON.stringify(item) + '_' + index)
      }
      .divider({ strokeWidth: 1, color: $r('sys.color.ohos_id_divider_color') })
    }
    .containerStyle()
    .bindSheet($$this.vm.showCustomOpt, this.optionBuilder(false), { height: SheetSize.FIT_CONTENT })
  }

  @Builder
  optionBuilder(isBasic: boolean) {
    Column({ space: 22 }) {
      Text('地点管理')
        .fontWeight(FontWeight.Medium)
        .width(CommonConstants.FULL_WIDTH)
        .fontSize($r('sys.float.Title_S'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))

      Column({ space: 12 }) {
        Text('修改地点')
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Medium)
          .width(CommonConstants.FULL_WIDTH)
          .onClick(() => {
            this.vm.toUpdateAddress();
          })
        Text(isBasic ? '清空地点' : '删除地址')
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Medium)
          .width(CommonConstants.FULL_WIDTH)
          .fontColor($r('app.color.delete_red'))
          .backgroundColor($r('app.color.system_color_background_gray'))
          .borderRadius($r('app.string.border_radius_20'))
          .padding({ top: $r('app.string.padding_8'), bottom: $r('app.string.padding_8') })
          .onClick(() => {
            this.vm.clearOrDeleteAddress(isBasic);
          })
      }
      .padding({
        left: 12,
        right: 12,
        top: 16,
        bottom: 16,
      })
      .borderRadius($r('app.string.border_radius_16'))
      .backgroundColor($r('app.color.system_color_background_white'))
    }
    .padding({
      left: 16,
      right: 16,
      top: 30,
      bottom: WindowUtil.getAvoidArea().bottom,
    })
    .backgroundColor($r('app.color.system_color_background_gray'))
  }

  @Styles
  containerStyle() {
    .padding($r('app.string.padding_12'))
    .borderRadius($r('app.string.border_radius_16'))
    .backgroundColor($r('app.color.system_color_background_white'))
    .width('calc(100% - 32vp)')
  }
}

@Builder
export function CommonAddressPageBuilder() {
  CommonAddressPage()
}