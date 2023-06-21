class RositaScrollUtils {
  static bool _scrolled = false;

  static bool get scrolled => _scrolled;

  static void onScroll() => _scrolled = true;

  static void callAfterDrawFrame() => _scrolled = false;
}
