-module(tserver_app).

-behaviour(application).

-export([start/2, stop/1]).


%% start(_StartType, _StartArgs) ->
%%     case tserver_sup:start_link() of
%%         {ok, Pid} ->
%%             %% start acceptors here
%%             {ok, Pid};
%%         Other ->
%%             {error, Other}
%%     end.

start(_StartType, _StartArgs) ->
    tserver_sup:start_link().


stop(_State) ->
    ok.
