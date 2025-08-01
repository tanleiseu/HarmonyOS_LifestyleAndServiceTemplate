import { display } from '@kit.ArkUI';
import { UIBase } from '@hw-agconnect/ui-base';

export const getScreenWidth = ():number=> {
  let displayClass: display.Display | null = null;
  displayClass = display.getDefaultDisplaySync();
  return px2vp(displayClass.width)
}

export const getWindowWidth = ():number=> {
  let windowWidth = UIBase.getWindowProperties()?.windowRect.width
  return px2vp(windowWidth)
}