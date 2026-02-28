import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Supabase.initialize() 추가
  runApp(const ProviderScope(child: IkdaApp()));
}
