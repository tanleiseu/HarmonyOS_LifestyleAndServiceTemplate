import { abilityAccessCtrl, bundleManager, common, PermissionRequestResult, Permissions, Want } from '@kit.AbilityKit';
import { map, mapCommon } from '@kit.MapKit';
import geoLocationManager from '@ohos.geoLocationManager';
import BusinessError from '@ohos.base';
import { Logger } from '../Logger';

export interface LocationResultData {
  result: LocationStatus;
  gcj02LatLng?: mapCommon.LatLng;
}

export enum LocationStatus {
  SUCCESS = 'SUCCESS',
  PERMISSION_DENIED = 'PERMISSION_DENIED', // 权限获取失败
  UNKNOWN_ERROR = 'UNKNOWN_ERROR', // 获取位置时发生未知异常
}

const TAG = '[LocationUtil]';

export class LocationUtil {
  private static _cacheLatLng: mapCommon.LatLng | undefined = undefined;
  private static _cacheTime: number = 0;

  public static async calDistanceFromMy(toLatLng: mapCommon.LatLng) {
    const cacheLatLng = await LocationUtil.getCachedGCJ02Location(getContext() as common.UIAbilityContext, 180000);
    if (cacheLatLng.result === LocationStatus.SUCCESS) {
      return LocationUtil.calculateDistance(toLatLng, cacheLatLng.gcj02LatLng!);
    }
    return 0;
  }

  public static calculateDistance(fromLatLng: mapCommon.LatLng, toLatLng: mapCommon.LatLng): number {
    return map.calculateDistance(fromLatLng, toLatLng);
  }

  public static navWithLatLng(toLatLng: mapCommon.LatLng, ctx: common.UIAbilityContext) {
    const uri = `https://www.petalmaps.com/routes/?utm_source=fb&daddr=${toLatLng.latitude + ',' + toLatLng.longitude}`;
    ctx.openLink(uri, { appLinkingOnly: true });
  }

  public static async getCachedGCJ02Location(context: common.UIAbilityContext,
    timeout?: number): Promise<LocationResultData> {
    // 对位置的新鲜度比较敏感,可以设置超时时间
    // 获取最新位置,刷新缓存
    if (timeout && timeout < Date.now() - LocationUtil._cacheTime) {
      return await LocationUtil.getGCJ02Location(context);
    }
    if (!LocationUtil._cacheLatLng) {
      return await LocationUtil.getGCJ02Location(context);
    }
    return { result: LocationStatus.SUCCESS, gcj02LatLng: LocationUtil._cacheLatLng };
  }

  public static async getGCJ02Location(context: common.UIAbilityContext): Promise<LocationResultData> {
    const hasPermission = await LocationUtil._requestLocationPermissions(context);
    if (!hasPermission) {
      return { result: LocationStatus.PERMISSION_DENIED };
    }
    try {
      const gcj02LatLng = await LocationUtil._fetchCurrentLocation();
      LocationUtil._cacheLatLng = gcj02LatLng;
      LocationUtil._cacheTime = Date.now();
      Logger.info(TAG, 'Get location successfully');
      return { result: LocationStatus.SUCCESS, gcj02LatLng: gcj02LatLng };
    } catch (error) {
      Logger.error(TAG, 'Get location failed:' + JSON.stringify(error));
      return { result: LocationStatus.UNKNOWN_ERROR };
    }
  }

  public static async startSettings(context: common.UIAbilityContext) {
    let bundleInfo: bundleManager.BundleInfo = await bundleManager.getBundleInfoForSelf(
      bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION,
    );
    let want: Want = {
      bundleName: 'com.huawei.hmos.settings',
      abilityName: 'com.huawei.hmos.settings.MainAbility',
      uri: 'application_info_entry',
      parameters: {
        settingsParamBundleName: bundleInfo.name,
      },
    };
    context.startAbility(want);
  }

  private static async _fetchCurrentLocation(): Promise<mapCommon.LatLng> {
    const locationRequest: geoLocationManager.CurrentLocationRequest = {
      priority: geoLocationManager.LocationRequestPriority.FIRST_FIX,
      timeoutMs: 10000,
    };
    return new Promise((resolve, reject) => {
      try {
        geoLocationManager.getCurrentLocation(locationRequest,
          (error: BusinessError.BusinessError, location: geoLocationManager.Location) => {
            if (error) {
              reject(error);
            } else {
              resolve(LocationUtil._convertLocationToGCJ02(location));
            }
          },
        );
      } catch (e) {
        reject(new Error('geoLocationManager.getCurrentLocation 自身调用异常: ' + e.message));
      }
    });
  }

  private static _convertLocationToGCJ02(location: geoLocationManager.Location): mapCommon.LatLng {
    const wgs84LatLng: mapCommon.LatLng = {
      latitude: location.latitude,
      longitude: location.longitude,
    };
    return map.convertCoordinateSync(mapCommon.CoordinateType.WGS84, mapCommon.CoordinateType.GCJ02, wgs84LatLng);
  }

  private static async _requestLocationPermissions(context: common.UIAbilityContext): Promise<boolean> {
    try {
      const accessCtrlManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
      const accessTokenId: number = await LocationUtil._getAccessTokenId();
      const permissions: Permissions[] = ['ohos.permission.APPROXIMATELY_LOCATION', 'ohos.permission.LOCATION'];
      for (let permission of permissions) {
        if (
          accessCtrlManager.checkAccessTokenSync(accessTokenId, permission) ===
          abilityAccessCtrl.GrantStatus.PERMISSION_DENIED
        ) {
          const result: PermissionRequestResult =
            await accessCtrlManager.requestPermissionsFromUser(context, permissions);
          return result.authResults.every((auth) => auth === 0);
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  private static async _getAccessTokenId(): Promise<number> {
    let bundleInfo: bundleManager.BundleInfo = await bundleManager.getBundleInfoForSelf(
      bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION,
    );
    let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
    return appInfo.accessTokenId;
  }
}