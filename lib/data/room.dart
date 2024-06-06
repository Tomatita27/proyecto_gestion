import 'package:proyecto_gestion/data/firebase_operations.dart';
import 'package:proyecto_gestion/data/product.dart';
import 'package:uuid/uuid.dart';

class Room {
  final String id;
  final int number;
  final String type;
  final String imageRoute;
  List<Product>? products;

  Room({required this.id, required this.number, required this.type, required this.imageRoute, this.products});
}

Map<String, List<Room>> roomMap = {};

Future<void> initializeRoomMap() async {
  List<Room> roomList = await getRooms();

  for (Room room in roomList) {
    roomMap.putIfAbsent(room.type, () => []);
    roomMap[room.type]!.add(room);
  }

  for (String key in roomMap.keys) {
    roomMap[key]!.sort((a, b) => a.number.compareTo(b.number));
  }
}

// Future<void> generateRoomMap() async {
//   roomMap = {
//     'Individual': List.generate(
//       10,
//       (int i) => Room(
//           id: (i + 1).toString(),
//           number: (i + 1),
//           type: 'Individual',
//           imageRoute: 'assets/individual.png',
//           products: individualProducts)),
//   'Doble': List.generate(
//       10,
//       (int i) => Room(
//           id: (i + 10 + 1).toString(),
//           number: (i + 10 + 1),
//           type: 'Doble',
//           imageRoute: 'assets/doble.png',
//           products: doubleProducts)),
//   'Familiar': List.generate(
//       6,
//       (int i) => Room(
//           id: (i + 20 + 1).toString(),
//           number: (i + 20 + 1),
//           type: 'Familiar',
//           imageRoute: 'assets/familiar.png',
//           products: familiarProducts)),
//   'Suite': List.generate(
//       4,
//       (int i) => Room(
//           id: (i + 26 + 1).toString(),
//           number: (i + 26 + 1),
//           type: 'Suite',
//           imageRoute: 'assets/suite.png',
//           products: suiteProducts)),
//   };
// }

// Future<void> generateRoomMapPro() async {
//   roomMap = {
//     'Individual': List.generate(
//       10,
//       (int i) {
//         var room = Room(
//           id: const Uuid().v4(),
//           number: (i + 1),
//           type: 'Individual',
//           imageRoute: 'assets/individual.png',
//           products: individualProducts);
//         addRoom(room);
//         return room;
//       }
//     ),
//   'Doble': List.generate(
//       10,
//       (int i) {
//         var room = Room(
//           id: const Uuid().v4(),
//           number: (i + 10 + 1),
//           type: 'Doble',
//           imageRoute: 'assets/doble.png',
//           products: doubleProducts);
//         addRoom(room);
//         return room;
//       }
//     ),
//   'Familiar': List.generate(
//       6,
//       (int i) {
//         var room = Room(
//           id: const Uuid().v4(),
//           number: (i + 20 + 1),
//           type: 'Familiar',
//           imageRoute: 'assets/familiar.png',
//           products: doubleProducts);
//         addRoom(room);
//         return room;
//       }
//     ),
//   'Suite': List.generate(
//       4,
//       (int i) {
//         var room = Room(
//           id: const Uuid().v4(),
//           number: (i + 26 + 1),
//           type: 'Suite',
//           imageRoute: 'assets/suite.png',
//           products: doubleProducts);
//         addRoom(room);
//         return room;
//       }
//     ),
//   };
// }