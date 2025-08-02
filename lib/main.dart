import 'package:flutter/material.dart';
import 'package:simple_task_manager/core/db/shared_pref_helper.dart';

import 'core/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefHelper.startDb();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: RouterApp.goRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
