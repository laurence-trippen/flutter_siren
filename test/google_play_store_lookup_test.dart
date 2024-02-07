import 'package:flutter_siren_2/src/services/siren_google_play_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  test("Google Play Store Lookup Test", () async {
    final response = await SirenGooglePlayStore().getStoreResponse(from: "de.divakom.biebrichbewegtapp", countryCode: "en");

    final semverRegex = RegExp(r"^([0-9]+)\.([0-9]+)\.([0-9]+)(?:-([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?(?:\+[0-9A-Za-z-]+)?$");

    expect(response.package, "de.divakom.biebrichbewegtapp");
    expect(response.version, "2.1.0");
    expect(semverRegex.hasMatch(response.version), true);
  });
}
