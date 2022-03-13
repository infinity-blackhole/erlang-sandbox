%%%-------------------------------------------------------------------
%% @doc sandbox public API
%% @end
%%%-------------------------------------------------------------------

-module(sandbox_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    sandbox_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
