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


-module(tserver_sup).

-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).


start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).


init([]) ->
    AcceptorSpec = {acceptor_sup,                     % id
                    {acceptor_sup, start_link, []},   % {Module, Function, Arguments}
                    permanent,                        % Restart
                    brutal_kill,                      % Shutdown
                    supervisor,                       % Type
                    [accepter_sup]},                  % ModuleList

    ConnsSpec = {conns_sup,                     % id
                 {conns_sup, start_link, []},   % {Module, Function, Arguments}
                 permanent,                     % Restart
                 brutal_kill,                   % Shutdown
                 supervisor,                    % Type
                 [conns_sup]},                  % ModuleList

    {ok, {{one_for_one, 5, 10}, [AcceptorSpec, ConnsSpec]}}.

