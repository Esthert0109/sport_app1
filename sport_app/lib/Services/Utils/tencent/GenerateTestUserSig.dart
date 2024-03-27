

import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

class GenerateTestUserSig {
  GenerateTestUserSig({required this.sdkappId, required this.key});
  int sdkappId;
  String key;
  static int sdkAppId = 20007685;

  /*
   * 签名过期时间，建议不要设置的过短
   * <p>
   * 时间单位：秒
   * 默认时间：7 x 24 x 60 x 60 = 604800 = 7 天
   */
  static int expireTime = 604800;

  static String secretKey = "0abda76ec2364e9e96a986d703cee89b86c82a4f6f4224af20830899d3e76466";

  static String PUSH_DOMAIN = "";
  static String PLAY_DOMAIN = "play.mindarker.top";
  static String LIVE_URL_KEY = "";

  static String LICENSEURL =
      "https://license.vod-pro.com/license/v2/1324939077_1/v_cube.license";

  static String LICENSEURLKEY = "4cdeecc66f99fcdd90e29e586fe3bec8";

  ///生成UserSig
  static String genTestSig(String userId) {
    int currTime = _getCurrentTime();
    String sig = '';
    Map<String, dynamic> sigDoc = <String, dynamic>{};
    sigDoc.addAll({
      "TLS.ver": "2.0",
      "TLS.identifier": userId,
      "TLS.sdkappid": sdkAppId,
      "TLS.expire": expireTime,
      "TLS.time": currTime,
    });

    sig = _hmacsha256(
      identifier: userId,
      currTime: currTime,
      expire: expireTime,
    );
    sigDoc['TLS.sig'] = sig;
    String jsonStr = json.encode(sigDoc);
    List<int> compress = zlib.encode(utf8.encode(jsonStr));
    return _escape(content: base64.encode(compress));
  }

  static int _getCurrentTime() {
    return (DateTime.now().millisecondsSinceEpoch / 1000).floor();
  }

  static String _hmacsha256({
    required String identifier,
    required int currTime,
    required int expire,
  }) {
    int sdkappid = sdkAppId;
    String contentToBeSigned =
        "TLS.identifier:$identifier\nTLS.sdkappid:$sdkappid\nTLS.time:$currTime\nTLS.expire:$expire\n";
    Hmac hmacSha256 = Hmac(sha256, utf8.encode(secretKey));
    Digest hmacSha256Digest =
        hmacSha256.convert(utf8.encode(contentToBeSigned));
    return base64.encode(hmacSha256Digest.bytes);
  }

  static String _escape({
    required String content,
  }) {
    return content
        .replaceAll('+', '*')
        .replaceAll('/', '-')
        .replaceAll('=', '_');
  }
}
