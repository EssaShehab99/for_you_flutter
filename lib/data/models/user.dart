class User{
  String? id;
  String name;
  String phone;
  int age;
  double height;
  double weight;
  String blood;
  String socialStatus;
  String? password;

  User(
      {this.id,
      required this.name,
      required this.phone,
      required this.age,
      required this.height,
      required this.weight,
      required this.blood,
      required this.socialStatus,
       this.password});
}