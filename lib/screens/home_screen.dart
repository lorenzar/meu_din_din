import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Stream<List<Expense>> _carregarDespesas() {
    return FirebaseFirestore.instance
        .collection('despesas')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Expense.fromFirestore(doc)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumo de Gastos'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Expense>>(
        stream: _carregarDespesas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final despesas = snapshot.data ?? [];

          double totalGastos = 0.0;
          Map<String, double> gastosPorCategoria = {};

          for (var despesa in despesas) {
            totalGastos += despesa.valor;
            gastosPorCategoria.update(
              despesa.categoria,
                  (valor) => valor + despesa.valor,
              ifAbsent: () => despesa.valor,
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total de Gastos:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  'R\$ ${totalGastos.toStringAsFixed(2)}',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: Colors.redAccent),
                ),
                const SizedBox(height: 24),
                Text(
                  'Gastos por Categoria:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...gastosPorCategoria.entries.map((e) => ListTile(
                  title: Text(e.key),
                  trailing: Text('R\$ ${e.value.toStringAsFixed(2)}'),
                )),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Adicionar'),
                      onPressed: () => Navigator.pushNamed(context, '/add'),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.list),
                      label: const Text('Listar'),
                      onPressed: () => Navigator.pushNamed(context, '/list'),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.bar_chart),
                      label: const Text('Metas'),
                      onPressed: () => Navigator.pushNamed(context, '/goal'),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
