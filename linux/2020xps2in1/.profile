export WLR_DRM_NO_MODIFIERS=1
# Fixes issues on jetbrains ides
export _JAVA_AWT_WM_NONREPARENTING=1
# More functional tray on waybar
export XDG_CURRENT_DESKTOP=sway
# Force firefox into wayland and enable hw video decoding (ff 75+)
export MOZ_ENABLE_WAYLAND=1
#export MOZ_WAYLAND_USE_VAAPI=1
# QT apps theme
export QT_QPA_PLATFORMTHEME=qt5ct
export GTK_IM_MODULE=uim
uim-xim &
export XMODIFIERS=@im=uim
export XAUTHORITY=$HOME/.Xauthority
export GDK_BACKEND=wayland
