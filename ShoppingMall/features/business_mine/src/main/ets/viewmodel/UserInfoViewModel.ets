import {
  BaseResponse,
  HttpCode,
  HttpRequestApi,
  Logger,
  RouterUtil,
  UserIconModel,
  UserInfo,
  UserInfoModel
} from 'lib_common';
import { AppStorageV2, PersistenceV2, promptAction } from '@kit.ArkUI';
import { util } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import fs from '@ohos.file.fs';
import { functionalButtonComponentManager } from '@kit.ScenarioFusionKit';

const TAG = '[UserInfoViewModel]';

@ObservedV2
export class UserInfoViewModel {
  @Trace userInfo: UserInfoModel = AppStorageV2.connect(UserInfoModel, () => new UserInfoModel())!;
  @Trace userIconInfo: UserIconModel = AppStorageV2.connect(UserIconModel, () => new UserIconModel())!;
  @Trace nickName: string = this.userInfo.userInfo.name
  @Trace showSheet: boolean = false

  modifyUserInfo() {
    HttpRequestApi.modifyUserInfo(this.nickName).then((resp: BaseResponse<UserInfo>) => {
      if (resp.code === HttpCode.SUCCESS) {
        promptAction.showToast({ message: $r('app.string.modify_success') })
        this.userInfo.userInfo = resp.data
        RouterUtil.pop()
      } else {
        promptAction.showToast({ message: $r('app.string.modify_failed') })
      }
    }).catch((e: BusinessError) => {
      Logger.error(TAG, `modifyUserInfo error: ${JSON.stringify(e)}.`);
      promptAction.showToast({ message: $r('app.string.modify_failed', JSON.stringify(e)) })
    })
  }

  saveIcon(data: functionalButtonComponentManager.ChooseAvatarResult) {
    let file: fs.File = null!;
    try {
      file = fs.openSync(data.avatarUri, fs.OpenMode.READ_ONLY)
      this.userIconInfo.userIconPath = `${util.generateRandomUUID(false)}.jpg`
      let imagePath = `${getContext().filesDir}/${this.userIconInfo.userIconPath}`
      fs.copyFileSync(file.fd, imagePath)
      this.userIconInfo.isSaved = true
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      Logger.error(TAG, `PhotoViewPicker failed with err: ${err.code}, ${err.message}`);
    } finally {
      fs.closeSync(file);
    }
  }
}