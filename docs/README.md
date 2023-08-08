<img alt="Flutter Rosita" src="assets/rosita_full_logo.png" width="185" height="185">

# Flutter Rosita

Flutter Rosita is a fork with changes to speed up WEB rendering.

It is worth trying Rosita if Flutter WEB html renderer is not fast enough for you, and if you are willing to make compromises to improve interface responsiveness.

## Installation

- [Linux](linux-install.md)
- [Windows](windows-install.md)
- [macOS](macos-install.md)

## Usage

`flutter-rosita` substitutes the original [`flutter`](https://docs.flutter.dev/reference/flutter-cli) CLI command. Only the command line interface is supported.

```sh
# Build the project and run WEB (either in debug or release mode).
flutter-rosita run
flutter-rosita run --release

# Build the project for WEB (release mode).
flutter-rosita build web
```