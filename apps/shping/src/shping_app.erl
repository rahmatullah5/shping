%%%-------------------------------------------------------------------
%% @doc shping public API
%% @end
%%%-------------------------------------------------------------------

-module(shping_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    shping_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
