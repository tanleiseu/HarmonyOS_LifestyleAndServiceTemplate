/**
 * 通用Utils
 */
export class CommonUtils {
  /**
   * 对象赋值
   * @param target
   * @param source
   * @returns
   */
  static assign(target: Object, ...source: Object[]) {
    for (let s of source) {
      for (let key of Object.keys(s)) {
        const value = Reflect.get(s, key) as Object;
        Reflect.set(target, key, value)
      }
    }
  }

}