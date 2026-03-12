import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mangaflow/theme/app_sizes.dart';

class ExpMockData {
  final String grado;
  final int expAttuali;
  final int expTotali;
  final Color coloreSfondo;

  const ExpMockData({
    required this.grado,
    required this.expAttuali,
    required this.expTotali,
    required this.coloreSfondo,
  });
}

class ExpPill extends StatelessWidget {
  final ExpMockData data;
  const ExpPill({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final appSizes = Theme.of(context).extension<AppSizeExtension>()!;
    return Center(
      child: SafeArea(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(appSizes.smallradius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: appSizes.small,
                vertical: appSizes.medium,
              ),
              color: data.coloreSfondo.withValues(alpha: 0.2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: appSizes.medium,
                children: [
                  Text("${data.expAttuali} / ${data.expTotali}"),
                  Icon(Icons.circle, size: appSizes.small),
                  Text(data.grado),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
