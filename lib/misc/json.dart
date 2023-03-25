import 'dart:convert';

String? toJsonOrString(object) {
  try {
    return object?.toJson();
  } catch (ex, st) {
    // print("$ex\n$st");
  }
  return object?.toString();
}

const jsonEncoder = JsonEncoder(toJsonOrString);

String jsonEncode(object) {
  return jsonEncoder.convert(object);
}

const jsonEncoder2 = JsonEncoder.withIndent("  ", toJsonOrString);

String jsonEncode2(object) {
  return jsonEncoder2.convert(object);
}

class JsonEntry<Value> implements MapEntry<String, Value?> {
  String _key;
  Value? _value;
  bool? skipEncode;
  bool? skipDecode;

  JsonEntry(this._key, [this._value]);

  JsonEntry.skipEncode(this._key, [this._value]) : skipEncode = true;

  JsonEntry.skipDecode(this._key, [this._value]) : skipDecode = true;

  @override
  String get key => _key;

  @override
  get value => _value;

  set value(Value? value) => _value = value;

  bool? asBool() {
    var value = this.value;
    if (value != null) {
      return value == true || value == "true" || value == 1;
    }
    return null;
  }

  num? asNum() {
    var value = this.value;
    if (value is num) return value;
    try {
      return num.parse(value.toString());
    } catch (ex) {
      return null;
    }
  }

  String? asString() {
    var value = this.value;
    return value?.toString();
  }

  Map? asMap() {
    var value = this.value;
    if (value is Map) return value;
    return null;
  }

  List<Item>? asList<Item>([Item Function(dynamic)? newItem]) {
    var value = this.value;
    if (value is List) {
      if (newItem != null) {
        return value.map((e) {
          var item = newItem(e);
          if (e is Map && item is JsonObj) {
            item.fromMap(e);
          }
          return item;
        }).toList();
      }
      return value as dynamic;
    }
    return null;
  }
}

abstract class JsonObj {
  List<JsonEntry> get entries;

  Map<String, dynamic> toMap() {
    return Map.fromEntries(entries.where((e) => e.value != null && e.skipEncode != true));
  }

  JsonObj fromMap(Map map) {
    for (var e in entries) {
      if (e.skipDecode == true) continue;
      var value2 = map[e.key];
      if (e.value is JsonObj) {
        if (value2 is String) {
          (e.value as JsonObj).fromJson(value2);
        } else if (value2 is Map) {
          (e.value as JsonObj).fromMap(value2);
        }
      } else {
        e.value = value2;
      }
    }
    return this;
  }

  JsonObj fromJson(String? json) {
    if (json == null || json.isEmpty) return this;
    try {
      Map<String, dynamic> map = jsonDecode(json);
      fromMap(map);
    } catch (ex, st) {
      print("$ex\n$st");
    }
    return this;
  }

  String toJson() {
    try {
      return jsonEncode(toMap());
    } catch (ex) {
      return "{}";
    }
  }

  @override
  String toString() {
    return toJson();
  }
}
