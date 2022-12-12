class Poste {
  int? _id;
  String? _designationPoste;
  String? _description;

  Poste({int? id, required String nomDuPoste, required String description}) {
    _id = id;
    _description = description;
    _designationPoste = nomDuPoste;
  }

  int get id => _id!;

  String get poste => _designationPoste!;
  set poste(String nomPoste) => _designationPoste = nomPoste;

  String get descriptionPoste => _description!;
}

var listePostes = [
  Poste(nomDuPoste: 'Secretaire', description: 'Ecrire quand il le faut...'),
  Poste(nomDuPoste: 'Professeur', description: 'Enseigner lse etudiants'),
  Poste(nomDuPoste: 'Docteur', description: 'Enseigner lse etudiants avec rigueur'),
  Poste(nomDuPoste: 'Directeur', description: 'Diriger l\' universite'),
  Poste(nomDuPoste: 'Surveillant?', description: 'Bah surveiller l\' universite'),
];
