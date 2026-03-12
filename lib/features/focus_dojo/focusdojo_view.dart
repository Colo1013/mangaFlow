import 'package:flutter/material.dart';
import 'package:mangaflow/features/focus_dojo/widgets/exp_pill.dart';
import 'package:mangaflow/features/focus_dojo/widgets/focus_ring_painter.dart';
import 'package:mangaflow/theme/app_sizes.dart';

class FocusdojoView extends StatelessWidget {
  const FocusdojoView({super.key});

  @override
  Widget build(BuildContext context) {
    final appSizes = Theme.of(context).extension<AppSizeExtension>()!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: appSizes.small),
              child: ExpPill(
                data: ExpMockData(
                  grado: "Novizio",
                  expAttuali: 150,
                  expTotali: 300,
                  coloreSfondo: Colors.blue,
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 300,
                width: 200,
                child: CustomPaint(painter: FocusRingPainter()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
