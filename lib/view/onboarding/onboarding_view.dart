import 'package:flutter/material.dart';
import 'package:flutter_app/common/color.extention.dart';
import 'package:flutter_app/view/onboarding/welcome_view.dart';

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
      "img": "assets/image/on_1.png",
    },
    {
      "title": "20 Book Grocers\nNationally",
      "sub_title": "We've successfully opened 20 stores across Australia.",
      "img": "assets/image/on_2.png",
    },
    {
      "title": "Sell or Recycle Your Old\nBooks With Us",
      "sub_title":
          "If you're looking to downsize, sell or recycle old books, the Book Grocer can help.",
      "img": "assets/image/on_3.png",
    },
  ];

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (mounted) {
        setState(() {
          page = controller.page?.round() ?? 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final double scale = media.height / 812; // base height for scaling

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // PageView for onboarding pages
            PageView.builder(
              controller: controller,
              itemCount: pageArr.length,
              itemBuilder: (context, index) {
                final pObj = pageArr[index];
                return Container(
                  width: media.width,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16 * scale,
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
                      SizedBox(height: media.height * 0.08),

                      // Image
                      Image.asset(
                        pObj["img"]!,
                        width: media.width * 0.8,
                        height: media.width * 0.8,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                );
              },
            ),

            // Page indicator and navigation controls
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16 * scale),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Skip Button
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const WelcomeView(),
                            ),
                          );
                        },
                        child: Text(
                          "Skip",
                          style: TextStyle(
                            color: Tcolor.primary,
                            fontSize: 16 * scale,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      // Page Indicators
                      Row(
                        children: List.generate(pageArr.length, (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: page == index ? 16 : 12,
                            height: page == index ? 16 : 12,
                            decoration: BoxDecoration(
                              color: page == index
                                  ? Tcolor.primary
                                  : Tcolor.primartLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          );
                        }),
                      ),

                      // Next Button
                      TextButton(
                        onPressed: () {
                          if (page < pageArr.length - 1) {
                            controller.animateToPage(
                              page + 1,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const WelcomeView(),
                              ),
                            );
                          }
                        },
                        child: Text(
                          "Next",
                          style: TextStyle(
                            color: Tcolor.primary,
                            fontSize: 16 * scale,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: media.height * 0.05),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
