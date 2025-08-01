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
import { AppStorageV2, LengthMetrics } from '@kit.ArkUI';
import {
  AppStorageBank,
  HomeBaseInfo,
  RouterModule,
  updateCitySelected,
  CommonConstants,
  JumpCategoryParam,
} from 'lib_foundation';
import { IGoodCategory, IGoodInfo, RouterMap, CommonUtils } from 'module_base'
import { CategoryController, CategoryLayout } from 'module_category';

@ComponentV2
export struct AllCategory {
  @Local contentList: IGoodCategory[] = [];
  @Local homeBaseInfo: HomeBaseInfo = AppStorageV2.connect(HomeBaseInfo, () => new HomeBaseInfo())!;
  @Local jumpCategoryParam: JumpCategoryParam = AppStorageV2.connect(JumpCategoryParam, () => new JumpCategoryParam())!;
  controller: CategoryController = new CategoryController();

  @Monitor('jumpCategoryParam.listInitialIndex')
  onChange(monitor: IMonitor) {
    this.controller.scrollToIndex(this.jumpCategoryParam.listInitialIndex);
  }

  aboutToAppear(): void {
    this.contentList = AppStorageBank.allCategoryList;
  }

  build() {
    NavDestination() {
      Column() {
        this.topBar()
        CategoryLayout({
          contentList: this.contentList,
          initIndex: this.jumpCategoryParam.listInitialIndex,
          controller: this.controller,
          itemBuilderParam: (good: IGoodInfo) => {
            this.buildItem(good)
          },
        })
          .height('calc(100% - 40vp)')
          .padding({ top: 10 })
          .width(CommonConstants.FULL_PERCENT)
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
    }
    .title('全部服务', { backgroundColor: Color.White, paddingStart: new LengthMetrics(10) })
  }

  @Builder
  topBar() {
    Row({ space: 10 }) {
      Row({ space: 4 }) {
        Text(this.homeBaseInfo.citySelected)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .constraintSize({ maxWidth: 120 })
        Image($r('app.media.ic_public_spinner_small')).width(10)
      }
      .onClick(() => {
        RouterModule.push({
          url: RouterMap.CITY_LIST,
          onPop: (info: PopInfo) => {
            if (!info.result) {
              return;
            }
            updateCitySelected(info.result as string).then(() => {
              AppStorageBank.updateCitySelected(info.result as string);
            });
          },
        });
      })

      Search({
        placeholder: '请输入你想要查找的',
      })
        .layoutWeight(1)
        .focusable(false)
        .onClick(() => {
          RouterModule.push({ url: RouterMap.SEARCH_PAGE });
        })
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(40)
    .padding({ left: 10, right: 10 })
  }

  @Builder
  buildItem(good: IGoodInfo) {
    Column() {
      Row({ space: 10 }) {
        Image(CommonUtils.handleImgUrl(good.image))
          .width(60)
          .height(50)
          .borderRadius(4)
          .alt($r('app.media.ic_placeholder_img'))
        Column({ space: 10 }) {
          Text(good.title).fontSize(14).fontWeight(500)
          Text(good.subTitle).fontSize(12).fontColor($r('app.color.common_grey'))
        }
        .alignItems(HorizontalAlign.Start)
      }
      .width(CommonConstants.FULL_PERCENT)
      .padding({ top: 10, bottom: 10 })
      .onClick(() => {
        RouterModule.push({ url: RouterMap.GOOD_DETAIL, param: good });
      })

      Divider()
    }
  }
}
