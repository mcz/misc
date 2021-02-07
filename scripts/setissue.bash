#!/bin/sh
cat > /etc/issue <<- 'EOF'
	ARCH LINUX (\v)                                         \s \r (\l)                                                                              \d \t
	
EOF

case "$1" in
	"")
		cat >> /etc/issue <<- EOF
			$(fortune -a -n 300 -s)
			
			
		EOF
		;;
	"-c")
		cat >> /etc/issue <&0
		;;
	"-f")
		[[ -f "$2" ]] && { cat "$2" >> /etc/issue; exit 0; }
		;&
	*)
		cat <<- EOF
			Usage: "$0" [OPTION]
			Set /etc/issue
			-c           read from stdin
			-f FILE      read from FILE
		EOF
		;;
esac
