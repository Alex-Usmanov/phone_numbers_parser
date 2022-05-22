import 'package:phone_number_metadata/phone_number_metadata.dart';

abstract class InternationalPrefixParser {
  /// remove the international prefix of a phone number if present.
  ///
  ///  It expects a normalized [phoneNumber] without the country calling code.
  ///  if phone starts with + it is removed
  ///  if starts with 00 or 011
  ///  we consider those as internationalPrefix as
  ///  they cover 4/5 of the international prefix
  static String removeInternationalPrefix(
    String phoneNumber, {
    String countryCode = '',
    PhoneMetadata? metadata,
  }) {
    if (phoneNumber.startsWith('+')) {
      return phoneNumber.substring(1);
    }

    if (metadata != null) {
      return _removeInternationalPrefixWithMetadata(
        phoneNumber,
        metadata,
        countryCode,
      );
    }
    // 4/5 of the world wide numbers start with 00 or 011
    // if a country code does not follow the international prefix
    // then we can assume it is not an international prefix
    if (phoneNumber.startsWith('00$countryCode')) {
      return phoneNumber.substring(2);
    }

    if (phoneNumber.startsWith('011$countryCode')) {
      return phoneNumber.substring(3);
    }

    return phoneNumber;
  }

  static String _removeInternationalPrefixWithMetadata(
    String phoneNumber,
    PhoneMetadata metadata,
    String countryCode,
  ) {
    final match =
        RegExp(metadata.internationalPrefix).matchAsPrefix(phoneNumber);
    if (match != null) {
      return phoneNumber.substring(match.end);
    }
    // if it does not start with the international prefix from the
    // country we assume the prefix is not present
    return phoneNumber;
  }
}
