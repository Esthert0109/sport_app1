import 'package:flutter/cupertino.dart';

import '../../Constants/textConstant.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PinNewsComponent extends StatefulWidget {
  final String title;
  final String timeAgo;
  final int read;

  PinNewsComponent(
      {super.key,
      required this.title,
      required this.timeAgo,
      required this.read});

  @override
  State<PinNewsComponent> createState() => _PinNewsComponentState();
}

class _PinNewsComponentState extends State<PinNewsComponent> {
  String formatDateString(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);

    String formattedDateString =
        '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';

    return formattedDateString;
  }

  @override
  Widget build(BuildContext context) {
    // standard size
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    String title = widget.title;
    String timeAgo = formatDateString(widget.timeAgo);
    int read = widget.read;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5 * fem, vertical: 5 * fem),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: tNewsTopTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5 * fem),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 20 * fem),
                  child: Text(
                    AppLocalizations.of(context)!.pin,
                    style: tPinNews,
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20 * fem),
                  child: Text(
                    timeAgo,
                    style: tTimeRead,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20 * fem),
                  child: Text(
                    "$read " + AppLocalizations.of(context)!.read,
                    style: tTimeRead,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
