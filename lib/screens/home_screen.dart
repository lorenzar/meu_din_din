import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Valores mockados por enquanto
    double totalGastos = 1240.50;
    Map<String, double> gastosPorCategoria = {
      'Alimentação': 500.00,
      'Transporte': 280.00,
      'Lazer': 190.50,
      'Outros': 270.00,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumo de Gastos'),
        centerTitle: true,
      ),
      body: Padding(
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
                  label: const Text('Relatório'),
                  onPressed: () => Navigator.pushNamed(context, '/report'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
