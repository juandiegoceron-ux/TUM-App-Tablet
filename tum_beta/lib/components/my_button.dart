import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final Widget? trailingIcon;
  final EdgeInsetsGeometry? padding;

  const MyButton({
    super.key,
    required this.onTap,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.trailingIcon,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.black,
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: 8),
                trailingIcon!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}