<img alt="Flutter Rosita" src="assets/rosita_full_logo.png" width="185" height="185">

# Flutter Rosita

Flutter Rosita - это форк с изменениями для ускорения веб-рендеринга.

Стоит попробовать Rosita, если Flutter WEB html renderer недостаточно быстр для вас, и если вы готовы идти на компромиссы, чтобы улучшить отзывчивость интерфейса.

## Установка

- [Linux](linux-install.md)
- [Windows](windows-install.md)
- [macOS](macos-install.md)

## Использование

`flutter-rosita` заменяет исходную команду [`flutter`](https://docs.flutter.dev/reference/flutter-cli) CLI. Поддерживается только интерфейс командной строки.

```sh
# Запуск проекта под WEB (в режиме debug или в режиме release).
flutter-rosita run
flutter-rosita run --release

# Сборка проекта под WEB (release сборка).
flutter-rosita build web
```