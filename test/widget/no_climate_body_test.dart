import 'package:climate/widget/no_climate_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('NoClimateBody shows the empty-state prompt', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: NoClimateBody())),
    );

    expect(find.text('Ready when you are'), findsOneWidget);
    expect(
      find.text('Start typing a city name above to see today’s weather.'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.cloud_outlined), findsOneWidget);
  });
}
