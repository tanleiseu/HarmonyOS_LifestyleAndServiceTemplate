export class FormatUtil {
  public static distanceDisplay(distanceInMeters: number): string {
    if (distanceInMeters < 1000) {
      return `${Math.floor(distanceInMeters)}m`;
    }
    const distanceInKilometers = (distanceInMeters / 1000).toFixed(2);
    return `${distanceInKilometers}km`;
  }

  public static dateTimeDisplay(date: Date, full: boolean, hasUnit: boolean) {
    const pad = (n: number) => n.toString().padStart(2, '0');
    const year = date.getFullYear();
    const month = pad(date.getMonth() + 1);
    const day = pad(date.getDate());
    const hours = pad(date.getHours());
    const minutes = pad(date.getMinutes());
    const seconds = pad(date.getSeconds());
    if (full) {
      if (hasUnit) {
        return `${year}年${month}月${day}日 ${hours}时${minutes}分${seconds}秒`;
      }
      return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
    }
    if (hasUnit) {
      return `${year}年${month}月${day}日`;
    }
    return `${year}-${month}-${day}`;
  }

  public static durationDisplay(start: number, end: number): string {
    const timeDifference = end - start;
    const days = Math.floor(timeDifference / (1000 * 60 * 60 * 24));
    const hours = Math.floor(timeDifference % (1000 * 60 * 60 * 24) / (1000 * 60 * 60));
    const minutes = Math.floor(timeDifference % (1000 * 60 * 60) / (1000 * 60));
    if (days === 0) {
      if (hours === 0) {
        return `${minutes}分钟`;
      }
      return `${hours}小时${minutes}分钟`;
    }
    return `${days}天${hours}小时${minutes}分钟`;
  }
}