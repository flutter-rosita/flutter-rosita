library rosita;

export 'src/extensions/color.dart';
export 'src/extensions/rrect.dart';
export 'src/rendering/rosita_paragraph.dart';
export 'src/rendering/rosita_rect.dart';
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
export 'src/widgets/rosita_image.dart';
export 'src/widgets/rosita_rich_text.dart';
export 'src/widgets/rosita_svg_picture.dart';
export 'src/widgets/rosita_text.dart';

const kIsRosita = bool.fromEnvironment('ROSITA');

const rositaDisableSemantics = bool.fromEnvironment('ROSITA_DISABLE_SEMANTICS', defaultValue: true);

const rositaEnableSemantics = !rositaDisableSemantics;

const rositaSkipSlowFrames = bool.fromEnvironment('ROSITA_SKIP_SLOW_FRAMES', defaultValue: true);

const rositaCastNullableToNonNullable =
    bool.fromEnvironment('ROSITA_CAST_NULLABLE_TO_NON_NULLABLE', defaultValue: true);
