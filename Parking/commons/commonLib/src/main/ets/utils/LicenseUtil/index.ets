import { LicenseModel, UsedLicenseModel } from './models';
import { AppStorageV2, PersistenceV2 } from '@kit.ArkUI';

@ObservedV2
export class LicenseUtil {
  // 车牌信息
  private static _licenseInfo: LicenseModel =
    AppStorageV2.connect(LicenseModel, 'licenseInfo', () => new LicenseModel())!;

  public static getLicenseInfo() {
    return LicenseUtil._licenseInfo;
  }

  public static findIndex(license: string) {
    return LicenseUtil._licenseInfo.all.findIndex(item => item === license);
  }

  public static updateAllLicenses(licenses: string[]) {
    LicenseUtil._licenseInfo.all = [...licenses];
  }

  public static addLicense(license: string, isDefault: boolean) {
    if (isDefault) {
      LicenseUtil.updateDefaultLicense(license);
    }
    LicenseUtil._licenseInfo.all.push(license);
  }

  public static deleteLicense(license: string) {
    const index = LicenseUtil.findIndex(license);
    if (index === -1) {
      return;
    }
    if (LicenseUtil._licenseInfo.default === license) {
      LicenseUtil._licenseInfo.default = '';
    }
    LicenseUtil._licenseInfo.all.splice(index, 1);
  }

  public static updateDefaultLicense(license: string) {
    LicenseUtil._licenseInfo.default = license;
  }
}

@ObservedV2
export class UsedLicenseUtil {
  // 车牌信息
  private static _usedLicenses: UsedLicenseModel =
    PersistenceV2.connect(UsedLicenseModel, 'usedLicenses', () => new UsedLicenseModel())!;

  public static getLicenses(): UsedLicenseModel {
    return UsedLicenseUtil._usedLicenses;
  }

  public static findIndex(license: string) {
    return UsedLicenseUtil._usedLicenses.all.findIndex(item => item === license);
  }

  public static addLicense(license: string) {
    UsedLicenseUtil._usedLicenses.all.push(license);
  }

  public static deleteLicense(license: string) {
    const index = UsedLicenseUtil.findIndex(license);
    if (index === -1) {
      return;
    }
    UsedLicenseUtil._usedLicenses.all.splice(index, 1);
  }
}

export * from './models';