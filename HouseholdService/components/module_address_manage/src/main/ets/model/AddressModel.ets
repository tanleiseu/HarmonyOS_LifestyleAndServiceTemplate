import { AddrMgtApi } from '../http/Api';
import { IAddrInfo } from '../http/Type';

export class AddressModel {
  id?: number;
  name: string = '';
  address: string = '';
  contactName: string = '';
  contactPhone: string = '';

  constructor(data?: IAddrInfo) {
    if (data) {
      this.id = data.id;
      this.name = data.name;
      this.address = data.address;
      this.contactName = data.contactName;
      this.contactPhone = data.contactPhone;
    }
  }

  get iAddr(): IAddrInfo {
    return {
      id: this.id,
      name: this.name,
      address: this.address,
      contactName: this.contactName,
      contactPhone: this.contactPhone,
    };
  }

  public add() {
    return AddrMgtApi.addAddress(this.iAddr);
  }

  public update() {
    return AddrMgtApi.updateAddress(this.iAddr);
  }

  public del() {
    return AddrMgtApi.deleteAddress(this.id!);
  }

}

