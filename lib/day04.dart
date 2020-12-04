import 'package:aoc2020/structures.dart';

final FIELDS = {
  'byr',
  'iyr',
  'eyr',
  'hgt',
  'hcl',
  'ecl',
  'pid',
  // 'cid',
};

var hgtReg = RegExp(r'^(\d+)(cm|in)$');
var hclReg = RegExp(r'^#[0-9a-f]{6}$');
var eclReg = RegExp(r'^amb|blu|brn|gry|grn|hzl|oth$');
var pidReg = RegExp(r'^\d{9}$');

Solutions run(String input) {
  var passports = [];
  for (var line in input.trim().split('\n\n')) {
    var pp = <String, String>{};
    for (var item in line.trim().split(RegExp(r'\s+'))) {
      final itemSplit = item.split(':');
      pp[itemSplit[0]] = itemSplit[1];
    }
    passports.add(pp);
  }
  // print(passports);

  var count = 0;
  var count2 = 0;
  for (var pp in passports) {
    count += 1;
    count2 += 1;
    var valid = true;
    var valid2 = true;
    for (var field in FIELDS) {
      if (pp[field] == null) {
        valid = false;
        valid2 = false;
        break;
      }
      switch (field) {
        case 'byr':
          final byr = int.parse(pp[field]);
          if (byr < 1920 || byr > 2002) {
            valid2 = false;
            // print([field, pp[field]]);
          }
          break;

        case 'iyr':
          final iyr = int.parse(pp[field]);
          if (iyr < 2010 || iyr > 2020) {
            valid2 = false;
            // print([field, pp[field]]);
          }
          break;

        case 'eyr':
          final eyr = int.parse(pp[field]);
          if (eyr < 2020 || eyr > 2030) {
            valid2 = false;
            // print([field, pp[field]]);
          }
          break;

        case 'hgt':
          final m = hgtReg.firstMatch(pp[field]);
          if (m == null) {
            valid2 = false;
            // print([field, pp[field]]);
          } else {
            final hgtInt = int.parse(m.group(1));
            if (m.group(2) == 'cm') {
              if (hgtInt < 150 || hgtInt > 193) {
                valid2 = false;
                // print([field, pp[field]]);
              }
            } else if (m.group(2) == 'in') {
              if (hgtInt < 59 || hgtInt > 76) {
                valid2 = false;
                // print([field, pp[field]]);
              }
            } else {
              valid2 = false;
              // print([field, pp[field]]);
            }
          }
          break;

        case 'hcl':
          if (!hclReg.hasMatch(pp[field])) {
            valid2 = false;
            // print([field, pp[field]]);
          }
          break;

        case 'ecl':
          if (!eclReg.hasMatch(pp[field])) {
            valid2 = false;
            // print([field, pp[field]]);
          }
          break;

        case 'pid':
          if (!pidReg.hasMatch(pp[field])) {
            valid2 = false;
            // print([field, pp[field]]);
          }
          break;

        default:
          throw Exception('Not a valid field');
      }
    }
    // print(pp.toString());
    if (!valid) {
      // print('invalid');
      count -= 1;
    } else {
      // print('valid');
    }
    if (!valid2) {
      // print('invalid2');
      count2 -= 1;
    } else {
      // print('valid2');
      print(pp['pid']);
    }
    // print('');
  }
  return Solutions.withParts('$count', '$count2');
}
