
import 'package:live_flutter_plugin/v2_tx_live_premier.dart';

/// 腾讯云License管理页面(https://console.cloud.tencent.com/live/license)
setupLicense() {
  // 当前应用的License LicenseUrl
  var LICENSEURL =
      "https://license.vod-pro.com/license/v2/1324939077_1/v_cube.license";
  // 当前应用的License Key
  var LICENSEURLKEY = "4cdeecc66f99fcdd90e29e586fe3bec8";
  V2TXLivePremier.setLicence(LICENSEURL, LICENSEURLKEY);
}
