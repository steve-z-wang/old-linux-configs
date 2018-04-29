# read the resource from .Xresources 
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

# external monitor 
~/.config/myScripts/externalMonitorStartUp.sh

# keymap change 
setxkbmap -option ctrl:swapcaps
setxkbmap -option altwin:swap_lalt_lwin

# dpi
xrandr --dpi 210

# transperency 
xcompmgr &

# redshift 
redshift -O 4000

# start xmonad
exec xmonad 
