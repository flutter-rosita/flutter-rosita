<img alt="Flutter Rosita" src="docs/assets/rosita_full_logo.png" width="185" height="185">

# Flutter Rosita

Enhance Your [Flutter](https://github.com/flutter/flutter) Web Experience with Flutter Rosita

Flutter Rosita is a fork of the popular Flutter framework, designed to address the performance challenges of web-based applications built with standard Flutter Web. If you've found the HTML rendering in Flutter Web to be sluggish or unresponsive, Rosita offers a compelling solution.

By introducing thoughtful modifications to the core Flutter engine, Rosita delivers a noticeable boost in rendering speed and overall responsiveness. This makes it an attractive option for developers who require a fast, reactive user interface for their web-based projects.

However, it's important to note that Rosita may require some trade-offs in certain areas to achieve these performance gains. So, if you're willing to prioritize speed and responsiveness over absolute flexibility, then Rosita could be the right choice for your Flutter Web development needs.

Elevate your Flutter web experiences with Flutter Rosita - a performance-focused fork that can help transform your online applications.

## Installation

- [Linux](linux-install.md)
- [Windows](windows-install.md)
- [macOS](macos-install.md)

## Usage

`flutter-rosita` substitutes the original [`flutter`](https://docs.flutter.dev/reference/flutter-cli) CLI command. Only the command line interface is supported.

```sh
# Update package config with Flutter Rosita
flutter-rosita pub get

# Build the project and run WEB (either in debug or release mode).
flutter-rosita run
flutter-rosita run --release

# Build the project for WEB (release mode).
flutter-rosita build web
```

## Rosita Widgets

To optimize the performance of the Flutter Rosita app, we can use special widgets. In order to do so, we need to add a dependency in the pubspec.yaml file.

```yaml
dependencies:
  rosita: ^0.6.0
```

### RositaAnimatedOpacity vs AnimatedOpacity

RositaAnimatedOpacity - work with Flutter too.
On the web, it works through CSS transitions, which do not cause the rebuild of rendered objects.

```dart
return RositaAnimatedOpacity(
  opacity: visible ? 1.0 : 0,
  duration: Diration(seconds: 1),
  child: image,
);
```

### RositaFadeImage vs FadeInImage / CachedNetworkImage / OctoImage

```dart
kIsRosita ? RositaFadeImage.network(imageUrl) : FadeInImage.assetNetwork(...)
```

### RositaImage vs Image

```dart
kIsRosita ? RositaImage.network(imageUrl) : Image.network(imageUrl)
```

### RositaSvgPicture vs SvgPicture

```dart
kIsRosita ? RositaSvgPicture.asset('assets/logo.svg') : SvgPicture.asset('assets/logo.svg')
```
