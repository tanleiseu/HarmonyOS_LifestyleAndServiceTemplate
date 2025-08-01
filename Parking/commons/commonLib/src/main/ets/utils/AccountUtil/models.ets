import { UserInfo } from '../../types';

@ObservedV2
export class UserInfoModel implements UserInfo {
  @Trace isPhoneAssociated: boolean = false;
  @Trace isMock: boolean = false;
  @Trace avatar: string = '';
  @Trace nickname: string = '';
  @Trace cellphone: string = '';
}

@ObservedV2
export class AccountModel {
  @Trace idToken: string = '';
  @Trace openID: string = '';
  @Trace unionID: string = '';
  @Trace authCode: string = '';
  @Trace loginToken: string = '';
}