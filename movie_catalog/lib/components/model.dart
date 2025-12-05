class Movie {
  final String id;
  final String title;
  final String? subititle;
  final String? coverUrl;
  final String? bannerUrl;
  final String? description;
  final String? director;
  final String? producer;
  final String? releaseDate;

  Movie({
    required this.id,
    required this.title,
    this.subititle,
    this.coverUrl,
    this.bannerUrl,
    this.description,
    this.director,
    this.producer,
    this.releaseDate,
  });
}