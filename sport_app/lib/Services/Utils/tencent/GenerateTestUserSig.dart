// // ignore_for_file: file_names

// import 'dart:convert';

// import 'package:crypto/crypto.dart';
// import 'package:archive/archive.dart';
// import 'package:archive/archive_io.dart';

// class GenerateTestUserSig {
//   GenerateTestUserSig({required this.sdkappid, required this.key});
//   int sdkappid;
//   String key;

//   String genSig({
//     required String identifier,
//     required int expire,
//   }) {
//     int currTime = _getCurrentTime();
//     String sig = '';
//     Map<String, dynamic> sigDoc = <String, dynamic>{};
//     sigDoc.addAll({
//       "TLS.ver": "2.0",
//       "TLS.identifier": identifier,
//       "TLS.sdkappid": this.sdkappid,
//       "TLS.expire": expire,
//       "TLS.time": currTime,
//     });

//     sig = _hmacsha256(
//       identifier: identifier,
//       currTime: currTime,
//       expire: expire,
//     );
//     sigDoc['TLS.sig'] = sig;
//     String jsonStr = json.encode(sigDoc);
//     List<int>? compress = const ZLibEncoder().encode(utf8.encode(jsonStr));
//     return _escape(content: base64.encode(compress));
//   }

//   int _getCurrentTime() {
//     return (DateTime.now().millisecondsSinceEpoch / 1000).floor();
//   }

//   String _hmacsha256({
//     required String identifier,
//     required int currTime,
//     int expire = 30 * 24 * 60 * 60,
//   }) {
//     int sdkappid = this.sdkappid;
//     String contentToBeSigned =
//         "TLS.identifier:$identifier\nTLS.sdkappid:$sdkappid\nTLS.time:$currTime\nTLS.expire:$expire\n";
//     Hmac hmacSha256 = Hmac(sha256, utf8.encode(key));
//     Digest hmacSha256Digest =
//         hmacSha256.convert(utf8.encode(contentToBeSigned));
//     return base64.encode(hmacSha256Digest.bytes);
//   }

//   String _escape({
//     required String content,
//   }) {
//     return content
//         .replaceAll('+', '*')
//         .replaceAll('/', '-')
//         .replaceAll('=', '_');
//   }
// }

// ignore_for_file: non_constant_identifier_names

/*
 * Module:   GenerateTestUserSig
 *
 * Function: 用于生成测试用的 UserSig，UserSig 是腾讯云为其云服务设计的一种安全保护签名。
 *           其计算方法是对 SDKAppID、UserID 和 EXPIRETIME 进行加密，加密算法为 HMAC-SHA256。
 *
 * Attention: 请不要将如下代码发布到您的线上正式版本的 App 中，原因如下：
 *
 *            本文件中的代码虽然能够正确计算出 UserSig，但仅适合快速调通 SDK 的基本功能，不适合线上产品，
 *            这是因为客户端代码中的 SECRETKEY 很容易被反编译逆向破解，尤其是 Web 端的代码被破解的难度几乎为零。
 *            一旦您的密钥泄露，攻击者就可以计算出正确的 UserSig 来盗用您的腾讯云流量。
 *
 *            正确的做法是将 UserSig 的计算代码和加密密钥放在您的业务服务器上，然后由 App 按需向您的服务器获取实时算出的 UserSig。
 *            由于破解服务器的成本要高于破解客户端 App，所以服务器计算的方案能够更好地保护您的加密密钥。
 *
 * Reference：https://cloud.tencent.com/document/product/647/17275#Server
 */

import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

class GenerateTestUserSig {
  GenerateTestUserSig({required this.sdkappId, required this.key});
  int sdkappId;
  String key;
  /*
   * 腾讯云 SDKAppId，需要替换为您自己账号下的 SDKAppId。
   *
   * 进入腾讯云实时音视频[控制台](https://console.cloud.tencent.com/trtc ) 创建应用，即可看到 SDKAppId，
   * 它是腾讯云用于区分客户的唯一标识。
   */
  static int sdkAppId = 20007685;

  /*
   * 签名过期时间，建议不要设置的过短
   * <p>
   * 时间单位：秒
   * 默认时间：7 x 24 x 60 x 60 = 604800 = 7 天
   */
  static int expireTime = 604800;

  /*
   * 计算签名用的加密密钥，获取步骤如下：
   *
   * step1. 进入腾讯云实时音视频[控制台](https://console.cloud.tencent.com/trtc )，如果还没有应用就创建一个，
   * step2. 单击“应用配置”进入基础配置页面，并进一步找到“帐号体系集成”部分。
   * step3. 点击“查看密钥”按钮，就可以看到计算 UserSig 使用的加密的密钥了，请将其拷贝并复制到如下的变量中
   *
   * 注意：该方案仅适用于调试Demo，正式上线前请将 UserSig 计算代码和密钥迁移到您的后台服务器上，以避免加密密钥泄露导致的流量盗用。
   * 文档：https://cloud.tencent.com/document/product/647/17275#Server
   */
  static String secretKey = "0abda76ec2364e9e96a986d703cee89b86c82a4f6f4224af20830899d3e76466";

  /*
   *  配置推流地址
   *  腾讯云域名管理页面：https://console.cloud.tencent.com/live/domainmanage
   */
  static String PUSH_DOMAIN = "";
  /*
   *  配置拉流地址
   *  腾讯云域名管理页面： https://console.cloud.tencent.com/live/domainmanage
   */
  static String PLAY_DOMAIN = "mindarker.top";
  /*
   * URL 鉴权Key
   */
  static String LIVE_URL_KEY = "";

  /*
   * 腾讯云License管理页面(https://console.cloud.tencent.com/live/license)
   * 当前应用的License LicenseUrl
   *
   * License Management View (https://console.cloud.tencent.com/live/license)
   * License URL of your application
   */
  static String LICENSEURL =
      "https://license.vod-pro.com/license/v2/1324939077_1/v_cube.license";

  /*
   * 腾讯云License管理页面(https://console.cloud.tencent.com/live/license)
   * 当前应用的License Key
   *
   * License Management View (https://console.cloud.tencent.com/live/license)
   * License key of your application
   */
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
