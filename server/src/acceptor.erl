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


-module(acceptor).

-export([start_link/1]).
-export([loop/1]).


start_link(ListenSocket) ->
    Pid = spawn_link(?MODULE, loop, [ListenSocket]),
    {ok, Pid}.


loop(ListenSocket) ->
    case api:accept(ListenSocket) of
        {ok, ConnSocket} ->
            {ok, Pid} = conns_sup:start_child(ConnSocket),
            api:controlling_process(ConnSocket, Pid);
        {error, emfile} ->
            receive after 100 -> ok end;
        %% if error reasonis closed, crash
        {error, Reason} when Reason =/= closed ->
            ok
    end,
    loop(ListenSocket).

