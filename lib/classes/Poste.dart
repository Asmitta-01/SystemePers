class Poste {
  final int _id = 0;
  String? _designationPoste;
  String? _description;

  Poste({required String nomDuPoste, required String description}) {
    _description = description;
    _designationPoste = nomDuPoste;
  }

  String get poste => _designationPoste!;
  set poste(String nomPoste) => _designationPoste = nomPoste;
}

var listePostes = [
  Poste(nomDuPoste: 'Secretaire', description: 'Ecrire quand il le faut...'),
  Poste(nomDuPoste: 'Professeur', description: 'Enseigner lse etudiants'),
  Poste(nomDuPoste: 'Docteur', description: 'Enseigner lse etudiants avec rigueur'),
  Poste(nomDuPoste: 'Directeur', description: 'Diriger l\' universite'),
  Poste(nomDuPoste: 'Surveillant?', description: 'Bah surveiller l\' universite'),
];
