import { formBindingData, FormExtensionAbility, formInfo, formProvider } from '@kit.FormKit';
import { Want } from '@kit.AbilityKit';
import { getId, Https } from 'network';
import { FormatUtil, WidgetUtil } from 'commonlib';

export default class PhoneFormAbility extends FormExtensionAbility {
  public onAddForm(want: Want) {
    let formData: Record<string, string | string[] | Map<string, string>> = {
      'default': '',
      'duration': '',
    };
    let formId = want.parameters?.[formInfo.FormParam.IDENTITY_KEY] as string | undefined;
    if (formId) {
      WidgetUtil.addFormId(formId, this.context);
      WidgetUtil.publishFormId(formId, false);
    }
    return formBindingData.createFormBindingData(formData);
  }

  public onRemoveForm(formId: string) {
    WidgetUtil.delFormId(formId, this.context);
    WidgetUtil.publishFormId(formId, true);
  }

  public onFormEvent(formId: string, message: string): void {
    const params = JSON.parse(message) as Record<string, string | Map<string, string>>;
    const license = params.license as string;
    Https.queryParking({ id: getId(), license: license });
    Https.queryParking({ id: getId(), license: license }).then(res => {
      if (res.code === 0) {
        const order = res.data.info?.pop();
        if (order) {
          let formData: Record<string, string> = {
            'duration': FormatUtil.durationDisplay(order?.start ?? Date.now(), order?.end ?? Date.now()),
          };
          WidgetUtil.getFormIds(this.context).forEach(id => {
            formProvider.updateForm(id, formBindingData.createFormBindingData(formData));
          });
        }
      }
    });
  }
}