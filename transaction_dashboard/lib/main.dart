import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'feature/dashboard/dashboard.dart';
import 'feature/dashboard/providers/providers.dart';
import 'feature/payout_form/providers/providers.dart';
import 'feature/payout_form/services/services.dart';
import 'network/network.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await PayoutStorageService.initialize();
  await PayoutStorageService.addSampleData();
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
        ChangeNotifierProvider<PayoutProvider>(
          create: (_) => PayoutProvider(),
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
