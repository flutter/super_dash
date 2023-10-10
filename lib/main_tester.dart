import 'package:dash_run/app/app.dart';
import 'package:dash_run/bootstrap.dart';

void main() {
  bootstrap(() => const App(isTesting: true));
}
