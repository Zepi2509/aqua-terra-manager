class Student {
  final String firstname;
  final String lastname;
  final SchoolClass schoolClass;
  final String email; // is used as ID
  final StudentRole role;
  DateTime created = DateTime.now();
  List<DateTime>? attendance;

  Student(this.firstname, this.lastname, this.schoolClass, this.email,
      this.role, this.attendance);

  Student.fromJson(Map<String, dynamic> json)
      : firstname = json['firstname'],
        lastname = json['lastname'],
        schoolClass = SchoolClass.fromLabel(json['schoolClass']),
        email = json['email'],
        role = StudentRole.fromLabel(json['role']),
        created = DateTime.parse(json['created'].toDate().toString()),
        // firestore database saves dates as 'Timestamps'
        attendance = List<DateTime>.from(json['attendance']
            .map((d) => DateTime.parse(d.toDate().toString())));

  Map<String, dynamic> toJson() => {
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'schoolClass': schoolClass.label,
        'role': role.label,
        'created': created,
        'attendance': attendance
      };
}

enum StudentRole {
  leiter("Leiter"),
  pfleger("Pfleger");

  final String label;

  const StudentRole(this.label);

  // get Enum from String
  factory StudentRole.fromLabel(String label) {
    return values.firstWhere((sr) => sr.label == label);
  }
}

enum SchoolClass {
  klasse5a("5a"),
  klasse5b("5b"),
  klasse5c("5c"),
  klasse5d("5d"),
  klasse6a("6a"),
  klasse6b("6b"),
  klasse6c("6c"),
  klasse6d("6d"),
  klasse11a("11a"),
  klasse11b("11b"),
  klasse11c("11c"),
  klasse11d("11d"),
  jahrgang12("Jg. 12"),
  jahrgang13("Jg. 13");

  final String label;

  const SchoolClass(this.label);

  factory SchoolClass.fromLabel(String label) {
    return values.firstWhere((sc) => sc.label == label);
  }
}
