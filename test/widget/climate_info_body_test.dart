import 'package:climate/model/climate_model.dart';
import 'package:climate/widget/climate_info_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget wrap(ClimateModel model) =>
    MaterialApp(home: Scaffold(body: ClimateInfoBody(climateModel: model)));

/// [ClimateInfoBody] renders an [Image.network]. In the test environment the
/// binding returns HTTP 400 for every request, so the image fails to load and
/// records a [NetworkImageLoadException]. That is expected and unrelated to
/// what these tests verify, so we consume it here.
Future<void> pumpBody(WidgetTester tester, ClimateModel model) async {
  await tester.pumpWidget(wrap(model));
  await tester.pump();
  tester.takeException();
}

void main() {
  group('ClimateInfoBody', () {
    testWidgets('shows city, condition and rounded temperatures', (
      tester,
    ) async {
      final model = ClimateModel(
        city: 'Madrid',
        date: DateTime(2024, 6, 1, 14, 5),
        iconUrl: '//cdn/icon.png',
        temperature: 23.6,
        maxTemperature: 27.4,
        minTemperature: 18.2,
        weatherCondition: 'Partly cloudy',
      );

      await pumpBody(tester, model);

      expect(find.text('Madrid'), findsOneWidget);
      expect(find.text('Partly cloudy'), findsOneWidget);
      expect(find.text('24°C'), findsOneWidget); // 23.6 rounded
      expect(find.text('27°C'), findsOneWidget); // max
      expect(find.text('18°C'), findsOneWidget); // min
      expect(find.text('Max'), findsOneWidget);
      expect(find.text('Min'), findsOneWidget);
    });

    testWidgets('formats afternoon time as 12-hour PM', (tester) async {
      final model = ClimateModel(
        city: 'Madrid',
        date: DateTime(2024, 6, 1, 14, 5),
        iconUrl: '//cdn/icon.png',
        temperature: 20.0,
        maxTemperature: 22.0,
        minTemperature: 18.0,
        weatherCondition: 'Sunny',
      );

      await pumpBody(tester, model);

      expect(find.text('Updated at 02:05 PM'), findsOneWidget);
    });

    testWidgets('formats midnight as 12 AM', (tester) async {
      final model = ClimateModel(
        city: 'Madrid',
        date: DateTime(2024, 6, 1, 0, 30),
        iconUrl: '//cdn/icon.png',
        temperature: 20.0,
        maxTemperature: 22.0,
        minTemperature: 18.0,
        weatherCondition: 'Clear',
      );

      await pumpBody(tester, model);

      expect(find.text('Updated at 12:30 AM'), findsOneWidget);
    });
  });
}
