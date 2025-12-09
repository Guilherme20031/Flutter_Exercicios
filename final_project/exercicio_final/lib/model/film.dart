
class Film {
  final String id;
  final String title;
  final String? description;
  final String? director;
  final String? producer;
  final String? releaseDate;
  final String? runningTime;
  final String? rtScore;

  const Film({
    required this.id,
    required this.title,
    this.description,
    this.director,
    this.producer,
    this.releaseDate,
    this.runningTime,
    this.rtScore,
  });

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      director: json['director'] as String?,
      producer: json['producer'] as String?,
      releaseDate: json['release_date']?.toString(),
      runningTime: json['running_time']?.toString(),
      rtScore: json['rt_score']?.toString(),
    );
  }
}
