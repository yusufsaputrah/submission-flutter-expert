import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/entities/movie.dart';


abstract class MovieRecommendationsEvent extends Equatable {
  const MovieRecommendationsEvent();
  @override
  List<Object> get props => [];
}
class FetchMovieRecommendations extends MovieRecommendationsEvent {
  final int id;
  const FetchMovieRecommendations(this.id);
  @override
  List<Object> get props => [id];
}

abstract class MovieRecommendationsState extends Equatable {
  const MovieRecommendationsState();
  @override
  List<Object> get props => [];
}

class MovieRecommendationsEmpty extends MovieRecommendationsState {}
class MovieRecommendationsLoading extends MovieRecommendationsState {}
class MovieRecommendationsError extends MovieRecommendationsState {
  final String message;
  const MovieRecommendationsError(this.message);
  @override
  List<Object> get props => [message];
}
class MovieRecommendationsHasData extends MovieRecommendationsState {
  final List<Movie> result;
  const MovieRecommendationsHasData(this.result);
  @override
  List<Object> get props => [result];
}

class MovieRecommendationsBloc extends Bloc<MovieRecommendationsEvent, MovieRecommendationsState> {
  final GetMovieRecommendations usecase;
  MovieRecommendationsBloc(this.usecase) : super(MovieRecommendationsEmpty()) {
    on<FetchMovieRecommendations>((event, emit) async {
      emit(MovieRecommendationsLoading());
      final result = await usecase.execute(event.id);
      result.fold(
        (failure) => emit(MovieRecommendationsError(failure.message)),
        (data) => emit(MovieRecommendationsHasData(data)),
      );
    });
  }
}
