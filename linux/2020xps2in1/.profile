export QT_QPA_PLATFORMTHEME="qt5ct"
export EDITOR=/usr/bin/nano
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
# fix "xdg-open fork-bomb" export your preferred browser from here
export BROWSER="env MOZ_USE_XINPUT2 DEFAULT=1 /opt/firefox-nightly/firefox"
# HiDPI stuff
export GDK_SCALE=3
export GDK_DPI_SCALE=0.33
export QT_AUTO_SCREEN_SET_FACTOR=0
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_SCALE_FACTOR=3
export QT_FONT_DPI=96
/usr/bin/xrandr --output eDP-1 --scale 1.3x1.3
