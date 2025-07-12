import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'feature/dashboard/dashboard.dart';
import 'feature/dashboard/providers/providers.dart';
import 'network/network.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DioClient>(
          create: (_) => DioClient(),
        ),
        Provider<TransactionApiService>(
          create: (context) => TransactionApiService(
            context.read<DioClient>(),
          ),
        ),
        ChangeNotifierProvider<TransactionProvider>(
          create: (context) => TransactionProvider(
            context.read<TransactionApiService>(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Transaction Dashboard',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const DashboardView(),
      ),
    );
  }
}
