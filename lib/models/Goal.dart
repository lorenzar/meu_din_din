class Goal {
  final String id;
  final String titulo;
  final double valor;
  final double atingido;
  final bool concluida;

  Goal({
    required this.id,
    required this.titulo,
    required this.valor,
    required this.atingido,
    required this.concluida,
  });

  factory Goal.fromMap(String id, Map<String, dynamic> map) {
    return Goal(
      id: id,
      titulo: map['titulo'],
      valor: map['valor'].toDouble(),
      atingido: map['atingido'].toDouble(),
      concluida: map['concluida'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'valor': valor,
      'atingido': atingido,
      'concluida': concluida,
    };
  }
}
