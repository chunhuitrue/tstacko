%% Copyright LiChunhui (chunhui_true@163.com)
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%   http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.


-module(client).

-include("head.hrl").

-export([start_link/0]).
-export([start_connect/0]).


start_link() ->
    Pid = spawn_link(?MODULE, start_connect, []),
    {ok, Pid}.


start_connect() ->
    case api:connect(?HOST, ?PORT, [binary], ?CONN_TIMEOUT) of
        {ok, Socket} ->
            io:format("client: ~p connect ok. ~n", [self()]),
            send_recv(Socket);
        {error, Reason} ->
            io:format("client: ~p connect error. reason: ~p. retry ~n", [self(), Reason]),
            start_connect()
    end.
    

send_recv(Socket) ->
    api:send(Socket, list_to_binary(["A" || _ <- lists:seq(1, ?ECHO_SIZE)])),
    recv_echo(Socket, []).


recv_echo(Socket, Buf) ->
    receive
        {tcp, Socket, Data} ->
            RecvSize = byte_size(list_to_binary([Data | Buf])),
            io:format("client: ~p RecvSize: ~p. received data: ~p~n", [self(), RecvSize, Data]),
            case RecvSize == ?ECHO_SIZE of
                true ->
                    io:format("client: ~p echo ok. echo data: ~p~n", 
                              [self(), list_to_binary(lists:reverse([Data | Buf]))]),
                    send_recv(Socket);
                false ->
                    recv_echo(Socket, [Data | Buf])
            end;
        {tcp_closed, Socket} ->
            io:format("client: ~p socket closed by peer.~n", [self()]),
            api:close(Socket),
            start_connect();
        _Other ->
            io:format("client: ~p socket error. loop again.~n", [self()]),
            api:close(Socket),
            start_connect()
    end.
    
