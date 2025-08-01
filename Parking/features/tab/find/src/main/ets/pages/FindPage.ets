import { CommonConstants } from 'commonlib';
import { FindPageVM } from '../viewmodels/FindPageVM';
import { MapComponent } from '@kit.MapKit';
import { TopPart } from '../components/TopPart';
import { BottomPart } from '../components/BottomPart';

@ComponentV2
export struct FindPage {
  vm: FindPageVM = FindPageVM.instance;

  build() {
    Stack({ alignContent: Alignment.Top }) {
      // 地图(高度为1-HeightEnum.LEVEL1)
      MapComponent({ mapOptions: this.vm.mapOptions, mapCallback: this.vm.mapInitCallback }).height('92%')

      // 顶部展示栏
      TopPart().position({ top: 0 })

      // 底部列表栏
      BottomPart().position({ bottom: 0 })
    }
    .height(CommonConstants.FULL_HEIGHT)
    .backgroundColor($r('app.color.system_color_background_gray'))
  }
}

@Builder
export function FindPageBuilder() {
  FindPage()
}