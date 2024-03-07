import 'package:get/get.dart';

class LayoutController extends GetxController {
  var sportType = 'football'.obs;
  // var isCN = true.obs;
  var selectedCompetitionType = 1.obs;
  var futureCompetitionDate = 1.obs; // 未开赛选择日期
  var endedCompetitionDate = 1.obs; // 已结束选择日期
}