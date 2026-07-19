/// Dificuldade de preparo de uma receita.
enum Dificuldade {
  facil('Facil'),
  media('Media'),
  dificil('Dificil');

  const Dificuldade(this.label);
  final String label;
}

/// Categoria culinaria de uma receita.
enum CategoriaReceita {
  salgado('Salgado'),
  doce('Doce'),
  fit('Fit'),
  vegano('Vegano'),
  lowCarb('Low Carb'),
  proteico('Proteico'),
  rapido('Ate 20 min'),
  paraCongelar('Para congelar'),
  comWhey('Com whey');

  const CategoriaReceita(this.label);
  final String label;
}

/// Modelo de dominio de uma receita de lanche saudavel.
class Receita {
  const Receita({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.imagemUrl,
    required this.tempoPreparoMin,
    required this.porcoes,
    required this.dificuldade,
    required this.categoria,
    required this.ingredientes,
    required this.modoPreparo,
    required this.tags,
    required this.ehPremium,
    required this.publicadaEm,
    this.informacaoNutricional,
  });

  final String id;
  final String titulo;
  final String descricao;
  final String imagemUrl;
  final int tempoPreparoMin;
  final int porcoes;
  final Dificuldade dificuldade;
  final CategoriaReceita categoria;
  final List<String> ingredientes;
  final List<String> modoPreparo;
  final List<String> tags;
  final bool ehPremium;
  final DateTime publicadaEm;
  final String? informacaoNutricional;

  /// Desserializa a partir de um JSON.
  factory Receita.fromJson(Map<String, dynamic> json) {
    return Receita(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      descricao: json['descricao'] as String,
      imagemUrl: json['imagemUrl'] as String,
      tempoPreparoMin: json['tempoPreparoMin'] as int,
      porcoes: json['porcoes'] as int,
      dificuldade: Dificuldade.values.firstWhere(
        (d) => d.name == json['dificuldade'],
        orElse: () => Dificuldade.facil,
      ),
      categoria: CategoriaReceita.values.firstWhere(
        (c) => c.name == json['categoria'],
        orElse: () => CategoriaReceita.fit,
      ),
      ingredientes: (json['ingredientes'] as List<dynamic>).cast<String>(),
      modoPreparo: (json['modoPreparo'] as List<dynamic>).cast<String>(),
      tags: (json['tags'] as List<dynamic>).cast<String>(),
      ehPremium: json['ehPremium'] as bool? ?? false,
      publicadaEm: DateTime.parse(json['publicadaEm'] as String),
      informacaoNutricional: json['informacaoNutricional'] as String?,
    );
  }

  /// Serializa para JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'imagemUrl': imagemUrl,
      'tempoPreparoMin': tempoPreparoMin,
      'porcoes': porcoes,
      'dificuldade': dificuldade.name,
      'categoria': categoria.name,
      'ingredientes': ingredientes,
      'modoPreparo': modoPreparo,
      'tags': tags,
      'ehPremium': ehPremium,
      'publicadaEm': publicadaEm.toIso8601String(),
      'informacaoNutricional': informacaoNutricional,
    };
  }
}
