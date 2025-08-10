import 'package:go_router/go_router.dart';
import 'package:product_catalog/core/ui/onboarding_screen.dart';
import 'package:product_catalog/core/ui/splash_screen.dart';
import 'package:product_catalog/features/products/ui/product_details_screen.dart';
import 'package:product_catalog/features/products/ui/product_list_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/products',
      builder: (context, state) => const ProductListScreen(),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ProductDetailsScreen(productId: id);
      },
    ),
  ],
);
