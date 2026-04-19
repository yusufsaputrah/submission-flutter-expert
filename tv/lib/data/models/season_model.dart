import 'package:tv/domain/entities/season.dart';
import 'package:equatable/equatable.dart';

class SeasonModel extends Equatable {
  final int id;
  final String? posterPath;
  final int seasonNumber;
  final int episodeCount;
  final String name;
  final String overview;

  SeasonModel({
    required this.id,
    required this.posterPath,
    required this.seasonNumber,
    required this.episodeCount,
    required this.name,
    required this.overview,
  });

  factory SeasonModel.fromJson(Map<String, dynamic> json) => SeasonModel(
        id: json["id"],
        posterPath: json["poster_path"],
        seasonNumber: json["season_number"],
        episodeCount: json["episode_count"],
        name: json["name"],
        overview: json["overview"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "poster_path": posterPath,
        "season_number": seasonNumber,
        "episode_count": episodeCount,
        "name": name,
        "overview": overview,
      };

  Season toEntity() {
    return Season(
      id: this.id,
      posterPath: this.posterPath,
      seasonNumber: this.seasonNumber,
      episodeCount: this.episodeCount,
      name: this.name,
      overview: this.overview,
    );
  }

  @override
  List<Object?> get props => [
        id,
        posterPath,
        seasonNumber,
        episodeCount,
        name,
        overview,
      ];
}
