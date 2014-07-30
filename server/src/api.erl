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


-module(api).

-include("head.hrl").

-export([accept/1]).
-export([listen/2]).
-export([recv/2]).
-export([send/2]).
-export([setopts/2]).
-export([controlling_process/2]).
-export([close/1]).


accept(ListenSocket) ->
    gen_tcp:accept(ListenSocket).


listen(Port, Opts) ->
    gen_tcp:listen(Port, Opts).


recv(Socket, N) ->
    gen_tcp:recv(Socket, N).


send(Socket, Data) ->
    gen_tcp:send(Socket, Data).


controlling_process(Socket, Pid) ->
    gen_tcp:controlling_process(Socket, Pid).


close(Scoket) ->
    gen_tcp:close(Scoket).


setopts(Socket, Options) ->
    inet:setopts(Socket, Options).
