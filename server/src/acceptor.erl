-module(acceptor).

-export([start_link/1]).
-export([loop/1]).


start_link(ListenSocket) ->
    Pid = spawn_link(?MODULE, loop, [ListenSocket]),
    {ok, Pid}.


loop(ListenSocket) ->
    case api:accept(ListenSocket) of
        {ok, ConnSocket} ->
            io:format("accept a socket: ~w~n", [ConnSocket]),
            api:close(ConnSocket);
        {error, emfile} ->
            receive after 100 -> ok end;
        {error, Reason} when Reason =/= closed ->
            ok
    end,
    loop(ListenSocket).

