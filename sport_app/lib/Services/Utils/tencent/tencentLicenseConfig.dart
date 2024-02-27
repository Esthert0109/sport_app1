
import 'package:live_flutter_plugin/v2_tx_live_premier.dart';

/// 腾讯云License管理页面(https://console.cloud.tencent.com/live/license)
setupLicense() {
  // 当前应用的License LicenseUrl
  var LICENSEURL =
      "https://license.vod-control.com/license/v2/1321239144_1/v_cube.license";
  // 当前应用的License Key
  var LICENSEURLKEY = "e24f6d66e5374a477e43f3abfb76f570";
  V2TXLivePremier.setLicence(LICENSEURL, LICENSEURLKEY);
}
