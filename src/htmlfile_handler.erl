-module(htmlfile_handler).
-behaviour(cowboy_loop_handler).
-export([init/3, info/3, terminate/3]).
-define(HEARBEAT_TIMEOUT, 20*1000).
-record(status, {count=0}).

init(_Any, Req, State) ->
	NowCount = count_server:welcome(),	
	io:format("online user ~p~n", [NowCount]),
	
	output_first(Req),
	%%Req2 = cowboy_req:compact(Req),
	{loop, Req, State, hibernate}.

%% POST/Short Request
info(_Any, Req, State) ->
	{loop, Req, State, hibernate}.

output_first(Req) ->
	{ok, Reply} = cowboy_req:chunked_reply(200, [{<<"Content-Type">>, <<"text/html; charset=utf-8">>},
								 {<<"Connection">>, <<"keep-alive">>}], Req),
	cowboy_req:chunk(<<"<html><body><script>var _ = function (msg) { parent.s._(msg, document); };</script>                                                                                                                                                                                                                  ">>, 
								Reply),
	cowboy_req:chunk(gen_output("1::"), Reply).

gen_output(String) ->
	DescList = io_lib:format("<script>_('~s');</script>", [String]),
	list_to_binary(DescList).

terminate(Reason, _Req, _State) ->
	NowCount = count_server:bye(),	
	io:format("offline user ~p :(( ~n", [NowCount]).

