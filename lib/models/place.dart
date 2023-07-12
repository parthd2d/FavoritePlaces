class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;

  const PlaceLocation({
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}

class Place {
  final String title;
  final String id;
  final String imageUrl;
  final String imageId;
  final PlaceLocation location;
  Place({
    required this.imageId,
    required this.title,
    required this.imageUrl,
    required this.location,
    required this.id,
  });
}
