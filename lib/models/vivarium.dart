class Vivarium {
  final String name; // is used as ID
  final VivariumType type;
  final num? height; // in cm
  final num? width; // in cm
  final num? depth; // in cm
  final num? tempMin; // in °C
  final num? tempMax; // in °C

  final List<String> inhabitants; // animals that live in this vivarium
  final List<String> responsible; // students that take care of this vivarium

  DateTime created = DateTime.now();

  Vivarium(this.name, this.type, this.height, this.width, this.depth,
      this.tempMin, this.tempMax, this.inhabitants, this.responsible);

  Vivarium.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        type = VivariumType.fromLabel(json['type']),
        height = json['height'],
        width = json['width'],
        depth = json['depth'],
        tempMin = json['tempMin'],
        tempMax = json['tempMax'],
        inhabitants = List<String>.from(json['inhabitants']),
        responsible = List<String>.from(json['responsible']),
        created = DateTime.parse(json['created']
            .toDate()
            .toString()); // firestore database saves dates as 'Timestamps'

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type.label,
        'height': height,
        'width': width,
        'depth': depth,
        'tempMin': tempMin,
        'tempMax': tempMax,
        'inhabitants': inhabitants,
        'responsible': responsible,
        'created': created
      };
}

enum VivariumType {
  aquarium("Aquarium"),
  terrarium("Terrarium"),
  aquaterrarium("Aquaterrarium");

  final String label;

  const VivariumType(this.label);

  // get Enum from String
  factory VivariumType.fromLabel(String label) {
    return values.firstWhere((sr) => sr.label == label);
  }
}
