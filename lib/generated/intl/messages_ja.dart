// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ja';

  static String m0(name) => "${name}にアイテムを作成";

  static String m1(e) => "フォルダの削除に失敗 ${e}";

  static String m2(e) => "アイテムの削除に失敗 ${e}";

  static String m3(name) => "フォルダ ${name} がすでに存在しています";

  static String m4(item, name) => "アイテム ${item} は フォルダ ${name} にすでに存在しています";

  static String m5(e) => "フォルダの作成が失敗 ${e}";

  static String m6(e) => "フォルダ名変更が失敗 ${e}";

  static String m7(e) => "アイテムの作成に失敗 ${e}";

  static String m8(e) => "アイテム名変更が失敗 ${e}";

  static String m9(e) => "読み込み失敗 ${e}";

  static String m10(e) => "画像の変更が失敗 ${e}";

  static String m11(e) => "アイテムの更新が失敗 ${e}";

  static String m12(name) => "フォルダ ${name} を削除";

  static String m13(item, folder) => "${folder} から ${item} を削除";

  static String m14(item) => "${item} の画像を変更";

  static String m15(name) => "フォルダ ${name} を作成";

  static String m16(item, folder) => "${folder} に ${item} を作成";

  static String m17(oldName, newName) => "フォルダ名 ${oldName} を ${newName} に変更";

  static String m18(oldName, newName) => "アイテム名 ${oldName} を ${newName} に変更";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "NoFolderFound": MessageLookupByLibrary.simpleMessage("フォルダが存在しません"),
        "NoFolderInItem":
            MessageLookupByLibrary.simpleMessage("フォルダ内にアイテムがありません"),
        "NoFolderSelected":
            MessageLookupByLibrary.simpleMessage("フォルダが選択されていません"),
        "addItemMessage": m0,
        "cancel": MessageLookupByLibrary.simpleMessage("キャンセル"),
        "create": MessageLookupByLibrary.simpleMessage("作成"),
        "delete": MessageLookupByLibrary.simpleMessage("削除"),
        "deleteCheck": MessageLookupByLibrary.simpleMessage("このアイテムを削除しますか？"),
        "error": MessageLookupByLibrary.simpleMessage("エラー"),
        "errorDeleteFolder": m1,
        "errorDeleteItem": m2,
        "errorDuplicationFolder": m3,
        "errorDuplicationItem": m4,
        "errorFolder": m5,
        "errorFolderRename": m6,
        "errorImageOptimizing":
            MessageLookupByLibrary.simpleMessage("画像の最適化に失敗"),
        "errorItem": m7,
        "errorItemRename": m8,
        "errorLoading": m9,
        "errorOnly": MessageLookupByLibrary.simpleMessage("エラーのみを通知"),
        "errorUpdateImage": m10,
        "errorUpdateItem": m11,
        "folderNameField": MessageLookupByLibrary.simpleMessage("フォルダ名を入力"),
        "icon": MessageLookupByLibrary.simpleMessage("アイコン"),
        "imageChange": MessageLookupByLibrary.simpleMessage("画像変更"),
        "imageSelect": MessageLookupByLibrary.simpleMessage("画像選択"),
        "item": MessageLookupByLibrary.simpleMessage("アイテム"),
        "itemName": MessageLookupByLibrary.simpleMessage("アイテム名"),
        "language": MessageLookupByLibrary.simpleMessage("言語"),
        "makeFolder": MessageLookupByLibrary.simpleMessage("フォルダ作成"),
        "newFolderName": MessageLookupByLibrary.simpleMessage("新しいフォルダ名を入力"),
        "rename": MessageLookupByLibrary.simpleMessage("変更"),
        "renameFolder": MessageLookupByLibrary.simpleMessage("フォルダ名変更"),
        "save": MessageLookupByLibrary.simpleMessage("保存"),
        "setting": MessageLookupByLibrary.simpleMessage("設定"),
        "stuck": MessageLookupByLibrary.simpleMessage("在庫"),
        "stuckNum": MessageLookupByLibrary.simpleMessage("在庫数"),
        "success": MessageLookupByLibrary.simpleMessage("成功"),
        "successDeleteFolder": m12,
        "successDeleteItem": m13,
        "successImageChange": m14,
        "successMakeFolder": m15,
        "successMakeItem": m16,
        "successRenameFolder": m17,
        "successRenameItem": m18
      };
}
