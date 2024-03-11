import 'package:flutter/material.dart';

import '../../Constants/textConstant.dart';

class SelectionButtonTextComponent extends StatefulWidget {
  final int index;
  final List<String> selectionList;
  final Function(int) onTap;
  final bool isMainPage;

  SelectionButtonTextComponent(
      {super.key,
      required this.index,
      required this.selectionList,
      required this.onTap,
      required this.isMainPage});

  @override
  State<SelectionButtonTextComponent> createState() =>
      _SelectionButtonTextComponentState();
}

class _SelectionButtonTextComponentState
    extends State<SelectionButtonTextComponent> {
  @override
  Widget build(BuildContext context) {
    // standard size
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
            widget.selectionList.length,
            (index) => Container(
                  height: 25 * fem,
                  padding: EdgeInsets.only(right: 20 * fem),
                  child: InkWell(
                    onTap: () => widget.onTap(index),
                    child: Center(
                      child: Text(
                        widget.selectionList[index],
                        textAlign: TextAlign.center,
                        style: (widget.index == index)
                            ? tSelectedTagTitle
                            : tUnselectedTagTitle,
                      ),
                    ),
                  ),
                )),
      ),
    );
  }
}
