import {
  FormatUtil,
  IOrder,
  LicenseModel,
  LicenseUtil,
  Logger,
  RouterMap,
  RouterModule,
  UsedLicenseModel,
  UsedLicenseUtil,
  WidgetUtil,
} from 'commonlib';
import { getId, Https } from 'network';
import { promptAction } from '@kit.ArkUI';
import { BusinessError, emitter } from '@kit.BasicServicesKit';
import { paymentService } from '@kit.PaymentKit';
import { common } from '@kit.AbilityKit';
import { formBindingData, formProvider } from '@kit.FormKit';

@ObservedV2
export class QueryPayPageVM {
  // 车牌信息
  @Trace licenseInfo: LicenseModel = LicenseUtil.getLicenseInfo();
  // 最近使用
  @Trace usedLicenses: UsedLicenseModel = UsedLicenseUtil.getLicenses();
  // 当前车牌
  @Trace license: string = '';
  // 是否完整
  @Trace isFull: boolean = false;
  // 查询订单
  @Trace order: IOrder | undefined = undefined;
  // 刷新状态
  @Trace refresh: boolean = false;
  // 是否初始化
  @Trace hasInit: boolean = false;
  private static _instance: QueryPayPageVM;

  public static get instance() {
    if (!QueryPayPageVM._instance) {
      QueryPayPageVM._instance = new QueryPayPageVM();
    }
    return QueryPayPageVM._instance;
  }

  /** 重置查询页面参数 **/
  public resetQueryParams() {
    this.isFull = false;
    this.license = '';
  }

  /** 重置支付页面参数 **/
  public resetPayParams() {
    this.order = undefined;
    this.hasInit = false;
    this.license = RouterModule.getNavParam({ url: RouterMap.PAY_PAGE }) as string;
  }


  /** 去查询车辆入场 **/
  public goToQuery() {
    if (!this.isFull) {
      promptAction.showToast({ message: '请补充完整车牌' });
      return;
    }
    RouterModule.push({ url: RouterMap.PAY_PAGE, param: this.license });
    if (LicenseUtil.findIndex(this.license) === -1 && UsedLicenseUtil.findIndex(this.license) === -1) {
      UsedLicenseUtil.addLicense(this.license);
    }
  }

  /** 查询入场订单 **/
  public queryParking() {
    Https.queryParking({ id: getId(), license: this.license }).then(res => {
      if (res.code === 404) {
        promptAction.showToast({ message: res.msg });
        this.refresh = false;
        this.hasInit = true;
        return;
      }
      if (res.code === 0) {
        this.order = res.data.info?.pop();
        if (this.order) {
          emitter.emit(this.license, { data: this.order });
          let formData: Record<string, string> = {
            'duration': FormatUtil.durationDisplay(this.order?.start ?? Date.now(), this.order?.end ?? Date.now()),
          };
          WidgetUtil.getFormIds(getContext()).forEach(id => {
            formProvider.updateForm(id, formBindingData.createFormBindingData(formData));
          })
        }
      }
      this.refresh = false;
      this.hasInit = true;
    });
  }

  /** 支付入场订单 **/
  public async payParking() {
    if (!this.order) {
      return;
    }
    const res = await Https.payParking({
      id: getId(),
      orderId: this.order.orderId,
      siteId: this.order.siteId,
      license: this.order.license,
    });
    if (res.code === 0) {
      paymentService
        .requestPayment(getContext(this) as common.UIAbilityContext, res.data.orderStr)
        .then(() => {
          Logger.info('succeeded in paying');
        })
        .catch((error: BusinessError) => {
          promptAction.showToast({ message: '支付失败！' });
          Logger.error(`failed to pay, error.code: ${error.code}, error.message: ${error.message}`);
        });
    }
  }
}