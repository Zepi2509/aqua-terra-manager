class Animal {
  final String
      name; // is used as ID; can be the name of an animal group, e.g. for Guppys
  final String speciesTrivial;
  final String speciesScientific;
  final Sex sex;
  final num? weight; // in gram
  final int? count;
  DateTime created = DateTime.now();
  final String image; // URL link to an image source (preferably png)

  Animal(this.name, this.speciesTrivial, this.speciesScientific, this.sex,
      this.weight, this.count, this.image);

  Animal.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        speciesTrivial = json['speciesTrivial'],
        speciesScientific = json['speciesScientific'],
        sex = Sex.fromLabel(json['sex']),
        weight = json['weight'],
        count = json['count'],
        created = DateTime.parse(json['created'].toDate().toString()),
        // firestore database saves dates as 'Timestamps'
        image = json['image'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'speciesTrivial': speciesTrivial,
        'speciesScientific': speciesScientific,
        'sex': sex.label,
        'weight': weight,
        'count': count,
        'created': created,
        'image': image
      };
}

enum Sex {
  male("männlich"),
  female("weiblich"),
  unknown(
      "unbekannt"); // use 'unknown' also for animal groups with mixed sex, e.g. Guppys

  final String label;

  const Sex(this.label);

  // get Enum from String
  factory Sex.fromLabel(String label) {
    return values.firstWhere((sr) => sr.label == label);
  }
}
