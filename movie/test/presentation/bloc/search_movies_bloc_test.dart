import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/entities/movie.dart';


import 'package:movie/domain/usecases/search_movies.dart';
import 'package:movie/presentation/bloc/search_movies_bloc.dart';

import 'search_movies_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late SearchMoviesBloc bloc;
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    bloc = SearchMoviesBloc(mockSearchMovies);
  });

  const tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tData = <Movie>[tMovie];

  test('initial state should be empty', () {
    expect(bloc.state, SearchMoviesEmpty());
  });

  blocTest<SearchMoviesBloc, SearchMoviesState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchMovies.execute('spiderman'))
          .thenAnswer((_) async => Right(tData));
      return bloc;
    },
    act: (bloc) => bloc.add(const FetchSearchMovies('spiderman')),
    expect: () => [
      SearchMoviesLoading(),
      SearchMoviesHasData(tData),
    ],
    verify: (bloc) {
      verify(mockSearchMovies.execute('spiderman'));
    },
  );

  blocTest<SearchMoviesBloc, SearchMoviesState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockSearchMovies.execute('spiderman'))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(const FetchSearchMovies('spiderman')),
    expect: () => [
      SearchMoviesLoading(),
      const SearchMoviesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchMovies.execute('spiderman'));
    },
  );
}
