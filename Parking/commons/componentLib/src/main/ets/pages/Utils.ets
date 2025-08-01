import { AccountUtil, Logger, RouterMap, RouterModule } from 'commonlib';
import { authentication } from '@kit.AccountKit';
import { util } from '@kit.ArkTS';
import { promptAction } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { getId, Https } from 'network';

const TAG = '[AssociateAccount]';

// 用户取消授权
const ERROR_CODE_CANCEL = 1001502012;

export class AssociateUtil {
  /** 检查是否关联 **/
  public static async checkBindPhone(callback?: () => void) {
    const userInfo = AccountUtil.getUserInfo();
    if (userInfo.isPhoneAssociated) {
      callback?.();
      return;
    }
    RouterModule.push({
      url: RouterMap.BIND_PHONE,
      onPop: () => {
        if (userInfo.isPhoneAssociated) {
          callback?.();
        }
      },
    });
  }

  /** 账号关联 **/
  public static async associateAccount(err: BusinessError, code?: string) {
    if (err?.code === ERROR_CODE_CANCEL) {
      Logger.error(TAG, 'get phone failed,err' + err.message);
      return;
    }
    if (!code) {
      AssociateUtil._mockAssociateAccount();
      return;
    }
    AssociateUtil._requestAssociateAccount(code);
  }

  /** 取消关联 **/
  public static disassociateAccount(ctx: Context) {
    const userInfo = AccountUtil.getUserInfo();
    if (userInfo.isMock) {
      Https.disassociateAccount().then(() => {
        userInfo.isPhoneAssociated = false;
      });
      return;
    }
    const cancelRequest = new authentication.HuaweiIDProvider().createCancelAuthorizationRequest();
    cancelRequest.state = util.generateRandomUUID();
    try {
      const controller = new authentication.AuthenticationController(ctx);
      controller.executeRequest(cancelRequest).then(data => {
        const cancelAuthorizationResponse = data as authentication.AuthorizationWithHuaweiIDResponse;
        const state = cancelAuthorizationResponse.state;
        if (state && cancelRequest.state !== state) {
          Logger.error(TAG, `Failed to disassociation. The state is different, response state: ${state}`);
          return;
        }
        Logger.info(TAG, 'Succeeded in disassociation.');
        Https.disassociateAccount().then(() => {
          userInfo.isPhoneAssociated = false;
        });
      })
        .catch((err: BusinessError) => {
          AssociateUtil._dealAllError(err, '取消关联失败');
        });
    } catch (err) {
      AssociateUtil._dealAllError(err, '取消关联失败');
    }
  }

  /** 模拟账号关联 **/
  private static _mockAssociateAccount() {
    AlertDialog.show({
      title: '提示',
      message: '元服务未获取phone权限或用户授权，点击确定将模拟创建关联账号？',
      height: 170,
      alignment: DialogAlignment.Center,
      primaryButton: {
        value: '取消',
        fontColor: '#1a1a1a',
        action: () => {
          Logger.info(TAG, '取消模拟创建关联账号');
        },
      },
      secondaryButton: {
        value: '确定',
        fontColor: $r('sys.color.brand_font'),
        action: () => {
          AssociateUtil._requestAssociateAccount('', true);
        },
      },
    });
  }

  private static _requestAssociateAccount(code: string = '', isMock: boolean = false) {
    const userInfo = AccountUtil.getUserInfo();
    Https.associateAccount({ id: getId(), code: code }).then((res) => {
      if (res.code === 0) {
        userInfo.isPhoneAssociated = true;
        userInfo.cellphone = res.data.cellphone;
        userInfo.isMock = isMock;
        RouterModule.popWithRes(null);
      } else {
        promptAction.showToast({ message: '账号关联失败' });
      }
    }).catch(() => {
      promptAction.showToast({ message: '账号关联失败' });
    });
  }

  private static _dealAllError(error: BusinessError, text: string): void {
    Logger.error(TAG, `Failed to login, errorCode is ${error.code}, errorMessage is ${error.message}`);
    promptAction.showToast({ message: text });
  }
}

