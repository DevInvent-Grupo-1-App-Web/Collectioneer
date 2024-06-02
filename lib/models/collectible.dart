class Collectible {
  int id;
  String description;
  String image;
  int communityId;
  String name;
  int ownerId;
  int value;

  Collectible({
    required this.id,
    required this.description,
    required this.image,
    required this.communityId,
    required this.name,
    required this.ownerId,
    required this.value,
  });

  Collectible.fromJson(Map<String, dynamic> json):
      id = json['id'],
      description = json['description'],
      image = json['image'],
      communityId = json['communityId'],
      name = json['name'],
      ownerId = json['ownerId'],
      value = json['value'];
    
  
}