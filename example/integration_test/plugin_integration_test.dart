import 'package:flutter_test/flutter_test.dart';
import 'package:cool_ui/cool_ui.dart';
import 'package:cool_ui_example/main.dart' as app;

void main() {
  testWidgets('Cool UI widgets render correctly', (WidgetTester tester) async {
    // Build the app
    app.main();
    await tester.pumpAndSettle();

    // Verify that widgets are rendered
    expect(find.byType(CoolButton), findsWidgets);
    expect(find.byType(CoolCard), findsWidgets);
  });
}
