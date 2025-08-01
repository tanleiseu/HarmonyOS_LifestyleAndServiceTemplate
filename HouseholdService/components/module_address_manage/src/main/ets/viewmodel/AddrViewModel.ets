import { promptAction } from '@kit.ArkUI';
import { CommonUtils } from 'module_base';
import { TypeAddressPage, PHONE_REG } from '../common/Constant';
import { AddressModel } from '../model/AddressModel';
import { IAddrInfo } from '../http/Type';

@ObservedV2
export class AddrViewModel {
  @Trace id?: number;
  @Trace name: string = '';
  @Trace address: string = '';
  @Trace contactName: string = '';
  @Trace contactPhone: string = '';
  @Trace type: TypeAddressPage = TypeAddressPage.NEW;
  private addrModel: AddressModel = new AddressModel();

  constructor(data?: AddressModel) {
    if (data) {
      this.id = data.id;
      this.name = data.name;
      this.address = data.address;
      this.contactName = data.contactName;
      this.contactPhone = data.contactPhone;

      this.type = TypeAddressPage.EDIT;
      this.addrModel = data;
    }
  }

  isNew() {
    return this.type === TypeAddressPage.NEW;
  }

  get getModel() {
    return this.addrModel;
  }

  async savaData() {
    CommonUtils.showLoading();
    const param: IAddrInfo = {
      id: this.id,
      name: this.name,
      address: this.address,
      contactName: this.contactName,
      contactPhone: this.contactPhone,
    };
    const model = new AddressModel(param);
    if (this.isNew()) {
      await model.add();
    } else {
      await model.update();
    }
    CommonUtils.hideLoading();
    return Promise.resolve();
  }

  onSubmit(): Promise<void> {
    const isValid = this.validInfo();
    if (!isValid) {
      return Promise.reject();
    }
    return this.savaData();
  }

  validInfo() {
    if (!this.name) {
      promptAction.showToast({ message: '请填写地区' });
      return false;
    }

    if (!this.address) {
      promptAction.showToast({ message: '请填写详细地址与门牌号' });
      return false;
    }

    if (!this.contactName) {
      promptAction.showToast({ message: '请填写收货人姓名' });
      return false;
    }

    if (!this.contactPhone) {
      promptAction.showToast({ message: '请填写手机号码' });
      return false;
    }
    if (!PHONE_REG.test(this.contactPhone)) {
      promptAction.showToast({ message: '请填写正确的手机号码' });
      return false;
    }

    return true;
  }
}