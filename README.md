# BatteryLand
Yet another battery icon for your system tray
This is my very first Linux-only, GTK+ and Vala app. Please don't be too harsh ;(

## How it works
This app relies on UPower and DBus in order to function. It listens for the `PropertiesChanged` signal on the `Device` found in the `org.freedesktop.UPower` bus.

## Features
- Indicates battery percentage
- Indicates battery status (Charging/Discharging)
- Supports custom icon themes (see down below)

## Dependencies
```
libayatana-appindicator3-1
libgio-2_0-0
libglib-2_0-0
libgobject-2_0-0
libgtk-3-0
libsoup-2_4-1
```
and related development libraries

## Installation
No packages (for the time being), manual installation only.

### 1. Clone the repo
`git clone https://github.com/Ciavi/batteryland && cd batteryland`

### 2. Configure the project
`chmod +x configure && ./configure`

### 3. Compile and install
`cd builddir/ && ninja && ninja install`

### 4. Enjoy!
`batteryland`

## Usage
### Run with default theme
`batteryland`

### Run with the light theme
`batteryland --theme default_light`

## Custom themes
Just have a look at the default themes, at how they're structured and then create a folder in the `/usr/local/share/it.lichtzeit.batteryland/resources/{YOUR_THEME}`.
Then run it like this:
`batteryland --theme {YOUR_THEME}`
