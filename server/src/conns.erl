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


-module(conns).

-include("head.hrl").


-export([start_link/1]).
-export([loop/2]).


start_link(ConnSocket) ->
    Pid = spawn_link(?MODULE, loop, [ConnSocket, []]),
    {ok, Pid}.


loop(ConnSocket, Buf) ->    
    api:setopts(ConnSocket, [{active, once}]),
    receive
        {tcp, ConnSocket, Data} ->
            RecvSize = byte_size(list_to_binary([Data | Buf])),
            io:format("conn: ~p. RecvSize: ~p. received data: ~p~n", [self(), RecvSize, Data]),
            case RecvSize == ?ECHO_SIZE of
                true ->
                    SendRet = api:send(ConnSocket, list_to_binary(lists:reverse([Data | Buf]))),
                    io:format("SendRet: ~p echo_size: ~p~n", [SendRet, ?ECHO_SIZE]),
                    loop(ConnSocket, []);
                false ->
                    loop(ConnSocket, [Data | Buf])
            end;
        {tcp_closed, _Socket} ->
            io:format("conn: ~p socket closed by peer. to die~n", [self()]);
        _Other ->
            io:format("conn: ~p socket error. to die~n", [self()])
    end.
                        
