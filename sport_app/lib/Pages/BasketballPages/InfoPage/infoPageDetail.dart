import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../Constants/colorConstant.dart';
import '../../../Constants/textConstant.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InfoPageDetail extends StatefulWidget {
  const InfoPageDetail({super.key});

  @override
  State<InfoPageDetail> createState() => _InfoPageDetailState();
}

class _InfoPageDetailState extends State<InfoPageDetail> {
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
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 20 * fem, vertical: 15 * fem),
                child: Text(
                  "阿森纳全场零射正客场0-1波尔图，加莱诺读秒世界波绝杀",
                  style: tNewsTitle,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: 10 * fem, horizontal: 40 * fem),
                height: 165 * fem,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8), color: pink),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 20 * fem, vertical: 15 * fem),
                child: Text(
                  "他不再是拿亿元顶薪的全明星前锋，他不再是球队核心，甚至不再是首发球员，33岁的海沃德在加盟雷霆之后迎来了角色转变。       现在的他是雷霆的替补，是亚历山大的帮手，也是年轻球员身边的导师。海沃德已经为雷霆征战两场比赛，第-场打快艇他一分未得，第二场打奇才，他逐渐找到感觉，出战15分钟得到8分6篮板1助攻，没有失误。海沃德本赛季为黄蜂征战25场比赛都是首发出场，他场均得到14.5分4.7篮板4.6助攻，投篮命中率46.8%，三分命中率36.1%。为了得到海沃德，雷霆送出了特雷·曼恩、贝尔坦斯、米西奇和两个二轮签。显然，雷霆付出的代价不小，但是这也是为了给雷霆升级。雷霆总经理普雷斯蒂对海沃德相当重视。雷霆本赛季迎来了迅猛崛起，形成了亚历山大、杰伦·威廉姆斯、霍姆格伦的新雷霆三少模式。不过，杰伦·威廉姆斯是二年级球员，霍姆格伦是菜鸟，两人都还太年轻。一般来说，这样一支青年军最好有资深老将当导师。来到雷霆之后，海沃德俨然成为了雷霆NBA资历最老的球员之一。海沃德的职业精神无需质疑，他在大学时代就以拼劲著称，进入NBA奋斗成为了全明星球员，拿到过4年1.28亿美元顶薪合同。他还曾多次遭遇重伤，又走出伤病，属于一位励志哥。       海沃德在场下没有任何绯闻，完全是一位优质偶像。当然，现在的他过了巅峰期。雷霆引进海沃德的目的是要提升第二阵容的实力，让他当球队的第六人。如果海沃德能发挥出14+4+4的水准，雷霆就是大赚。来到雷霆之后，海沃德选择了33号球衣，他透露选择33号有两个原因，一是他已经33岁，二是因为拉里·伯德球员生涯穿33号。对于自己在雷霆的角色定位，海沃德说道:“我觉着我能为我们的团队带来帮助，帮助我们赢得比赛。对此我会非常专注并尽我所能，无论我的出场时间有多少。如果你专注于赢球，其他一切问题都会迎刃而解。雷霆现在的首发阵容很完整，亚历山大、吉迪、杰伦·威廉姆斯、多尔特和霍姆格伦本赛季状态稳定。雷霆需要提升板凳实力，他们曾经寄望欧冠MVP米西奇在替补席发威，但是后者在NBA似乎水土不服，在雷霆淡出轮换阵容，最终被送走。       雷霆替补席还有卡森·华菜士、阿降·维金斯、以赛亚·乔、肯里奇·威廉姆斯、杰林:威廉姆斯、比永博等球员，他们都是纯粹的角色球员，而海沃德可以扮演替补席的领袖，让第二阵容的战斗力实现升级。海沃德是一位经验丰富的全能前锋，如果他能完全恢复状态，那么雷霆在终结阵容里也可能会使用他。      海沃德最近几个赛季的伤病太多了，每个赛季都会因伤缺席比较长的时间。本赛季他在12月再次受伤，一直休战到全明星周末过后才复出。雷霆在他身上豪赌一把，而海沃德能提升雷霆的上限吗?本赛季西部竞争太惨烈，雷霆杀进季后赛没什么问题，但季后赛才是真正的考验。雷霆引进海沃德或许也是希望他的季后赛经验能帮助球队，毕竟他有4年征战季后赛的经历，还曾杀进过第二轮。雷霆如今战绩排名西部第二，得到海沃德使得球队冲击西部领头羊增加了一个筹码。",
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
