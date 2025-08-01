import fs from '@ohos.file.fs';
import { util } from '@kit.ArkTS';
import { Logger } from './Logger';

const TAG = '[FileUtils]';

/**
 * 文件处理类
 */
export class FileUtils {
  /**
   * 写入沙箱
   * @param uri
   * @returns
   */
  static handleUri(uri: string) {
    if (!uri) {
      return '';
    }
    let url = uri;
    let tempFile: fs.File | null = null;
    try {
      tempFile = fs.openSync(url, fs.OpenMode.READ_ONLY);
      let newPath: string = getContext().cacheDir + `/${util.generateRandomUUID(false)}.png`;
      fs.copyFileSync(tempFile.fd, newPath);
      url = 'file://' + newPath;
      return url;
    } finally {
      if (tempFile) {
        fs.closeSync(tempFile);
      }
    }
  }

  /**
   * 清除缓存
   * @param cacheDir
   */
  static clearCache(cacheDir: string) {
    Logger.info(TAG, 'clear cache dir:' + cacheDir);
    fs.listFile(cacheDir).then((filenames) => {
      for (let i = 0; i < filenames.length; i++) {
        let dirPath = cacheDir + '/' + filenames[i];
        Logger.info(TAG, 'dir path:' + dirPath);
        let isDirectory: boolean = false;
        try {
          isDirectory = fs.statSync(dirPath).isDirectory();
        } catch (e) {
          Logger.error(TAG, 'statSync error:' + JSON.stringify(e));
        }

        if (isDirectory) {
          fs.rmdirSync(dirPath);
        } else {
          fs.unlink(dirPath).then(() => {
            Logger.info(TAG, 'remove file succeed');
          }).catch((err: Error) => {
            Logger.error(TAG, 'remove file failed with error message: ' + err.message);
          });
        }
      }
    })
  }
}