import 'package:climate/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const fallback = Colors.teal;

  group('getThemeColor', () {
    test('returns the fallback color when condition is null', () {
      expect(getThemeColor(null, fallback), fallback);
    });

    test('returns the fallback color when condition is empty', () {
      expect(getThemeColor('', fallback), fallback);
    });

    test('returns the fallback color for an unknown condition', () {
      expect(getThemeColor('Raining frogs', fallback), fallback);
    });

    test('maps sunny/clear conditions to orange', () {
      expect(getThemeColor('Sunny', fallback), Colors.orange);
      expect(getThemeColor('Clear', fallback), Colors.orange);
    });

    test('maps partly cloudy to amber', () {
      expect(getThemeColor('Partly cloudy', fallback), Colors.amber);
    });

    test('maps cloudy/overcast to blueGrey', () {
      expect(getThemeColor('Cloudy', fallback), Colors.blueGrey);
      expect(getThemeColor('Overcast', fallback), Colors.blueGrey);
    });

    test('maps mist/fog conditions to grey', () {
      expect(getThemeColor('Mist', fallback), Colors.grey);
      expect(getThemeColor('Fog', fallback), Colors.grey);
      expect(getThemeColor('Freezing fog', fallback), Colors.grey);
    });

    test('maps light rain conditions to lightBlue', () {
      expect(getThemeColor('Light rain', fallback), Colors.lightBlue);
      expect(getThemeColor('Patchy rain possible', fallback), Colors.lightBlue);
      expect(getThemeColor('Light rain shower', fallback), Colors.lightBlue);
    });

    test('maps heavy rain conditions to indigo', () {
      expect(getThemeColor('Heavy rain', fallback), Colors.indigo);
      expect(getThemeColor('Moderate rain', fallback), Colors.indigo);
      expect(
        getThemeColor('Torrential rain shower', fallback),
        Colors.indigo,
      );
    });

    test('maps snow conditions to lightBlue', () {
      expect(getThemeColor('Light snow', fallback), Colors.lightBlue);
      expect(getThemeColor('Blizzard', fallback), Colors.lightBlue);
      expect(getThemeColor('Heavy snow', fallback), Colors.lightBlue);
    });

    test('maps sleet/ice conditions to cyan', () {
      expect(getThemeColor('Light sleet', fallback), Colors.cyan);
      expect(getThemeColor('Ice pellets', fallback), Colors.cyan);
      expect(
        getThemeColor('Moderate or heavy freezing rain', fallback),
        Colors.cyan,
      );
    });

    test('maps thunder conditions to deepPurple', () {
      expect(
        getThemeColor('Thundery outbreaks possible', fallback),
        Colors.deepPurple,
      );
      expect(
        getThemeColor('Moderate or heavy rain with thunder', fallback),
        Colors.deepPurple,
      );
    });
  });
}
