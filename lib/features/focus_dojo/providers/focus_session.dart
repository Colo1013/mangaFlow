import 'package:flutter/services.dart';
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
  String? _mangaId;
  Duration? _tempoRimanente;
  Timer? _timer;
  SessionResult? ultimaSessione;

  @override
  StatoSchermo build() => StatoSchermo.idle;

  void avviaSessione({required String mangaId, Duration? durata}) {
    _mangaId = mangaId;
    _durataObiettivo = durata;
    _startTimestamp = DateTime.now().millisecondsSinceEpoch;
    _tempoAccumulato = 0;
    _tempoRimanente = durata;
    state = StatoSchermo.attesa;
    _avviaSensori();

    if (durata != null) {
      _timer = Timer(durata, () => terminaSessione());
    }
  }

  void mettiInPausa() {
    if (state != StatoSchermo.attiva) return;

    _timer?.cancel();

    if (_durataObiettivo != null) {
      final ora = DateTime.now().millisecondsSinceEpoch;
      final tempoConsumato = (ora - _startTimestamp!) - _tempoAccumulato;
      _tempoRimanente =
          _durataObiettivo! - Duration(milliseconds: tempoConsumato);
    }

    _pausaInizio = DateTime.now().millisecondsSinceEpoch;
    state = StatoSchermo.pausa;
  }

  void riprendi() {
    if (state != StatoSchermo.pausa) return;

    if (_pausaInizio != null) {
      _tempoAccumulato += DateTime.now().millisecondsSinceEpoch - _pausaInizio!;
      _pausaInizio = null;
    }

    if (_tempoRimanente != null) {
      _timer = Timer(_tempoRimanente!, () => terminaSessione());
    }

    state = StatoSchermo.attiva;
  }

  Future<void> terminaSessione() async {
    HapticFeedback.heavyImpact();
    _timer?.cancel();
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
        mangaId: _mangaId!,
        expGained: expFinale,
      ),
    );

    await _profileRepo.addExp(expFinale);

    ultimaSessione = SessionResult(
      expGuadagnati: expFinale,
      durataEffettiva: Duration(milliseconds: durataEffettiva),
      mangaId: _mangaId!,
    );

    _startTimestamp = null;
    _tempoAccumulato = 0;
    _durataObiettivo = null;
    _tempoRimanente = null;
    _mangaId = null;
    _pausaInizio = null;
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

class SessionResult {
  final int expGuadagnati;
  final String mangaId;
  final Duration durataEffettiva;

  SessionResult({
    required this.expGuadagnati,
    required this.mangaId,
    required this.durataEffettiva,
  });

  Future<List<Session>> sessionList(Ref ref) async {
    return await SessionRepository().getAll();
  }

  int calcolaStreak(List<Session> sessioni) {
    if (sessioni.isEmpty) return 0;

    // Estrai i giorni unici in ordine decrescente
    final giorniUnici =
        sessioni
            .map((s) => DateTime.fromMillisecondsSinceEpoch(s.startTimestamp))
            .map(
              (d) => DateTime(d.year, d.month, d.day),
            ) // azzera ore/minuti/secondi
            .toSet() // rimuovi duplicati stesso giorno
            .toList()
          ..sort((a, b) => b.compareTo(a)); // ordine decrescente

    int streak = 1;
    for (int i = 0; i < giorniUnici.length - 1; i++) {
      final differenza = giorniUnici[i].difference(giorniUnici[i + 1]).inDays;
      if (differenza == 1) {
        streak++;
      } else {
        break; // streak interrotta
      }
    }
    return streak;
  }
}
