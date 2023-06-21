const kIsRosita = bool.fromEnvironment('ROSITA');

const rositaDisableSemantics = bool.fromEnvironment('ROSITA_DISABLE_SEMANTICS', defaultValue: true);

const rositaEnableSemantics = !rositaDisableSemantics;

const rositaCastNullableToNonNullable =
    bool.fromEnvironment('ROSITA_CAST_NULLABLE_TO_NON_NULLABLE', defaultValue: true);

const rositaDisableRoutesChanged = bool.fromEnvironment('ROSITA_DISABLE_ROUTES_CHANGED', defaultValue: true);

const rositaEnableRoutesChanged = !rositaDisableRoutesChanged;

const rositaEnableVisitChildren = bool.fromEnvironment('ROSITA_ENABLE_VISIT_CHILDREN', defaultValue: true);

const rositaDisableUpdateCompositingBits =
    bool.fromEnvironment('ROSITA_DISABLE_UPDATE_COMPOSITING_BITS', defaultValue: kIsRosita);

const rositaEnableUpdateCompositingBits = !rositaDisableUpdateCompositingBits;

const rositaDisableLayoutMarkNeedsPaint =
    bool.fromEnvironment('ROSITA_DISABLE_LAYOUT_MARK_NEEDS_PAINT', defaultValue: kIsRosita);

const rositaEnableLayoutMarkNeedsPaint = !rositaDisableLayoutMarkNeedsPaint;

const rositaDisableHeroFlightAlwaysOnTickCheckUpdate =
    bool.fromEnvironment('ROSITA_DISABLE_HERO_FLIGHT_ALWAYS_ON_TICK_CHECK_UPDATE', defaultValue: kIsRosita);
