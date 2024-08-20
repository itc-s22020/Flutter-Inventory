// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(name) => "Create item in ${name}";

  static String m1(e) => "Failed to delete folder: ${e}";

  static String m2(e) => "Failed to delete item: ${e}";

  static String m3(name) => "Folder ${name} already exists";

  static String m4(item, name) =>
      "Item ${item} already exists in folder ${name}";

  static String m5(e) => "Failed to create folder: ${e}";

  static String m6(e) => "Failed to rename folder: ${e}";

  static String m7(e) => "Failed to create item: ${e}";

  static String m8(e) => "Failed to rename item: ${e}";

  static String m9(e) => "Failed to load: ${e}";

  static String m10(e) => "Failed to update image: ${e}";

  static String m11(e) => "Failed to update item: ${e}";

  static String m12(name) => "Deleted folder ${name}";

  static String m13(item, folder) => "Deleted ${item} from ${folder}";

  static String m14(item) => "Changed image for ${item}";

  static String m15(name) => "Created folder ${name}";

  static String m16(item, folder) => "Created ${item} in ${folder}";

  static String m17(oldName, newName) =>
      "Renamed folder from ${oldName} to ${newName}";

  static String m18(oldName, newName) =>
      "Renamed item from ${oldName} to ${newName}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "NoFolderFound":
            MessageLookupByLibrary.simpleMessage("No folder found"),
        "NoFolderInItem":
            MessageLookupByLibrary.simpleMessage("No items in folder"),
        "NoFolderSelected":
            MessageLookupByLibrary.simpleMessage("No folder selected"),
        "addItemMessage": m0,
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "create": MessageLookupByLibrary.simpleMessage("Create"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "deleteCheck": MessageLookupByLibrary.simpleMessage(
            "Do you want to delete this item?"),
        "error": MessageLookupByLibrary.simpleMessage("Error"),
        "errorDeleteFolder": m1,
        "errorDeleteItem": m2,
        "errorDuplicationFolder": m3,
        "errorDuplicationItem": m4,
        "errorFolder": m5,
        "errorFolderRename": m6,
        "errorImageOptimizing":
            MessageLookupByLibrary.simpleMessage("Failed to optimize image"),
        "errorItem": m7,
        "errorItemRename": m8,
        "errorLoading": m9,
        "errorOnly": MessageLookupByLibrary.simpleMessage("Notify errors only"),
        "errorUpdateImage": m10,
        "errorUpdateItem": m11,
        "folderNameField":
            MessageLookupByLibrary.simpleMessage("Enter folder name"),
        "icon": MessageLookupByLibrary.simpleMessage("Icon"),
        "imageChange": MessageLookupByLibrary.simpleMessage("Change Image"),
        "imageSelect": MessageLookupByLibrary.simpleMessage("Select Image"),
        "item": MessageLookupByLibrary.simpleMessage("Item"),
        "itemName": MessageLookupByLibrary.simpleMessage("Item Name"),
        "language": MessageLookupByLibrary.simpleMessage("language"),
        "makeFolder": MessageLookupByLibrary.simpleMessage("Create Folder"),
        "newFolderName":
            MessageLookupByLibrary.simpleMessage("Enter new folder name"),
        "rename": MessageLookupByLibrary.simpleMessage("Rename"),
        "renameFolder": MessageLookupByLibrary.simpleMessage("Rename Folder"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "setting": MessageLookupByLibrary.simpleMessage("Settings"),
        "stuck": MessageLookupByLibrary.simpleMessage("Stock"),
        "stuckNum": MessageLookupByLibrary.simpleMessage("Stock Quantity"),
        "success": MessageLookupByLibrary.simpleMessage("Success"),
        "successDeleteFolder": m12,
        "successDeleteItem": m13,
        "successImageChange": m14,
        "successMakeFolder": m15,
        "successMakeItem": m16,
        "successRenameFolder": m17,
        "successRenameItem": m18
      };
}
