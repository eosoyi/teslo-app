import 'package:flutter/material.dart';
import 'package:teslo_app/config/const/environment.dart';
import 'package:teslo_app/config/router/app_router.dart';
import 'package:teslo_app/config/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  await Environments.initEnvironment();
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouterProvider = ref.watch(goRouterProvider);
    return MaterialApp.router(
      routerConfig: appRouterProvider,
      theme: AppTheme().getTheme(),
      debugShowCheckedModeBanner: false,
    );
  }
}
