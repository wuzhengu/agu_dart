///Use a locale for key, and translations map for value
final Map<String, Map<String, String>> l10nDict = {};

/// Like `zh_hans_cn` or `zh_cn` or `zh`
String? l10nLocale;

extension L10nStringExt on String {
  String l10n([String? locale]) {
    var str = this;

    locale ??= l10nLocale;
    if (locale == null) return str;

    var names = locale.toLowerCase().split("_");
    for (var length = names.length, length2 = length - 1; length2 >= 0; length2--) {
      for (int start = 0; start < length - length2 && (start == 0 || length2 > 0); start++) {
        var end = start + length2;
        for (int i = end; i < length; i++) {
          if (start != 0 || (end == start && i != 0)) continue; //Ensure the res contains the [0]
          var res = names.sublist(start, end)..add(names[i]);
          var name = res.join("_");
          var dict = l10nDict[name];
          var value = dict?[str];
          if (value != null) {
            return value;
          }
        }
      }
    }

    return str;
  }
}
