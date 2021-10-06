import 'package:flutter_test/flutter_test.dart';
import 'package:gesture_recorder/gesture_recorder.dart';
import 'package:integration_test/integration_test.dart';
import 'package:simple_scroll/main.dart' as app;

import '../build/record_gesture.dart';

Future<void> main() async {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding;
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  testWidgets('E2E test with recorded input', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await replayRecord(tester, record_gesture);
    await tester.pumpAndSettle();
  }, semanticsEnabled: false);
}
