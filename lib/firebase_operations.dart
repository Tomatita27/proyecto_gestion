
Future<void> printMessage() {
  return Future.delayed(
    const Duration(seconds: 5),
    () {
      print("Hola");
    }
  );
}

