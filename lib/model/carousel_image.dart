class CarouselImage {
  final String imageUrl;





  CarouselImage({ this.imageUrl});

  factory CarouselImage.fromJson(Map<String, dynamic> json) {
    return CarouselImage(
        imageUrl : json['Url']


    );
  }


}