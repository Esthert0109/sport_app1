import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Constants/colorConstant.dart';
import '../../Constants/textConstant.dart';

class StatusButtonComponent extends StatefulWidget {
  final int statusId;
  final List<String> statusList;
  final Function(int) onTap;

  StatusButtonComponent(
      {super.key,
      required this.statusList,
      required this.statusId,
      required this.onTap});

  @override
  State<StatusButtonComponent> createState() => _StatusButtonComponentState();
}

class _StatusButtonComponentState extends State<StatusButtonComponent> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0 * fem, vertical: 10 * fem),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
            widget.statusList.length,
            (index) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(53),
                color: widget.statusId == index
                    ? kMainGreenColor
                    : kMainComponentColor,
              ),
              padding:
                  EdgeInsets.symmetric(horizontal: 12 * fem, vertical: 3 * fem),
              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: InkWell(
                onTap: () => widget.onTap(index),
                child: Text(widget.statusList[index],
                    textAlign: TextAlign.center,
                    style: widget.statusId == index
                        ? tSelectedButton
                        : tUnselectedButton),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
