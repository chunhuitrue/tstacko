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

