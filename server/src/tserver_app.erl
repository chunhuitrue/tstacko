-module(tserver_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

%% start(_StartType, _StartArgs) ->
%%     tserver_sup:start_link().

start(_StartType, _StartArgs) ->
    case tserver_sup:start_link() of
        {ok, Pid} ->
            %% start acceptors here
            {ok, Pid};
        Other ->
            {error, Other}
    end.

stop(_State) ->
    ok.
