import 'package:mangaflow/data/models/profile_repository.dart';
import 'package:mangaflow/data/models/session_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'dart:async';
import 'dart:io';
import 'package:mangaflow/data/models/session.dart';

part 'focus_session.g.dart';

enum StatoSchermo { idle, attesa, attiva, pausa }

@riverpod
class FocusSessionNotifier extends _$FocusSessionNotifier {
  final _profileRepo = ProfileRepository();
  final _sessionRepo = SessionRepository();

  int? _startTimestamp;
  int _tempoAccumulato = 0;
  int? _pausaInizio;
  Duration? _durataObiettivo;
  StreamSubscription? _accelerometroSub;
  StreamSubscription? _proximitySub;

  @override
  StatoSchermo build() => StatoSchermo.idle;

  void avviaSessione({Duration? durata}) {
    _durataObiettivo = durata;
    _startTimestamp = DateTime.now().millisecondsSinceEpoch;
    _tempoAccumulato = 0;
    state = StatoSchermo.attesa;
    _avviaSensori();
  }

  void mettiInPausa() {
    if (state != StatoSchermo.attiva) return;
    _pausaInizio = DateTime.now().millisecondsSinceEpoch;
    state = StatoSchermo.pausa;
  }

  void riprendi() {
    if (state != StatoSchermo.pausa) return;
    if (_pausaInizio != null) {
      _tempoAccumulato += DateTime.now().millisecondsSinceEpoch - _pausaInizio!;
      _pausaInizio = null;
    }
    state = StatoSchermo.attiva;
  }

  Future<void> terminaSessione(int mangaId) async {
    _fermaSensori();
    final end = DateTime.now().millisecondsSinceEpoch;
    final durataEffettiva = (end - _startTimestamp!) - _tempoAccumulato;

    double expGuadagnati = durataEffettiva / 60000;
    if (_durataObiettivo != null) {
      if (_durataObiettivo!.inMilliseconds <= durataEffettiva) {
        expGuadagnati += expGuadagnati * 0.10;
      } else {
        expGuadagnati -= expGuadagnati * 0.10;
      }
    }
    final expFinale = expGuadagnati.floor();

    await _sessionRepo.insert(
      Session(
        startTimestamp: _startTimestamp!,
        endTimestamp: end,
        mangaId: mangaId,
        expGained: expFinale,
      ),
    );

    await _profileRepo.addExp(expFinale);

    _startTimestamp = null;
    _tempoAccumulato = 0;
    _durataObiettivo = null;
    state = StatoSchermo.idle;
  }

  void _avviaSensori() {
    if (Platform.isWindows || Platform.isLinux) return;

    _accelerometroSub =
        accelerometerEventStream(
          samplingPeriod: const Duration(seconds: 5),
        ).listen((evento) {
          final bool facciaInGiu = evento.z < -7.0;
          if (facciaInGiu && state == StatoSchermo.attesa) {
            state = StatoSchermo.attiva;
          } else if (!facciaInGiu && state == StatoSchermo.attiva) {
            mettiInPausa();
          } else if (facciaInGiu && state == StatoSchermo.pausa) {
            riprendi();
          }
        });

    _proximitySub = ProximitySensor.events.listen((evento) {
      final bool vicino = evento > 0;
      if (vicino && state == StatoSchermo.attesa) {
        state = StatoSchermo.attiva;
      } else if (!vicino && state == StatoSchermo.attiva) {
        mettiInPausa();
      }
    });
  }

  void _fermaSensori() {
    _accelerometroSub?.cancel();
    _proximitySub?.cancel();
    _accelerometroSub = null;
    _proximitySub = null;
  }

  void annullaSessione() {
    _fermaSensori();
    _startTimestamp = null;
    _tempoAccumulato = 0;
    _durataObiettivo = null;
    state = StatoSchermo.idle;
  }
}
