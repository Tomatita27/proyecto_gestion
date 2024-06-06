import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_gestion/data/product.dart';
import 'package:proyecto_gestion/data/room.dart';
import 'package:uuid/uuid.dart';

Future<void> addRoom(Room room) {
  return FirebaseFirestore.instance.collection('habitaciones').doc(room.id).set({
    'id': room.id,
    'numero': room.number,
    'tipo': room.type,
    'imagen': room.imageRoute,
    'productos': room.products!.map((product) => {
      'id': product.id,
      'nombre': product.name,
      'cantidad': product.quantity,
      'imagen': product.imageRoute,
    }).toList(),
  });
}

Future<void> addProductToRoom(String roomId, String productName, int quantity, String imagePath) async {
  try {
    if (productName.isNotEmpty && quantity > 0 && imagePath.isNotEmpty) {
      await FirebaseFirestore.instance.collection('habitaciones').doc(roomId).update({
        'productos': FieldValue.arrayUnion([
          {
            'id': const Uuid().v4(),
            'nombre': productName,
            'cantidad': quantity,
            'imagen': imagePath,
          }
        ])
      });
    } else {
      throw Exception('Todos los campos son obligatorios');
    }
  } catch (error) {
    throw Exception('Error al agregar el producto: $error');
  }
}

Future<void> addIncident(String description, Timestamp date) async {
  try {
    if (description.isNotEmpty) {
      await FirebaseFirestore.instance.collection('incidentes').add({
        'id': const Uuid().v4(),
        'descripcion': description,
        'fecha': date,
      });
    } else {
      throw Exception('Todos los campos son obligatorios');
    }
  } catch (error) {
    throw Exception('Error al agregar el incidente: $error');
  }
}

Future<void> addNote(String description, String productId, Timestamp date) async {
  try {
    if (description.isNotEmpty) {
      await FirebaseFirestore.instance.collection('notas').add({
        'id': const Uuid().v4(),
        'descripcion': description,
        'producto_id': productId,
        'fecha': date,
      });
    } else {
      throw Exception('Todos los campos son obligatorios');
    }
  } catch (error) {
    throw Exception('Error al agregar la nota: $error');
  }
}

Future<List<Room>> getRooms() async {
  try {
    final rooms = await FirebaseFirestore.instance.collection('habitaciones').get();
    final List<Room> roomsList = [];
    for (final doc in rooms.docs) {
      // print(doc.data());
      roomsList.add(Room(
        id: doc.id,
        number: doc.data()['numero'],
        type: doc.data()['tipo'],
        imageRoute: doc.data()['imagen'],
        products: doc.data()['productos'].map<Product>((product) => Product(
          id: product['id'],
          name: product['nombre'],
          quantity: product['cantidad'],
          imageRoute: product['imagen'],
        )).toList(),
      ));
    }
    return roomsList;
  } catch (error) {
    throw Exception('Error al obtener las habitaciones: $error');
  }
}

Future<List<Product>> getProductsFromRoom(String roomId) async {
  try {
    final room = await FirebaseFirestore.instance.collection('habitaciones').doc(roomId).get();
    return room.data()?['productos'].map<Product>((product) => Product(
      id: product['id'],
      name: product['nombre'],
      quantity: product['cantidad'],
      imageRoute: product['imagen'],
    )).toList() ?? [];
  } catch (error) {
    throw Exception('Error al obtener los productos: $error');
  }
}