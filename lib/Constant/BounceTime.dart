import 'dart:async';

import 'dart:ui';

class BounceTime {
  final int milliseconds;
  Timer? _timer;

  BounceTime({required this.milliseconds});

  run(VoidCallback action) {
    _timer?.cancel();

    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
