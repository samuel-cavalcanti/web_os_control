enum TvState { connected, disconect, connecting }

extension TvStateMap on Future<bool> {
  Future<TvState> toTVState() async {
    final bool state = await this;

    return state ? TvState.connected : TvState.disconect;
  }
}
