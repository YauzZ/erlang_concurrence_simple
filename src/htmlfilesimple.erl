-module(htmlfilesimple).
-behaviour(application).
-export([start/0, start/2, stop/1]).

start() ->
	application:start(cowlib),
	application:start(crypto),
	application:start(ranch),
	application:start(cowboy),
	application:start(htmlfilesimple).

start(_Type, _Args) ->
	Dispatch = cowboy_router:compile([
	    %% {URIHost, list({URIPath, Handler, Opts})}
	    {'_', [{'_', htmlfile_handler, []}]}
	]),
	%% Name, NbAcceptors, TransOpts, ProtoOpts
	cowboy:start_http(my_http_listener, 100,
	    [{port, 8000}, {max_connections, infinity}],
	    [{env, [{dispatch, Dispatch}]}]
	),
	count_server:start(),
	htmlfilesimple_sup:start_link().

stop(_State) ->
	ok.
