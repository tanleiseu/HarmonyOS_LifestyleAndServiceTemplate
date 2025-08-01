import { AddrMgtApi } from '../http/Api';
import { IAddrInfo } from '../http/Type';
import { AddressModel } from './AddressModel';

export class AddressListModel {
  list: AddressModel[] = [];

  public getAddressList() {
    return AddrMgtApi.getAddressList().then((resp: IAddrInfo[]) => {
      this.list = resp.map((v) => new AddressModel(v));
    }).catch(() => {
      this.list = [];
    });
  }

}
