library rosita;

export 'src/extensions/color.dart';
export 'src/extensions/rrect.dart';
export 'src/rendering/rosita_paragraph.dart';
export 'src/rendering/rosita_render_box.dart';
export 'src/rendering/rosita_render_object.dart';
export 'src/utils/border.dart';
export 'src/utils/box_fit.dart';
export 'src/utils/image.dart';
export 'src/utils/opacity.dart';
export 'src/utils/paragraph.dart';
export 'src/utils/radius.dart';
export 'src/utils/scroll.dart';
export 'src/utils/text_style.dart';
export 'src/widgets/rosita_color_r_box.dart';
export 'src/widgets/rosita_element.dart';
export 'src/widgets/rosita_image.dart';
export 'src/widgets/rosita_repaint_boundary.dart';
export 'src/widgets/rosita_rich_text.dart';
export 'src/widgets/rosita_semantics.dart';
export 'src/widgets/rosita_svg_picture.dart';
export 'src/widgets/rosita_text.dart';

Duration rositaTimeStamp = Duration.zero;

const kIsRosita = bool.fromEnvironment('ROSITA');

const rositaDisableSemantics = bool.fromEnvironment('ROSITA_DISABLE_SEMANTICS', defaultValue: true);

const rositaEnableSemantics = !rositaDisableSemantics;

const rositaCastNullableToNonNullable =
    bool.fromEnvironment('ROSITA_CAST_NULLABLE_TO_NON_NULLABLE', defaultValue: true);

const rositaDisableRoutesChanged = bool.fromEnvironment('ROSITA_DISABLE_ROUTES_CHANGED', defaultValue: true);

const rositaEnableRoutesChanged = !rositaDisableRoutesChanged;

const rositaEnableVisitChildren = bool.fromEnvironment('ROSITA_ENABLE_VISIT_CHILDREN', defaultValue: true);

const rositaDisableUpdateCompositingBits =
    bool.fromEnvironment('ROSITA_DISABLE_UPDATE_COMPOSITING_BITS', defaultValue: true);

const rositaEnableUpdateCompositingBits = !rositaDisableUpdateCompositingBits;

const rositaDisableLayoutMarkNeedsPaint =
    bool.fromEnvironment('ROSITA_DISABLE_LAYOUT_MARK_NEEDS_PAINT', defaultValue: true);

const rositaEnableLayoutMarkNeedsPaint = !rositaDisableLayoutMarkNeedsPaint;
