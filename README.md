# phorensix

Phorensix is a post-login VoIP forensics tool created for
Asterisk (tested on Asterisk 1.4.5 to be exact).

Phorensix takes a look at a rogue host connecting to a vulnerable
account. Who is connecting, where are they coming from, what are they
doing to my PBX, what are they doing ON MY PBX.

It is a work in progress that can be scripted to take a list of
accounts, and do the legwork... It uses tshark to capture a 2 minute
network conversation between the attacker and host, does a quick
lookup to see where the attacker is coming from, checks against
rogue hosts via Shadowserver and can also block that subnet if need
be.

Because of the variances on Asterisk and the logging, I decided to
ignore the bruteforcers, create an account (100) with a simple
password (100) which would allow any brute forcer instance access
to the account. This allows me to focus solely on people who are
actually trying to make calls.

Why shell, I use {perl,ruby,python,etc}@!? Simple; everyone's
system differs. Rather than create a makefile and install yet more
software on your machine, the system relies on what's always going
to be available... Shell scripting

Requires: tshark and... that's it. Change the email address to get
alerts sent upon the someone logging onto the honeypot.

## TSHARK
https://www.wireshark.org/download.html
