import 'package:flutter/material.dart';
import 'theme.dart';
import 'router.dart';

class IkdaApp extends StatelessWidget {
  const IkdaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '읽다',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
