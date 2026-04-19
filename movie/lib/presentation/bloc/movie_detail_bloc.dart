import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';


abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();
  @override
  List<Object> get props => [];
}
class FetchMovieDetail extends MovieDetailEvent {
  final int id;
  FetchMovieDetail(this.id);
  @override
  List<Object> get props => [id];
}

abstract class MovieDetailState extends Equatable {
  const MovieDetailState();
  @override
  List<Object> get props => [];
}

class MovieDetailEmpty extends MovieDetailState {}
class MovieDetailLoading extends MovieDetailState {}
class MovieDetailError extends MovieDetailState {
  final String message;
  MovieDetailError(this.message);
  @override
  List<Object> get props => [message];
}
class MovieDetailHasData extends MovieDetailState {
  final MovieDetail result;
  MovieDetailHasData(this.result);
  @override
  List<Object> get props => [result];
}

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail usecase;
  MovieDetailBloc(this.usecase) : super(MovieDetailEmpty()) {
    on<FetchMovieDetail>((event, emit) async {
      emit(MovieDetailLoading());
      final result = await usecase.execute(event.id);
      result.fold(
        (failure) => emit(MovieDetailError(failure.message)),
        (data) => emit(MovieDetailHasData(data)),
      );
    });
  }
}
