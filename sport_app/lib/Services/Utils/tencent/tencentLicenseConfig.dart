
import 'package:live_flutter_plugin/v2_tx_live_premier.dart';

/// 腾讯云License管理页面(https://console.cloud.tencent.com/live/license)
setupLicense() {
  // 当前应用的License LicenseUrl
  var LICENSEURL =
      "https://license.vod-pro.com/license/v2/1325710331_1/v_cube.license";
  // 当前应用的License Key
  var LICENSEURLKEY = "4da5931fb7eba6d5853c180289a6a870";
  V2TXLivePremier.setLicence(LICENSEURL, LICENSEURLKEY);
}
