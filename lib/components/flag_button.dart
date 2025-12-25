import 'package:flag/flag.dart';
import 'package:flutter/material.dart';

class FlagButton extends StatelessWidget {
  final String langFlag;
  final String langCode;
  final bool isSelected;
  final VoidCallback? onPressed;

  const FlagButton({
    super.key,
    required this.langFlag,
    required this.langCode,
    required this.isSelected,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(
                  color: Theme.of(context).colorScheme.tertiary,
                  width: 2.0,
                )
              : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: IconButton(
          icon: Flag.fromString(
            langFlag,
            height: 44,
            width: 66,
            fit: BoxFit.fill,
          ),
          onPressed:
              onPressed ??
              () {
                print('$langCode flag pressed - no handler');
              },
          tooltip: '$langCode ${isSelected ? '(Selected)' : ''}',
        ),
      ),
    );
  }
}
