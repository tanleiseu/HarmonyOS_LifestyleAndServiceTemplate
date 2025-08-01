import { TabConstant } from '../constants';

@ComponentV2
export struct CommonTab {
  /** 内容参数 **/
  // 初始Tab页索引,支持!!双向绑定
  @Param index: number = 0;
  @Event $index: (val: number) => void;
  // 页签名数组
  @Require @Param tabBar: string[];
  // TabContent内容,注意使用()=>{},防止this指向性问题、不动态刷新
  @BuilderParam contentUi: (index: number) => void = this.tabContentsDefaultBuilder;
  // TabBar自定义内容,背景色跟随tabBar栏,注意设置内边距
  @BuilderParam tabBarUi?: () => void;
  /** 样式参数 **/
  // 页签所处位置: 默认居顶
  @Param top: boolean = true;
  // 页签对齐方式: 默认均分
  @Param start: boolean = false;
  // 摩擦系数(左对齐且超长可滚动时)
  @Param friction: number = TabConstant.FRICTION;
  // 间隙(左对齐时)
  @Param space: number = TabConstant.SPACE;
  // 页签左边距
  @Param offsetLeft: number = TabConstant.OFFSET_LEFT;
  // 页签右边距
  @Param offsetRight: number = TabConstant.OFFSET_RIGHT;
  // 选中颜色: 文字 + 条形
  @Param activeColor: ResourceColor = TabConstant.ACTIVE_COLOR;
  // 待选颜色: 同上
  @Param frozenColor: ResourceColor = TabConstant.FROZEN_COLOR;
  // 选中大小: 文字 + 条形
  @Param activeSize: string | number | Resource = TabConstant.ACTIVE_SIZE;
  // 待选大小: 同上
  @Param frozenSize: string | number | Resource = TabConstant.FROZEN_SIZE;
  // 页签区背景颜色
  @Param tabBarBgColor: ResourceColor = TabConstant.TAB_BAR_BGCOLOR;
  // 内容背景颜色
  @Param tabContentBgColor: ResourceColor = TabConstant.TAB_CONTENT_BGCOLOR;
  // 选中文字粗细
  @Param activeWeight: number | string | FontWeight = TabConstant.ACTIVE_WEIGHT;
  // 待选文字粗细
  @Param frozenWeight: number | string | FontWeight = TabConstant.FROZEN_WEIGHT;
  // 动画时长
  @Param animationDuration: number = TabConstant.ANIMATION_DURATION;
  // 导航区高度
  @Param tabBarHeight: number = TabConstant.TAB_BAR_HEIGHT;
  // 条形高度
  @Param lineHeight: number = TabConstant.LINE_HEIGHT;
  // 条形相对垂直位置(top为true时相对页签顶部,为false时相对页签底部)
  @Param relativeY: number = TabConstant.RELATIVE_Y;
  /** 本地参数 **/
  @Local localIndex: number = 0;
  @Local indicatorLeftMargin: number = 0;
  @Local indicatorWidth: number = 0;
  private _listWidth: number = 0;
  private _tabsWidth: number = 0;
  private _textInfos: [number, number][] = [];
  private _isStartAnimateTo: boolean = false;
  private _tabController: TabsController = new TabsController();
  private _listController: Scroller = new Scroller();

  aboutToAppear(): void {
    for (let i = 0; i < this.tabBar.length; i++) {
      this._textInfos.push([0, 0]);
    }
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Tabs({ barPosition: this.top ? BarPosition.Start : BarPosition.End, controller: this._tabController }) {
        ForEach(this.tabBar, (item: string, index: number) => {
          TabContent() {
            Column() {
              this.contentUi(index)
            }.width(TabConstant.FULL_WIDTH).height(TabConstant.FULL_HEIGHT)
          }.tabBar(this.start ? undefined : this.tabBarBuilder(item, index))
        }, (item: string, index) => item + '_' + index)
      }
      .onAppear(() => {
        this._tabController.changeIndex(this.index);
      })
      .onSizeChange((oldValue, newValue) => {
        this._tabsWidth = newValue.width as number;
        if (!this._isStartAnimateTo) {
          this._setIndicatorAttr(this._textInfos[this.localIndex][0], this._textInfos[this.localIndex][1]);
        }
      })
      .padding({
        top: this.start && this.top ? this.tabBarHeight : 0,
        bottom: this.start && !this.top ? this.tabBarHeight : 0,
      })
      .barWidth(TabConstant.FULL_WIDTH)
      .barHeight(this.start ? 0 : this.tabBarHeight)
      .width(TabConstant.FULL_WIDTH)
      .height(TabConstant.FULL_HEIGHT)
      .barBackgroundColor(this.tabBarBgColor)
      .backgroundColor(this.tabContentBgColor)
      .animationDuration(this.animationDuration)
      .onChange((index: number) => {
        // 监听索引index的变化，实现页签内容的切换。
        this.localIndex = index;
        this.$index(index);
        if (this.indicatorLeftMargin + this.indicatorWidth > this._listWidth || this.indicatorLeftMargin < 0) {
          this._listController.scrollToIndex(this.localIndex, true);
        }
      })
      .onAnimationStart((index: number, targetIndex: number) => {
        // 切换动画开始时触发该回调。下划线跟着页面一起滑动，同时宽度渐变。
        this.localIndex = targetIndex;
        this._startAnimateTo(this.animationDuration, this._textInfos[targetIndex][0], this._textInfos[targetIndex][1]);
      })
      .onAnimationEnd((index: number, event: TabsAnimationEvent) => {
        // 切换动画结束时触发该回调。下划线动画停止。
        let currentIndicatorInfo = this._getCurrentIndicatorInfo(index, event);
        this._startAnimateTo(0, currentIndicatorInfo.left, currentIndicatorInfo.width);
      })
      .onGestureSwipe((index: number, event: TabsAnimationEvent) => {
        // 在页面跟手滑动过程中，逐帧触发该回调。
        let currentIndicatorInfo = this._getCurrentIndicatorInfo(index, event);
        this.localIndex = currentIndicatorInfo.index;
        this._setIndicatorAttr(currentIndicatorInfo.left, currentIndicatorInfo.width);
      })

      if (this.start) {
        Row() {
          List({ space: this.space, initialIndex: this.index, scroller: this._listController }) {
            ForEach(this.tabBar, (item: string, index) => {
              ListItem() {
                this.tabBarBuilder(item, index)
              }
            }, (item: string, index) => item + '_' + index)
          }
          .onSizeChange((oldArea, newArea) => {
            this._listWidth = newArea.width as number;
          })
          .layoutWeight(1)
          .friction(this.friction)
          .height(this.tabBarHeight)
          .contentStartOffset(this.offsetLeft)
          .contentEndOffset(this.offsetRight)
          .scrollBar(BarState.Off)
          .listDirection(Axis.Horizontal)
          .alignListItem(ListItemAlign.Start)
          .onDidScroll((xOffset: number) => {
            this.indicatorLeftMargin -= xOffset;
          })

          Column()
            .height(this.lineHeight)
            .width(this.indicatorWidth)
            .position(this.top ? { left: this.indicatorLeftMargin, top: this.relativeY } :
              { left: this.indicatorLeftMargin, bottom: this.relativeY })
            .backgroundColor(this.activeColor)

          Column() {
            this.tabBarUi?.()
          }.height(this.tabBarHeight).backgroundColor(this.tabBarBgColor).offset({ right: 0 }).zIndex(10)
        }
        .backgroundColor(this.tabBarBgColor)
        .position({ top: this.top ? 0 : undefined, bottom: this.top ? undefined : 0 })

      }

      if (!this.start) {
        Column()
          .height(this.lineHeight)
          .width(this.indicatorWidth)
          .position(this.top ? { left: this.indicatorLeftMargin, top: this.relativeY } :
            { left: this.indicatorLeftMargin, bottom: this.relativeY })
          .backgroundColor(this.activeColor)
      }
    }.width(TabConstant.FULL_WIDTH).layoutWeight(1).clip(true)
  }

  private _getCurrentIndicatorInfo(index: number, event: TabsAnimationEvent): Record<string, number> {
    let nextIndex = index;
    if (index > 0 && event.currentOffset > 0) {
      nextIndex--;
    } else if (index < this._textInfos.length - 1 && event.currentOffset < 0) {
      nextIndex++;
    }
    let indexInfo = this._textInfos[index];
    let nextIndexInfo = this._textInfos[nextIndex];
    let swipeRatio = Math.abs(event.currentOffset / this._tabsWidth);
    // 页面滑动超过一半，tabBar切换到下一页。
    let currentIndex = swipeRatio > 0.5 ? nextIndex : index;
    let currentLeft = indexInfo[0] + (nextIndexInfo[0] - indexInfo[0]) * swipeRatio;
    let currentWidth = indexInfo[1] + (nextIndexInfo[1] - indexInfo[1]) * swipeRatio;
    return { 'index': currentIndex, 'left': currentLeft, 'width': currentWidth };
  }

  private _startAnimateTo(duration: number, leftMargin: number, width: number) {
    this._isStartAnimateTo = true;
    animateTo({
      duration: duration,
      curve: Curve.Linear,
      iterations: 1,
      playMode: PlayMode.Normal,
      onFinish: () => {
        this._isStartAnimateTo = false;
      },
    }, () => {
      this._setIndicatorAttr(leftMargin, width);
    });
  }

  private _setIndicatorAttr(leftMargin: number, width: number) {
    this.indicatorWidth = width;
    this.indicatorLeftMargin = leftMargin;
  }

  @Builder
  tabBarBuilder(name: string, index: number) {
    Text(name)
      .height(TabConstant.FULL_HEIGHT)
      .fontColor(this.localIndex === index ? this.activeColor : this.frozenColor)
      .fontWeight(this.localIndex === index ? this.activeWeight : this.frozenWeight)
      .fontSize(this.localIndex === index ? this.activeSize : this.frozenSize)
      .id(index.toString())
      .onAreaChange((oldValue: Area, newValue: Area) => {
        this._textInfos[index] = [newValue.globalPosition.x as number, newValue.width as number];
        if (!this._isStartAnimateTo && this.localIndex === index && this._tabsWidth > 0) {
          this._setIndicatorAttr(this._textInfos[this.localIndex][0], this._textInfos[this.localIndex][1]);
        }
      })
      .onClick(() => {
        this._tabController.changeIndex(index);
        this.localIndex = index;
      })
  }

  @Builder
  tabContentsDefaultBuilder(index: number) {
    Text('TabContent' + index).height(TabConstant.FULL_HEIGHT)
      .fontWeight(FontWeight.Medium)
      .fontSize($r('sys.float.Title_M'))
  }
}