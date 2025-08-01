import { CommonConstants, FormatUtil, IOrder, OrderStatus, RouterMap, RouterModule } from 'commonlib';
import { AssociateUtil } from 'componentlib';
import { HomePageVM } from '../viewmodels/HomePageVM';
import { emitter } from '@kit.BasicServicesKit';
import { MenuItem } from '../types';
import { MENU_LIST } from '../constants';

@ComponentV2
export struct LicenseCardItem {
  @Param license: string = '';
  @Local order?: IOrder;
  vm: HomePageVM = HomePageVM.instance;

  aboutToAppear(): void {
    emitter.on(this.license, this.callback);
  }

  aboutToDisappear(): void {
    emitter.off(this.license, this.callback);
  }

  callback = (res: emitter.EventData) => {
    if (res.data) {
      this.order = res.data as IOrder;
    }
  };

  build() {
    Column() {
      if (!this.license) {
        this.addLicenseBuilder()
      } else {
        this.showLicenseBuilder()
      }
    }
    .height(128)
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r('app.color.system_color_background_white'))
    .borderRadius($r('app.string.border_radius_16'))
  }

  @Builder
  addLicenseBuilder() {
    Column({ space: 6 }) {
      Image($r('app.media.ic_add_license')).width(140).height(60)
      Text('添加常用车牌')
        .fontSize($r('sys.float.Title_S'))
        .fontColor($r('sys.color.font_secondary'))
        .fontWeight(FontWeight.Medium)
    }
    .justifyContent(FlexAlign.Center)
    .width(CommonConstants.FULL_WIDTH)
    .height(CommonConstants.FULL_HEIGHT)
    .onClick(() => {
      AssociateUtil.checkBindPhone(() => {
        RouterModule.push({ url: RouterMap.ADD_LICENSE });
      });
    })
  }

  @Builder
  showLicenseBuilder() {
    RelativeContainer() {
      Row({ space: 10 }) {
        Text(this.license)
          .fontWeight(FontWeight.Medium)
          .height(CommonConstants.FULL_HEIGHT)
          .fontSize($r('sys.float.Title_S'))
          .fontColor($r('sys.color.font_primary'))
          .borderRadius($r('app.string.border_radius_8'))
          .padding({
            left: 10,
            right: 10,
            top: 6,
            bottom: 6,
          })
          .linearGradient({
            angle: 90,
            colors: this.license.length < 8 ? [] : [
              ['#7FDE3C', 0],
              ['#DDFFB8', 1],
            ],
          })

        if (this.vm.licenseInfo.default === this.license) {
          Text('默认车牌')
            .fontSize($r('sys.float.Caption_S'))
            .fontColor($r('sys.color.font_secondary'))
            .padding($r('app.string.padding_4'))
            .borderRadius($r('app.string.border_radius_8'))
            .backgroundColor($r('app.color.system_color_background_gray'))
        }
      }.height(40)
      .alignRules({
        'top': { 'anchor': '__container__', 'align': VerticalAlign.Top },
        'left': { 'anchor': '__container__', 'align': HorizontalAlign.Start },
      })

      Image($r('app.media.ic_option')).width(16).alignRules({
        'top': { 'anchor': '__container__', 'align': VerticalAlign.Top },
        'right': { 'anchor': '__container__', 'align': HorizontalAlign.End },
      })
        .bindMenu(this.menuBuilder)

      Column({ space: 9 }) {
        if (this.order) {
          Row({ space: 4 }) {
            Image($r('app.media.ic_location')).width(16)
            Text(this.order.spot).textStyle()
          }

          Row({ space: 4 }) {
            Image($r('app.media.ic_duration')).width(16)
            if (this.order.status === OrderStatus.PARKING) {
              Text('已停时长:  ' + FormatUtil.durationDisplay(this.order.start, Date.now())).textStyle()
            } else if (this.order.status === OrderStatus.PENDING) {
              Text('已支付，请尽快驶离！')
                .fontColor($r('sys.color.multi_color_08'))
                .fontSize($r('sys.float.Caption_L'))
            }
          }
        } else {
          Row({ space: 4 }) {
            Image($r('app.media.ic_location')).width(16)
            Text('暂未查询到入场信息').textStyle()
          }
        }
      }
      .alignItems(HorizontalAlign.Start)
      .alignRules({
        'bottom': { 'anchor': '__container__', 'align': VerticalAlign.Bottom },
        'left': { 'anchor': '__container__', 'align': HorizontalAlign.Start },
      })

      Button() {
        Row({ space: 4 }) {
          Image($r('app.media.ic_query')).width(16)
          Text(this.order?.status === OrderStatus.PENDING ? '等待出场' : '查询缴费')
            .fontSize($r('sys.float.Body_M'))
            .fontColor($r('sys.color.background_primary'))
        }
      }
      .backgroundColor($r('app.color.btn_blue1'))
      .padding({
        left: 9,
        right: 9,
        top: 6,
        bottom: 6,
      })
      .alignRules({
        'bottom': { 'anchor': '__container__', 'align': VerticalAlign.Bottom },
        'right': { 'anchor': '__container__', 'align': HorizontalAlign.End },
      })
      .onClick(() => {
        RouterModule.push({ url: RouterMap.PAY_PAGE, param: this.license });
      })
    }
    .width(CommonConstants.FULL_WIDTH)
    .height(CommonConstants.FULL_HEIGHT)
    .padding(14)
  }

  @Builder
  menuBuilder() {
    List({ space: 24 }) {
      ForEach(MENU_LIST, (item: MenuItem, index) => {
        ListItem() {
          Row({ space: 6 }) {
            Image(item.icon)
              .width(16)
              .aspectRatio(1)
            Text(item.text)
              .fontWeight(FontWeight.Regular)
              .fontSize(12)
              .fontColor($r('sys.color.font_secondary'))
          }
          .width(CommonConstants.FULL_WIDTH)
        }
        .padding({ left: $r('app.string.padding_12'), right: $r('app.string.padding_12') })
        .onClick(() => {
          if (index === 0) {
            // 刷新状态
            this.vm.queryParking(this.license).then(res => {
              this.order = res;
            });
          } else {
            // 删除车牌
            AssociateUtil.checkBindPhone(() => {
              this.vm.deleteLicense(this.license);
            });
          }
        })
      }, (item: MenuItem, index) => JSON.stringify(item) + '_' + index)
    }
    .width(100)
    .divider({ strokeWidth: 1, color: $r('app.color.divider_gray') })
    .padding({ top: $r('app.string.padding_12'), bottom: $r('app.string.padding_12') })
  }
}

@Extend(Text)
function textStyle() {
  .fontColor($r('sys.color.font_secondary'))
  .fontSize($r('sys.float.Caption_M'))
}