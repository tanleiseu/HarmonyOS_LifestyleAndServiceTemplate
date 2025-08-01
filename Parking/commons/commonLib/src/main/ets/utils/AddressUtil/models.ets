import { AddressModel, AddressType } from '../../types';

@ObservedV2
export class CommonAddressListModel {
  @Trace list: AddressModel[];

  constructor() {
    this.list = [
      {
        name: '',
        location: { latitude: 39.9, longitude: 116.4 },
        siteId: '',
        addr: '',
        type: AddressType.HOME,
      },
      {
        name: '',
        location: { latitude: 39.9, longitude: 116.4 },
        siteId: '',
        addr: '',
        type: AddressType.WORK,
      },
      {
        name: '',
        location: { latitude: 39.9, longitude: 116.4 },
        siteId: '',
        addr: '',
        type: AddressType.DINNER,
      },
    ];
  }
}