# mustang_viewer

##Steps to Run Mustang Viewer as a Desktop Application:\
From the terminal, run the following commands.
1. If OS is Mac,```flutter config --enable-macos-desktop```\
    For Windows,```flutter config --enable-windows-desktop```\
    For Linux,```flutter config --enable-linux-desktop```
2. Execute ```flutter devices``` to view all the available devices. Your OS should be one among the available devices.
3. ```flutter create .```
4. For Mac,```flutter run -d macos```\
    For Windows,```flutter run -d windows```\
    For Linux,```flutter run -d linux```

If you get error "SocketException: Connection failed (OS Error: Operation not permitted, errno = 1)" while trying to connect in Mac,
add below mentioned key-value pair in **macos/Runner/DebugProfile.entitlements** and **macos/Runner/Release.entitlements**

```<key>com.apple.security.network.client</key>
   <true/>```

