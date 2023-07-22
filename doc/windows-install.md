# Install for Windows

## Installing flutter-rosita

1. Clone this repository to your local hard drive.

   ```powershell
   git clone https://github.com/flutter-rosita/flutter-rosita.git
   ```

2. Add `flutter-rosita\bin` to your PATH.

    - From the Start search bar, enter "env" and select **Edit environment variables for your account**.
    - Under **User variables** check if there is an entry called **Path**:
        - If the entry exists, click **Edit...** and add a new entry with the full path to `flutter-rosita\bin`.
        - If the entry doesn't exist, create a new user variable named **Path** with the full path to `flutter-rosita\bin` as its value.

   You have to close and reopen any existing console windows for this change to take effect.

3. Verify that the `flutter-rosita` command is available by running:

   ```powershell
   where.exe flutter-rosita
   ```