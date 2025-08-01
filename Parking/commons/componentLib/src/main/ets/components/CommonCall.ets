import { CommonConstants, Logger } from 'commonlib';
import { call } from '@kit.TelephonyKit';
import { BusinessError } from '@kit.BasicServicesKit';

@ComponentV2
export struct CommonCall {
  // 提示文字
  @Param title: string = '';
  // 拨号号码
  @Param phoneNum: string = '';
  // 取消操作
  @Event cancel: () => void;

  desensitizePhoneNumber(phoneNum: string) {
    if (phoneNum.length === 11) {
      return phoneNum.slice(0, 3) + '****' + phoneNum.slice(7);
    }
    return phoneNum;
  }

  build() {
    Column({ space: 22 }) {
      Text(this.title)
        .fontWeight(FontWeight.Medium)
        .width(CommonConstants.FULL_WIDTH)
        .fontSize($r('sys.float.Title_S'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))

      Column({ space: 12 }) {
        Text(this.desensitizePhoneNumber(this.phoneNum))
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.Subtitle_L'))
          .fontColor($r('sys.color.ohos_id_color_text_primary'))

        Button() {
          Row({ space: 8 }) {
            Image($r('app.media.ic_make_call')).width(24)
            Text('一键拨号')
              .fontWeight(FontWeight.Medium)
              .fontSize($r('sys.float.Body_L'))
              .fontColor($r('sys.color.font_on_primary'))
          }
        }
        .height(40)
        .width(CommonConstants.FULL_WIDTH)
        .backgroundColor('#387BF1')
        .onClick(() => {
          if (canIUse('SystemCapability.Applications.Contacts')) {
            call.makeCall(this.phoneNum, (error: BusinessError) => {
              if (error) {
                Logger.error('Make call fail, error is: ' + JSON.stringify(error));
              } else {
                Logger.info('Make call success');
              }
            });
          }
        })

        Button('取消')
          .height(40)
          .width(CommonConstants.FULL_WIDTH)
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .fontColor($r('sys.color.font_secondary'))
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.Body_L'))
          .onClick(() => {
            this.cancel();
          })
      }
      .backgroundColor(Color.White)
      .width(CommonConstants.FULL_WIDTH)
      .borderRadius(16)
      .padding({
        left: 12,
        right: 12,
        top: 16,
        bottom: 16,
      })
    }
    .width(CommonConstants.FULL_WIDTH)
    .padding({
      left: 16,
      right: 16,
      top: 32,
      bottom: 32,
    })
  }
}