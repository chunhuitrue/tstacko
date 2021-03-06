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

-export([connect/4]).
-export([send/2]).
-export([setopts/2]).


connect(Address, Port, Options, Timeout) ->
    gen_tcp:connect(Address, Port, Options, Timeout).


send(Socket, Date) ->
    gen_tcp:send(Socket, Date).


setopts(Socket, Options) ->
    inet:setopts(Socket, Options).
