import { Constants, NavHeaderBar } from 'lib_common';
import { GuideListComp } from '../components/GuideListComp';
import { Floor, StoreGuideViewModel } from '../viewmodel/StoreGuideViewModel';

@Builder
export function StoreGuidePageBuilder() {
  StoreGuidePage()
}

@ComponentV2
struct StoreGuidePage {
  @Local vm: StoreGuideViewModel = new StoreGuideViewModel()

  aboutToAppear(): void {
    this.vm.getService()
  }

  build() {
    NavDestination() {
      Stack() {
        Column() {
          Swiper() {
            ForEach(this.vm.floorImages, (item: Floor) => {
              Stack() {
                Image(item.img).width(Constants.FULL_SIZE)
                Row() {
                  Image($r('app.media.ic_location')).width(16).height(16)
                  Text(item.text).fontSize(12).fontColor($r('sys.color.font_primary')).margin({ left: 4 })
                }
                .margin({ right: 32, bottom: 32 })
                .borderRadius(24)
                .padding({
                  top: 6,
                  bottom: 6,
                  left: 12,
                  right: 12,
                })
                .backgroundColor('#1AFFFFFF')
              }
              .alignContent(Alignment.BottomEnd)
              .onClick(() => {
                this.vm.goStore(item);
              })
            }, (item: ResourceStr) => (JSON.stringify(item)),
            );
          }
          .displayMode(SwiperDisplayMode.STRETCH)
          .loop(true)
          .autoPlay(false)
          .vertical(false)
          .interval(2000)
          .indicator(new DotIndicator()
            .itemWidth(8)
            .itemHeight(8)
            .selectedItemWidth(12)
            .selectedItemHeight(8)
            .color($r('sys.color.comp_background_secondary'))
            .selectedColor($r('app.color.app_theme')))
          .onChange((index) => {
            this.vm.swiperIndex = index;
          })

          GuideListComp({ vm: this.vm }).layoutWeight(1)
        }

        NavHeaderBar({ title: '', hasBgColor: false })
      }
      .alignContent(Alignment.TopStart)
      .width(Constants.FULL_SIZE)
    }
    .hideTitleBar(true)
  }
}
