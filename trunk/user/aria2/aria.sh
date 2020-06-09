#!/bin/sh

#######################################################################
# (1) run process from superuser root (less security)
# (0) run process from unprivileged user "nobody" (more security)
SVC_ROOT=0

# process priority (0-normal, 19-lowest)
SVC_PRIORITY=3
#######################################################################

SVC_NAME="Aria2"
SVC_PATH="/usr/bin/aria2c"
DIR_LINK="/mnt/aria"

func_start()
{
	# Make sure already running
	if [ -n "`pidof aria2c`" ] ; then
		return 0
	fi

	echo -n "Starting $SVC_NAME:."

	if [ ! -d "${DIR_LINK}" ] ; then
		echo "[FAILED]"
		logger -t "$SVC_NAME" "Cannot start: unable to find target dir!"
		return 1
	fi

	DIR_CFG="${DIR_LINK}/config"
	DIR_DL1="`cd \"$DIR_LINK\"; dirname \"$(pwd -P)\"`/Downloads"
	[ ! -d "$DIR_DL1" ] && DIR_DL1="${DIR_LINK}/downloads"

	[ ! -d "$DIR_CFG" ] && mkdir -p "$DIR_CFG"

	FILE_CONF="$DIR_CFG/aria2.conf"
	FILE_LIST="$DIR_CFG/incomplete.lst"

	touch "$FILE_LIST"

	aria_pport=`nvram get aria_pport`
	aria_rport=`nvram get aria_rport`
	aria_user=`nvram get http_username`
	aria_pass=`nvram get http_passwd`

	[ -z "$aria_rport" ] && aria_rport="6800"
	[ -z "$aria_pport" ] && aria_pport="16888"

	if [ ! -f "$FILE_CONF" ] ; then
		[ ! -d "$DIR_DL1" ] && mkdir -p "$DIR_DL1"
		chmod -R 777 "$DIR_DL1"
		cat > "$FILE_CONF" <<EOF

### XML-RPC
rpc-listen-all=true
rpc-allow-origin-all=true
#rpc-secret=
#rpc-user=$aria_user
#rpc-passwd=$aria_pass

### Common
dir=$DIR_DL1
max-download-limit=0
max-overall-download-limit=0
disable-ipv6=false

### File
#file-allocation=trunc
#file-allocation=falloc
file-allocation=none
no-file-allocation-limit=10M
allow-overwrite=false
auto-file-renaming=true

### Bittorent
bt-enable-lpd=false
#bt-lpd-interface=eth2.2
bt-max-peers=50
bt-max-open-files=100
bt-request-peer-speed-limit=100K
bt-stop-timeout=0
enable-dht=true
#enable-dht6=false
enable-peer-exchange=true
seed-ratio=1.5
#seed-time=60
max-upload-limit=0
max-overall-upload-limit=0

### FTP/HTTP
ftp-pasv=true
ftp-type=binary
timeout=120
connect-timeout=60
split=8
max-concurrent-downloads=3
max-connection-per-server=8
min-split-size=1M
check-certificate=false

### Log
log=$DIR_CFG/aria2.log
log-level=notice
bt-tracker=udp://tracker.coppersurfer.tk:6969/announce,udp://tracker.opentrackr.org:1337/announce,http://tracker.opentrackr.org:1337/announce,udp://tracker.leechers-paradise.org:6969/announce,udp://p4p.arenabg.com:1337/announce,udp://9.rarbg.to:2710/announce,udp://9.rarbg.me:2710/announce,udp://exodus.desync.com:6969/announce,udp://tracker.cyberia.is:6969/announce,udp://open.stealth.si:80/announce,udp://retracker.lanta-net.ru:2710/announce,udp://tracker.tiny-vps.com:6969/announce,udp://tracker3.itzmx.com:6961/announce,udp://tracker.torrent.eu.org:451/announce,http://tracker3.itzmx.com:6961/announce,http://tracker1.itzmx.com:8080/announce,udp://tracker.moeking.me:6969/announce,udp://ipv4.tracker.harry.lu:80/announce,udp://bt1.archive.org:6969/announce,udp://bt2.archive.org:6969/announce,udp://valakas.rollo.dnsabr.com:2710/announce,udp://opentor.org:2710/announce,udp://explodie.org:6969/announce,http://explodie.org:6969/announce,udp://tracker.zerobytes.xyz:1337/announce,udp://tracker.uw0.xyz:6969/announce,udp://tracker.lelux.fi:6969/announce,udp://tracker.kamigami.org:2710/announce,udp://tracker.ds.is:6969/announce,udp://tracker.army:6969/announce,udp://tracker-udp.gbitt.info:80/announce,udp://retracker.akado-ural.ru:80/announce,udp://opentracker.i2p.rocks:6969/announce,udp://chihaya.de:6969/announce,https://tracker.lelux.fi:443/announce,https://tracker.gbitt.info:443/announce,http://vps02.net.orel.ru:80/announce,http://tracker.zerobytes.xyz:1337/announce,http://tracker.nyap2p.com:8080/announce,http://tracker.lelux.fi:80/announce,http://tracker.kamigami.org:2710/announce,http://tracker.gbitt.info:80/announce,http://tracker.bt4g.com:2095/announce,http://opentracker.i2p.rocks:6969/announce,http://h4.trakx.nibba.trade:80/announce,udp://u.wwwww.wtf:1/announce,udp://tracker.jae.moe:6969/announce,udp://tracker.dler.org:6969/announce,udp://t3.leech.ie:1337/announce,udp://t2.leech.ie:1337/announce,udp://t1.leech.ie:1337/announce,udp://aaa.army:8866/announce,https://w.wwwww.wtf:443/announce,https://tracker.jae.moe:443/announce,https://aaa.army:8866/announce,http://tracker.dler.org:6969/announce,http://t3.leech.ie:80/announce,http://t2.leech.ie:80/announce,http://t1.leech.ie:80/announce,http://t.overflow.biz:6969/announce,http://aaa.army:8866/announce,udp://zephir.monocul.us:6969/announce,udp://tracker.yoshi210.com:6969/announce,udp://tracker.teambelgium.net:6969/announce,udp://tracker.skyts.net:6969/announce,udp://retracker.sevstar.net:2710/announce,udp://retracker.netbynet.ru:2710/announce,https://tracker.tamersunion.org:443/announce,https://tracker.sloppyta.co:443/announce,https://tracker.nitrix.me:443/announce,https://tracker.nanoha.org:443/announce,https://1337.abcvg.info:443/announce,http://trun.tom.ru:80/announce,http://tracker2.dler.org:80/announce,http://tracker.yoshi210.com:6969/announce,http://tracker.ygsub.com:6969/announce,http://tracker.skyts.net:6969/announce,http://t.nyaatracker.com:80/announce,http://retracker.sevstar.net:2710/announce,http://open.acgtracker.com:1096/announce,http://mail2.zelenaya.net:80/announce,udp://www.loushao.net:8080/announce,udp://tracker6.dler.org:2710/announce,udp://tracker4.itzmx.com:2710/announce,udp://tracker2.itzmx.com:6961/announce,udp://tracker.filemail.com:6969/announce,udp://tr2.ysagin.top:2710/announce,udp://tr.bangumi.moe:6969/announce,udp://qg.lorzl.gq:2710/announce,udp://cx42light.cn:39652/announce,udp://bt2.54new.com:8080/announce,https://tracker.vectahosting.eu:2053/announce,https://tracker.imgoingto.icu:443/announce,https://tracker.hama3.net:443/announce,https://tracker.coalition.space:443/announce,https://tr.ready4.icu:443/announce,http://www.loushao.net:8080/announce,http://tracker4.itzmx.com:2710/announce,http://tracker2.itzmx.com:6961/announce,http://t.acg.rip:6699/announce,http://open.acgnxtracker.com:80/announce

EOF
	fi

	# aria2 needed home dir
	export HOME="$DIR_CFG"

	if [ "`nvram get http_proto`" != "0" ]; then
		SVC_ROOT=1
		SSL_OPT="--rpc-secure=true --rpc-certificate=/etc/storage/https/server.crt --rpc-private-key=/etc/storage/https/server.key"
	else
		SSL_OPT=
	fi

	svc_user=""

	if [ $SVC_ROOT -eq 0 ] ; then
		chmod 777 "${DIR_LINK}"
		chown -R nobody "$DIR_CFG"
		svc_user=" -c nobody"
	fi

	start-stop-daemon -S -N $SVC_PRIORITY$svc_user -x $SVC_PATH -- \
		-D --enable-rpc=true --conf-path="$FILE_CONF" --input-file="$FILE_LIST" --save-session="$FILE_LIST" \
		--rpc-listen-port="$aria_rport" --listen-port="$aria_pport" --dht-listen-port="$aria_pport" $SSL_OPT

	if [ $? -eq 0 ] ; then
		echo "[  OK  ]"
		logger -t "$SVC_NAME" "daemon is started"
	else
		echo "[FAILED]"
	fi
}

func_stop()
{
	# Make sure not running
	if [ -z "`pidof aria2c`" ] ; then
		return 0
	fi

	echo -n "Stopping $SVC_NAME:."

	# stop daemon
	killall -q aria2c

	# gracefully wait max 15 seconds while aria2c stopped
	i=0
	while [ -n "`pidof aria2c`" ] && [ $i -le 15 ] ; do
		echo -n "."
		i=$(( $i + 1 ))
		sleep 1
	done

	aria_pid=`pidof aria2c`
	if [ -n "$aria_pid" ] ; then
		# force kill (hungup?)
		kill -9 "$aria_pid"
		sleep 1
		echo "[KILLED]"
		logger -t "$SVC_NAME" "Cannot stop: Timeout reached! Force killed."
	else
		echo "[  OK  ]"
	fi
}

func_reload()
{
	aria_pid=`pidof aria2c`
	if [ -n "$aria_pid" ] ; then
		echo -n "Reload $SVC_NAME config:."
		kill -1 "$aria_pid"
		echo "[  OK  ]"
	else
		echo "Error: $SVC_NAME is not started!"
	fi
}

case "$1" in
start)
	func_start
	;;
stop)
	func_stop
	;;
reload)
	func_reload
	;;
restart)
	func_stop
	func_start
	;;
*)
	echo "Usage: $0 {start|stop|reload|restart}"
	exit 1
	;;
esac
