import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:rosita/rosita.dart';

// ignore: non_constant_identifier_names
Widget RositaSemantics({
  Key? key,
  Widget? child,
  bool container = false,
  bool explicitChildNodes = false,
  bool excludeSemantics = false,
  bool blockUserActions = false,
  bool? enabled,
  bool? checked,
  bool? mixed,
  bool? selected,
  bool? toggled,
  bool? button,
  bool? slider,
  bool? keyboardKey,
  bool? link,
  bool? header,
  bool? textField,
  bool? readOnly,
  bool? focusable,
  bool? focused,
  bool? inMutuallyExclusiveGroup,
  bool? obscured,
  bool? multiline,
  bool? scopesRoute,
  bool? namesRoute,
  bool? hidden,
  bool? image,
  bool? liveRegion,
  bool? expanded,
  int? maxValueLength,
  int? currentValueLength,
  String? identifier,
  String? label,
  AttributedString? attributedLabel,
  String? value,
  AttributedString? attributedValue,
  String? increasedValue,
  AttributedString? attributedIncreasedValue,
  String? decreasedValue,
  AttributedString? attributedDecreasedValue,
  String? hint,
  AttributedString? attributedHint,
  String? tooltip,
  String? onTapHint,
  String? onLongPressHint,
  TextDirection? textDirection,
  SemanticsSortKey? sortKey,
  SemanticsTag? tagForChildren,
  VoidCallback? onTap,
  VoidCallback? onLongPress,
  VoidCallback? onScrollLeft,
  VoidCallback? onScrollRight,
  VoidCallback? onScrollUp,
  VoidCallback? onScrollDown,
  VoidCallback? onIncrease,
  VoidCallback? onDecrease,
  VoidCallback? onCopy,
  VoidCallback? onCut,
  VoidCallback? onPaste,
  VoidCallback? onDismiss,
  MoveCursorHandler? onMoveCursorForwardByCharacter,
  MoveCursorHandler? onMoveCursorBackwardByCharacter,
  SetSelectionHandler? onSetSelection,
  SetTextHandler? onSetText,
  VoidCallback? onDidGainAccessibilityFocus,
  VoidCallback? onDidLoseAccessibilityFocus,
  Map<CustomSemanticsAction, VoidCallback>? customSemanticsActions,
}) {
  if (rositaEnableSemantics || key != null) {
    return Semantics(
      key: key,
      container: container,
      explicitChildNodes: explicitChildNodes,
      excludeSemantics: excludeSemantics,
      blockUserActions: blockUserActions,
      enabled: enabled,
      checked: checked,
      mixed: mixed,
      selected: selected,
      toggled: toggled,
      button: button,
      slider: slider,
      keyboardKey: keyboardKey,
      link: link,
      header: header,
      textField: textField,
      readOnly: readOnly,
      focusable: focusable,
      focused: focused,
      inMutuallyExclusiveGroup: inMutuallyExclusiveGroup,
      obscured: obscured,
      multiline: multiline,
      scopesRoute: scopesRoute,
      namesRoute: namesRoute,
      hidden: hidden,
      image: image,
      liveRegion: liveRegion,
      expanded: expanded,
      maxValueLength: maxValueLength,
      currentValueLength: currentValueLength,
      identifier: identifier,
      label: label,
      attributedLabel: attributedLabel,
      value: value,
      attributedValue: attributedValue,
      increasedValue: increasedValue,
      attributedIncreasedValue: attributedIncreasedValue,
      decreasedValue: decreasedValue,
      attributedDecreasedValue: attributedDecreasedValue,
      hint: hint,
      attributedHint: attributedHint,
      tooltip: tooltip,
      onTapHint: onTapHint,
      onLongPressHint: onLongPressHint,
      textDirection: textDirection,
      sortKey: sortKey,
      tagForChildren: tagForChildren,
      onTap: onTap,
      onLongPress: onLongPress,
      onScrollLeft: onScrollLeft,
      onScrollRight: onScrollRight,
      onScrollUp: onScrollUp,
      onScrollDown: onScrollDown,
      onIncrease: onIncrease,
      onDecrease: onDecrease,
      onCopy: onCopy,
      onCut: onCut,
      onPaste: onPaste,
      onDismiss: onDismiss,
      onMoveCursorForwardByCharacter: onMoveCursorForwardByCharacter,
      onMoveCursorBackwardByCharacter: onMoveCursorBackwardByCharacter,
      onSetSelection: onSetSelection,
      onSetText: onSetText,
      onDidGainAccessibilityFocus: onDidGainAccessibilityFocus,
      onDidLoseAccessibilityFocus: onDidLoseAccessibilityFocus,
      customSemanticsActions: customSemanticsActions,
      child: child,
    );
  }

  return SizedBox(child: child);
}

// ignore: non_constant_identifier_names
Widget RositaBlockSemantics({Key? key, bool blocking = true, Widget? child}) {
  if (rositaEnableSemantics || key != null) {
    return BlockSemantics(
      key: key,
      blocking: blocking,
      child: child,
    );
  }

  return SizedBox(child: child);
}

// ignore: non_constant_identifier_names
Widget RositaExcludeSemantics({Key? key, bool excluding = true, Widget? child}) {
  if (rositaEnableSemantics || key != null) {
    return ExcludeSemantics(
      key: key,
      excluding: excluding,
      child: child,
    );
  }

  return SizedBox(child: child);
}
