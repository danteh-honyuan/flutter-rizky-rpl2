
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hello/routes/app_routes.dart';

class GlobalBackButton extends StatelessWidget {
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  const GlobalBackButton({
    super.key,
    required this.child,
    required this.navigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Application pages
        Positioned.fill(
          child: child,
        ),

        // Floating glass navigation bar
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),

                // Blur background
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 15,
                    sigmaY: 15,
                  ),

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 7,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(35),

                      border: Border.all(
                        color: Colors.white.withOpacity(0.35),
                        width: 1,
                      ),
                    ),

                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        // BACK BUTTON
                        _buildButton(
                          icon: Icons.arrow_back_rounded,
                          label: 'Back',
                          onTap: () {
                            final navigator =
                                navigatorKey.currentState;

                            if (navigator != null &&
                                navigator.canPop()) {
                              navigator.pop();
                            }
                          },
                        ),

                        const SizedBox(width: 8),

                        // HOME BUTTON
                        _buildButton(
                          icon: Icons.home_rounded,
                          label: 'Home',
                          onTap: () {
                            navigatorKey.currentState
                                ?.pushNamedAndRemoveUntil(
                              AppRoutes.home,
                              (route) => false,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Reusable glass button
  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 10,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Colors.black87,
                size: 23,
              ),

              const SizedBox(width: 7),

              Text(
                label,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
