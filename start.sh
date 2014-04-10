#!/bin/sh
erl +K true +P 10240000 -sname testserver -pa ebin -pa deps/*/ebin -s htmlfilesimple\
	-eval "io:format(\"Server start with port 8000 Success!~n\")." \
	> server.log

