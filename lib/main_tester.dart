import 'package:dash_run/app/app.dart';
import 'package:dash_run/bootstrap.dart';
import 'package:flutter/widgets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  bootstrap(() => const App(isTesting: true));
}
