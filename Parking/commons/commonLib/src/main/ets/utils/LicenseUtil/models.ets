@ObservedV2
export class LicenseModel {
  @Trace all: string[] = [];
  @Trace default: string = '';
}

@ObservedV2
export class UsedLicenseModel {
  @Trace all: string[] = [];
}