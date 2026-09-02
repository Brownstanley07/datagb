// views/main_layout.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../view/app_drawer.dart';
import '../controller/app_drawer_controller.dart';

class MainLayout extends GetView<AppDrawerController> {
  final Widget child;
  const MainLayout({super.key, required this.child});

  static const Duration _animDuration = Duration(milliseconds: 260);
  static const Curve _animCurve = Curves.easeOutCubic;

  @override
  Widget build(BuildContext context) {
    final ctrl = controller;

    return Obx(() {
      final bool isOpen = ctrl.isOpen;
      final double drawerWidth = ctrl.drawerWidth;
      final double drawerTargetX = isOpen ? 0.0 : -drawerWidth;

      return Stack(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0.w, end: 0.0.w),
            duration: _animDuration,
            curve: _animCurve,
            builder: (context, offsetX, _) {
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0.w, end: 0.0.w),
                duration: _animDuration,
                curve: _animCurve,
                builder: (context, radius, childWidget) {
                  return Transform.translate(
                    offset: Offset(offsetX, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: .circular(radius),
                        boxShadow: isOpen
                            ? [
                                BoxShadow(
                                  color: Colors.black.withAlpha(46),
                                  blurRadius: 18.w,
                                  offset: const Offset(0, 8),
                                ),
                              ]
                            : null,
                      ),
                      child: ClipRRect(
                        borderRadius: .circular(radius),
                        child: childWidget,
                      ),
                    ),
                  );
                },
                child: child,
              );
            },
          ),
          IgnorePointer(
            ignoring: !isOpen,
            child: AnimatedOpacity(
              duration: _animDuration,
              opacity: isOpen ? 1.0 : 0.0,
              child: Container(color: Colors.black.withAlpha(92)),
            ),
          ),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: -drawerWidth, end: drawerTargetX),
            duration: _animDuration,
            curve: _animCurve,
            builder: (context, dx, drawerChild) {
              return Transform.translate(
                offset: Offset(dx, 0),
                child: drawerChild,
              );
            },
            child: SizedBox(width: drawerWidth, child: const AppDrawer()),
          ),
          if (isOpen)
            Positioned(
              left: controller.drawerWidth,
              top: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: ctrl.closeDrawer,
                child: const SizedBox.shrink(),
              ),
            ),
        ],
      );
    });
  }
}
