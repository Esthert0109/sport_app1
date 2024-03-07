import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sport_app/Model/userDataModel.dart';

import '../../Constants/colorConstant.dart';
import '../../Constants/textConstant.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatusDateButtonComponent extends StatefulWidget {
  final int dateId;
  final List<DateTime> dateList;
  final Function(int) onTap;
  final bool isFuture;

  StatusDateButtonComponent(
      {super.key,
      required this.dateList,
      required this.dateId,
      required this.onTap,
      required this.isFuture});

  @override
  State<StatusDateButtonComponent> createState() =>
      _StatusDateButtonComponentState();
}

List<String> formatDateTimeList(List<DateTime> dateTimes) {
  List<String> formattedDates = [];

  for (DateTime dateTime in dateTimes) {
    int month = dateTime.month;
    int day = dateTime.day;

    String formattedMonth = month < 10 ? '0$month' : '$month';
    String formattedDay = day < 10 ? '0$day' : '$day';

    String formattedDate = '$formattedMonth/$formattedDay';

    formattedDates.add(formattedDate);
  }

  return formattedDates;
}

List<String> formatDayOfWeekList(List<DateTime> dateTimes, String language) {
  List<String> dayOfWeekList = [];

  for (DateTime dateTime in dateTimes) {
    String dayOfWeek = DateFormat('EEEE', language).format(dateTime);
    dayOfWeekList.add(dayOfWeek);
  }

  return dayOfWeekList;
}

class _StatusDateButtonComponentState extends State<StatusDateButtonComponent> {
  UserDataModel userDataModel = Get.find<UserDataModel>();
  String language = 'en_US';

  @override
  void initState() {
    super.initState();
    if (userDataModel.isCN.value) {
      language = 'zh_CN';
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    List<String> formattedDateList = formatDateTimeList(widget.dateList);
    List<String> formattedDayList =
        formatDayOfWeekList(widget.dateList, language);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 2 * fem, 5 * fem, 2 * fem),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
            widget.dateList.length,
            (index) => Container(
              // width: 60 * fem,
              height: 46 * fem,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: widget.dateId == index
                    ? kMainComponentColor
                    : Colors.transparent,
              ),
              padding:
                  EdgeInsets.symmetric(horizontal: 8 * fem, vertical: 2 * fem),
              margin: EdgeInsets.fromLTRB(0, 0, 5 * fem, 0),
              child: InkWell(
                onTap: () => widget.onTap(index),
                child: (index == 0 && widget.isFuture) ||
                        (index == 6 && !widget.isFuture)
                    ? Center(
                        child: Text(
                        AppLocalizations.of(context)!.tdy,
                        style: widget.dateId == index
                            ? tTodayDateButton
                            : tOtherUnselectedDateButton,
                      ))
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(formattedDateList[index].toString(),
                              textAlign: TextAlign.center,
                              style: widget.dateId == index
                                  ? tOtherSelectedDateButton
                                  : tOtherUnselectedDateButton),
                          Text(formattedDayList[index].toString(),
                              textAlign: TextAlign.center,
                              style: widget.dateId == index
                                  ? tOtherSelectedDateButton
                                  : tOtherUnselectedDateButton),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
