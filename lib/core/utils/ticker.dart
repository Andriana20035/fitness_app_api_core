/// Emits the remaining seconds once per second: `ticks - 1, ..., 0`.
/// Injected into the timer cubit so tests can use a fast fake.
class Ticker {
  const Ticker();

  Stream<int> tick({required int ticks}) => Stream.periodic(
        const Duration(seconds: 1),
        (x) => ticks - x - 1,
      ).take(ticks);
}
