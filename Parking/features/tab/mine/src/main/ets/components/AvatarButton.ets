import { MinePageVM } from '../viewmodels/MinePageVM';
import { FunctionalButton, functionalButtonComponentManager } from '@kit.ScenarioFusionKit';
import { Logger } from 'commonlib';

const TAG = '[AvatarButton]';

@ComponentV2
export struct AvatarButton {
  vm: MinePageVM = MinePageVM.instance;

  build() {
    FunctionalButton({
      params: {
        openType: functionalButtonComponentManager.OpenType.CHOOSE_AVATAR,
        label: '',
        styleOption: {
          styleConfig: new functionalButtonComponentManager.ButtonConfig()
            .type(ButtonType.Normal)
            .backgroundImage(this.vm.userInfo.avatar === '' ? $r('app.media.ic_avatar_inner') :
            this.vm.userInfo.avatar)
            .backgroundImageSize(ImageSize.Cover)
            .backgroundColor(Color.Transparent)
            .width(40)
            .height(40)
            .borderRadius('50%'),
        },
      },
      controller: new functionalButtonComponentManager.FunctionalButtonController().onChooseAvatar((err, data) => {
        if (err) {
          Logger.error(TAG, err.code + '', err.message);
          return;
        }
        if (data.avatarUri) {
          this.vm.updateAvatar(data.avatarUri);
          Logger.info(TAG, 'succeeded in choosing avatar');
        } else {
          Logger.error(TAG, 'Failed: the uri is empty.');
        }
      }),
    })
  }
}