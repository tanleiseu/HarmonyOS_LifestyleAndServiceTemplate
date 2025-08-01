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

import { CitySearchController, UICitySelect } from 'module_city_select'
import { AppStorageBank, CommonConstants, HomeBaseInfo, RecentVisitList, RouterModule } from 'lib_foundation'
import { AppStorageV2, LengthMetrics } from '@kit.ArkUI';

@Builder
export function CityListBuilder() {
  CityList()
}

@ComponentV2
export struct CityList {
  controller: CitySearchController = new CitySearchController();
  homeBaseInfo: HomeBaseInfo = AppStorageV2.connect(HomeBaseInfo, () => new HomeBaseInfo())!;
  recentVisitList: RecentVisitList = AppStorageV2.connect(RecentVisitList, () => new RecentVisitList())!;

  build() {
    NavDestination() {
      Column() {
        UICitySelect({
          currentCity: this.homeBaseInfo.currentCity,
          recentVisitList: this.recentVisitList.list,
          controller: this.controller,
          goBack: (citySelected?: string) => {
            RouterModule.pop(citySelected);
          },
          emitUpdateCityLocation: (city: string) => {
            AppStorageBank.updateCityCurrent(city);
          },
          emitUpdateRecentCityList: (city) => {
            AppStorageBank.updateRecentVisitList(city);
          },
        })
      }
      .width(CommonConstants.FULL_PERCENT)
    }
    .title('服务地址', { backgroundColor: Color.White, paddingStart: new LengthMetrics(10) })
    .backgroundColor(Color.White)
    .onBackPressed(() => {
      return this.controller.onBackPressed();
    })
  }
}
