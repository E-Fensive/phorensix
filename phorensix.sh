#!/bin/sh

# phorensix v.1
# J. Oquendo
# 01/11/11 
# See README.md


#####################################################################
#                                                                   #
#                 Sample extensions.conf context                    #
#                                                                   #
#####################################################################

# [phorensix]
#
# 
# ; First get and document the information for an attacker
# ; and place that information in a file
#
# exten => _X.,1,system(echo "${EXTEN} ${STRFTIME(${EPOCH},EDT,%F-%T)} - ${CALLERID} - ${CHANNEL}" >> /usr/phorensix/calls)
#
# ; Here we will answer a call 50% of the time. This variable is inverted
# ; so to answer say 10% of the calls, the number needs to be 90.  Don't
# ; ask about the backwardness (Asterisk)
#
# exten => _X.,2,GotoIf($[${RAND(0,99)} + 50 >= 100]?s|1)
#
# ; Everything else simply gets recorded for evidence, etc., no one
# ; would want to consistently answer 1+ calls per second. It's not
# ; necessary.
# 
# exten => _X.,1,system(/usr/local/bin/phorensix&)
# exten => _X.,2,Answer
# exten => _X.,3,Record(/usr/phorensix/recordings/phorensix%d:wav)
# exten => _X.,4,Wait(5)
# exten => _X.,5,Hangup
#
#
# exten => s,1,system(/usr/local/bin/phorensix&)
# exten => s,2,Dial(SIP/your.account.if.you.want.to.answer.phones)
# exten => s,3,Hangup

#####################################################################
#                                                                   #
#                 Sample sip.conf context                           #
#                                                                   #
#####################################################################

# [100]
# username=100
# secret=100
# canreinvite=no
# host=dynamic
# nat=yes
# canreinvite=no
# allow=ulaw
# disallow=all
# qualify=yes
# context=phorensix
# dtmfmode=rfc2833
# type=friend
# callerid=Phorensix 100<12125551212>
# alwaysauthreject=yes
#


peer='(Unspecified)'

while true ; do

                if [ `asterisk -rx "sip show peer 100"|strings|awk '/Addr/{print $3}'` = "$peer" ] ; then

        exit

        else


                now=`date +%Y%m%d`
                
                attacker=`asterisk -rx "sip show peer 100"|strings|awk '/Addr/{print $3}'`
                mkdir /usr/phorensix/$attacker-$now && cd /usr/phorensix/$attacker-$now
                echo "whois -h whois.asn.shadowserver.org 'peer $attacker verbose' >> /usr/phorensix/$attacker-$now/shadowlookup-$attacker-$now.txt" | sh 
                echo "tshark -R \"ip.addr == $attacker\" -w /usr/phorensix/$attacker-$now/$attacker-$now.cap -a duration:120 | grep -vi specified" | sh 
                traceroute $attacker > /usr/phorensix/$attacker-$now/$attacker-trace.txt 

                md5sum /usr/phorensix/$attacker-$now/shadowlookup-$attacker-$now.txt > /usr/phorensix/$attacker-$now/$attacker-$now-checksum.txt
                md5sum /usr/phorensix/$attacker-$now/$attacker-$now.cap >> /usr/phorensix/$attacker-$now/$attacker-$now-checksum.txt
                md5sum /usr/phorensix/$attacker-$now/$attacker-trace.txt >> /usr/phorensix/$attacker-$now/$attacker-$now-checksum.txt

                echo `hostname` | mail -s "Phorensix on `hostname` has been triggered" your@email.address.goes.here.com


        fi


done


                # seems like CentOS keeps the script in a loop. This is to kill
                # the process(es) associated with phorensix if they're stuck

                sleep 120
                lsof | awk '/awk '/\/usr\/sbin\/phorensix/{print "kill -9 "$2}' | sh
