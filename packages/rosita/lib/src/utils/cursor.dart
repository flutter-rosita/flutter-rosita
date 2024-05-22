class RositaCursorUtils {
  static bool _changed = false;

  static bool get changed => _changed;

  static void onChange() => _changed = true;

  static void callAfterDrawFrame() => _changed = false;
}
