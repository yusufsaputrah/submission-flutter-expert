import 'package:core/data/models/genre_model.dart';
import 'package:tv/data/models/tv_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvDetailResponse = TvDetailResponse(
    backdropPath: 'backdropPath',
    genres: [GenreModel(id: 1, name: 'Action')],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    name: 'name',
    voteAverage: 1.0,
    voteCount: 1,
    seasons: [],
  );

  test('should return a valid TvDetailResponse from JSON', () {
    // arrange
    final Map<String, dynamic> jsonMap = {
      "backdrop_path": "backdropPath",
      "genres": [
        {"id": 1, "name": "Action"}
      ],
      "id": 1,
      "original_name": "originalName",
      "overview": "overview",
      "poster_path": "posterPath",
      "first_air_date": "firstAirDate",
      "name": "name",
      "vote_average": 1.0,
      "vote_count": 1
    };
    // act
    final result = TvDetailResponse.fromJson(jsonMap);
    // assert
    expect(result, tTvDetailResponse);
  });

  test('should return a valid JSON map containing proper data', () {
    // arrange
    final expectedJsonMap = {
      "backdrop_path": "backdropPath",
      "genres": [
        {"id": 1, "name": "Action"}
      ],
      "id": 1,
      "original_name": "originalName",
      "overview": "overview",
      "poster_path": "posterPath",
      "first_air_date": "firstAirDate",
      "name": "name",
      "vote_average": 1.0,
      "vote_count": 1,
      "seasons": [],
    };
    // act
    final result = tTvDetailResponse.toJson();
    // assert
    expect(result, expectedJsonMap);
  });

  test('should transform to entity properly', () {
    // act
    final result = tTvDetailResponse.toEntity();
    // assert
    expect(result.id, 1);
    expect(result.name, 'name');
    expect(result.genres.length, 1);
    expect(result.genres.first.name, 'Action');
  });
}
