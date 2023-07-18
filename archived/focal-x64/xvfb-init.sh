XVFB=/usr/bin/Xvfb
XVFBARGS=":10 -ac -screen 0 1280x800x24 -nolisten tcp -dpi 96 +extension RANDR"
/sbin/start-stop-daemon --start --quiet --background --exec $XVFB -- $XVFBARGS