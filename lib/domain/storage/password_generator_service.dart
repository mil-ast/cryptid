import 'dart:math';

class PasswordGenerator {
  static const _letter = "abcdefghijklmnopqrstuvwxyz";
  static const _letterUpper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  static const _number = '0123456789';
  static const _special = r'@#%^*>$@?/[]=+-()';

  static String generate({
    required int length,
    bool letterLower = true,
    bool letterUpper = true,
    bool isNumber = true,
    bool isSpecial = true,
  }) {
    String chars = '';
    if (letterLower) chars += _letter;
    if (letterUpper) chars += _letterUpper;
    if (isNumber) chars += _number;
    if (isSpecial) chars += _special;
    if (chars.isEmpty) {
      return '👅';
    }
    return List.generate(length, (index) {
      final indexRandom = Random.secure().nextInt(chars.length);
      return chars[indexRandom];
    }).join('');
  }
}
