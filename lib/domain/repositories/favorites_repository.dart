abstract interface class FavoritesRepository {
  Future<Set<String>> getFavoriteIds();

  Future<void> saveFavoriteIds(Set<String> ids);
}
