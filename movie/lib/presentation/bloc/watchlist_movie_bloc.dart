import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/domain/usecases/get_watchlist_movies.dart';
import 'package:movie/domain/usecases/get_watchlist_status.dart';
import 'package:movie/domain/usecases/remove_watchlist.dart';
import 'package:movie/domain/usecases/save_watchlist.dart';

abstract class WatchlistMovieEvent extends Equatable {
  const WatchlistMovieEvent();
  @override
  List<Object> get props => [];
}

class FetchWatchlistMovies extends WatchlistMovieEvent {}

class LoadWatchlistMovieStatus extends WatchlistMovieEvent {
  final int id;
  LoadWatchlistMovieStatus(this.id);
  @override
  List<Object> get props => [id];
}

class AddMovieToWatchlist extends WatchlistMovieEvent {
  final MovieDetail movie;
  AddMovieToWatchlist(this.movie);
  @override
  List<Object> get props => [movie];
}

class RemoveMovieFromWatchlist extends WatchlistMovieEvent {
  final MovieDetail movie;
  RemoveMovieFromWatchlist(this.movie);
  @override
  List<Object> get props => [movie];
}

abstract class WatchlistMovieState extends Equatable {
  const WatchlistMovieState();
  @override
  List<Object> get props => [];
}

class WatchlistMovieEmpty extends WatchlistMovieState {}
class WatchlistMovieLoading extends WatchlistMovieState {}

class WatchlistMovieError extends WatchlistMovieState {
  final String message;
  WatchlistMovieError(this.message);
  @override
  List<Object> get props => [message];
}

class WatchlistMovieHasData extends WatchlistMovieState {
  final List<Movie> result;
  WatchlistMovieHasData(this.result);
  @override
  List<Object> get props => [result];
}

class WatchlistMovieStatusLoaded extends WatchlistMovieState {
  final bool isAdded;
  WatchlistMovieStatusLoaded(this.isAdded);
  @override
  List<Object> get props => [isAdded];
}

class WatchlistMovieMessage extends WatchlistMovieState {
  final String message;
  WatchlistMovieMessage(this.message);
  @override
  List<Object> get props => [message];
}

class WatchlistMovieBloc extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchlistMovies getWatchlistMovies;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  WatchlistMovieBloc({
    required this.getWatchlistMovies,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(WatchlistMovieEmpty()) {
  
    on<FetchWatchlistMovies>((event, emit) async {
      emit(WatchlistMovieLoading());
      final result = await getWatchlistMovies.execute();
      result.fold(
        (failure) => emit(WatchlistMovieError(failure.message)),
        (data) => emit(WatchlistMovieHasData(data)),
      );
    });

    on<LoadWatchlistMovieStatus>((event, emit) async {
      final result = await getWatchListStatus.execute(event.id);
      emit(WatchlistMovieStatusLoaded(result));
    });

    on<AddMovieToWatchlist>((event, emit) async {
      final result = await saveWatchlist.execute(event.movie);
      result.fold(
        (failure) => emit(WatchlistMovieError(failure.message)),
        (successMessage) => emit(WatchlistMovieMessage(successMessage)),
      );
      add(LoadWatchlistMovieStatus(event.movie.id));
    });

    on<RemoveMovieFromWatchlist>((event, emit) async {
      final result = await removeWatchlist.execute(event.movie);
      result.fold(
        (failure) => emit(WatchlistMovieError(failure.message)),
        (successMessage) => emit(WatchlistMovieMessage(successMessage)),
      );
      add(LoadWatchlistMovieStatus(event.movie.id));
    });
  }
}
