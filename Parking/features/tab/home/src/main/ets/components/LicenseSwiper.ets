import { HomePageVM } from '../viewmodels/HomePageVM';
import { LicenseCardItem } from './LicenseCardItem';

@ComponentV2
export struct LicenseSwiper {
  vm: HomePageVM = HomePageVM.instance;

  build() {
    Column() {
      if (this.vm.licenseInfo.all) {
        Swiper() {
          ForEach(this.vm.licenseInfo.all, (item: string) => {
            LicenseCardItem({ license: item })
          }, (item: string) => item)
          LicenseCardItem()
        }
        .index(this.vm.licenseInfo.all.findIndex(item => item === this.vm.licenseInfo.default))
        .indicator(false)
        .autoPlay(false)
        .loop(false)
        .prevMargin(20)
        .nextMargin(20)
        .itemSpace(10)
      } else {
        LicenseCardItem().alignSelf(ItemAlign.Center).margin({ left: 30, right: 30 })
      }
    }
  }
}