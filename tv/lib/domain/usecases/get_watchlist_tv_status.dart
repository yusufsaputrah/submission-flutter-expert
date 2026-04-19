import 'package:tv/domain/repositories/tv_repository.dart';

class GetWatchlistTvStatus {
  final TvRepository repository;

  GetWatchlistTvStatus(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}
