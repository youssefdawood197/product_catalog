import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_catalog/core/di/locator.dart';
import 'package:product_catalog/core/routing/app_router.dart';
import 'package:product_catalog/core/theme/app_theme.dart';
import 'package:product_catalog/features/products/logic/cubit/product_cubit.dart';
import 'package:product_catalog/features/products/data/repositories/product_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';

final GlobalKey<_MyAppState> myAppKey = GlobalKey<_MyAppState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();

  final prefs = await SharedPreferences.getInstance();
  final savedLocale = prefs.getString('app_locale');
  runApp(MyApp(savedLocale: savedLocale, key: myAppKey));
}

class MyApp extends StatefulWidget {
  final String? savedLocale;
  const MyApp({super.key, this.savedLocale});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = switch (widget.savedLocale) {
      'ar' => const Locale('ar'),
      _ => const Locale('en'),
    };
  }

  void _toggleLocale() async {
    setState(() {
      _locale = _locale.languageCode == 'en' ? const Locale('ar') : const Locale('en');
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_locale', _locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, __) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ProductCubit(sl<ProductRepository>())),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Product Catalog',
          theme: AppTheme.light,
          locale: _locale,
          supportedLocales: const [Locale('en'), Locale('ar')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          routerConfig: router,
          builder: (context, child) {
            return Directionality(
              textDirection: _locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
              child: _ScaffoldWithLangToggle(onToggle: _toggleLocale, child: child!,),
            );
          },
        ),
      ),
    );
  }
}

class _ScaffoldWithLangToggle extends StatelessWidget {
  final VoidCallback onToggle;
  final Widget child;
  _ScaffoldWithLangToggle({required this.onToggle, required this.child});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Stack(
      children: [
        child,
        Positioned(
          left: MediaQuery.of(context).size.width / 2 - 28,  // Center the button horizontally
          bottom: 32,
          child: FloatingActionButton.extended(
            onPressed: onToggle,
            label: Text(loc.langToggle),
          ),
        )
      ],
    );
  }
}


