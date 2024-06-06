import 'package:proyecto_gestion/data/product.dart';

class Room {
  final String id;
  final String type;
  final String imageRoute;
  List<Product>? products;
  
  Room({required this.id, required this.type, required this.imageRoute, this.products});
}