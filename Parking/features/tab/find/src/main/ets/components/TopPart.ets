import { IAddressInfo, RouterMap, RouterModule } from 'commonlib';
import { CommonHeader } from 'componentlib';
import { FindPageVM } from '../viewmodels/FindPageVM';

@ComponentV2
export struct TopPart {
  vm: FindPageVM = FindPageVM.instance;

  build() {
    Column() {
      CommonHeader({ title: '找车位', showBackButton: false })

      Stack({ alignContent: Alignment.End }) {
        Search({ value: $$this.vm.query, placeholder: '输入地址' })
          .backgroundColor($r('sys.color.white'))
          .shadow({
            radius: 4,
            offsetY: 4,
            offsetX: 0,
            color: 'rgba(0,0,0,0.25)',
          })
          .searchButton('搜索')
          .focusable(false)
          .onClick(() => {
            RouterModule.push({
              url: RouterMap.SEARCH_LIST,
              param: this.vm.query,
              onPop: (res) => {
                if (res.result) {
                  const info = res.result as IAddressInfo;
                  this.vm.query = info.name;
                  this.vm.moveCamera(info.location);
                }
              },
            });
          })

        if (this.vm.query) {
          Row()
            .width(24)
            .height(24)
            .margin({ right: 72 })
            .onClick(() => {
              this.vm.query = '';
            })
        }
      }
      .padding({ left: $r('app.string.padding_16'), right: $r('app.string.padding_16') })
    }
  }
}