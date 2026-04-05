import 'dart:async';
import 'supabase_service.dart';

class CounterService {
  static final CounterService _instance = CounterService._internal();
  factory CounterService() => _instance;
  CounterService._internal();

  final _controller = StreamController<int>.broadcast();
  int _currentCount = 1200;
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
    final count = await fetchInscriptionCount();
    if (count != _currentCount) {
      _currentCount = count;
      _controller.add(count);
    }
  }

  void dispose() {
    stop();
    _controller.close();
  }
}
