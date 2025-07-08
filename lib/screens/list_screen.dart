import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  Stream<List<Expense>> _carregarDespesas() {
    return FirebaseFirestore.instance
        .collection('despesas')
        .orderBy('data', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Expense.fromFirestore(doc)).toList();
    });
  }

  Future<void> _deletarDespesa(String id, BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('despesas').doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Despesa deletada com sucesso')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao deletar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Despesas'),
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

          final despesas = snapshot.data;

          if (despesas == null || despesas.isEmpty) {
            return const Center(child: Text('Nenhuma despesa encontrada.'));
          }

          return ListView.builder(
            itemCount: despesas.length,
            itemBuilder: (context, index) {
              final despesa = despesas[index];
              return ListTile(
                title: Text(despesa.descricao),
                subtitle: Text('${despesa.categoria} • ${_formatarData(despesa.data)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'R\$ ${despesa.valor.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.grey),
                      onPressed: () => _deletarDespesa(despesa.id!, context),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }
}
