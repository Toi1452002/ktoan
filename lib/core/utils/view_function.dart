import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class ViewFunction {
  void showInfo(BuildContext context) {}

  void showFilter(WidgetRef ref) {}
}
