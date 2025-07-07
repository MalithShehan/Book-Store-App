import 'package:flutter/material.dart';
import 'package:flutter_app/common/color.extention.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  int page = 0;
  final PageController controller = PageController();

  final List<Map<String, String>> pageArr = [
    {
      "title": "Discounted\nSecondhand Books",
      "sub_title": "Used and near new Secondhand books at great prices.",
      "img": "assets/image/on_1.png"
    },
    {
      "title": "20 Book Grocers\nNationally",
      "sub_title": "We've successfully opened 20 stores across Australia.",
      "img": "assets/image/on_2.png"
    },
    {
      "title": "Sell or Recycle Your Old\nBooks With Us",
      "sub_title":
          "If you're looking to downsize, sell or recycle old books, the Book Grocer can help.",
      "img": "assets/image/on_3.png"
    },
  ];

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        page = controller.page?.round() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final double baseHeight = 812.0; // iPhone 11 Pro height
    final double scale = media.height / baseHeight;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: controller,
              itemCount: pageArr.length,
              itemBuilder: (context, index) {
                final pObj = pageArr[index];
                return Container(
                  width: media.width,
                  padding: EdgeInsets.symmetric(
                    horizontal: 15 * scale,
                    vertical: 50 * scale,
                  ),
                  child: Column(
                    children: [
                      // Title
                      Text(
                        pObj["title"]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Tcolor.primary,
                          fontSize: 32 * scale,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 15 * scale),

                      // Subtitle
                      Text(
                        pObj["sub_title"]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Tcolor.primartLight,
                          fontSize: 14 * scale,
                        ),
                      ),
                      SizedBox(height: media.height * 0.06),

                      // Image
                      Image.asset(
                        pObj["img"]!,
                        width: media.width * 0.75,
                        height: media.width * 0.75,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                );
              },
            ),

            // Page Indicator
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: media.height * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: pageArr.asMap().entries.map((entry) {
                    int index = entry.key;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: page == index ? 16 * scale : 12 * scale,
                      height: page == index ? 16 * scale : 12 * scale,
                      decoration: BoxDecoration(
                        color: page == index
                            ? Tcolor.primary
                            : Tcolor.primartLight,
                        shape: BoxShape.circle,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
