// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Settings`
  String get setting {
    return Intl.message(
      'Settings',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `Notify errors only`
  String get errorOnly {
    return Intl.message(
      'Notify errors only',
      name: 'errorOnly',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `language`
  String get language {
    return Intl.message(
      'language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get success {
    return Intl.message(
      'Success',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get create {
    return Intl.message(
      'Create',
      name: 'create',
      desc: '',
      args: [],
    );
  }

  /// `Rename`
  String get rename {
    return Intl.message(
      'Rename',
      name: 'rename',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete this item?`
  String get deleteCheck {
    return Intl.message(
      'Do you want to delete this item?',
      name: 'deleteCheck',
      desc: '',
      args: [],
    );
  }

  /// `Change Image`
  String get imageChange {
    return Intl.message(
      'Change Image',
      name: 'imageChange',
      desc: '',
      args: [],
    );
  }

  /// `Select Image`
  String get imageSelect {
    return Intl.message(
      'Select Image',
      name: 'imageSelect',
      desc: '',
      args: [],
    );
  }

  /// `Stock`
  String get stuck {
    return Intl.message(
      'Stock',
      name: 'stuck',
      desc: '',
      args: [],
    );
  }

  /// `Stock Quantity`
  String get stuckNum {
    return Intl.message(
      'Stock Quantity',
      name: 'stuckNum',
      desc: '',
      args: [],
    );
  }

  /// `Item`
  String get item {
    return Intl.message(
      'Item',
      name: 'item',
      desc: '',
      args: [],
    );
  }

  /// `Item Name`
  String get itemName {
    return Intl.message(
      'Item Name',
      name: 'itemName',
      desc: '',
      args: [],
    );
  }

  /// `Create Folder`
  String get makeFolder {
    return Intl.message(
      'Create Folder',
      name: 'makeFolder',
      desc: '',
      args: [],
    );
  }

  /// `Enter folder name`
  String get folderNameField {
    return Intl.message(
      'Enter folder name',
      name: 'folderNameField',
      desc: '',
      args: [],
    );
  }

  /// `Enter new folder name`
  String get newFolderName {
    return Intl.message(
      'Enter new folder name',
      name: 'newFolderName',
      desc: '',
      args: [],
    );
  }

  /// `Rename Folder`
  String get renameFolder {
    return Intl.message(
      'Rename Folder',
      name: 'renameFolder',
      desc: '',
      args: [],
    );
  }

  /// `Create item in {name}`
  String addItemMessage(Object name) {
    return Intl.message(
      'Create item in $name',
      name: 'addItemMessage',
      desc: '',
      args: [name],
    );
  }

  /// `Icon`
  String get icon {
    return Intl.message(
      'Icon',
      name: 'icon',
      desc: '',
      args: [],
    );
  }

  /// `Created folder {name}`
  String successMakeFolder(Object name) {
    return Intl.message(
      'Created folder $name',
      name: 'successMakeFolder',
      desc: '',
      args: [name],
    );
  }

  /// `Renamed folder from {oldName} to {newName}`
  String successRenameFolder(Object oldName, Object newName) {
    return Intl.message(
      'Renamed folder from $oldName to $newName',
      name: 'successRenameFolder',
      desc: '',
      args: [oldName, newName],
    );
  }

  /// `Renamed item from {oldName} to {newName}`
  String successRenameItem(Object oldName, Object newName) {
    return Intl.message(
      'Renamed item from $oldName to $newName',
      name: 'successRenameItem',
      desc: '',
      args: [oldName, newName],
    );
  }

  /// `Deleted folder {name}`
  String successDeleteFolder(Object name) {
    return Intl.message(
      'Deleted folder $name',
      name: 'successDeleteFolder',
      desc: '',
      args: [name],
    );
  }

  /// `Created {item} in {folder}`
  String successMakeItem(Object item, Object folder) {
    return Intl.message(
      'Created $item in $folder',
      name: 'successMakeItem',
      desc: '',
      args: [item, folder],
    );
  }

  /// `Deleted {item} from {folder}`
  String successDeleteItem(Object item, Object folder) {
    return Intl.message(
      'Deleted $item from $folder',
      name: 'successDeleteItem',
      desc: '',
      args: [item, folder],
    );
  }

  /// `Changed image for {item}`
  String successImageChange(Object item) {
    return Intl.message(
      'Changed image for $item',
      name: 'successImageChange',
      desc: '',
      args: [item],
    );
  }

  /// `Folder {name} already exists`
  String errorDuplicationFolder(Object name) {
    return Intl.message(
      'Folder $name already exists',
      name: 'errorDuplicationFolder',
      desc: '',
      args: [name],
    );
  }

  /// `Item {item} already exists in folder {name}`
  String errorDuplicationItem(Object item, Object name) {
    return Intl.message(
      'Item $item already exists in folder $name',
      name: 'errorDuplicationItem',
      desc: '',
      args: [item, name],
    );
  }

  /// `Failed to create folder: {e}`
  String errorFolder(Object e) {
    return Intl.message(
      'Failed to create folder: $e',
      name: 'errorFolder',
      desc: '',
      args: [e],
    );
  }

  /// `Failed to rename folder: {e}`
  String errorFolderRename(Object e) {
    return Intl.message(
      'Failed to rename folder: $e',
      name: 'errorFolderRename',
      desc: '',
      args: [e],
    );
  }

  /// `Failed to rename item: {e}`
  String errorItemRename(Object e) {
    return Intl.message(
      'Failed to rename item: $e',
      name: 'errorItemRename',
      desc: '',
      args: [e],
    );
  }

  /// `Failed to delete folder: {e}`
  String errorDeleteFolder(Object e) {
    return Intl.message(
      'Failed to delete folder: $e',
      name: 'errorDeleteFolder',
      desc: '',
      args: [e],
    );
  }

  /// `Failed to delete item: {e}`
  String errorDeleteItem(Object e) {
    return Intl.message(
      'Failed to delete item: $e',
      name: 'errorDeleteItem',
      desc: '',
      args: [e],
    );
  }

  /// `Failed to create item: {e}`
  String errorItem(Object e) {
    return Intl.message(
      'Failed to create item: $e',
      name: 'errorItem',
      desc: '',
      args: [e],
    );
  }

  /// `Failed to load: {e}`
  String errorLoading(Object e) {
    return Intl.message(
      'Failed to load: $e',
      name: 'errorLoading',
      desc: '',
      args: [e],
    );
  }

  /// `Failed to update item: {e}`
  String errorUpdateItem(Object e) {
    return Intl.message(
      'Failed to update item: $e',
      name: 'errorUpdateItem',
      desc: '',
      args: [e],
    );
  }

  /// `Failed to optimize image`
  String get errorImageOptimizing {
    return Intl.message(
      'Failed to optimize image',
      name: 'errorImageOptimizing',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update image: {e}`
  String errorUpdateImage(Object e) {
    return Intl.message(
      'Failed to update image: $e',
      name: 'errorUpdateImage',
      desc: '',
      args: [e],
    );
  }

  /// `No folder found`
  String get NoFolderFound {
    return Intl.message(
      'No folder found',
      name: 'NoFolderFound',
      desc: '',
      args: [],
    );
  }

  /// `No folder selected`
  String get NoFolderSelected {
    return Intl.message(
      'No folder selected',
      name: 'NoFolderSelected',
      desc: '',
      args: [],
    );
  }

  /// `No items in folder`
  String get NoFolderInItem {
    return Intl.message(
      'No items in folder',
      name: 'NoFolderInItem',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ja'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
