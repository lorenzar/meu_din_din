import 'package:flutter/material.dart';
import 'package:meu_din_din/screens/financial_goals_screen.dart';
import 'screens/home_screen.dart';
import 'screens/list_screen.dart';
import 'screens/add_expense_screen.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCuvvHLSjc5SimQtM23GonHEeG7e01YUzg",
        authDomain: "meudindin-3dd5a.firebaseapp.com",
        projectId: "meudindin-3dd5a",
        storageBucket: "meudindin-3dd5a.firebasestorage.app",
        messagingSenderId: "367048939576",
        appId: "1:367048939576:web:050630d7b3bb2558ff2ecd",
        measurementId: "G-JLV0TPVYNG"
    ),
  );

  runApp(const MeuDinDinApp());
}



class MeuDinDinApp extends StatelessWidget {
  const MeuDinDinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MeuDinDin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/list': (context) => const ListScreen(),
        '/add': (context) => const AddExpenseScreen(),
        '/goal': (context) => const FinancialGoalsScreen(),
      },
    );
  }
}
