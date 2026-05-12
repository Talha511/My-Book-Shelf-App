import 'package:book_library_pro/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {

    await tester.pumpWidget(
      const ProviderScope(
        child: MyBookShelfApp(),
      ),
    );

    expect(find.byType(MyBookShelfApp), findsOneWidget);
  });
}