import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constants/colorConstant.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DanmakuInput extends StatefulWidget {
  final bool isOn;

  DanmakuInput({
    required this.isOn,
  });

  @override
  State<DanmakuInput> createState() => _DanmakuInputState();
}

class _DanmakuInputState extends State<DanmakuInput> {
  @override
  Widget build(BuildContext context) {
    TextEditingController danmakuController = TextEditingController();
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    bool isDanmakuOn = widget.isOn;

    return Container(
      width: 134 * fem,
      height: 30 * fem,
      decoration: BoxDecoration(
          color: kButtonOnColor, borderRadius: BorderRadius.circular(15 * fem)),
      child: Row(
        children: [
          Container(
              width: 92 * fem,
              height: 30 * fem,
              padding: EdgeInsets.fromLTRB(5 * fem, 2 * fem, 0 * fem, 2 * fem),
              child: isDanmakuOn
                  ? TextField(
                      obscureText: false,
                      controller: danmakuController,
                      inputFormatters: [LengthLimitingTextInputFormatter(20)],
                      style:
                          TextStyle(color: Color.fromARGB(255, 109, 109, 109)),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(
                            8 * fem, 0 * fem, 1 * fem, 12.5 * fem),
                        hintText: AppLocalizations.of(context)!.sendDanmaku,
                        hintStyle: TextStyle(
                            color: kButtonOnWordColor, fontSize: 12 * fem),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.fromLTRB(
                          8 * fem, 3 * fem, 1 * fem, 0 * fem),
                      child: Text(
                        AppLocalizations.of(context)!.offDanmaku,
                        style: TextStyle(
                          color: kButtonOnWordColor,
                          fontSize: 12 * fem,
                        ),
                      ),
                    )),
          SizedBox(
            width: 2 * fem,
          ),
          Stack(
            children: [
              Container(
                width: 30 * fem,
                height: 60 * fem,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDanmakuOn
                          ? kButtonOffSecondaryColor
                          : kButtonOnSecondaryColor,
                      width: 5,
                    ),
                    color: Colors.white),
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(4.5 * fem, 1 * fem, 1 * fem, 2 * fem),
                  child: Text(
                    isDanmakuOn
                        ? AppLocalizations.of(context)!.on
                        : AppLocalizations.of(context)!.off,
                    style: GoogleFonts.inter(
                        fontSize: 12 * fem,
                        color:
                            isDanmakuOn ? kMainGreenColor : kButtonOnWordColor,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
