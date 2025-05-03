This is a simple syslog daemon that takes the EC console log messages and sends them to local syslog.
It is written in rust.

Compile it with:
cargo build


Run it with:
sudo ./target/debug/ec-syslog


It is a daemon so runs in the backround.
The messages in the syslog have its PID, if you wish to kill it.

It needs to be run as root (sudo) because the /sys file it reads from needs root to read it.



