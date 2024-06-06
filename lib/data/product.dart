class Product {
  final String id;
  final String name;
  final String imageRoute;
  int quantity;

  Product({required this.id, required this.name, required this.imageRoute, this.quantity = 0});
}