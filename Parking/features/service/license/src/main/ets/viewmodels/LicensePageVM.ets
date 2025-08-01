import { LicenseModel, LicenseUtil, RouterModule } from 'commonlib';
import { getId, Https } from 'network';
import { promptAction } from '@kit.ArkUI';

@ObservedV2
export class LicensePageVM {
  // 当前车牌
  @Trace license: string = '';
  // 是否完整
  @Trace isFull: boolean = false;
  // 是否默认
  @Trace isDefault: boolean = false;
  // 车牌信息
  @Trace licenseInfo: LicenseModel = LicenseUtil.getLicenseInfo();
  @Trace showOpt: boolean = false;
  private static _instance: LicensePageVM;

  public static get instance() {
    if (!LicensePageVM._instance) {
      LicensePageVM._instance = new LicensePageVM();
    }
    return LicensePageVM._instance;
  }

  /** 重置新增车牌页面参数 **/
  public resetParams() {
    this.license = '';
    this.isFull = false;
    this.isDefault = false;
  }

  /** 新增车牌 **/
  public async addNewLicense(animation: boolean) {
    if (!this.isFull) {
      promptAction.showToast({ message: '请补充完整车牌' });
      return;
    }
    if (LicenseUtil.findIndex(this.license) !== -1) {
      promptAction.showToast({ message: '已存在相同车牌' });
      return;
    }
    const res = await Https.addNewLicenseNumber({ id: getId(), new: this.license, isDfault: this.isDefault });
    if (res.code === 0) {
      LicenseUtil.addLicense(this.license, this.isDefault);
      RouterModule.pop(animation);
    }
  }

  /** 修改默认 **/
  public async setNewDefaultLicense() {
    if (this.license === this.licenseInfo.default) {
      return;
    }
    const res = await Https.setDefaultLicenseNumber({ id: getId(), new: this.license });
    if (res.code === 0) {
      LicenseUtil.updateDefaultLicense(res.data.default);
    }
  }

  /** 删除车牌 **/
  public async deleteLicense() {
    const res = await Https.deleteOldLicenseNumber({ id: getId(), old: this.license });
    if (res.code === 0) {
      LicenseUtil.deleteLicense(this.license);
    }
  }
}