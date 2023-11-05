import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:favorite_places/models/place.dart';

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  Future<void> loadPlaces() async {
    final List<Place> loadedPlaces = [];

    final url = Uri.https('favorite-location-8ea47-default-rtdb.firebaseio.com',
        'user_places.json');
    final response = await http.get(url);

    final Map<String, dynamic> placesData = json.decode(response.body);

    placesData.forEach(
      (key, value) {
        loadedPlaces.add(
          Place(
            imageId: value['image_id'],
            id: key,
            title: value['title'],
            imageUrl: value['image'],
            location: PlaceLocation(
              address: value['address'],
              latitude: value['lat'],
              longitude: value['lng'],
            ),
          ),
        );
      },
    );

    loadedPlaces.sort(
      (a, b) {
        return a.title.compareTo(b.title);
      },
    );
    state = loadedPlaces;
  }

  Future<void> addPlace(String title, File image, PlaceLocation location,
      String imageName) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('places_images')
        .child('$imageName.jpg');

    await storageRef.putFile(image);
    final imageUrl = await storageRef.getDownloadURL();

    final url = Uri.https('favorite-location-8ea47-default-rtdb.firebaseio.com',
        'user_places.json');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': title,
        'image': imageUrl,
        'image_id': imageName,
        'lat': location.latitude,
        'lng': location.longitude,
        'address': location.address,
      }),
    );

    if (response.body == 'null') {
      return;
    }

    final id = json.decode(response.body)['name'];

    final newPlace = Place(
      imageId: imageName,
      title: title,
      imageUrl: imageUrl,
      location: location,
      id: id,
    );

    state = [
      newPlace,
      ...state,
    ];

    state.sort(
      (a, b) {
        return a.title.compareTo(b.title);
      },
    );
    state = state;

    return;
  }

  Future<bool> removePlace(String id) async {
    final placeToDelete = state.where((place) => place.id == id).toList()[0];

    final storageRef = FirebaseStorage.instance.ref();
    await storageRef
        .child('places_images')
        .child('${placeToDelete.imageId}.jpg')
        .delete();

    final url = Uri.https('favorite-location-8ea47-default-rtdb.firebaseio.com',
        'user_places/$id.json');
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      return false;
    }

    state = state.where((place) => place.id != id).toList();
    state.sort(
      (a, b) {
        return a.title.compareTo(b.title);
      },
    );
    return true;
  }

  void refreshData() async {
    loadPlaces();
    return;
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  (ref) => UserPlacesNotifier(),
);
