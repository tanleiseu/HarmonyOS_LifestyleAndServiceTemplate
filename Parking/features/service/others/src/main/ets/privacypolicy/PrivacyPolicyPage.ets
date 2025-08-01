import { CommonHeader } from 'componentlib';
import { AtomicServiceWeb, AtomicServiceWebController } from '@kit.ArkUI';

@Component
export struct PrivacyPolicyPage {
  @State controller: AtomicServiceWebController = new AtomicServiceWebController();
  @State progress: number = 0;
  @State loading: boolean = true;

  build() {
    NavDestination() {
      /** 标题 **/
      CommonHeader({ title: '隐私政策' })
      Column() {
        if (this.loading) {
          Progress({ type: ProgressType.Linear, value: this.progress, total: 100 })
            .color($r('sys.color.comp_background_emphasize'))
            .style({ strokeWidth: 4, strokeRadius: $r('sys.float.corner_radius_level1') })
            .position({ top: 0 })
            .zIndex(1)
        }

        AtomicServiceWeb({
          src: $rawfile('PrivacyPolicy.html'),
          controller: this.controller,
          onPageBegin: () => {
            this.progress = 0;
          },
          onProgressChange: (event: OnProgressChangeEvent) => {
            this.progress = event.newProgress;
            if (this.progress === 100) {
              animateTo({ duration: 300, delay: 300 }, () => {
                this.loading = false;
              });
            }
          },
        })
      }.layoutWeight(1)
    }
    .hideTitleBar(true)
  }
}

@Builder
export function PrivacyPolicyPageBuilder() {
  PrivacyPolicyPage()
}