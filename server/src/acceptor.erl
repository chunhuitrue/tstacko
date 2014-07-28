-module(acceptor).

-export([start_link/0]).
-export([init/1]).

-export([system_code_change/4]).
-export([system_continue/3]).
-export([system_terminate/4]).
-export([write_debug/3]).


start_link() ->
    proc_lib:start_link(?MODULE, init, [self()]).


init(Parent) ->
    register(?MODULE, self()),
    Debug = sys:debug_options([]),
    proc_lib:init_ack(Parent, {ok, self()}),
    loop(Parent, Debug, []).


loop(Parent, Debug, State) ->
    receive
        {system, From, Request} ->
            sys:handle_system_msg(Request, From, Parent, ?MODULE, Debug, State);
        Msg ->
            sys:handle_debug(Debug, fun ?MODULE:write_debug/3, ?MODULE, {in, Msg}),
            loop(Parent, Debug, State)
    end.


write_debug(Dev, Event, Name) ->
    io:format(Dev, "~p event = ~p~n", [Name, Event]).


system_continue(Parent, Debug, State) ->
    loop(Parent, Debug, State).


system_terminate(Reason, _Parent, _Debug, _State) ->
    exit(Reason).


system_code_change(State, _Module, _OldVsn, _Extra) ->
    {ok, State}.
