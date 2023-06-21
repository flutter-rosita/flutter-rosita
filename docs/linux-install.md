# Install for Linux

## Installing flutter-rosita

1. Clone this repository to your local hard drive.

   ```sh
   git clone https://github.com/flutter-rosita/flutter-rosita.git
   ```

2. Add `flutter-rosita/bin` to your PATH.

   ```sh
   export PATH="`pwd`/flutter-rosita/bin:$PATH"
   ```

   This command sets your PATH variable for the current terminal window only. To permanently add to your PATH, edit your config file (typically `.bashrc`) by running:

   ```sh
   echo "export PATH=\"`pwd`/flutter-rosita/bin:\$PATH\"" >> ~/.bashrc
   ```

   You have to run `source ~/.bashrc` or open a new terminal window for this change to take effect.

3. Verify that the `flutter-rosita` command is available by running:

   ```sh
   which flutter-rosita
   ```