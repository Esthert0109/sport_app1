import 'package:flutter/material.dart';

import '../../Constants/textConstant.dart';

class SelectionButtonTournamentComponent extends StatefulWidget {
  final int index;
  final List<String> selectionList;
  final Function(int) onTap;

  SelectionButtonTournamentComponent({
    super.key,
    required this.index,
    required this.selectionList,
    required this.onTap,
  });

  @override
  State<SelectionButtonTournamentComponent> createState() =>
      _SelectionButtonTournamentComponentState();
}

class _SelectionButtonTournamentComponentState
    extends State<SelectionButtonTournamentComponent> {
  @override
  Widget build(BuildContext context) {
    // standard size
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(
          widget.selectionList.length,
          (index) => Container(
                height: 25,
                padding: EdgeInsets.only(right: 20),
                child: InkWell(
                  onTap: () => widget.onTap(index),
                  child: Center(
                    child: Text(
                      widget.selectionList[index],
                      textAlign: TextAlign.center,
                      style: (widget.index == index)
                          ? tSelectedText
                          : tUnselectedText,
                    ),
                  ),
                ),
              )),
    );
  }
}
