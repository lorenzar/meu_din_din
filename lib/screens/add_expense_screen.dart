import 'package:flutter/material.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  String _categoriaSelecionada = 'Alimentação';
  DateTime _dataSelecionada = DateTime.now();

  final List<String> _categorias = [
    'Alimentação',
    'Transporte',
    'Lazer',
    'Saúde',
    'Outros',
  ];

  void _salvarDespesa() {
    if (_formKey.currentState!.validate()) {
      // Simula salvamento (futuramente vai pro banco)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Despesa salva com sucesso!')),
      );
      Navigator.pop(context); // Volta pra Home
    }
  }

  void _selecionarData() async {
    DateTime? novaData = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (novaData != null) {
      setState(() {
        _dataSelecionada = novaData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Despesa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Digite a descrição' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _valorController,
                decoration: const InputDecoration(labelText: 'Valor (R\$)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Digite o valor';
                  final double? parsed = double.tryParse(value.replaceAll(',', '.'));
                  if (parsed == null || parsed <= 0) return 'Valor inválido';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _categoriaSelecionada,
                decoration: const InputDecoration(labelText: 'Categoria'),
                items: _categorias
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _categoriaSelecionada = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Data: ${_dataSelecionada.day}/${_dataSelecionada.month}/${_dataSelecionada.year}',
                    ),
                  ),
                  TextButton(
                    onPressed: _selecionarData,
                    child: const Text('Selecionar Data'),
                  )
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _salvarDespesa,
                icon: const Icon(Icons.save),
                label: const Text('Salvar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
