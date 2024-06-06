import 'package:proyecto_gestion/data/product.dart';

class Room {
  final String id;
  final int number;
  final String type;
  final String imageRoute;
  List<Product>? products;

  Room({required this.id, required this.number, required this.type, required this.imageRoute, this.products});
}

Map<String, List<Room>> roomMap = {};

Future<void> generateRoomMap() async {
  roomMap = {
    'Individual': List.generate(
      10,
      (int i) => Room(
          id: (i + 1).toString(),
          number: (i + 1),
          type: 'Individual',
          imageRoute: 'assets/individual.png',
          products: individualProducts)),
  'Doble': List.generate(
      10,
      (int i) => Room(
          id: (i + 10 + 1).toString(),
          number: (i + 10 + 1),
          type: 'Doble',
          imageRoute: 'assets/doble.png',
          products: doubleProducts)),
  'Familiar': List.generate(
      6,
      (int i) => Room(
          id: (i + 20 + 1).toString(),
          number: (i + 20 + 1),
          type: 'Familiar',
          imageRoute: 'assets/familiar.png',
          products: familiarProducts)),
  'Suite': List.generate(
      4,
      (int i) => Room(
          id: (i + 26 + 1).toString(),
          number: (i + 26 + 1),
          type: 'Suite',
          imageRoute: 'assets/suite.png',
          products: suiteProducts)),
  };
}