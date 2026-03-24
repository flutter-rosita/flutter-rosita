// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// JavaScript API bindings for browser APIs.
///
/// The public surface of this API must be safe to use. In particular, using the
/// API of this library it must not be possible to execute arbitrary code from
/// strings by injecting it into HTML or URLs.

@JS()
library browser_api;

import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:ui/ui.dart' as ui;
import 'package:ui/ui_web/src/ui_web.dart' as ui_web;

import 'browser_detection.dart' show WebGLVersion, webGLVersion;
import 'display.dart';
import 'dom.dart';
import 'vector_math.dart';

/// Returns true if [object] has property [name], false otherwise.
///
/// This is equivalent to writing `name in object` in plain JavaScript.
bool hasJsProperty(JSObject object, String name) {
  return object.has(name);
}

/// Returns the value of property [name] from a JavaScript [object].
///
/// This is equivalent to writing `object.name` in plain JavaScript.
T getJsProperty<T>(Object object, String name) {
  return (object as JSObject).getProperty(name.toJS) as T;
}

const Set<String> _safeJsProperties = <String>{'decoding', '__flutter_state'};

/// Sets the value of property [name] on a JavaScript [object].
///
/// This is equivalent to writing `object.name = value` in plain JavaScript.
T setJsProperty<T>(JSObject object, String name, T value) {
  assert(
  _safeJsProperties.contains(name),
  'Attempted to set property "$name" on a JavaScript object. This property '
      'has not been checked for safety. Possible solutions to this problem:\n'
      ' - Do not set this property.\n'
      ' - Ensure that the property is safe then add it to _safeJsProperties set.',
  );
  object.setProperty(name.toJS, value as JSAny);
  return value;
}

/// Converts a JavaScript `Promise` into Dart [Future].
Future<T> promiseToFuture<T>(Object jsPromise) async {
  final value = await (jsPromise as JSPromise).toDart;
  return value as T;
}

/// Parses a string [source] into a double.
///
/// Uses the JavaScript `parseFloat` function instead of Dart's [double.parse]
/// because the latter can't parse strings like "20px".
///
/// Returns null if it fails to parse.
num? parseFloat(String source) {
  // Using JavaScript's `parseFloat` here because it can parse values
  // like "20px", while Dart's `double.tryParse` fails.
  final num? result = domWindow.callMethod('parseFloat'.toJS,  <Object>[source].toJSAnyDeep);

  if (result == null || result.isNaN) {
    return null;
  }
  return result;
}

/// Used to decide if the browser tab still has the focus.
///
/// This information is useful for deciding on the blur behavior.
/// See [DefaultTextEditingStrategy].
///
/// This getter calls the `hasFocus` method of the `Document` interface.
/// See for more details:
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/hasFocus
bool get windowHasFocus => domDocument.callMethod('hasFocus'.toJS, <dynamic>[].toJSAnyDeep);

/// Parses the font size of [element] and returns the value without a unit.
num? parseFontSize(DomElement element) {
  return 1;
  num? fontSize;

  if (hasJsProperty(element, 'computedStyleMap')) {
    // Use the newer `computedStyleMap` API available on some browsers.
    final Object? computedStyleMap =
      (element as JSObject).callMethod('computedStyleMap'.toJS, <Object?>[].toJSAnyDeep);
    if (computedStyleMap is Object) {
      final Object? fontSizeObject = (computedStyleMap as JSObject).callMethod('get'.toJS, <Object?>['font-size'].toJSAnyDeep);
      if (fontSizeObject is Object) {
        fontSize = (fontSizeObject as JSObject).getProperty('value'.toJS);
      }
    }
  }

  if (fontSize == null) {
    // Fallback to `getComputedStyle`.
    final String fontSizeString = domWindow.getComputedStyle(element).getPropertyValue('font-size');
    fontSize = parseFloat(fontSizeString);
  }

  return fontSize;
}

/// Provides haptic feedback.
void vibrate(int durationMs) {
  final DomNavigator navigator = domWindow.navigator;
  if (hasJsProperty(navigator, 'vibrate')) {
    navigator.callMethod('vibrate'.toJS, <num>[durationMs].toJSAnyDeep);
  }
}

/// Creates a `<canvas>` but anticipates that the result may be null.
///
/// The [DomCanvasElement] factory assumes that element allocation will
/// succeed and will return a non-null element. This is not always true. For
/// example, when Safari on iOS runs out of memory it returns null.
DomHTMLCanvasElement? tryCreateCanvasElement(int width, int height) {
  final DomHTMLCanvasElement? canvas = domDocument.callMethod('createElement'.toJS, <dynamic>['CANVAS'].toJSAnyDeep);
  if (canvas == null) {
    return null;
  }
  try {
    canvas.width = width.toDouble();
    canvas.height = height.toDouble();
  } catch (e) {
    // It seems the tribal knowledge of why we anticipate an exception while
    // setting width/height on a non-null canvas and why it's OK to return null
    // in this case has been lost. Kudos to the one who can recover it and leave
    // a proper comment here!
    return null;
  }
  return canvas;
}

@JS('window.ImageDecoder')
external JSAny? get __imageDecoderConstructor;
Object? get _imageDecoderConstructor => __imageDecoderConstructor?.toObjectShallow;

/// Environment variable that allows the developer to opt out of using browser's
/// `ImageDecoder` API, and use the WASM codecs bundled with CanvasKit.
///
/// While all reported severe issues with `ImageDecoder` have been fixed, this
/// API remains relatively new. This option will allow developers to opt out of
/// it, if they hit a severe bug that we did not anticipate.
// TODO(yjbanov): remove this flag once we're fully confident in the new API.
//                https://github.com/flutter/flutter/issues/95277
const bool _browserImageDecodingEnabled = bool.fromEnvironment(
  'BROWSER_IMAGE_DECODING_ENABLED',
  defaultValue: true,
);

/// Whether the current browser supports `ImageDecoder`.
bool browserSupportsImageDecoder = _defaultBrowserSupportsImageDecoder;

/// Sets the value of [browserSupportsImageDecoder] to its default value.
void debugResetBrowserSupportsImageDecoder() {
  browserSupportsImageDecoder = _defaultBrowserSupportsImageDecoder;
}

bool get _defaultBrowserSupportsImageDecoder =>
    _browserImageDecodingEnabled &&
        _imageDecoderConstructor != null &&
        _isBrowserImageDecoderStable;

// TODO(yjbanov): https://github.com/flutter/flutter/issues/122761
// Frequently, when a browser launches an API that other browsers already
// support, there are subtle incompatibilities that may cause apps to crash if,
// we blindly adopt the new implementation. This variable prevents us from
// picking up potentially incompatible implementations of ImageDecoder API.
// Instead, when a new browser engine launches the API, we'll evaluate it and
// enable it explicitly.
bool get _isBrowserImageDecoderStable => ui_web.browser.browserEngine == ui_web.BrowserEngine.blink;

/// Corresponds to the browser's `ImageDecoder` type.
///
/// See also:
///
///  * https://www.w3.org/TR/webcodecs/#imagedecoder-interface
@JS('window.ImageDecoder')
extension type ImageDecoder._(JSObject _) implements JSObject {
  external ImageDecoder(ImageDecoderOptions options);

  external ImageTrackList get tracks;
  external bool get complete;
  external JSPromise<JSAny?> decode(DecodeOptions options);
  external void close();
}

/// Options passed to the `ImageDecoder` constructor.
///
/// See also:
///
///  * https://www.w3.org/TR/webcodecs/#imagedecoderinit-interface
extension type ImageDecoderOptions._(JSObject _) implements JSObject {
  external ImageDecoderOptions({
    required String type,
    required JSAny data,
    required String premultiplyAlpha,
    double? desiredWidth,
    double? desiredHeight,
    required String colorSpaceConversion,
    required bool preferAnimation,
  });
}

/// The result of [ImageDecoder.decode].
///
/// See also:
///
///  * https://www.w3.org/TR/webcodecs/#imagedecoderesult-interface
extension type DecodeResult(JSObject _) implements JSObject {
  external VideoFrame get image;
  external bool get complete;
}

/// Options passed to [ImageDecoder.decode].
///
/// See also:
///
///  * https://www.w3.org/TR/webcodecs/#dictdef-imagedecodeoptions
extension type DecodeOptions._(JSObject _) implements JSObject {
  external DecodeOptions({required int frameIndex});
}

/// The only frame in a static image, or one of the frames in an animated one.
///
/// This class maps to the `VideoFrame` type provided by the browser.
///
/// See also:
///
///  * https://www.w3.org/TR/webcodecs/#videoframe-interface
extension type VideoFrame(JSObject _) implements JSObject, DomCanvasImageSource {
  external double allocationSize();

  @JS('copyTo')
  external JSPromise<JSAny?> _copyTo(JSAny destination);
  JSPromise<JSAny?> copyTo(Object destination) => _copyTo(destination.toJSAnyShallow);

  external String? get format;
  external double get codedWidth;
  external double get codedHeight;
  external double get displayWidth;
  external double get displayHeight;
  external double? get duration;
  external VideoFrame clone();
  external void close();
}

/// Corresponds to the browser's `ImageTrackList` type.
///
/// See also:
///
///  * https://www.w3.org/TR/webcodecs/#imagetracklist-interface
extension type ImageTrackList(JSObject _) implements JSObject {
  external JSPromise<JSAny?> get ready;
  external ImageTrack? get selectedTrack;
}

/// Corresponds to the browser's `ImageTrack` type.
///
/// See also:
///
///  * https://www.w3.org/TR/webcodecs/#imagetrack
extension type ImageTrack(JSObject _) implements JSObject {
  external double get repetitionCount;
  external double get frameCount;
}

void scaleCanvas2D(Object context2d, num x, num y) {
  (context2d as JSObject).callMethod('scale'.toJS, <dynamic>[x, y].toJSAnyDeep);
}

void drawImageCanvas2D(Object context2d, Object imageSource, num width, num height) {
  (context2d as JSObject).callMethod('drawImage'.toJS, <dynamic>[imageSource, width, height].toJSAnyDeep);
}

void vertexAttribPointerGlContext(
    Object glContext,
    Object index,
    num size,
    Object type,
    bool normalized,
    num stride,
    num offset,
    ) {
  (glContext as JSObject).callMethod('vertexAttribPointer'.toJS, <dynamic>[
    index,
    size,
    type,
    normalized,
    stride,
    offset,
  ].toJSAnyDeep);
}

/// Compiled and cached gl program.
class GlProgram {
  GlProgram(this.program);
  final Object program;
}

/// JS Interop helper for webgl apis.
class GlContext {
  factory GlContext(OffScreenCanvas offScreenCanvas) {
    return OffScreenCanvas.supported
        ? GlContext._fromOffscreenCanvas(offScreenCanvas.offScreenCanvas!)
        : GlContext._fromCanvasElement(
      offScreenCanvas.canvasElement!,
      webGLVersion == WebGLVersion.webgl1,
    );
  }

  GlContext._fromOffscreenCanvas(DomOffscreenCanvas canvas)
      : glContext = canvas.getContext('webgl2', <String, dynamic>{'premultipliedAlpha': false})!,
        isOffscreen = true {
    _programCache = <String, GlProgram?>{};
    _canvas = canvas;
  }

  GlContext._fromCanvasElement(DomHTMLCanvasElement canvas, bool useWebGl1)
      : glContext =
  canvas.getContext(useWebGl1 ? 'webgl' : 'webgl2', <String, dynamic>{
    'premultipliedAlpha': false,
  })!,
        isOffscreen = false {
    _programCache = <String, GlProgram?>{};
    _canvas = canvas;
  }

  final Object glContext;
  final bool isOffscreen;
  Object? _kCompileStatus;
  Object? _kArrayBuffer;
  Object? _kElementArrayBuffer;
  Object? _kStaticDraw;
  Object? _kFloat;
  Object? _kColorBufferBit;
  Object? _kTexture2D;
  Object? _kTextureWrapS;
  Object? _kTextureWrapT;
  Object? _kRepeat;
  Object? _kClampToEdge;
  Object? _kMirroredRepeat;
  Object? _kTriangles;
  Object? _kLinkStatus;
  Object? _kUnsignedByte;
  Object? _kUnsignedShort;
  Object? _kRGBA;
  Object? _kLinear;
  Object? _kTextureMinFilter;
  double? _kTexture0;

  Object? _canvas;
  int? _widthInPixels;
  int? _heightInPixels;
  static late Map<String, GlProgram?> _programCache;

  void setViewportSize(int width, int height) {
    _widthInPixels = width;
    _heightInPixels = height;
  }

  /// Draws Gl context contents to canvas context.
  void drawImage(DomCanvasRenderingContext2D context, double left, double top) {
    // Actual size of canvas may be larger than viewport size. Use
    // source/destination to draw part of the image data.
    context.callMethod('drawImage'.toJS, <dynamic>[
      _canvas,
      0,
      0,
      _widthInPixels,
      _heightInPixels,
      left,
      top,
      _widthInPixels,
      _heightInPixels,
    ].toJSAnyDeep);
  }

  GlProgram cacheProgram(String vertexShaderSource, String fragmentShaderSource) {
    final String cacheKey = '$vertexShaderSource||$fragmentShaderSource';
    GlProgram? cachedProgram = _programCache[cacheKey];
    if (cachedProgram == null) {
      // Create and compile shaders.
      final Object vertexShader = compileShader('VERTEX_SHADER', vertexShaderSource);
      final Object fragmentShader = compileShader('FRAGMENT_SHADER', fragmentShaderSource);
      // Create a gl program and link shaders.
      final Object program = createProgram();
      attachShader(program, vertexShader);
      attachShader(program, fragmentShader);
      linkProgram(program);
      cachedProgram = GlProgram(program);
      _programCache[cacheKey] = cachedProgram;
    }
    return cachedProgram;
  }

  Object compileShader(String shaderType, String source) {
    final Object? shader = _createShader(shaderType);
    if (shader == null) {
      throw Exception(error);
    }
    (glContext as JSObject).callMethod('shaderSource'.toJS, <dynamic>[shader, source].toJSAnyDeep);
    (glContext as JSObject).callMethod('compileShader'.toJS, <dynamic>[shader].toJSAnyDeep);
    final bool shaderStatus = (glContext as JSObject).callMethod('getShaderParameter'.toJS, <dynamic>[
      shader,
      compileStatus,
    ].toJSAnyDeep);
    if (!shaderStatus) {
      throw Exception('Shader compilation failed: ${getShaderInfoLog(shader)}');
    }
    return shader;
  }

  Object createProgram() =>
      (glContext as JSObject).callMethod('createProgram'.toJS, const <dynamic>[].toJSAnyDeep);

  void attachShader(Object? program, Object shader) {
    (glContext as JSObject).callMethod('attachShader'.toJS, <dynamic>[program, shader].toJSAnyDeep);
  }

  void linkProgram(Object program) {
    (glContext as JSObject).callMethod('linkProgram'.toJS, <dynamic>[program].toJSAnyDeep);
    final bool programStatus = (glContext as JSObject).callMethod('getProgramParameter'.toJS, <dynamic>[
      program,
      kLinkStatus,
    ].toJSAnyDeep);
    if (!programStatus) {
      throw Exception(getProgramInfoLog(program));
    }
  }

  void useProgram(GlProgram program) {
    (glContext as JSObject).callMethod('useProgram'.toJS, <dynamic>[program.program].toJSAnyDeep);
  }

  Object? createBuffer() => (glContext as JSObject).callMethod('createBuffer'.toJS, const <dynamic>[].toJSAnyDeep);

  void bindArrayBuffer(Object? buffer) {
    (glContext as JSObject).callMethod('bindBuffer'.toJS, <dynamic>[kArrayBuffer, buffer].toJSAnyDeep);
  }

  Object? createVertexArray() =>
      (glContext as JSObject).callMethod('createVertexArray'.toJS, const <dynamic>[].toJSAnyDeep);

  void bindVertexArray(Object vertexObjectArray) {
    (glContext as JSObject).callMethod('bindVertexArray'.toJS, <dynamic>[vertexObjectArray].toJSAnyDeep);
  }

  void unbindVertexArray() {
    (glContext as JSObject).callMethod('bindVertexArray'.toJS, <dynamic>[null].toJSAnyDeep);
  }

  void bindElementArrayBuffer(Object? buffer) {
    (glContext as JSObject).callMethod('bindBuffer'.toJS, <dynamic>[kElementArrayBuffer, buffer].toJSAnyDeep);
  }

  Object? createTexture() => (glContext as JSObject).callMethod('createTexture'.toJS, const <dynamic>[].toJSAnyDeep);

  void generateMipmap(dynamic target) =>
      (glContext as JSObject).callMethod('generateMipmap'.toJS, <dynamic>[target].toJSAnyDeep);

  void bindTexture(dynamic target, Object? buffer) {
    (glContext as JSObject).callMethod('bindTexture'.toJS, <dynamic>[target, buffer].toJSAnyDeep);
  }

  void activeTexture(double textureUnit) {
    (glContext as JSObject).callMethod('activeTexture'.toJS, <dynamic>[textureUnit].toJSAnyDeep);
  }

  void texImage2D(
      dynamic target,
      int level,
      dynamic internalFormat,
      dynamic format,
      dynamic dataType,
      dynamic pixels, {
        int? width,
        int? height,
        int border = 0,
      }) {
    if (width == null) {
      (glContext as JSObject).callMethod('texImage2D'.toJS, <dynamic>[
        target,
        level,
        internalFormat,
        format,
        dataType,
        pixels,
      ].toJSAnyDeep);
    } else {
      (glContext as JSObject).callMethod('texImage2D'.toJS, <dynamic>[
        target,
        level,
        internalFormat,
        width,
        height,
        border,
        format,
        dataType,
        pixels,
      ].toJSAnyDeep);
    }
  }

  void texParameteri(dynamic target, dynamic parameterName, dynamic value) {
    (glContext as JSObject).callMethod('texParameteri'.toJS, <dynamic>[target, parameterName, value].toJSAnyDeep);
  }

  void deleteBuffer(Object buffer) {
    (glContext as JSObject).callMethod('deleteBuffer'.toJS, <dynamic>[buffer].toJSAnyDeep);
  }

  void bufferData(TypedData? data, dynamic type) {
    (glContext as JSObject).callMethod('bufferData'.toJS, <dynamic>[kArrayBuffer, data, type].toJSAnyDeep);
  }

  void bufferElementData(TypedData? data, dynamic type) {
    (glContext as JSObject).callMethod('bufferData'.toJS, <dynamic>[kElementArrayBuffer, data, type].toJSAnyDeep);
  }

  void enableVertexAttribArray(dynamic index) {
    (glContext as JSObject).callMethod('enableVertexAttribArray'.toJS, <dynamic>[index].toJSAnyDeep);
  }

  /// Clear background.
  void clear() {
    (glContext as JSObject).callMethod('clear'.toJS, <dynamic>[kColorBufferBit].toJSAnyDeep);
  }

  /// Destroys gl context.
  void dispose() {
    final Object? loseContextExtension = _getExtension('WEBGL_lose_context');
    if (loseContextExtension != null) {
      (loseContextExtension as JSObject).callMethod('loseContext'.toJS, const <dynamic>[].toJSAnyDeep);
    }
  }

  void deleteProgram(Object program) {
    (glContext as JSObject).callMethod('deleteProgram'.toJS, <dynamic>[program].toJSAnyDeep);
  }

  void deleteShader(Object shader) {
    (glContext as JSObject).callMethod('deleteShader'.toJS, <dynamic>[shader].toJSAnyDeep);
  }

  Object? _getExtension(String extensionName) =>
      (glContext as JSObject).callMethod('getExtension'.toJS, <dynamic>[extensionName].toJSAnyDeep);

  void drawTriangles(int triangleCount, ui.VertexMode vertexMode) {
    final dynamic mode = _triangleTypeFromMode(vertexMode);
    (glContext as JSObject).callMethod('drawArrays'.toJS, <dynamic>[mode, 0, triangleCount].toJSAnyDeep);
  }

  void drawElements(dynamic type, int indexCount, dynamic indexType) {
    (glContext as JSObject).callMethod('drawElements'.toJS, <dynamic>[type, indexCount, indexType, 0].toJSAnyDeep);
  }

  /// Sets affine transformation from normalized device coordinates
  /// to window coordinates
  void viewport(double x, double y, double width, double height) {
    (glContext as JSObject).callMethod('viewport'.toJS, <dynamic>[x, y, width, height].toJSAnyDeep);
  }

  Object _triangleTypeFromMode(ui.VertexMode mode) {
    switch (mode) {
      case ui.VertexMode.triangles:
        return kTriangles;
      case ui.VertexMode.triangleFan:
        return kTriangleFan;
      case ui.VertexMode.triangleStrip:
        return kTriangleStrip;
    }
  }

  Object? _createShader(String shaderType) => (
    glContext as JSObject).callMethod(
    'createShader'.toJS,
    <Object?>[(glContext as JSObject).getProperty(shaderType.toJS)].toJSAnyDeep,
  );

  /// Error state of gl context.
  Object? get error => (glContext as JSObject).callMethod('getError'.toJS, const <dynamic>[].toJSAnyDeep);

  /// Shader compiler error, if this returns [kFalse], to get details use
  /// [getShaderInfoLog].
  Object? get compileStatus => _kCompileStatus ??= (glContext as JSObject).callMethod('COMPILE_STATUS'.toJS);

  Object? get kArrayBuffer => _kArrayBuffer ??= (glContext as JSObject).callMethod('ARRAY_BUFFER'.toJS);

  Object? get kElementArrayBuffer =>
      _kElementArrayBuffer ??= (glContext as JSObject).callMethod('ELEMENT_ARRAY_BUFFER'.toJS);

  Object get kLinkStatus => _kLinkStatus ??= (glContext as JSObject).callMethod('LINK_STATUS'.toJS)!;

  Object get kFloat => _kFloat ??= (glContext as JSObject).callMethod('FLOAT'.toJS)!;

  Object? get kRGBA => _kRGBA ??= (glContext as JSObject).callMethod('RGBA'.toJS);

  Object get kUnsignedByte =>
      _kUnsignedByte ??= (glContext as JSObject).callMethod('UNSIGNED_BYTE'.toJS)!;

  Object? get kUnsignedShort =>
      _kUnsignedShort ??= (glContext as JSObject).callMethod('UNSIGNED_SHORT'.toJS)!;

  Object? get kStaticDraw => _kStaticDraw ??= (glContext as JSObject).callMethod('STATIC_DRAW'.toJS);

  Object get kTriangles => _kTriangles ??= (glContext as JSObject).callMethod('TRIANGLES'.toJS)!;

  Object get kTriangleFan => _kTriangles ??= (glContext as JSObject).callMethod('TRIANGLE_FAN'.toJS)!;

  Object get kTriangleStrip =>
      _kTriangles ??= (glContext as JSObject).callMethod('TRIANGLE_STRIP'.toJS)!;

  Object? get kColorBufferBit =>
      _kColorBufferBit ??= (glContext as JSObject).callMethod('COLOR_BUFFER_BIT'.toJS);

  Object? get kTexture2D => _kTexture2D ??= (glContext as JSObject).callMethod('TEXTURE_2D'.toJS);

  double get kTexture0 => _kTexture0 ??= (glContext as JSObject).callMethod('TEXTURE0'.toJS)!;

  Object? get kTextureWrapS => _kTextureWrapS ??= (glContext as JSObject).callMethod('TEXTURE_WRAP_S'.toJS);

  Object? get kTextureWrapT => _kTextureWrapT ??= (glContext as JSObject).callMethod('TEXTURE_WRAP_T'.toJS);

  Object? get kRepeat => _kRepeat ??= (glContext as JSObject).callMethod('REPEAT'.toJS);

  Object? get kClampToEdge => _kClampToEdge ??= (glContext as JSObject).callMethod('CLAMP_TO_EDGE'.toJS);

  Object? get kMirroredRepeat =>
      _kMirroredRepeat ??= (glContext as JSObject).callMethod('MIRRORED_REPEAT'.toJS);

  Object? get kLinear => _kLinear ??= (glContext as JSObject).callMethod('LINEAR'.toJS);

  Object? get kTextureMinFilter =>
      _kTextureMinFilter ??= (glContext as JSObject).callMethod('TEXTURE_MIN_FILTER'.toJS);

  /// Returns reference to uniform in program.
  Object getUniformLocation(Object program, String uniformName) {
    final Object? res = (glContext as JSObject).callMethod('getUniformLocation'.toJS, <dynamic>[
      program,
      uniformName,
    ].toJSAnyDeep);
    if (res == null) {
      throw Exception('$uniformName not found');
    } else {
      return res;
    }
  }

  /// Returns true if uniform exists.
  bool containsUniform(Object program, String uniformName) {
    final Object? res = (glContext as JSObject).callMethod('getUniformLocation'.toJS, <dynamic>[
      program,
      uniformName,
    ].toJSAnyDeep);
    return res != null;
  }

  /// Returns reference to uniform in program.
  Object getAttributeLocation(Object program, String attribName) {
    final Object? res = (glContext as JSObject).callMethod('getAttribLocation'.toJS, <dynamic>[
      program,
      attribName,
    ].toJSAnyDeep);
    if (res == null) {
      throw Exception('$attribName not found');
    } else {
      return res;
    }
  }

  /// Sets float uniform value.
  void setUniform1f(Object uniform, double value) {
    (glContext as JSObject).callMethod('uniform1f'.toJS, <dynamic>[uniform, value].toJSAnyDeep);
  }

  /// Sets vec2 uniform values.
  void setUniform2f(Object uniform, double value1, double value2) {
    (glContext as JSObject).callMethod('uniform2f'.toJS, <dynamic>[uniform, value1, value2].toJSAnyDeep);
  }

  /// Sets vec4 uniform values.
  void setUniform4f(Object uniform, double value1, double value2, double value3, double value4) {
    (glContext as JSObject).callMethod('uniform4f'.toJS, <dynamic>[
      uniform,
      value1,
      value2,
      value3,
      value4,
    ].toJSAnyDeep);
  }

  /// Sets mat4 uniform values.
  void setUniformMatrix4fv(Object uniform, bool transpose, Float32List value) {
    (glContext as JSObject).callMethod('uniformMatrix4fv'.toJS, <dynamic>[uniform, transpose, value].toJSAnyDeep);
  }

  /// Shader compile error log.
  Object? getShaderInfoLog(Object glShader) {
    return (glContext as JSObject).callMethod('getShaderInfoLog'.toJS, <dynamic>[glShader].toJSAnyDeep);
  }

  ///  Errors that occurred during failed linking or validation of program
  ///  objects. Typically called after [linkProgram].
  String? getProgramInfoLog(Object glProgram) {
    return (glContext as JSObject).callMethod('getProgramInfoLog'.toJS, <dynamic>[glProgram].toJSAnyDeep);
  }

  int? get drawingBufferWidth => (glContext as JSObject).getProperty('drawingBufferWidth'.toJS);
  int? get drawingBufferHeight => (glContext as JSObject).getProperty('drawingBufferWidth'.toJS);

  /// Reads gl contents as image data.
  ///
  /// Warning: data is read bottom up (flipped).
  DomImageData readImageData() {
    const int kBytesPerPixel = 4;
    final int bufferWidth = _widthInPixels!;
    final int bufferHeight = _heightInPixels!;
    if (ui_web.browser.browserEngine == ui_web.BrowserEngine.webkit ||
        ui_web.browser.browserEngine == ui_web.BrowserEngine.firefox) {
      final Uint8List pixels = Uint8List(bufferWidth * bufferHeight * kBytesPerPixel);
      (glContext as JSObject).callMethod('readPixels'.toJS, <dynamic>[
        0,
        0,
        bufferWidth,
        bufferHeight,
        kRGBA,
        kUnsignedByte,
        pixels,
      ].toJSAnyDeep);
      return createDomImageData(Uint8ClampedList.fromList(pixels), bufferWidth, bufferHeight);
    } else {
      final Uint8ClampedList pixels = Uint8ClampedList(bufferWidth * bufferHeight * kBytesPerPixel);
      (glContext as JSObject).callMethod('readPixels'.toJS, <dynamic>[
        0,
        0,
        bufferWidth,
        bufferHeight,
        kRGBA,
        kUnsignedByte,
        pixels,
      ].toJSAnyDeep);
      return createDomImageData(pixels, bufferWidth, bufferHeight);
    }
  }

  /// Returns image data in a form that can be used to create Canvas
  /// context patterns.
  Object? readPatternData(bool isOpaque) {
    // When using OffscreenCanvas and transferToImageBitmap is supported by
    // browser create ImageBitmap otherwise use more expensive canvas
    // allocation. However, transferToImageBitmap does not properly preserve
    // the alpha channel, so only use it if the pattern is opaque.
    if (_canvas != null && (_canvas! as JSObject).has('transferToImageBitmap') && isOpaque) {
      // TODO(yjbanov): find out why we need to call getContext and ignore the return value.
      (_canvas! as JSObject).callMethod('getContext'.toJS, <dynamic>['webgl2'].toJSAnyDeep);
      final Object? imageBitmap =
        (_canvas! as JSObject).callMethod(
        'transferToImageBitmap'.toJS,
        <dynamic>[].toJSAnyDeep,
      );
      return imageBitmap;
    } else {
      final DomHTMLCanvasElement canvas = createDomCanvasElement(
        width: _widthInPixels,
        height: _heightInPixels,
      );
      final DomCanvasRenderingContext2D ctx = canvas.context2D;
      drawImage(ctx, 0, 0);
      return canvas;
    }
  }

  /// Returns image data in data url format.
  String toImageUrl() {
    final DomHTMLCanvasElement canvas = createDomCanvasElement(
      width: _widthInPixels,
      height: _heightInPixels,
    );
    final DomCanvasRenderingContext2D ctx = canvas.context2D;
    drawImage(ctx, 0, 0);
    final String dataUrl = canvas.toDataURL();
    canvas.width = 0;
    canvas.height = 0;
    return dataUrl;
  }
}

/// Creates gl context from cached OffscreenCanvas for webgl rendering to image.
class GlContextCache {
  static int _maxPixelWidth = 0;
  static int _maxPixelHeight = 0;
  static GlContext? _cachedContext;
  static OffScreenCanvas? _offScreenCanvas;

  static void dispose() {
    _maxPixelWidth = 0;
    _maxPixelHeight = 0;
    _cachedContext = null;
    _offScreenCanvas?.dispose();
  }

  static GlContext? createGlContext(int widthInPixels, int heightInPixels) {
    if (widthInPixels > _maxPixelWidth || heightInPixels > _maxPixelHeight) {
      _cachedContext?.dispose();
      _cachedContext = null;
      _offScreenCanvas = null;
      _maxPixelWidth = math.max(_maxPixelWidth, widthInPixels);
      _maxPixelHeight = math.max(_maxPixelHeight, widthInPixels);
    }
    _offScreenCanvas ??= OffScreenCanvas(widthInPixels, heightInPixels);
    _cachedContext ??= GlContext(_offScreenCanvas!);
    _cachedContext!.setViewportSize(widthInPixels, heightInPixels);
    return _cachedContext;
  }
}

void setupVertexTransforms(
    GlContext gl,
    GlProgram glProgram,
    double offsetX,
    double offsetY,
    double widthInPixels,
    double heightInPixels,
    Matrix4 transform,
    ) {
  final Object transformUniform = gl.getUniformLocation(glProgram.program, 'u_ctransform');
  final Matrix4 transformAtOffset = transform.clone()..translate(-offsetX, -offsetY);
  gl.setUniformMatrix4fv(transformUniform, false, transformAtOffset.storage);

  // Set uniform to scale 0..width/height pixels coordinates to -1..1
  // clipspace range and flip the Y axis.
  final Object resolution = gl.getUniformLocation(glProgram.program, 'u_scale');
  gl.setUniform4f(resolution, 2.0 / widthInPixels, -2.0 / heightInPixels, 1, 1);
  final Object shift = gl.getUniformLocation(glProgram.program, 'u_shift');
  gl.setUniform4f(shift, -1, 1, 0, 0);
}

void setupTextureTransform(
    GlContext gl,
    GlProgram glProgram,
    double offsetx,
    double offsety,
    double sx,
    double sy,
    ) {
  final Object scalar = gl.getUniformLocation(glProgram.program, 'u_textransform');
  gl.setUniform4f(scalar, sx, sy, offsetx, offsety);
}

void bufferVertexData(GlContext gl, Float32List positions, double devicePixelRatio) {
  if (devicePixelRatio == 1.0) {
    gl.bufferData(positions, gl.kStaticDraw);
  } else {
    final int length = positions.length;
    final Float32List scaledList = Float32List(length);
    for (int i = 0; i < length; i++) {
      scaledList[i] = positions[i] * devicePixelRatio;
    }
    gl.bufferData(scaledList, gl.kStaticDraw);
  }
}

dynamic tileModeToGlWrapping(GlContext gl, ui.TileMode tileMode) {
  switch (tileMode) {
    case ui.TileMode.clamp:
      return gl.kClampToEdge;
    case ui.TileMode.decal:
      return gl.kClampToEdge;
    case ui.TileMode.mirror:
      return gl.kMirroredRepeat;
    case ui.TileMode.repeated:
      return gl.kRepeat;
  }
}

/// Polyfill for DomOffscreenCanvas that is not supported on some browsers.
class OffScreenCanvas {
  OffScreenCanvas(this.width, this.height) {
    if (OffScreenCanvas.supported) {
      offScreenCanvas = createDomOffscreenCanvas(width, height);
    } else {
      canvasElement = createDomCanvasElement(width: width, height: height);
      canvasElement!.className = 'gl-canvas';
      _updateCanvasCssSize(canvasElement!);
    }
  }

  DomOffscreenCanvas? offScreenCanvas;
  DomHTMLCanvasElement? canvasElement;
  int width;
  int height;
  static bool? _supported;

  void _updateCanvasCssSize(DomHTMLCanvasElement element) {
    final double cssWidth = width / EngineFlutterDisplay.instance.browserDevicePixelRatio;
    final double cssHeight = height / EngineFlutterDisplay.instance.browserDevicePixelRatio;
    element.style
      ..position = 'absolute'
      ..width = '${cssWidth}px'
      ..height = '${cssHeight}px';
  }

  void resize(int requestedWidth, int requestedHeight) {
    if (requestedWidth != width || requestedHeight != height) {
      width = requestedWidth;
      height = requestedHeight;
      if (offScreenCanvas != null) {
        offScreenCanvas!.width = requestedWidth.toDouble();
        offScreenCanvas!.height = requestedHeight.toDouble();
      } else if (canvasElement != null) {
        canvasElement!.width = requestedWidth.toDouble();
        canvasElement!.height = requestedHeight.toDouble();
        _updateCanvasCssSize(canvasElement!);
      }
    }
  }

  void dispose() {
    offScreenCanvas = null;
    canvasElement = null;
  }

  /// Returns CanvasRenderContext2D or OffscreenCanvasRenderingContext2D to
  /// paint into.
  Object? getContext2d() {
    return offScreenCanvas != null
        ? offScreenCanvas!.getContext('2d')
        : canvasElement!.getContext('2d');
  }

  DomImageBitmapRenderingContext? getBitmapRendererContext() {
    return (offScreenCanvas != null
        ? offScreenCanvas!.getContext('bitmaprenderer')
        : canvasElement!.getContext('bitmaprenderer'))
    as DomImageBitmapRenderingContext?;
  }

  /// Feature detection for transferToImageBitmap on OffscreenCanvas.
  bool get transferToImageBitmapSupported =>
      offScreenCanvas!.has('transferToImageBitmap');

  /// Creates an ImageBitmap object from the most recently rendered image
  /// of the OffscreenCanvas.
  ///
  /// !Warning API still in experimental status, feature detect before using.
  Object? transferToImageBitmap() {
    return (offScreenCanvas! as JSObject).callMethod('transferToImageBitmap'.toJS, <dynamic>[].toJSAnyDeep);
  }

  /// Draws canvas contents to a rendering context.
  void transferImage(Object targetContext) {
    // Actual size of canvas may be larger than viewport size. Use
    // source/destination to draw part of the image data.
    (targetContext as JSObject).callMethod('drawImage'.toJS,
    <dynamic>[
      offScreenCanvas ?? canvasElement!,
      0,
      0,
      width,
      height,
      0,
      0,
      width,
      height,
    ].toJSAnyDeep);
  }

  /// Converts canvas contents to an image and returns as data URL.
  Future<String> toDataUrl() {
    final Completer<String> completer = Completer<String>();
    if (offScreenCanvas != null) {
      offScreenCanvas!.convertToBlob().then((DomBlob value) {
        final DomFileReader fileReader = createDomFileReader();
        fileReader.addEventListener(
          'load',
          createDomEventListener((DomEvent event) {
            completer.complete(
              (event.getProperty('target'.toJS) as JSObject).getProperty('result'.toJS)
            );
          }),
        );
        fileReader.readAsDataURL(value);
      });
      return completer.future;
    } else {
      return Future<String>.value(canvasElement!.toDataURL());
    }
  }

  /// Draws an image to canvas for both offscreen canvas context2d.
  void drawImage(Object image, int x, int y, int width, int height) {
    (getContext2d()! as JSObject).callMethod('drawImage'.toJS, <dynamic>[image, x, y, width, height].toJSAnyDeep);
  }

  /// Feature detects OffscreenCanvas.
  static bool get supported =>
      _supported ??=
      // Safari 16.4 implements OffscreenCanvas, but without WebGL support. So
      // it's not really supported in a way that is useful to us.
      !ui_web.browser.isSafari && domWindow.hasProperty('OffscreenCanvas'.toJS).toDart;
}