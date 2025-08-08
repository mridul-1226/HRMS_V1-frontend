import 'package:flutter/material.dart';
import 'package:hrms/core/config/color_cofig.dart';
import 'package:hrms/core/config/text_config.dart';
import 'package:oktoast/oktoast.dart';

class Toast {
  static void show({
    required String message,
    bool isError = false,
    bool isWarning = false,
    ToastPosition? position,
  }) {
    showToastWidget(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.black,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isWarning
                ? const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.warning,
                  size: 20,
                )
                : Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.5,
                      color: isError ? AppColors.error : AppColors.success,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child:
                      isError
                          ? const Icon(
                            Icons.close,
                            color: AppColors.error,
                            size: 16,
                          )
                          : const Icon(
                            Icons.check,
                            color: AppColors.success,
                            size: 16,
                          ),
                ),
            const SizedBox(width: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 200),
              child: Text(
                message.replaceAll('Exception: ', ''),
                style: AppTypography.caption(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      dismissOtherToast: true,
      position: position ?? ToastPosition.bottom,
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 300),
      animationCurve: Curves.easeInOut,
      handleTouch: true,
    );
  }
}
