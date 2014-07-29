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
-export([loop/1]).


start_link(ConnSocket) ->
    Pid = spawn_link(?MODULE, loop, [ConnSocket]),
    api:controlling_process(ConnSocket, Pid),
    {ok, Pid}.


loop(ConnSocket) ->
    case api:recv(ConnSocket, ?ECHO_SIZE) of
        {ok, Data} ->
            io:format("conn: ~p received data: ~p~n",[self(), Data]),
            api:send(ConnSocket, Data),
            loop(ConnSocket);
        {error, Reason} ->
            io:format("conn: ~p received error: ~p~n",[self(), Reason]),
            api:close(ConnSocket)
    end.
    
