import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_siren_2/src/services/siren_apple_app_store.dart';

void main() {

  test("Apple App Store Loopup", () async {
    final response = await SirenAppleAppStore().getStoreResponse(from: 'de.divakom.biebrichbewegtapp', countryCode: 'de');

    final semverRegex = RegExp(r"^([0-9]+)\.([0-9]+)\.([0-9]+)(?:-([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?(?:\+[0-9A-Za-z-]+)?$");

    expect(response.package, "1590439332");
    expect(response.version, "2.1.0");
    expect(semverRegex.hasMatch(response.version), true);
  });
}
