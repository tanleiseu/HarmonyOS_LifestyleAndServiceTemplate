import { CommonConstants, RouterMap, RouterModule } from 'commonlib';
import { AssociateUtil, CommonCall } from 'componentlib';
import { SettingItem } from '../types';
import { MinePageVM } from '../viewmodels/MinePageVM';

@ComponentV2
export struct Settings {
  @Local showCall: boolean = false;
  vm: MinePageVM = MinePageVM.instance;

  build() {
    List({ space: 12 }) {
      ForEach(this.vm.getSettingGroupList(), (group: SettingItem[]) => {
        ListItemGroup({ space: 24 }) {
          ForEach(group, (item: SettingItem) => {
            this.settingListItemBuilder(item)
          }, (item: SettingItem, index) => JSON.stringify(item) + '_' + index)
        }
        .divider({ strokeWidth: 1, color: $r('app.color.divider_gray') })
        .containerStyle()
      }, (group: SettingItem, index) => JSON.stringify(group) + '_' + index)
    }
    .bindSheet($$this.showCall, this.callBuilder, { height: SheetSize.FIT_CONTENT })
  }

  @Builder
  settingListItemBuilder(item: SettingItem) {
    ListItem() {
      Row() {
        Image(item.icon).width(16).margin({ right: $r('app.string.margin_16') })
        Text(item.label)
          .flexGrow(1)
          .fontSize($r('sys.float.Subtitle_M'))
          .fontColor($r('sys.color.font_primary'))
        Image($r('app.media.ic_arrow')).width(16)
      }
      .width(CommonConstants.FULL_WIDTH)
    }
    .onClick(() => {
      if (item.url === 'CallPhone') {
        this.showCall = true;
        return;
      }
      if (item.url === RouterMap.PRIVACY_POLICY) {
        RouterModule.push({ url: RouterMap.PRIVACY_POLICY });
      } else {
        AssociateUtil.checkBindPhone(() => {
          RouterModule.push({ url: item.url as RouterMap });
        });
      }
    })
  }

  @Builder
  callBuilder() {
    CommonCall({
      phoneNum: '01201000100',
      title: '联系客服',
      cancel: () => {
        this.showCall = false;
      },
    })
  }

  @Styles
  containerStyle() {
    .padding($r('app.string.padding_12'))
    .borderRadius($r('app.string.border_radius_16'))
    .backgroundColor($r('app.color.system_color_background_white'))
  }
}