import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../Constants/colorConstant.dart';
import '../../../Constants/textConstant.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../Model/infoModel.dart';
import '../../../Provider/infoProvider.dart';

class InfoPageDetail extends StatefulWidget {
  final int id;
  const InfoPageDetail({super.key, required this.id});

  @override
  State<InfoPageDetail> createState() => _InfoPageDetailState();
}

class _InfoPageDetailState extends State<InfoPageDetail> {
  bool isLoading = false;

  InfoListData? infoDetails;

  // provider
  InfoProvider infoProvider = InfoProvider();

  @override
  void initState() {
    super.initState();
    getInfoDetails();
  }

  Future<void> getInfoDetails() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      InfoDetailsModel? model = await infoProvider.getInfoDetail(widget.id);

      infoDetails = model?.data;

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // standard size
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: kMainGreenColor,
    ));

    return SafeArea(
      child: Scaffold(
        backgroundColor: kMainBackgroundColor,
        appBar: AppBar(
          backgroundColor: kMainGreenColor,
          scrolledUnderElevation: 0.0,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: kMainComponentColor),
          title:
              Text(AppLocalizations.of(context)!.info, style: tInfoDetailTitle),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20 * fem,
              )),
        ),
        body: isLoading
            ? Center(
                child: Lottie.asset(
                  'images/common/pandahappy.json',
                  width: 250,
                  height: 250,
                ),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20 * fem, vertical: 15 * fem),
                      child: Text(
                        infoDetails?.title ?? "",
                        style: tNewsTitle,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 10 * fem, horizontal: 40 * fem),
                      height: 165 * fem,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image(
                            image: NetworkImage(infoDetails?.imgUrl ?? ""),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20 * fem, vertical: 15 * fem),
                      child: Text(
                        infoDetails?.content ?? "",
                        style: tNewsDetails,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
