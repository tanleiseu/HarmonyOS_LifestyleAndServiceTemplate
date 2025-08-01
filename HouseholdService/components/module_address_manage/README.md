# 地址管理组件快速入门

## 目录

- [简介](#简介)
- [前提](#前提)
- [使用](#使用)
- [API参考](#API参考)
- [示例代码](#示例代码)

## 简介

本组件提供地址管理场景组件。

| 地址列表                                         | 地址编辑                                         |
|----------------------------------------------|----------------------------------------------|
| <img src="screenshots/list.jpg" width="300"> | <img src="screenshots/edit.jpg" width="300"> |

## 前提

选择地点需要使用地图选点Button，参考[开发前提](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/map-config-agc)

## 使用

1. 安装组件。

   由于地址管理场景组件依赖module_base、module_form组件，所以需要将模板工程根目录的components下
   [module_base](../module_base)、[module_form](../module_form)、[module_address_manage](../module_address_manage)
   目录拷贝至您工程根目录的components/，并添加依赖和module声明。

```
// entry/oh-package.json5
"dependencies": {
  "module_base": "file:../components/module_base",
  "module_address_manage": "file:../components/module_address_manage"
}

// build-profile.json5
"modules": [
  {
    "name": "module_base",
    "srcPath": "./components/module_base"
  },
  {
    "name": "module_form",
    "srcPath": "./components/module_form",
  },
  {
    "name": "module_address_manage",
    "srcPath": "./components/module_address_manage"
  }
]
```

## API参考

由于本组件内流程闭环，以页面的方式注册并对外提供，不涉及API介绍。

## 示例代码

```
import { RouterMap } from 'module_base'

@Entry
@ComponentV2
struct AddrSample {
  stack: NavPathStack = new NavPathStack()

  build() {
    Navigation(this.stack) {
      Column({ space: 10 }) {
        Text('地址管理').fontSize(20).fontWeight(FontWeight.Bold)
        Button('go').width('100%').onClick(() => {
          this.stack.pushPath({
            name: RouterMap.ADDRESS_MANAGE,
          })
        })
      }
      .padding(10)
    }
    .hideTitleBar(true)
  }
}
```
