import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/domain/usecases/get_watchlist_tvs.dart';
import 'package:tv/domain/usecases/get_watchlist_tv_status.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:tv/domain/usecases/save_watchlist_tv.dart';

abstract class WatchlistTvEvent extends Equatable {
  const WatchlistTvEvent();
  @override
  List<Object> get props => [];
}

class FetchWatchlistTvs extends WatchlistTvEvent {}

class LoadWatchlistTvStatus extends WatchlistTvEvent {
  final int id;
  const LoadWatchlistTvStatus(this.id);
  @override
  List<Object> get props => [id];
}

class AddTvToWatchlist extends WatchlistTvEvent {
  final TvDetail tv;
  const AddTvToWatchlist(this.tv);
  @override
  List<Object> get props => [tv];
}

class RemoveTvFromWatchlist extends WatchlistTvEvent {
  final TvDetail tv;
  const RemoveTvFromWatchlist(this.tv);
  @override
  List<Object> get props => [tv];
}

abstract class WatchlistTvState extends Equatable {
  const WatchlistTvState();
  @override
  List<Object> get props => [];
}

class WatchlistTvEmpty extends WatchlistTvState {}
class WatchlistTvLoading extends WatchlistTvState {}

class WatchlistTvError extends WatchlistTvState {
  final String message;
  const WatchlistTvError(this.message);
  @override
  List<Object> get props => [message];
}

class WatchlistTvHasData extends WatchlistTvState {
  final List<Tv> result;
  const WatchlistTvHasData(this.result);
  @override
  List<Object> get props => [result];
}

class WatchlistTvStatusLoaded extends WatchlistTvState {
  final bool isAdded;
  const WatchlistTvStatusLoaded(this.isAdded);
  @override
  List<Object> get props => [isAdded];
}

class WatchlistTvMessage extends WatchlistTvState {
  final String message;
  const WatchlistTvMessage(this.message);
  @override
  List<Object> get props => [message];
}

class WatchlistTvBloc extends Bloc<WatchlistTvEvent, WatchlistTvState> {
  final GetWatchlistTvs getWatchlistTvs;
  final GetWatchlistTvStatus getWatchListStatusTv;
  final SaveWatchlistTv saveWatchlistTv;
  final RemoveWatchlistTv removeWatchlistTv;

  WatchlistTvBloc({
    required this.getWatchlistTvs,
    required this.getWatchListStatusTv,
    required this.saveWatchlistTv,
    required this.removeWatchlistTv,
  }) : super(WatchlistTvEmpty()) {
  
    on<FetchWatchlistTvs>((event, emit) async {
      emit(WatchlistTvLoading());
      final result = await getWatchlistTvs.execute();
      result.fold(
        (failure) => emit(WatchlistTvError(failure.message)),
        (data) => emit(WatchlistTvHasData(data)),
      );
    });

    on<LoadWatchlistTvStatus>((event, emit) async {
      final result = await getWatchListStatusTv.execute(event.id);
      emit(WatchlistTvStatusLoaded(result));
    });

    on<AddTvToWatchlist>((event, emit) async {
      final result = await saveWatchlistTv.execute(event.tv);
      result.fold(
        (failure) => emit(WatchlistTvError(failure.message)),
        (successMessage) => emit(WatchlistTvMessage(successMessage)),
      );
      add(LoadWatchlistTvStatus(event.tv.id));
    });

    on<RemoveTvFromWatchlist>((event, emit) async {
      final result = await removeWatchlistTv.execute(event.tv);
      result.fold(
        (failure) => emit(WatchlistTvError(failure.message)),
        (successMessage) => emit(WatchlistTvMessage(successMessage)),
      );
      add(LoadWatchlistTvStatus(event.tv.id));
    });
  }
}
