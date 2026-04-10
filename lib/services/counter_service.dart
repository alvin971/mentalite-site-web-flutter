import 'dart:async';
import 'supabase_service.dart';

class CounterService {
  static final CounterService _instance = CounterService._internal();
  factory CounterService() => _instance;
  CounterService._internal();

  final _controller = StreamController<int>.broadcast();
  static const _offset = 858; // Offset d'affichage — 0 inscrit réel = 859 affiché
  static const _max = 10000;
  int _currentCount = 859;
  Timer? _timer;

  Stream<int> get stream => _controller.stream;
  int get currentCount => _currentCount;

  void start() {
    _fetch();
    _timer ??= Timer.periodic(const Duration(seconds: 5), (_) => _fetch());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _fetch() async {
    final real = await fetchInscriptionCount();
    final displayed = real + _offset; // Pas de plafond — affiche la sursouscription
    if (displayed != _currentCount) {
      _currentCount = displayed;
      _controller.add(displayed);
    }
  }

  void dispose() {
    stop();
    _controller.close();
  }
}
