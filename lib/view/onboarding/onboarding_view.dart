import 'package:flutter/material.dart';
import 'package:flutter_app/common/color.extention.dart'; 

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  int page = 0;
  PageController controller = PageController();

  // Page data
  List<Map<String, String>> pageArr = [
    {
      "title": "Discounted\nSecondhand Books",
      "sub_title": "Used and near new Secondhand books at great prices.",
      "img": "assets/image/on_1.png" // Correct path
    },
    {
      "title": "20 Book Grocers\nNationally",
      "sub_title": "We've successfully opened 20 stores across Australia.",
      "img": "assets/image/on_2.png" // Correct path
    },
    {
      "title": "Sell or Recycle Your Old\nBooks With Us",
      "sub_title":
          "If you're looking to downsize, sell or recycle old books, the Book Grocer can help.",
      "img": "assets/image/on_3.png" // Correct path
    },
  ];

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      page = controller.page?.round() ?? 0;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: controller,
              itemCount: pageArr.length,
              itemBuilder: (context, index) {
                var pObj = pageArr[index];
                return Container(
                  width: media.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
                  child: Column(
                    children: [
                      // Title
                      Text(
                        pObj["title"]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Tcolor.primary,
                          fontSize: 38,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Subtitle
                      Text(
                        pObj["sub_title"]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Tcolor.primartLight,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: media.width * 0.2,
                      ),

                      // Image
                      Image.asset(
                        pObj["img"]!, // Correct key
                        width: media.width * 0.8,
                        height: media.width * 0.8,
                        fit: BoxFit.fitWidth,
                      ),
                    ],
                  ),
                );
              },
            ),

            // Page Indicator
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: pageArr.map((pObj) {
                    var index = pageArr.indexOf(pObj);
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        color: page == index
                            ? Tcolor.primary
                            : Tcolor.primartLight,
                        borderRadius: BorderRadius.circular(7.5),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: media.width * 0.15,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}