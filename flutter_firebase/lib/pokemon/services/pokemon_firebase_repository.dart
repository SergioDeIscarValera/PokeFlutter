import 'package:cloud_firestore/cloud_firestore.dart';

class PokemonFireBaseRepository{
  Future<List<int>> getFavorites({required String email}) async {
    return await FirebaseFirestore.instance
      .collection("favorites")
      .doc(email)
      .get()
      .then((value) => value.data()?["favorites"].cast<int>() ?? []);
  }

  Future<void> setFavorites({required String email, required List<int> favorites}) async {
    await FirebaseFirestore.instance
      .collection("favorites")
      .doc(email)
      .set({"favorites": favorites}, SetOptions(merge: true));
  }
}