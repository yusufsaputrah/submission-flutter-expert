import 'package:about/presentation/pages/about_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AboutPage should display logo and description text', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: AboutPage(),
    ));

    final imageFinder = find.byType(Image);
    final textFinder = find.textContaining('Ditonton merupakan sebuah aplikasi katalog film');

    expect(imageFinder, findsOneWidget);
    expect(textFinder, findsOneWidget);
  });

  testWidgets('AboutPage back button should pop the navigator', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
              child: const Text('Go to About'),
            );
          },
        ),
      ),
    ));

    await tester.tap(find.text('Go to About'));
    await tester.pumpAndSettle();

    expect(find.byType(AboutPage), findsOneWidget);

    final backButtonFinder = find.byIcon(Icons.arrow_back);
    expect(backButtonFinder, findsOneWidget);

    await tester.tap(backButtonFinder);
    await tester.pumpAndSettle();

    expect(find.byType(AboutPage), findsNothing);
  });
}
