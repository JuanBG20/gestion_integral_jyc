class AddressEntity {
  final String street;
  final String number;
  final String location;
  final String province;
  final String? apartment;
  final String? floor;

  AddressEntity({
    required this.street,
    required this.number,
    required this.location,
    required this.province,
    this.apartment,
    this.floor,
  });
}
