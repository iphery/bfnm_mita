class Assets {
  final String id_asset;
  final String description;
  final String manufacture;
  final String model;
  final String user;
  final String location;
  final String available;
  final String reserve;
  final String image;
  final String userImage;
  final String type;
  final String based;
  final String kelas;



  Assets({ this.id_asset , this.description, this.manufacture, this.model, this.user, this.location, this.available, this.reserve, this.image, this.userImage, this.type, this.based, this.kelas });

  factory Assets.fromJson(Map<String, dynamic> json) {
    return Assets(
        id_asset : json['ID_Asset'],
        description : json['Description'],
        manufacture : json['Manufacture'],
        model: json['Model'],
        user: json['User'],
        location : json['Location'],
        available: json['Available'],
        reserve: json['Reserve'],
        image: json['Image'],
        userImage: json['Profile_Image'],
        type:  json['Type'],
        based: json['Based'],
        kelas: json['Class']

    );
  }


}