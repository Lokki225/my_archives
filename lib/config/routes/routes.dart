
import 'package:flutter/cupertino.dart';
import 'package:my_archives/features/authentification/presentation/screens/login_screen.dart';
import 'package:my_archives/features/folders/presentation/screens/folders_screen.dart';
import 'package:my_archives/features/home/presentation/screens/home_screen.dart';

import '../../features/archives/presentation/screens/archive_detail_screen.dart';
import '../../features/archives/presentation/screens/archives_screen.dart';
import '../../features/authentification/presentation/screens/register_screen.dart';
import '../../features/categories/presentation/screens/categories_screen.dart';
import '../../features/categories/presentation/screens/category_detail_screen.dart';
import '../../features/code_pin_verification/presentation/screens/create_pin_code_screen.dart';
import '../../features/code_pin_verification/presentation/screens/verify_pin_code_screen.dart';
import '../../features/folders/presentation/screens/folder_detail_screen.dart';
import '../../features/home/presentation/screens/search_screen.dart';

const List<String> routeNames = [
  "/LoginScreen", "/RegisterScreen",
  "/HomeScreen", "/SearchScreen",
  "/FolderDetailScreen", "/CategoryDetailScreen", "/ArchiveDetailScreen",
  "/FoldersScreen", "/CategoriesScreen", "/ArchivesScreen",
  "/SettingsScreen", "/ProfileScreen", "/HelpScreen", "/AboutScreen",
  "/VerifyPinCodeScreen", "/CreatePinCodeScreen"
];

final Map<String, Widget Function(BuildContext)> appRoutes = {
  routeNames[0]: (context) => LoginScreen(),
  routeNames[1]: (context) => RegisterScreen(),
  routeNames[2]: (context) => HomeScreen(),
  routeNames[3]: (context) => SearchScreen(),
  routeNames[4]: (context) => FolderDetailScreen(),
  routeNames[5]: (context) => CategoryDetailScreen(),
  routeNames[6]: (context) => ArchiveDetailScreen(),
  routeNames[7]: (context) => FoldersScreen(),
  routeNames[8]: (context) => CategoriesScreen(),
  routeNames[9]: (context) => ArchivesScreen(),
  // routeNames[10]: (context) => SettingsScreen(),
  // routeNames[11]: (context) => ProfileScreen(),
  // routeNames[12]: (context) => HelpScreen(),
  // routeNames[13]: (context) => AboutScreen(),
  routeNames[14]: (context) => VerifyPinCodeScreen(),
  routeNames[15]: (context) => CreatePinCodeScreen(),
};