import { UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[EntryAbility]';

export default class EntryAbility extends UIAbility {
  public targetPage: string = '';
  public license: string = '';

  public onCreate(want: Want): void {
    this._processWant(want);
  }

  public onNewWant(want: Want): void {
    this._processWant(want);
    this._pageJump();
  }

  public onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/MainEntry', (err) => {
      if (err.code) {
        hilog.error(0xff00, TAG, 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(0xff00, TAG, 'Succeeded in loading the content.');
    });
    this._pageJump();
  }

  private _processWant(want: Want) {
    if (want?.parameters?.params) {
      try {
        let params: Record<string, string> = JSON.parse(want.parameters.params as string);
        this.targetPage = params.targetPage;
        this.license = params?.license ?? '';
      } catch (error) {
        hilog.error(0xff00, TAG, 'Failed to get params. Cause: %{public}s', JSON.stringify(error));
      }
    }
  }

  private _pageJump() {
    if (this.targetPage) {
      import('commonlib').then((ns: ESObject) => {
        if (ns.RouterModule.getNowPage() === 'PayPage') {
          ns.RouterModule.replace({ url: this.targetPage, param: this.license });
        } else {
          ns.RouterModule.push({ url: this.targetPage, param: this.license });
        }
      });
    }
  }
}