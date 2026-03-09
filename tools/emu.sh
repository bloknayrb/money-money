#!/usr/bin/env bash
# Emulator testing helpers for Patrimonium
# Usage: source tools/emu.sh

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ANDROID_SDK="$HOME/AppData/Local/Android/Sdk"
ADB="$ANDROID_SDK/platform-tools/adb.exe"
EMULATOR="$ANDROID_SDK/emulator/emulator.exe"
AVD_NAME="Medium_Phone_API_36.1"
APP_PACKAGE="com.patrimonium.patrimonium"
APP_ACTIVITY="$APP_PACKAGE/.MainActivity"
SCREENSHOT_DIR="$PROJECT_ROOT/tmp/screenshots"
DEV_PIN="984438"

# Ensure screenshot dir exists
mkdir -p "$SCREENSHOT_DIR"

# Strip \r from ADB output (Windows ADB returns \r\n)
# MSYS2_ARG_CONV_EXCL prevents git-bash from mangling /sdcard/ paths
_adb() {
    MSYS2_ARG_CONV_EXCL="*" "$ADB" "$@" 2>&1 | tr -d '\r'
}

# ADB pull: remote path stays Unix, local path converted to Windows for adb.exe
_adb_pull() {
    local remote="$1"
    local local_path="$2"
    MSYS2_ARG_CONV_EXCL="*" "$ADB" pull "$remote" "$(cygpath -w "$local_path")" 2>&1 | tr -d '\r'
}

# ── Emulator lifecycle ──────────────────────────────────────────────

emu_wake() {
    _adb shell input keyevent KEYCODE_WAKEUP
    sleep 0.5
    # Swipe up to dismiss Android lock screen (not app PIN screen)
    _adb shell input swipe 540 1800 540 800 300
    sleep 0.5
}

emu_start() {
    echo "Starting emulator: $AVD_NAME"
    "$EMULATOR" -avd "$AVD_NAME" -no-audio -gpu auto &
    disown

    echo "Waiting for boot..."
    "$ADB" wait-for-device
    local booted=""
    while [ "$booted" != "1" ]; do
        sleep 2
        booted=$(_adb shell getprop sys.boot_completed)
    done
    # Wake screen (emulator may resume from snapshot with screen off)
    emu_wake
    echo "Emulator booted."
}

emu_stop() {
    echo "Stopping emulator..."
    _adb emu kill
}

# ── Build & deploy ──────────────────────────────────────────────────

emu_deploy() {
    echo "Building debug APK..."
    (cd "$PROJECT_ROOT" && flutter build apk --debug) || { echo "Build failed"; return 1; }
    local apk="$PROJECT_ROOT/build/app/outputs/flutter-apk/app-debug.apk"
    echo "Installing APK..."
    _adb install -r "$apk"
    echo "Deployed."
}

emu_launch() {
    emu_wake
    _adb shell am start -n "$APP_ACTIVITY"
    sleep 2
}

emu_clear_data() {
    _adb shell pm clear "$APP_PACKAGE"
    echo "App data cleared."
}

# ── Interaction ─────────────────────────────────────────────────────

emu_tap() {
    local x="$1" y="$2"
    _adb shell input tap "$x" "$y"
    sleep 0.2
}

emu_swipe() {
    local x1="$1" y1="$2" x2="$3" y2="$4" duration="${5:-300}"
    _adb shell input swipe "$x1" "$y1" "$x2" "$y2" "$duration"
    sleep 0.3
}

emu_text() {
    # Input text (spaces must be replaced with %s for ADB)
    local text="${1// /%s}"
    _adb shell input text "$text"
    sleep 0.2
}

emu_back() {
    _adb shell input keyevent KEYCODE_BACK
    sleep 0.3
}

emu_home() {
    _adb shell input keyevent KEYCODE_HOME
    sleep 0.3
}

# ── Screenshots & UI inspection ────────────────────────────────────

emu_screenshot() {
    local name="${1:-screenshot}"
    local timestamp
    timestamp=$(date +%Y%m%d_%H%M%S)
    local filename="${name}_${timestamp}.png"
    _adb shell screencap -p /sdcard/screenshot.png
    _adb_pull /sdcard/screenshot.png "$SCREENSHOT_DIR/$filename"
    _adb shell rm /sdcard/screenshot.png
    echo "$SCREENSHOT_DIR/$filename"
}

emu_ui_dump() {
    _adb shell uiautomator dump /sdcard/window_dump.xml
    _adb_pull /sdcard/window_dump.xml "$PROJECT_ROOT/tmp/window_dump.xml"
    _adb shell rm /sdcard/window_dump.xml
    echo "UI dump: $PROJECT_ROOT/tmp/window_dump.xml"
}

# ── PIN handling ────────────────────────────────────────────────────

# PIN pad coordinates for Medium_Phone_API_36 (1080x2400, 420dpi)
# Flutter PinNumberPad: 72dp buttons (189px), spaceEvenly layout, 16dp gaps (42px)
# Columns (spaceEvenly across 1080px): centers at 223, 540, 857
# Rows: calibrated from screenshot — adjust _PIN_ROW1_Y if layout changes
_PIN_COL1=223
_PIN_COL2=540
_PIN_COL3=857
# Row Y centers (estimated from live screenshot, ~231px apart)
_PIN_ROW1_Y=1370
_PIN_ROW2_Y=1601
_PIN_ROW3_Y=1832
_PIN_ROW4_Y=2063

# Map digit to (x, y) coordinate
_pin_digit_xy() {
    local d="$1"
    case "$d" in
        1) echo "$_PIN_COL1 $_PIN_ROW1_Y" ;;
        2) echo "$_PIN_COL2 $_PIN_ROW1_Y" ;;
        3) echo "$_PIN_COL3 $_PIN_ROW1_Y" ;;
        4) echo "$_PIN_COL1 $_PIN_ROW2_Y" ;;
        5) echo "$_PIN_COL2 $_PIN_ROW2_Y" ;;
        6) echo "$_PIN_COL3 $_PIN_ROW2_Y" ;;
        7) echo "$_PIN_COL1 $_PIN_ROW3_Y" ;;
        8) echo "$_PIN_COL2 $_PIN_ROW3_Y" ;;
        9) echo "$_PIN_COL3 $_PIN_ROW3_Y" ;;
        0) echo "$_PIN_COL2 $_PIN_ROW4_Y" ;;
        *) echo "ERROR: invalid digit $d" >&2; return 1 ;;
    esac
}

# Tap a sequence of PIN digits
_tap_pin_digits() {
    local pin="$1"
    for (( i=0; i<${#pin}; i++ )); do
        local d="${pin:$i:1}"
        local coords
        coords=$(_pin_digit_xy "$d") || return 1
        local x="${coords%% *}"
        local y="${coords##* }"
        emu_tap "$x" "$y"
        sleep 0.15
    done
}

# First launch: enter PIN twice for setup flow
emu_setup_pin() {
    local pin="${1:-$DEV_PIN}"
    echo "Setting up PIN: $pin"
    sleep 1
    _tap_pin_digits "$pin"
    sleep 1.5
    _tap_pin_digits "$pin"
    sleep 1.5
    echo "PIN setup complete."
}

# Subsequent launches: unlock with PIN
emu_unlock() {
    local pin="${1:-$DEV_PIN}"
    echo "Unlocking with PIN..."
    sleep 0.5
    _tap_pin_digits "$pin"
    sleep 1
    echo "Unlock complete."
}

# ── Navigation (bottom tab bar) ─────────────────────────────────────

# Bottom nav: 5 tabs at y=2270, evenly spaced across 1080px
_NAV_Y=2270
emu_tab_dashboard()     { emu_tap 108  $_NAV_Y; sleep 0.5; }
emu_tab_accounts()      { emu_tap 324  $_NAV_Y; sleep 0.5; }
emu_tab_transactions()  { emu_tap 540  $_NAV_Y; sleep 0.5; }
emu_tab_ai()            { emu_tap 756  $_NAV_Y; sleep 0.5; }
emu_tab_settings()      { emu_tap 972  $_NAV_Y; sleep 0.5; }

# Scroll down on current screen
emu_scroll_down()  { emu_swipe 540 1600 540 600 300; }
emu_scroll_up()    { emu_swipe 540 600 540 1600 300; }

# ── Compound helpers ────────────────────────────────────────────────

# Full fresh start: deploy, launch, set up PIN
emu_fresh_start() {
    emu_clear_data
    emu_deploy
    emu_launch
    sleep 2
    emu_setup_pin
}

# Quick resume: launch and unlock
emu_resume() {
    emu_launch
    sleep 1
    emu_unlock
}

echo "Emulator helpers loaded. PROJECT_ROOT=$PROJECT_ROOT"
echo "Commands: emu_start emu_stop emu_deploy emu_launch emu_screenshot emu_ui_dump"
echo "          emu_tap emu_swipe emu_text emu_back emu_home emu_clear_data"
echo "          emu_setup_pin emu_unlock emu_fresh_start emu_resume emu_wake"
echo "          emu_tab_dashboard emu_tab_accounts emu_tab_transactions"
echo "          emu_tab_ai emu_tab_settings emu_scroll_down emu_scroll_up"
