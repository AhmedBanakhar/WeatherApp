import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:climate/main.dart';
import 'package:climate/widget/no_climate_body.dart';

void main() {
  testWidgets('shows the empty state and search field on launch', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    // The initial (NoClimate) state should be visible.
    expect(find.byType(NoClimateBody), findsOneWidget);

    // The search field prompt should be present.
    expect(find.text('Search city'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });
}
