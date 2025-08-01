export function desensitizePhoneNumber(phoneNum: string) {
  if (phoneNum.length === 11) {
    return phoneNum.slice(0, 3) + '****' + phoneNum.slice(7);
  }
  return phoneNum;
}