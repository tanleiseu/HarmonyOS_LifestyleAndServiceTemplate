import { AccountUtil, RouterModule, UserInfoModel } from 'commonlib';
import { SETTING_LIST } from '../constants';
import { SettingItem } from '../types';
import { promptAction } from '@kit.ArkUI';

@ObservedV2
export class MinePageVM {
  // 用户信息
  @Trace userInfo: UserInfoModel = AccountUtil.getUserInfo();
  private static _instance: MinePageVM;

  public static get instance() {
    if (!MinePageVM._instance) {
      MinePageVM._instance = new MinePageVM();
    }
    return MinePageVM._instance;
  }

  /** 获取配置 **/
  public getSettingGroupList() {
    const itemList = SETTING_LIST;
    let list: SettingItem[][] = [];
    let group: SettingItem[] = [];
    let curGroupNum = 1;
    for (let i = 0; i < itemList.length; i++) {
      if (itemList[i].group === curGroupNum) {
        group.push(itemList[i]);
      } else {
        list.push(group);
        group = [];
        curGroupNum++;
        group.push(itemList[i]);
      }
    }
    list.push(group);
    return list;
  }

  /** 头像更新 **/
  public async updateAvatar(url: string) {
    await this._uploadAvatar(url);
    AccountUtil.updateUserInfo({ avatar: url });
  }

  /**
   * 头像上传
   * 详细内容查阅API:request.agent.create
   */
  private async _uploadAvatar(url: string) {
    // 元服务头像上传
  }

  /** 保存修改后的名称 **/
  public saveEdit(newName: string) {
    if (this._isLegal(newName)) {
      AccountUtil.updateUserInfo({ nickname: newName });
      RouterModule.pop();
    }
  }

  /** 判断是否合法 **/
  private _isLegal(name: string) {
    if (!name) {
      promptAction.showToast({
        message: '昵称不能为空,长度限制为8位',
      });
      return false;
    }
    if (!(/^[a-zA-Z0-9\u4e00-\u9fa5]+$/).test(name)) {
      promptAction.showToast({
        message: '昵称只能包含字母、数字、中文',
      });
      return false;
    }
    return true;
  }
}
