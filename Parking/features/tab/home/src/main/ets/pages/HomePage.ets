import { CommonConstants, RouterMap, RouterModule } from 'commonlib';
import { LicenseSwiper } from '../components/LicenseSwiper';
import { HomePageVM } from '../viewmodels/HomePageVM';
import { AssociateUtil, CommonHeader } from 'componentlib';
import { CommonAddress } from '../components/CommonAddress';
import { SpotsList } from '../components/SpotsList';

@ComponentV2
export struct HomePage {
  @Local offsetY: number = 0;
  vm: HomePageVM = HomePageVM.instance;
  controller: Scroller = new Scroller();

  aboutToAppear() {
    this.vm.init();
  }

  build() {
    Scroll(this.controller) {
      Column() {
        // 标题
        CommonHeader({ title: '首页', showBackButton: false })

        // 车牌轮播
        LicenseSwiper().margin({ top: 94, bottom: 12 })

        // 停车缴费
        this.payBtnBuilder()

        // 常去地址
        CommonAddress().margin({ top: 12 })

        // 车场列表
        SpotsList()
      }
      .padding({ bottom: $r('app.string.padding_12') })
    }
    .scrollBar(BarState.Off)
    .width(CommonConstants.FULL_WIDTH)
    .height(CommonConstants.FULL_HEIGHT)
    .onWillScroll(() => {
      this.offsetY = this.controller.currentOffset().yOffset;
    })
    .backgroundImage(this.vm.banner)
    .backgroundImageSize({ width: '100%', height: '262vp' })
    .backgroundImagePosition({ x: 0, y: -this.offsetY / 2 })
    .backgroundColor($r('app.color.system_color_background_gray'))
  }

  @Builder
  payBtnBuilder() {
    Row() {
      Row({ space: 4 }) {
        Image($r('app.media.ic_car_pay')).width(24)
        Text('停车缴费').fontSize($r('sys.float.Body_M')).fontColor($r('sys.color.font_primary'))
      }

      Row() {
        Text('点击前往').fontSize($r('sys.float.Caption_L')).fontColor($r('sys.color.font_secondary'))
        Image($r('app.media.ic_arrow')).width(12)
      }
      .onClick(() => {
        AssociateUtil.checkBindPhone(() => {
          RouterModule.push({ url: RouterMap.QUERY_PAGE });
        });
      })
    }
    .clip(true)
    .height(44)
    .padding($r('app.string.padding_12'))
    .borderRadius($r('app.string.border_radius_16'))
    .width('calc(100% - 32vp)')
    .backgroundImage($r('app.media.ic_bg_pay'))
    .backgroundImageSize(ImageSize.Cover)
    .justifyContent(FlexAlign.SpaceBetween)
  }
}

@Builder
export function HomePageBuilder() {
  HomePage()
}