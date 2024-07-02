class Country {
  final String name;
  final String flag;

  Country({
    required this.name,
    required this.flag,
  });

  factory Country.fromJson(Map<String, dynamic> data) {
    String name = data['name']['common'];
    String flag = data['flags']['png'];
    return Country(
      name: name,
      flag: flag,
    );
  }
}
