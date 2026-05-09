import 'package:bz_map/bz_map.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('latlng clamps latitude and wraps longitude', () {
    const point = LatLng(100, 181);
    expect(point.latitude, 90);
    expect(point.longitude, -179);
  });

  test('api key serialization keeps non-null values', () {
    const apiKey = AMapApiKey(androidKey: 'android', iosKey: 'ios');
    expect(apiKey.toMap(), {
      'androidKey': 'android',
      'iosKey': 'ios',
    });
  });
}
