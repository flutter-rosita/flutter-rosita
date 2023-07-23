// ignore_for_file: public_member_api_docs

import 'package:rosita/rosita.dart';

mixin RositaSkipRenderObjectMixin on RositaRenderMixin {
  @override
  void createRositaElement() {
    // Skip create HTML element
  }
}
