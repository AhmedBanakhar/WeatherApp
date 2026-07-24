import 'package:climate/widget/climate_status_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StatusCard', () {
    testWidgets('renders title, subtitle and icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => StatusCard(
                context: context,
                title: 'Loading weather',
                subtitle: 'Fetching the latest data for your city.',
                icon: Icons.cloud_download_outlined,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Loading weather'), findsOneWidget);
      expect(
        find.text('Fetching the latest data for your city.'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.cloud_download_outlined), findsOneWidget);
      // No action provided -> no button rendered.
      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets('renders an action button that invokes the callback', (
      tester,
    ) async {
      var tapped = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => StatusCard(
                context: context,
                title: 'Something went wrong',
                subtitle: 'Please check the city name and try again.',
                icon: Icons.error_outline,
                actionLabel: 'Try again',
                action: () => tapped++,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Try again'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(tapped, 1);
    });
  });
}
