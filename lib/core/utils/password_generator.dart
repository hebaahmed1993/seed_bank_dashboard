import 'dart:math';

class PasswordGenerator {
  PasswordGenerator._(); // منع إنشاء نسخة من الكلاس

  static String generate({int length = 10}) {
    const String upperCase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String lowerCase = 'abcdefghijklmnopqrstuvwxyz';
    const String numbers = '0123456789';
    const String symbols = '!@#\$%&*';

    const String allChars = upperCase + lowerCase + numbers + symbols;
    final Random random = Random.secure();

    // ضمان وجود حرف من كل نوع على الأقل
    String password = '';
    password += upperCase[random.nextInt(upperCase.length)];
    password += lowerCase[random.nextInt(lowerCase.length)];
    password += numbers[random.nextInt(numbers.length)];
    password += symbols[random.nextInt(symbols.length)];

    // إكمال باقي الطول عشوائياً
    for (int i = 4; i < length; i++) {
      password += allChars[random.nextInt(allChars.length)];
    }

    // خلط الحروف لكي لا يكون النمط متوقعاً
    List<String> chars = password.split('');
    chars.shuffle(random);
    return chars.join();
  }
}