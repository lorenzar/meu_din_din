import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String? id; // ID do documento no Firestore
  final String descricao;
  final double valor;
  final String categoria;
  final DateTime data;

  Expense({
    this.id,
    required this.descricao,
    required this.valor,
    required this.categoria,
    required this.data,
  });

  // Converter para Map (usado para salvar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      'descricao': descricao,
      'valor': valor,
      'categoria': categoria,
      'data': Timestamp.fromDate(data),
    };
  }

  // Criar objeto a partir de um documento do Firestore
  factory Expense.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Expense(
      id: doc.id,
      descricao: data['descricao'] ?? '',
      valor: (data['valor'] as num).toDouble(),
      categoria: data['categoria'] ?? 'Outros',
      data: (data['data'] as Timestamp).toDate(),
    );
  }
}
