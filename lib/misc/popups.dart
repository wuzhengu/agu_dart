import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

hideKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

///显示临时提示
Future showToast(BuildContext context, String message, [int duration = 1000]) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: Duration(milliseconds: duration),
    content: Text(message),
  ));
  return Future.delayed(Duration(milliseconds: duration), () {});
}

class Popup {
  ///弹窗消除函数
  final Future Function([bool rightNow]) dismiss;

  ///弹窗消除后回传结果
  Future<dynamic>? result;

  Popup(this.dismiss);
}

///显示提示弹窗
///
/// [cancelable] - 可否取消
///
/// [loading] - 一个[Widget]，或`true`
///
/// [message] - 一个[Widget]，或提示文字
///
/// [actions] - 可选按钮及回调
///
/// [builder] - 自定义弹窗内容
///
Popup showPopup(
  BuildContext context, {
  bool cancelable = false,
  dynamic loading,
  dynamic message,
  Map<String, Function?> actions = const {},
  WidgetBuilder? builder,
}) {
  var completer = Completer<BuildContext>();
  var time = DateTime.now().millisecond + 1000; //预设一定显示时间，避免闪屏
  dismiss([rightNow]) async {
    var context = await completer.future;
    if (rightNow != true) {
      time = time - DateTime.now().millisecond;
      if (time > 0) {
        //未到预定时间，等待一下
        await Future.delayed(Duration(milliseconds: time), () {});
      }
    }
    Navigator.of(context).pop(); //取消context对应弹窗
  }

  var popup = Popup(dismiss);

  Widget? content;
  if (builder == null) {
    List<Widget>? rows = [];
    if (loading is Widget) {
      rows.add(loading);
    } else if (loading == true) {
      rows.add(CircularProgressIndicator());
    }

    if (message is Widget) {
      rows.add(message);
    } else if (message != null) {
      rows.add(Text(message.toString()));
    }

    if (rows.length == 2) rows.insert(1, SizedBox(height: 4)); //插入空隙

    if (actions != null && actions.isNotEmpty) {
      var children = actions.entries.map((e) {
        Widget widget = TextButton(
          onPressed: () async {
            var context = await completer.future;
            Navigator.of(context).pop(e.key);
            e.value?.call();
          },
          child: Text(e.key),
        );
        return widget;
      }).toList(growable: true);
      for (int i = 0; i < children.length; i++) {
        if (i % 2 == 1) {
          children.insert(i++, SizedBox(width: 4)); //按钮之间插入空隙
        }
      }
      if (rows.length > 0) {
        rows.insert(0, Expanded(child: SizedBox())); //顶部添加空隙
        rows.add(Expanded(child: SizedBox())); //按钮上面添加空隙
      }
      rows.add(Row(mainAxisAlignment: MainAxisAlignment.center, children: children));
    }

    content = Container(
      width: 140 + min(actions.length, 3) * 30.0,
      height: 140,
      padding: EdgeInsets.all(10),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rows,
      ),
    );
  }

  popup.result = showDialog(
    context: context,
    barrierDismissible: cancelable,
    // barrierColor: Colors.transparent,
    builder: (context) {
      if (completer.isCompleted != true) completer.complete(context);
      return Center(
        child: WillPopScope(
          onWillPop: () async => cancelable,
          child: Material(
            borderRadius: BorderRadius.circular(10),
            child: content ?? builder!(context),
          ),
        ),
      );
    },
  );
  return popup;
}

Popup showAlert(
  BuildContext context, {
  bool? cancelable,
  required dynamic message,
  Map<String, Function?> actions = const {"知道了": null},
}) {
  return showPopup(
    context,
    cancelable: cancelable ?? actions.isEmpty,
    message: message,
    actions: actions,
  );
}

Popup showLoading(
  BuildContext context, {
  dynamic message,
  bool cancelable = false,
}) {
  return showPopup(
    context,
    loading: true,
    cancelable: cancelable,
    message: message,
  );
}
