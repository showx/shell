#!/bin/bash

username='user'
password='pass'

SHOW_COUNT=5

echo
curl -u $username:$password --silent "https://mail.google.com/mail/feed/atom" | \
	tr -d '\n' | sed 's:</entry>:\n:g' |\
	sed -n 's/.*<title>\(.*\)<\/title.*<author><name>\([^<]*\)<\/name><email>\([^<]*\).*/From: \2 [\3] \nSubject: \1\n/p' | \
	head -n $(( $SHOW_COUNT * 3 ))
