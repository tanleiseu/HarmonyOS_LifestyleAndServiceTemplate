import { CommonConstants } from 'commonlib';
import { LicensePageVM } from '../viewmodels/LicensePageVM';

@ComponentV2
export struct MyLicenseCard {
  @Param isDefault: boolean = false;
  @Param license: string = '';
  vm: LicensePageVM = LicensePageVM.instance;

  build() {
    Row() {
      Image(this.license.length === 8 ? $r('app.media.ic_car_nev') : $r('app.media.ic_car_normal')).width(32)

      Text(this.license)
        .fontWeight(FontWeight.Medium)
        .fontSize($r('sys.float.Subtitle_L'))
        .fontColor(this.license.length === 8 ? $r('sys.color.font_primary') : $r('sys.color.font_on_primary'))
        .margin({ left: $r('app.string.margin_12'), right: $r('app.string.margin_4') })

      if (this.isDefault) {
        Text('默认车辆')
          .fontSize($r('sys.float.Caption_S'))
          .backgroundColor($r('app.color.system_color_background_gray'))
          .fontColor($r('sys.color.font_secondary'))
          .borderRadius($r('app.string.border_radius_8'))
          .padding({
            left: 4,
            right: 4,
            top: 3,
            bottom: 3,
          })
      }

      Blank().layoutWeight(1)

      Image(this.license.length === 8 ? $r('app.media.ic_opt_gray') : $r('app.media.ic_opt_white'))
        .width(24)
        .margin($r('app.string.margin_12'))
        .onClick(() => {
          this.vm.license = this.license;
          this.vm.showOpt = true;
        })
    }
    .height(80)
    .width(CommonConstants.FULL_WIDTH)
    .padding({ left: $r('app.string.padding_16') })
    .clip(true)
    .borderRadius($r('app.string.border_radius_16'))
    .backgroundImage(this.license.length === 8 ? $r('app.media.ic_bg_nev') : $r('app.media.ic_bg_normal'))
    .backgroundImageSize(ImageSize.Cover)
  }
}