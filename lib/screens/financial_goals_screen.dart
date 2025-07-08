import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/goal.dart';

class FinancialGoalsScreen extends StatefulWidget {
  const FinancialGoalsScreen({super.key});

  @override
  State<FinancialGoalsScreen> createState() => _FinancialGoalsScreenState();
}

class _FinancialGoalsScreenState extends State<FinancialGoalsScreen> {
  final _tituloController = TextEditingController();
  final _valorController = TextEditingController();

  Future<void> _adicionarMeta() async {
    final titulo = _tituloController.text.trim();
    final valor = double.tryParse(_valorController.text.replaceAll(',', '.')) ?? 0;

    if (titulo.isNotEmpty && valor > 0) {
      await FirebaseFirestore.instance.collection('metas').add({
        'titulo': titulo,
        'valor': valor,
        'atingido': 0,
        'concluida': false,
      });

      _tituloController.clear();
      _valorController.clear();
      Navigator.pop(context);
    }
  }

  void _mostrarDialogoNovaMeta() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nova Meta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: _valorController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Valor (R\$)'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: Navigator.of(context).pop, child: const Text('Cancelar')),
          ElevatedButton(onPressed: _adicionarMeta, child: const Text('Salvar')),
        ],
      ),
    );
  }

  void _adicionarValorAtingido(Goal meta) {
    final _valorController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Atualizar "${meta.titulo}"'),
        content: TextField(
          controller: _valorController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Valor a adicionar (R\$)'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final valor = double.tryParse(_valorController.text.replaceAll(',', '.')) ?? 0;
              if (valor > 0) {
                final novoTotal = meta.atingido + valor;
                final concluida = novoTotal >= meta.valor;

                await FirebaseFirestore.instance
                    .collection('metas')
                    .doc(meta.id)
                    .update({
                  'atingido': novoTotal,
                  'concluida': concluida,
                });

                Navigator.of(context).pop();
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Metas Financeiras')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('metas').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final metas = snapshot.data!.docs.map((doc) {
            return Goal.fromMap(doc.id, doc.data() as Map<String, dynamic>);
          }).toList();

          if (metas.isEmpty) {
            return const Center(child: Text('Nenhuma meta cadastrada'));
          }

          return ListView.builder(
              itemCount: metas.length,
              itemBuilder: (context, index) {
                final meta = metas[index];
                final progresso = (meta.atingido / meta.valor).clamp(0.0, 1.0);

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(meta.titulo),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'R\$ ${meta.atingido.toStringAsFixed(2)} / R\$ ${meta.valor.toStringAsFixed(2)}',
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(value: progresso),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!meta.concluida)
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => _adicionarValorAtingido(meta),
                          ),
                        if (meta.concluida)
                          const Icon(Icons.check, color: Colors.green),
                      ],
                    ),
                  ),
                );
              }
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialogoNovaMeta,
        child: const Icon(Icons.add),
      ),
    );
  }
}
