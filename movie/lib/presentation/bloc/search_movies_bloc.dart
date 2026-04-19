import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/domain/usecases/search_movies.dart';
import 'package:movie/domain/entities/movie.dart';


abstract class SearchMoviesEvent extends Equatable {
  const SearchMoviesEvent();
  @override
  List<Object> get props => [];
}
class FetchSearchMovies extends SearchMoviesEvent {
  final String query;
  FetchSearchMovies(this.query);
  @override
  List<Object> get props => [query];
}

abstract class SearchMoviesState extends Equatable {
  const SearchMoviesState();
  @override
  List<Object> get props => [];
}

class SearchMoviesEmpty extends SearchMoviesState {}
class SearchMoviesLoading extends SearchMoviesState {}
class SearchMoviesError extends SearchMoviesState {
  final String message;
  SearchMoviesError(this.message);
  @override
  List<Object> get props => [message];
}
class SearchMoviesHasData extends SearchMoviesState {
  final List<Movie> result;
  SearchMoviesHasData(this.result);
  @override
  List<Object> get props => [result];
}

class SearchMoviesBloc extends Bloc<SearchMoviesEvent, SearchMoviesState> {
  final SearchMovies usecase;
  SearchMoviesBloc(this.usecase) : super(SearchMoviesEmpty()) {
    on<FetchSearchMovies>((event, emit) async {
      emit(SearchMoviesLoading());
      final result = await usecase.execute(event.query);
      result.fold(
        (failure) => emit(SearchMoviesError(failure.message)),
        (data) => emit(SearchMoviesHasData(data)),
      );
    });
  }
}
