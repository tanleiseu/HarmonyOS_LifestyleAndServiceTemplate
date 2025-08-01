const storageLocal2 = new LocalStorage();

@Entry(storageLocal2)
@Component
struct Widget2x2Card {
  @LocalStorageProp('default') default: string = '';
  @LocalStorageProp('duration') duration: string = '';
  fontColor: ResourceStr = $r('sys.color.background_emphasize');
  readonly actionType: string = 'router';
  readonly abilityName: string = 'EntryAbility';

  nextDo() {
    if (this.default) {
      postCardAction(this, {
        action: 'router',
        abilityName: this.abilityName,
        params: {
          targetPage: 'PayPage',
          license: this.default,
        },
      });
    } else {
      postCardAction(this, {
        action: 'router',
        abilityName: this.abilityName,
        params: {
          targetPage: 'QueryPage',
        },
      });
    }
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.app_icon_rect'))
          .borderRadius('50%')
          .clip(true)
          .aspectRatio(1)
          .width(20)

        Text('停车缴费')
          .textStyle1()
          .layoutWeight(1)
          .margin({ left: 8 })

        Image($r('app.media.ic_refresh'))
          .width(14)
          .onClick(() => {
            if (this.default) {
              postCardAction(this, {
                action: 'message',
                params: { license: this.default },
              });
            }
          })
      }
      .margin({ bottom: 9 })

      if (this.default) {
        Column({ space: 12 }) {
          Row({ space: 4 }) {
            Text(this.default).textStyle1()
            Text('默认车辆')
              .padding({
                left: 4,
                right: 4,
                top: 3,
                bottom: 3,
              })
              .backgroundColor($r('app.color.system_color_background_gray'))
              .borderRadius($r('app.string.border_radius_8'))
              .fontColor('rgba(0,0,0,0.60)')
              .fontSize(8)
          }.height(20)

          Text(this.duration ? this.duration : '未查询到入场').textStyle2()
        }
        .width('100%')
        .layoutWeight(1).justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Start)
      } else {
        Column({ space: 12 }) {
          Text('无默认车牌').textStyle1()
          Text('未查询到车辆').textStyle2()
        }
        .width('100%')
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Start)
      }

      Button('查询缴费')
        .fontColor(this.fontColor)
        .fontWeight(FontWeight.Medium)
        .fontSize($r('sys.float.Body_M'))
        .backgroundColor($r('app.color.system_color_background_white'))
        .width('100%')
        .height(28)
        .onClick(() => {
          this.nextDo();
        })
    }
    .width('100%')
    .height('100%')
    .linearGradient({
      angle: 180,
      colors: [
        ['#EFF5FF', 0],
        ['#8FB2F1', 0.99],
      ],
    })
    .padding(12)
  }
}

@Extend(Text)
function textStyle1() {
  .fontSize(14)
  .fontColor('#0C0634')
  .fontWeight(FontWeight.Medium)
}

@Extend(Text)
function textStyle2() {
  .fontSize(18)
  .fontColor('#0C0634')
  .fontWeight(FontWeight.Medium)
}