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
import { LengthMetrics } from '@kit.ArkUI';
import { CommonConstants, getGoodList, QueryGoodListSource, RouterModule, } from 'lib_foundation';
import { IGoodInfo, RouterMap } from 'module_base';
import { UISearch, UISearchController } from 'module_search';

@Builder
export function SearchPageBuilder() {
  SearchPage()
}

const RECOMMEND_LIST: string[] = [
  '日常保洁', '开荒清洁', '住家保姆', '金牌月嫂',
  '家电维修', '数码维修', '衣柜收纳', '全屋擦窗',
];

@ComponentV2
export struct SearchPage {
  @Local searchRspList: IGoodInfo[] = [];
  controller: UISearchController = new UISearchController();

  build() {
    NavDestination() {
      Column() {
        UISearch({
          recommendList: RECOMMEND_LIST,
          list: this.searchRspList,
          controller: this.controller,
          query: (content) => {
            return getGoodList(QueryGoodListSource.SEARCH, content).then((resp) => {
              this.searchRspList = resp;
            });
          },
          goBack: () => {
            RouterModule.pop();
          },
          jumpDetail: (v: IGoodInfo) => {
            RouterModule.push({ url: RouterMap.GOOD_DETAIL, param: v });
          },
        })
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
      .padding({
        left: 10,
        right: 10,
        bottom: 10,
      })
    }
    .title('搜索服务', { backgroundColor: Color.White, paddingStart: new LengthMetrics(10) })
    .onBackPressed(() => {
      return this.controller.onBackPressed();
    })
  }
}
