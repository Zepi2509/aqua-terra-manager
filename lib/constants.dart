import 'dart:math';

class SizeConstants {
  SizeConstants._();

  static const _base = 25.0;
  static const _goldenRatio = 1.618;

  static final s100 = _base / pow(_goldenRatio, 4);
  static final s200 = _base / pow(_goldenRatio, 3);
  static final s300 = _base / pow(_goldenRatio, 2);
  static final s400 = _base / pow(_goldenRatio, 1);
  static const s500 = _base;
  static final s600 = _base * pow(_goldenRatio, 1);
  static final s700 = _base * pow(_goldenRatio, 2);
  static final s800 = _base * pow(_goldenRatio, 3);
  static final s900 = _base * pow(_goldenRatio, 4);
}

class FontConstants {
  FontConstants._();

  static const _sBase = 16.0;
  static const _goldenRatio = 1.618;

  static final s100 = _sBase / pow(_goldenRatio, 4);
  static final s200 = _sBase / pow(_goldenRatio, 3);
  static final s300 = _sBase / pow(_goldenRatio, 2);
  static final s400 = _sBase / pow(_goldenRatio, 1);
  static const s500 = _sBase;
  static final s600 = _sBase * pow(_goldenRatio, 1);
  static final s700 = _sBase * pow(_goldenRatio, 2);
  static final s800 = _sBase * pow(_goldenRatio, 3);
  static final s900 = _sBase * pow(_goldenRatio, 4);
}
