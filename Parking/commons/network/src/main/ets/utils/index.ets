import { AccountUtil } from 'commonlib';

export function getId() {
  return AccountUtil.getAccountInfo().unionID;
}