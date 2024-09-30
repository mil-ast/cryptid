import 'dart:math';

class PasswordGenerator {
  static const _letter = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
  static const _number = '0123456789';
  static const _special = r'@#%^*>$@?/[]=+-()';

  static String generate({
    required int length,
    bool letter = true,
    bool isNumber = true,
    bool isSpecial = true,
  }) {
    String chars = '';
    if (letter) chars += _letter;
    if (isNumber) chars += _number;
    if (isSpecial) chars += _special;
    return List.generate(length, (index) {
      final indexRandom = Random.secure().nextInt(chars.length);
      return chars[indexRandom];
    }).join('');
  }
}
