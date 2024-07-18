import 'package:flutter/material.dart';

class ListsNavigatorService {
  final studentNavigatorKey = GlobalKey<NavigatorState>();
  final animalNavigatorKey = GlobalKey<NavigatorState>();
  final vivariumNavigatorKey = GlobalKey<NavigatorState>();

  PageController pageController = PageController();

  Future<void> navigateToStudentDetails() async {
    // we change the tab
    await pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    Future.delayed(const Duration(milliseconds: 400), () {
      studentNavigatorKey.currentState!.pushNamed('/details');
    });
  }

  Future<void> navigateToAnimalDetails() async {
    // we change the tab
    await pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    Future.delayed(const Duration(milliseconds: 400), () {
      animalNavigatorKey.currentState!.pushNamed('/details');
    });
  }

  Future<void> navigateToVivariumDetails() async {
    // we change the tab
    await pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    Future.delayed(const Duration(milliseconds: 400), () {
      vivariumNavigatorKey.currentState!.pushNamed('/details');
    });
  }
}
