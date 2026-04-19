import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:movie/domain/entities/movie.dart';


abstract class PopularMoviesEvent extends Equatable {
  const PopularMoviesEvent();
  @override
  List<Object> get props => [];
}
class FetchPopularMovies extends PopularMoviesEvent {
}

abstract class PopularMoviesState extends Equatable {
  const PopularMoviesState();
  @override
  List<Object> get props => [];
}

class PopularMoviesEmpty extends PopularMoviesState {}
class PopularMoviesLoading extends PopularMoviesState {}
class PopularMoviesError extends PopularMoviesState {
  final String message;
  const PopularMoviesError(this.message);
  @override
  List<Object> get props => [message];
}
class PopularMoviesHasData extends PopularMoviesState {
  final List<Movie> result;
  const PopularMoviesHasData(this.result);
  @override
  List<Object> get props => [result];
}

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final GetPopularMovies usecase;
  PopularMoviesBloc(this.usecase) : super(PopularMoviesEmpty()) {
    on<FetchPopularMovies>((event, emit) async {
      emit(PopularMoviesLoading());
      final result = await usecase.execute();
      result.fold(
        (failure) => emit(PopularMoviesError(failure.message)),
        (data) => emit(PopularMoviesHasData(data)),
      );
    });
  }
}
