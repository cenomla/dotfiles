# Prevent path from taking on duplicate entires
typeset -U path

path=($HOME/.local/bin $path[@])

#export GDK_SCALE=2
#export GDK_DPI_SCALE=0.5
#export QT_AUTO_SCREEN_SCALE_FACTOR=1
