#!/usr/bin/expect -f
set timeout 600
set date [exec date "+%Y-%m-%d"]
set package [lindex $argv 0]

spawn /usr/bin/get_reference_source  -p $package
expect {
  "type 'yes' to continue:" { send "yes\n" }
}

log_file log/$date.log

expect eof
