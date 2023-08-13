abstract interface class WebOsPointerAPI {
  Future<bool> moveIt(double dx, double dy, bool drag);

  Future<bool> scroll(double dx, double dy);

  Future<bool> click();
}
