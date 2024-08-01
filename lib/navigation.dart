import 'package:flutter/material.dart';
import 'package:inventory/page/add_inventory.dart';
import 'package:inventory/page/home.dart';
import 'package:inventory/page/inventory.dart';
import 'package:inventory/page/make_folder.dart';
import 'package:inventory/page/folder.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

void toHome(BuildContext context) =>
  PersistentNavBarNavigator.pushNewScreen(
    context,
    screen: const HomePage(),
    withNavBar: true,
  );

void toAddInventory(BuildContext context) =>
  PersistentNavBarNavigator.pushNewScreen(
    context,
    screen: const AddInventoryPage(),
    withNavBar: true,
  );

void toInventory(BuildContext context) =>
  PersistentNavBarNavigator.pushNewScreen(
    context,
    screen: const InventoryPage(),
    withNavBar: true,
  );

void toMakeFolder(BuildContext context) =>
  PersistentNavBarNavigator.pushNewScreen(
    context,
    screen: const MakeFolderPage(),
    withNavBar: true,
    pageTransitionAnimation: PageTransitionAnimation.cupertino
  );

void toFolder(BuildContext context) =>
  PersistentNavBarNavigator.pushNewScreen(
    context,
    screen: const FolderPage(),
    withNavBar: true,
    pageTransitionAnimation: PageTransitionAnimation.fade
  );

void toBack(BuildContext context) => Navigator.pop(context);

