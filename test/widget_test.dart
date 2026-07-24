// App-level smoke tests for the weather app.
//
// These verify that the app boots into its empty state and exposes the
// city search field.

import 'package:climate/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app boots into the empty state with a search field', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    // App title in the AppBar.
    expect(find.text('Weather'), findsOneWidget);

    // Empty-state prompt from NoClimateBody.
    expect(find.text('Ready when you are'), findsOneWidget);

    // Search field is present and accepts input.
    final searchField = find.byType(TextField);
    expect(searchField, findsOneWidget);

    await tester.enterText(searchField, 'London');
    expect(find.text('London'), findsOneWidget);
  });
}