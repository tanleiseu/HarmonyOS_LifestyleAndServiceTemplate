import { CommonConstants } from 'commonlib';
import { CommonHeader } from 'componentlib';
import { HeadPart } from '../components/HeaderPart';
import { Settings } from '../components/Settings';
import { MinePageVM } from '../viewmodels/MinePageVM';

@ComponentV2
export struct MinePage {
  vm: MinePageVM = MinePageVM.instance;

  build() {
    Column() {
      /** 标题栏 **/
      CommonHeader({ title: '我的', showBackButton: false })

      Scroll() {
        Column({ space: 16 }) {
          /** 顶部信息 **/
          HeadPart()

          /** 更多设置 **/
          Settings()

          Blank().layoutWeight(1)
        }
        .padding({ left: $r('app.string.padding_16'), right: $r('app.string.padding_16') })
      }.layoutWeight(1).scrollBar(BarState.Off)
    }
    .height(CommonConstants.FULL_HEIGHT)
    .backgroundColor($r('app.color.system_color_background_gray'))
  }
}

@Builder
export function MinePageBuilder() {
  MinePage()
}