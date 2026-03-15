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
    final progressione = data.expAttuali / data.expTotali;

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(color: Colors.white.withValues(alpha: 0.15)),
              ),
            ),
            Positioned.fill(
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progressione,
                child: Container(
                  foregroundDecoration: BoxDecoration(
                    color: data.coloreSfondo.withValues(alpha: 0.9),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                      width: 4,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: appSizes.medium,
                vertical: appSizes.small,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: appSizes.small,
                children: [
                  Text(data.grado),
                  Text("•"),
                  Text("${data.expAttuali}/${data.expTotali} EXP"),
                ],
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    width: 4,
                    color: Colors.white.withValues(alpha: 0.30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
