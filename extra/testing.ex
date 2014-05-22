#!/usr/bin/expect -f
#
# Usage: testing.ex <path to arping> <ip address> <mac address>
#
# Test all cases against a "normal" machine:
# * Responds to ARP
# * Responds to ping
# * Doesn't respond to broadcast pings.
#
# Abnormal machines, to be tested elsewhere:
# * Proxy ARP
# * Respond to broadcast pings
# * Lost packets
# * Duplicated replies
#
# Tested here:
# * -a
# * -c
# * -D
# * -e
# * -h
# * -q (soon)
# * -r (soon)
# * -R (soon)
# * -s (soon)
# * -S (soon)
# * -t
# * -T
# * -u (soon)
# * -v (soon)
# * -w (soon)
# * -W (soon)
#
# Not tested here:
# * -0
# * -A
# * -b
# * -B
# * -d
# * -p
# * -U
# * Mac ping without -T.
#
set bin [lindex $argv 0]
set ip [lindex $argv 1]
set mac [lindex $argv 2]
set bad_ip "1.2.4.3"
set bad_mac "00:11:22:33:44:55"

send_user -- "--------------- No options ------------------\n"
spawn $bin
expect -re "ARPing 2\.\d+, by Thomas Habets <thomas@habets.se>\r
usage: arping \\\[ -0aAbdDeFpqrRuUv \\\] \\\[ -w <us> \\\] \\\[ -S <host/ip> \\\]\r
\\\[ -T <host/ip \\\] \\\[ -s <MAC> \\\] \\\[ -t <MAC> \\\] \\\[ -c <count> \\\]\r
\\\[ -i <interface> \\\] <host/ip/MAC | -B>\r
For complete usage info, use --help or check the manpage.\r
"
expect eof

send_user -- "--------------- -h ------------------\n"
spawn $bin -h
expect -re "ARPing 2\.\d+, by Thomas Habets <thomas@habets.se>\r
usage: arping \\\[ -0aAbdDeFpqrRuUv \\\] \\\[ -w <us> \\\] \\\[ -S <host/ip> \\\]\r
\\\[ -T <host/ip \\\] \\\[ -s <MAC> \\\] \\\[ -t <MAC> \\\] \\\[ -c <count> \\\]\r
\\\[ -i <interface> \\\] <host/ip/MAC | -B>\r
For complete usage info, use --help or check the manpage.\r
"
expect eof

send_user -- "--------------- --help ------------------\n"
spawn $bin --help
expect -re "ARPing 2\.\d+, by Thomas Habets <thomas@habets.se>\r
usage: arping \\\[ -0aAbdDeFpqrRuUv \\\] \\\[ -w <us> \\\] \\\[ -S <host/ip> \\\]\r
\\\[ -T <host/ip \\\] \\\[ -s <MAC> \\\] \\\[ -t <MAC> \\\] \\\[ -c <count> \\\]\r
\\\[ -i <interface> \\\] <host/ip/MAC | -B>\r
\r
"
expect "Report bugs to: thomas@habets.se\r
Arping home page: <http://www.habets.pp.se/synscan/>\r
Development repo: http://github.com/ThomasHabets/arping\r
"
expect eof

send_user -- "--------------- Ping IP Simple ------------------\n"
spawn $bin -c 1 $ip
expect -re "ARPING $ip\r
60 bytes from $mac \\($ip\\): index=0 time=(.*)sec\r
\r
--- $ip statistics ---\r
1 packets transmitted, 1 packets received,   0% unanswered \\(0 extra\\)\r
rtt min/avg/max/std-dev = \[0-9.\]+/\[0-9.\]+/\[0-9.\]+/0.000 ms\r
"
expect eof

send_user -- "--------------- Ping IP max 2 (-C) ------------------\n"
spawn $bin -C 2 -c 10 $ip
expect -re "ARPING $ip\r
60 bytes from $mac \\($ip\\): index=0 time=(.*)sec\r
60 bytes from $mac \\($ip\\): index=1 time=(.*)sec\r
\r
--- $ip statistics ---\r
2 packets transmitted, 2 packets received,   0% unanswered \\(0 extra\\)\r
rtt min/avg/max/std-dev = \[0-9.\]+/\[0-9.\]+/\[0-9.\]+/\[0-9.\]+ ms\r
"
expect eof

send_user -- "--------------- Ping IP x 3 (-c) ------------------\n"
spawn $bin -c 3 $ip
expect -re "ARPING $ip\r
60 bytes from $mac \\($ip\\): index=0 time=\[0-9.\]+ \[mu\]?sec\r
60 bytes from $mac \\($ip\\): index=1 time=\[0-9.\]+ \[mu\]?sec\r
60 bytes from $mac \\($ip\\): index=2 time=\[0-9.\]+ \[mu\]?sec\r
\r
--- $ip statistics ---\r
3 packets transmitted, 3 packets received,   0% unanswered \\(0 extra\\)\r
rtt min/avg/max/std-dev = \[0-9.\]+/\[0-9.\]+/\[0-9.\]+/\[0-9.\]+ ms\r
"
expect eof

send_user -- "--------------- Ping IP x 3 with audio (-a)  ------------------\n"
spawn $bin -c 3 -a $ip
expect -re "ARPING $ip\r
60 bytes from $mac \\($ip\\): index=0 time=\[0-9.\]+ \[mu\]?sec\a\r
60 bytes from $mac \\($ip\\): index=1 time=\[0-9.\]+ \[mu\]?sec\a\r
60 bytes from $mac \\($ip\\): index=2 time=\[0-9.\]+ \[mu\]?sec\a\r
\r
--- $ip statistics ---\r
3 packets transmitted, 3 packets received,   0% unanswered \\(0 extra\\)\r
rtt min/avg/max/std-dev = \[0-9.\]+/\[0-9.\]+/\[0-9.\]+/\[0-9.\]+ ms\r
"
expect eof

send_user -- "--------- Ping IP x 2 with inverted audio (-e)  ------------\n"
spawn $bin -c 2 -e $ip
expect -re "ARPING $ip\r
60 bytes from $mac \\($ip\\): index=0 time=\[0-9.\]+ \[mu\]?sec\r
60 bytes from $mac \\($ip\\): index=1 time=\[0-9.\]+ \[mu\]?sec\r
\r
--- $ip statistics ---\r
2 packets transmitted, 2 packets received,   0% unanswered \\(0 extra\\)\r
rtt min/avg/max/std-dev = \[0-9.\]+/\[0-9.\]+/\[0-9.\]+/\[0-9.\]+ ms\r
"
expect eof

send_user -- "--------- Ping IP x 2 with inverted audio, bad IP (-e)  ------------\n"
spawn $bin -c 2 -e "$bad_ip"
expect -re "ARPING $bad_ip\r
Timeout\r
\aTimeout\r
\a\r
--- $bad_ip statistics ---\r
2 packets transmitted, 0 packets received, 100% unanswered \\(0 extra\\)\r
\r
"
expect eof

send_user -- "--------- Ping IP x 2 with inverted audio (-e -D)  ------------\n"
spawn $bin -c 2 -e -D $ip
expect "!!\t  0% packet loss (0 extra)\r\n"
expect eof

send_user -- "--------- Ping IP x 2 with inverted audio, bad IP (-e -D)  ------------\n"
# TODO: surely this should be \a.\a. ?
spawn $bin -c 2 -e -i eth0 -D "$bad_ip"
expect "\a\a..\t100% packet loss (0 extra)\r\n"
expect eof

send_user -- "--------------- Ping IP cisco style (-D) ------------------\n"
spawn $bin -c 3 -D $ip
expect "!!!\t  0% packet loss (0 extra)\r\n"
expect eof

send_user -- "--------------- Ping IP cisco style with audio (-D -a) -----------\n"
spawn $bin -c 3 -D -a $ip
expect "!\a!\a!\a\t  0% packet loss (0 extra)\r\n"
expect eof

send_user -- "--------------- Ping IP Targeted (-t) ------------------\n"
spawn $bin -c 1 $ip -t $mac
expect -re "ARPING $ip\r
60 bytes from $mac \\($ip\\): index=0 time=(.*)sec\r
\r
--- $ip statistics ---\r
1 packets transmitted, 1 packets received,   0% unanswered \\(0 extra\\)\r
rtt min/avg/max/std-dev = \[0-9.\]+/\[0-9.\]+/\[0-9.\]+/0.000 ms\r
"
expect eof

send_user -- "--------------- Ping IP Mistargeted (-t) ------------------\n"
spawn $bin -c 1 $ip -t $bad_mac
expect "ARPING $ip\r
Timeout\r
\r
--- $ip statistics ---\r
1 packets transmitted, 0 packets received, 100% unanswered \\(0 extra\\)\r
"
expect eof

send_user -- "--------------- Ping MAC with IP destination ------------------\n"
spawn $bin -A -c 1 $mac -T $ip
expect -re "ARPING $mac\r
60 bytes from $ip \\($mac\\): icmp_seq=0 time=(.*)sec\r
\r
--- $mac statistics ---\r
1 packets transmitted, 1 packets received,   0% unanswered \\(0 extra\\)\r
rtt min/avg/max/std-dev = \[0-9.\]+/\[0-9.\]+/\[0-9.\]+/0.000 ms\r
"
expect eof

send_user -- "--------------- Ping MAC max 2 (-C) ------------------\n"
spawn $bin -A -C 2 -c 10 $mac -T $ip
expect -re "ARPING $mac\r
60 bytes from $ip \\($mac\\): icmp_seq=0 time=(.*)sec\r
60 bytes from $ip \\($mac\\): icmp_seq=1 time=(.*)sec\r
\r
--- $mac statistics ---\r
2 packets transmitted, 2 packets received,   0% unanswered \\(0 extra\\)\r
rtt min/avg/max/std-dev = \[0-9.\]+/\[0-9.\]+/\[0-9.\]+/\[0-9.\]+ ms\r
"
expect eof

send_user -- "--------------- Ping MAC cisco style (-D) ------------------\n"
spawn $bin -A -c 3 -D $mac -T $ip
expect "!!!\t  0% packet loss (0 extra)\r\n"
expect eof

send_user -- "--------------- Ping MAC cisco style with audio (-D -a) -----------\n"
spawn $bin -A -c 3 -D -a $mac -T $ip
expect "!\a!\a!\a\t  0% packet loss (0 extra)\r\n"
expect eof

send_user -- "--------- Ping MAC x 2 with inverted audio (-e)  ------------\n"
spawn $bin -c 2 "$mac" -T $ip
expect -re "ARPING $mac\r
60 bytes from $ip \\($mac\\): icmp_seq=0 time=(.*)sec\r
60 bytes from $ip \\($mac\\): icmp_seq=1 time=(.*)sec\r
\r
--- $mac statistics ---\r
2 packets transmitted, 2 packets received,   0% unanswered \\(0 extra\\)\r
rtt min/avg/max/std-dev = \[0-9.\]+/\[0-9.\]+/\[0-9.\]+/\[0-9.\]+ ms\r
"
expect eof

send_user -- "--------- Ping MAC x 2 with inverted audio, bad dest (-e)  ------------\n"
spawn $bin -e -c 2 "$bad_mac" -T $ip
expect -re "ARPING $bad_mac\r
Timeout\r
\aTimeout\r
\a\r
--- $bad_mac statistics ---\r
2 packets transmitted, 0 packets received, 100% unanswered \\(0 extra\\)\r
\r
"
expect eof

send_user -- "--------- Ping MAC x 2 with inverted audio (-e -D)  ------------\n"
spawn $bin -A -e -c 2 -D $mac -T $ip
expect "!!\t  0% packet loss (0 extra)\r\n"
expect eof

send_user -- "--------- Ping MAC x 2 with inverted audio, bad dest (-e -D)  ------------\n"
# TODO: surely this should be \a.\a. ?
spawn $bin -A -c 2 -e -i eth0 -D $bad_mac -T $ip
expect "\a\a..\t100% packet loss (0 extra)\r\n"
expect eof
