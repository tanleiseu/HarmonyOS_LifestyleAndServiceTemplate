/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { STYLE_OPTIONS_DEFAULT, TIME_OPTIONS_DEFAULT, TimeOptions, StyleOptions } from '../common/Constant';
import { DayModel } from '../common/Model';
import { TimeSelectVM } from '../viewmodel/TimeSelectVM';

@ComponentV2
export struct TimeSelect {
  @Param label: ResourceStr = '请选择';
  @Param timeOptions: TimeOptions = TIME_OPTIONS_DEFAULT;
  @Param styleOptions: StyleOptions = STYLE_OPTIONS_DEFAULT;
  @Event onTimeSelect: (dateTime: Date) => void = () => {
  };
  timeSelectVM: TimeSelectVM = new TimeSelectVM(this.timeOptions, this.styleOptions);

  @Builder
  SheetTimeSelect() {
    Column() {
      // 标题
      Row() {
        Image($r('app.media.ic_public_close_sheet')).width(40).height(40).onClick(() => {
          this.timeSelectVM.closeDateTimeSheet();
        })
        Text('上门时间').fontSize(20).fontWeight(700).margin({ left: 8 })
        Blank()
        Image($r('app.media.ic_public_confirm_sheet')).width(40).height(40).onClick(() => {
          this.timeSelectVM.confirmSelectDateTime();
          this.onTimeSelect(this.timeSelectVM.getSelectTime());
        })
      }
      .width('100%')
      .height(56)

      Scroll() {
        Row({ space: 4 }) {
          ForEach(this.timeSelectVM.dates, (v: DayModel, index) => {
            Column({ space: 2 }) {
              Text(v.weekDesc)
                .fontSize(12)
                .fontColor(this.timeSelectVM.dateFgColor(index))
                .fontWeight(this.timeSelectVM.dateFgWeight(index))
              Text(v.dateDesc)
                .fontSize(12)
                .fontColor(this.timeSelectVM.dateFgColor(index))
                .fontWeight(this.timeSelectVM.dateFgWeight(index))
            }
            .padding(10)
            .backgroundColor(this.timeSelectVM.dateBgColor(index))
            .borderRadius(4)
            .onClick(() => {
              this.timeSelectVM.onSelectDate(index);
            })
          }, (v: DayModel) => v.date.getTime().toString())
        }
      }
      .scrollBar(BarState.Off)
      .scrollable(ScrollDirection.Horizontal)
      .edgeEffect(EdgeEffect.Spring)
      .padding({
        top: 10,
        bottom: 16,
      })

      if (this.timeSelectVM.times.length) {
        Grid(this.timeSelectVM.scroller) {
          ForEach(this.timeSelectVM.times, (v: string, index: number) => {
            GridItem() {
              Column({ space: 2 }) {
                Text(v).fontSize(14)
                if (!this.timeSelectVM.isTimeEnableSelect(index)) {
                  Text('约满').fontSize(10)
                }
              }
              .width('100%')
              .height(36)
              .justifyContent(FlexAlign.Center)
              .borderRadius(4)
              .backgroundColor(this.timeSelectVM.timeBgColor(index))
              .borderColor(this.timeSelectVM.timeBorderColor(index))
              .borderWidth(1)
              .enabled(this.timeSelectVM.isTimeEnableSelect(index))
              .opacity(this.timeSelectVM.isTimeEnableSelect(index) ? 1 : $r('sys.float.ohos_id_alpha_disabled'))
              .onClick(() => {
                this.timeSelectVM.onClickTime(index);
              })
            }
          }, (day: string) => day)
        }
        .columnsTemplate('1fr 1fr 1fr 1fr')
        .columnsGap(4)
        .rowsGap(10)
        .width('100%')
        .padding({
          bottom: 10,
        })
        .scrollBar(BarState.Off)
      } else {
        Column({ space: 10 }) {
          Image($r('app.media.ic_empty')).width(56).height(47)
          Text('暂无时间').fontColor($r('app.color.common_grey')).fontSize(12)
        }
        .width('100%')
        .margin({ top: 60, bottom: 60 })
      }
    }
    .padding({ left: 16, right: 16 })
  }

  build() {
    Row() {
      Text(this.label).fontSize(14).fontWeight(500)
      Image($r('app.media.ic_public_arrow_right')).width(12).margin({ left: 8 })
    }
    .onClick(() => {
      this.timeSelectVM.openDateTimeSheet();
    })
    .bindSheet($$this.timeSelectVM.showTimeSheet, this.SheetTimeSelect(), {
      showClose: false,
      detents: [SheetSize.MEDIUM, SheetSize.LARGE],
      scrollSizeMode: ScrollSizeMode.CONTINUOUS,
    })
  }
}
