import 'package:flutter/material.dart';
import 'package:shop_app/layouts/shop_layout.dart';
import 'package:shop_app/modules/auth/login_screen.dart';
import 'package:shop_app/modules/splash/sliding_text.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> slidingAnimation;
  @override
  void initState() {
    super.initState();
    initSlidingAnimation();
    navigateToScreen();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset('assets/images/onboard_1.jpg'),
            const SizedBox(
              height: 5.0,
            ),
            SlidingText(slidingAnimation: slidingAnimation),
          ],
        ),
      ),
    );
  }

  void navigateToScreen() {
    var token = CacheHelper.sharedPreferences?.getString("token");
    Future.delayed(const Duration(seconds: 2), () {
      if (token == null || token == 'null') {
        navigateAndFinish(context, const LoginScreen());
      } else {
        navigateAndFinish(context, const ShopLayout());
      }
    });
  }

  void initSlidingAnimation() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    slidingAnimation =
        Tween<Offset>(begin: const Offset(0, 2), end: Offset.zero)
            .animate(animationController);
    animationController.forward();
  }
}
