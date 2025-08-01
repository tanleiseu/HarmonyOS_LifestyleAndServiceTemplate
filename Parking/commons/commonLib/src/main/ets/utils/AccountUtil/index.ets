import { AppStorageV2, PersistenceV2 } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from '../Logger';
import { AccountModel, UserInfoModel } from './models';
import { UserInfo } from '../../types';
import { authentication } from '@kit.AccountKit';
import { util } from '@kit.ArkTS';

const TAG = '[AccountUtil]';

@ObservedV2
export class AccountUtil {
  // 用户信息
  private static _userInfo: UserInfoModel = AppStorageV2.connect(UserInfoModel, 'userInfo', () => new UserInfoModel())!;
  // 账号信息
  private static _accountInfo: AccountModel =
    PersistenceV2.connect(AccountModel, 'accountInfo', () => new AccountModel())!;

  public static async silentLogin() {
    if (AccountUtil._accountInfo.unionID) {
      return;
    }
    const loginRequest = new authentication.HuaweiIDProvider().createLoginWithHuaweiIDRequest();
    loginRequest.forceLogin = false;
    loginRequest.state = util.generateRandomUUID();
    try {
      const controller = new authentication.AuthenticationController();
      controller.executeRequest(loginRequest).then((response: authentication.LoginWithHuaweiIDResponse) => {
        const loginWithHuaweiIDResponse = response as authentication.LoginWithHuaweiIDResponse;
        const state = loginWithHuaweiIDResponse.state;
        if (state && loginRequest.state !== state) {
          Logger.error(TAG, `Failed to login. The state is different, response state: ${state}`);
          return;
        }
        Logger.info(TAG, 'Succeeded in logging in.');
        const loginWithHuaweiIDCredential = loginWithHuaweiIDResponse.data!;
        AccountUtil._accountInfo.idToken = loginWithHuaweiIDCredential.idToken ?? '';
        AccountUtil._accountInfo.openID = loginWithHuaweiIDCredential.openID;
        AccountUtil._accountInfo.unionID = loginWithHuaweiIDCredential.unionID;
        AccountUtil._accountInfo.authCode = loginWithHuaweiIDCredential.authorizationCode ?? '';
      })
        .catch((error: BusinessError) => {
          AccountUtil._dealAllError(error);
        });
    } catch (error) {
      AccountUtil._dealAllError(error);
    }
  }

  public static getAccountInfo() {
    return AccountUtil._accountInfo;
  }

  public static getUserInfo() {
    return AccountUtil._userInfo;
  }

  public static getAuthorization() {
    return AccountUtil._accountInfo.loginToken ?? AccountUtil._accountInfo.authCode;
  }

  public static updateUserInfo(data: UserInfo) {
    AccountUtil._userInfo.isPhoneAssociated = data.isPhoneAssociated ?? AccountUtil._userInfo.isPhoneAssociated;
    AccountUtil._userInfo.avatar = data.avatar ?? AccountUtil._userInfo.avatar;
    AccountUtil._userInfo.nickname = data.nickname ?? AccountUtil._userInfo.nickname;
    AccountUtil._userInfo.cellphone = data.cellphone ?? AccountUtil._userInfo.cellphone;
  }

  private static _dealAllError(error: BusinessError): void {
    Logger.error(TAG, `Failed to login, errorCode: ${error.code}, errorMsg: ${error.message}`);
  }
}

export * from './models';