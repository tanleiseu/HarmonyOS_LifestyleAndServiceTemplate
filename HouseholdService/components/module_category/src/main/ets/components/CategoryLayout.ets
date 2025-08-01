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
import { IGoodCategory, IGoodInfo } from 'module_base'
import { CategoryController, defaultBuilder } from '../common/Utils';

@ComponentV2
export struct CategoryLayout {
  @Param contentList: IGoodCategory[] = [];
  @Param initIndex: number = 0;
  @Param controller: CategoryController = new CategoryController();
  @Event onScrollIndex: (index: number) => void = () => {
  };
  @BuilderParam itemBuilderParam: (good: IGoodInfo) => void = defaultBuilder;
  @Local localScrollIndex: number = 0;
  private listScroller: Scroller = new Scroller();

  aboutToAppear(): void {
    this.localScrollIndex = this.initIndex;
    this.controller.scrollToIndex = (index: number) => {
      this.scrollToAssignIndex(index);
    };
  }

  scrollToAssignIndex(targetIndex: number) {
    this.localScrollIndex = targetIndex;
    this.listScroller.scrollToIndex(this.localScrollIndex);
    this.onScrollIndex(this.localScrollIndex);
  }

  build() {
    Column() {
      Row() {
        this.LeftMenu()
        this.MainContent()
      }
      .height('100%')
      .width('100%')
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  LeftMenu() {
    Scroll() {
      Column() {
        ForEach(this.contentList, (v: IGoodCategory, index: number) => {
          Text(v.categoryLabel)
            .fontSize(14)
            .fontWeight(500)
            .fontColor(Color.Black)
            .width('100%')
            .height(52)
            .textAlign(TextAlign.Center)
            .backgroundColor(index === this.localScrollIndex ? $r('app.color.common_page_bg') : null)
            .onClick(() => {
              this.scrollToAssignIndex(index);
            })
        }, (v: IGoodCategory) => v.categoryId)
      }
    }
    .width(90)
    .height('100%')
    .backgroundColor(Color.White)
    .align(Alignment.Top)
    .scrollBar(BarState.Off)
  }

  @Builder
  ListGroupHeader(v: IGoodCategory) {
    Text(v.categoryLabel)
      .fontSize(14)
      .fontWeight(400)
      .fontColor(Color.Black)
      .padding({ top: 10, bottom: 10 })
  }

  @Builder
  MainContent() {
    List({
      initialIndex: this.localScrollIndex,
      scroller: this.listScroller,
    }) {
      ForEach(this.contentList, (v: IGoodCategory) => {
        ListItemGroup({ header: this.ListGroupHeader(v) }) {
          ForEach(v.list, (good: IGoodInfo) => {
            ListItem() {
              this.itemBuilderParam(good)
            }
          }, (v: IGoodInfo) => v.id.toString() + v.subIndex)
        }
      }, (v: IGoodCategory) => v.categoryId)
    }
    .padding({ left: 10, right: 10 })
    .backgroundColor($r('app.color.common_page_bg'))
    .width('calc(100% - 90vp)')
    .height('100%')
    .onScrollIndex((start: number) => {
      this.localScrollIndex = start;
      this.onScrollIndex(this.localScrollIndex);
    })
  }
}
