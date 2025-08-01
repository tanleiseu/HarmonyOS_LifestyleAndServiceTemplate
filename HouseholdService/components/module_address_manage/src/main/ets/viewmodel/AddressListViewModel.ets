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
import { CommonUtils, IJumpAddrParam, RouterMap } from 'module_base';
import { AddressListModel } from '../model/AddressListModel';
import { AddrViewModel } from './AddrViewModel';
import { AddressModel } from '../model/AddressModel';
import { AppStorageBank } from '../common/Global';

@ObservedV2
export class AddrListVM {
  @Trace list: AddrViewModel[] = [];
  @Trace needPop: boolean = false;
  @Trace selectedId: number = 0;
  listScroller: ListScroller = new ListScroller();
  stack: NavPathStack = new NavPathStack();
  static _instance: AddrListVM;

  static get instance() {
    if (AddrListVM._instance) {
      return AddrListVM._instance;
    }
    AddrListVM._instance = new AddrListVM();
    return AddrListVM._instance;
  }

  init() {
    this.queryList();
  }

  getRouteParam() {
    const paramList: IJumpAddrParam[] = this.stack.getParamByName(RouterMap.ADDRESS_MANAGE) as IJumpAddrParam[];
    if (paramList.length && paramList[paramList.length - 1]) {
      const item = paramList[paramList.length - 1];
      this.needPop = item.needOnPop ?? false;
      this.selectedId = item.selectedId ?? 0;
    } else {
      this.needPop = false;
      this.selectedId = 0;
    }
  }

  setStack(stack: NavPathStack) {
    this.stack = stack;
  }

  isSelected(item: AddrViewModel) {
    return item.id === this.selectedId;
  }

  getObservedAddrInfo(item: AddressModel): AddrViewModel {
    return new AddrViewModel(item);
  }

  sortAddrList(a: AddressModel, b: AddressModel): number {
    if (this.selectedId === 0) {
      return 0;
    }
    if (a.id === this.selectedId) {
      return -1;
    }
    if (b.id === this.selectedId) {
      return 1;
    }
    return 0;
  }

  async queryList() {
    CommonUtils.showLoading();
    const listModel = new AddressListModel();
    await listModel.getAddressList();
    this.list = listModel.list
      .sort((a: AddressModel, b: AddressModel) => this.sortAddrList(a, b))
      .map((item: AddressModel) => this.getObservedAddrInfo(item))
    CommonUtils.hideLoading();
    AppStorageBank.updateAddrList(this.list);
  }

  deleteConfirm(data: AddrViewModel) {
    CommonUtils.openConfirmDialog({
      content: '是否删除此地址',
      priBtnV: '取消',
      secBtnV: '删除',
      secBtnRole: ButtonRole.ERROR,
      confirm: () => {
        this.deleteAddr(data);
      },
      cancel: () => {
        this.listScroller.closeAllSwipeActions();
      },
    })
  }

  async deleteAddr(data: AddrViewModel) {
    await data.getModel.del();
    this.listScroller.closeAllSwipeActions();
    this.queryList();
  }
}