import 'package:flutter/material.dart';
import 'package:koins/strings.dart';

const gold = LinearGradient(
  colors: [
    Color(0xFFECB62B),
    Color(0xFFFFF177),
    Color(0xFFECB62B),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const silver = LinearGradient(
  colors: [
    Color(0xFF7A7A7A),
    Color(0xFFDDDDDD),
    Color(0xFF7A7A7A),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const goldText = Color(0xFFBC8801);
const silverText = Color(0xFF757575);

class KoinWidget extends StatelessWidget {
  const KoinWidget({
    super.key,
    required this.value,
    required this.onTap,
  });

  final int value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final double size;
    final String title = value > 4
        ? Strings.cent5.toUpperCase()
        : value == 1
            ? Strings.cent1.toUpperCase()
            : Strings.cent2.toUpperCase();
    switch (value) {
      case 1:
      case 10:
        size = 80;
        break;
      case 2:
      case 3:
      case 20:
      case 25:
        size = 95;
        break;
      default:
        size = 110;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: value < 10 ? silver : gold,
        ),
        child: Container(
          width: size - 8,
          height: size - 8,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border:
                Border.all(width: 2, color: value < 10 ? silverText : goldText),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value.toString(),
                  style: TextStyle(
                    fontFamily: Strings.fontFamilyFraunces,
                    color: value < 10 ? silverText : goldText,
                    fontSize: size / 2,
                    fontWeight: FontWeight.w600,
                    height: 0.95,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: Strings.fontFamilyMontserrat,
                    color: value < 10 ? silverText : goldText,
                    fontSize: 10 * size / 95,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
