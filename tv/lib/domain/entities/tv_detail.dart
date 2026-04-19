import 'package:core/domain/entities/genre.dart';
import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/season.dart';

class TvDetail extends Equatable {
  TvDetail({
    required this.backdropPath,
    required this.genres,
    required this.id,
    required this.originalName,
    required this.overview,
    required this.posterPath,
    required this.firstAirDate,
    required this.name,
    required this.voteAverage,
    required this.voteCount,
    required this.seasons,
  });

  final String? backdropPath;
  final List<Genre> genres;
  final int id;
  final String originalName;
  final String overview;
  final String? posterPath;
  final String firstAirDate;
  final String name;
  final double voteAverage;
  final int voteCount;
  final List<Season> seasons;

  @override
  List<Object?> get props => [
        backdropPath,
        genres,
        id,
        originalName,
        overview,
        posterPath,
        firstAirDate,
        name,
        voteAverage,
        voteCount,
        seasons,
      ];
}
