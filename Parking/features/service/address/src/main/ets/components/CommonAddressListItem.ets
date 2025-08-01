import {
  AddressModel,
  AddressType,
  AddressUtil,
  AppStorageMap,
  CommonConstants,
  EmitterConstants,
  RouterMap,
  RouterModule,
} from 'commonlib';
import { emitter } from '@kit.BasicServicesKit';
import { AddressPageVM } from '../viewmodels/AddressPageVM';

@ComponentV2
export struct CommonAddressListItem {
  @Param address: AddressModel = {
    siteId: '',
    name: '',
    addr: '',
    location: { latitude: 39.9, longitude: 116.4 },
    type: AddressType.CUSTOM,
  };
  vm: AddressPageVM = AddressPageVM.instance;

  build() {
    ListItem() {
      Row() {
        Image($r(AddressUtil.CONFIG_LIST[Number(this.address.type)].iconInner))
          .width(24)
          .aspectRatio(1)
          .margin({ right: 8 })

        if (this.address.type) {
          Text(AddressUtil.CONFIG_LIST[Number(this.address.type)].textInner).textStyle1().margin({ right: 42 })
        }

        if (this.address.siteId) {
          Text(this.address.name)
            .textStyle1()
            .layoutWeight(1)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .onClick(() => {
              // 跳转
              AppStorage.setOrCreate(AppStorageMap.SELECTED_ADDRESS, this.address);
              emitter.emit(EmitterConstants.TO_FIND);
              RouterModule.pop();
            })
        } else {
          Text('点击设置')
            .layoutWeight(1)
            .fontSize($r('sys.float.Subtitle_S'))
            .fontColor($r('sys.color.font_tertiary'))
            .onClick(() => {
              // 设置
              RouterModule.push({ url: RouterMap.SEARCH_LIST, param: this.address.type });
            })
        }

        Image($r('app.media.ic_opt')).width(16).onClick(() => {
          // 更多
          this.vm.moreOpt(this.address);
        })
      }
      .alignItems(VerticalAlign.Center)
      .width(CommonConstants.FULL_WIDTH)
    }
  }
}

@Extend(Text)
function textStyle1() {
  .fontSize($r('sys.float.Subtitle_S'))
  .fontColor($r('sys.color.font_primary'))
}