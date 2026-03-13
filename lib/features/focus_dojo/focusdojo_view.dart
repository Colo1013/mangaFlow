import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangaflow/features/focus_dojo/widgets/exp_pill.dart';
import 'package:mangaflow/features/focus_dojo/widgets/focus_ring_painter.dart';
import 'package:mangaflow/theme/app_sizes.dart';

class FocusdojoView extends ConsumerStatefulWidget {
  const FocusdojoView({super.key});

  @override
  ConsumerState<FocusdojoView> createState() => _FocusdojoViewState();
}

class _FocusdojoViewState extends ConsumerState<FocusdojoView> {
  Duration durata = Duration();
  static const Duration durataMax = Duration(hours: 1);
  final _ringKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final appSizes = Theme.of(context).extension<AppSizeExtension>()!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            ExpPill(
              data: ExpMockData(
                grado: "Novizio",
                expAttuali: 150,
                expTotali: 300,
                coloreSfondo: Colors.blue,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GestureDetector(
                onPanUpdate: (details) {
                  final size =
                      (_ringKey.currentContext!.findRenderObject() as RenderBox)
                          .size;
                  final dx = details.localPosition.dx - size.width / 2;
                  final dy = details.localPosition.dy - size.height / 2;
                  final angolo = atan2(dy, dx);
                  final progressione = (angolo + pi / 2) % (2 * pi) / (2 * pi);
                  setState(() {
                    final minuti = (durataMax.inSeconds * progressione / 60)
                        .round();
                    durata = Duration(minutes: minuti);
                  });
                  print(
                    "${details.localPosition} ; ${size}; progressione ${progressione}",
                  );
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      key: _ringKey,
                      aspectRatio: 1,
                      child: CustomPaint(
                        painter: FocusRingPainter(
                          progressione: durata.inSeconds / durataMax.inSeconds,
                        ),
                      ),
                    ),

                    Text(
                      durata.inMinutes == 0
                          ? "∞"
                          : "${durata.inMinutes} : ${durata.inSeconds % 60}",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
