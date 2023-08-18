%%%-------------------------------------------------------------------
%% @doc shping public API
%% @end
%%%-------------------------------------------------------------------

-module(shping_app).

-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_StartType, _StartArgs) ->
    {ok, _} = application:ensure_all_started(ranch),
    {ok, _} = application:ensure_all_started(cowboy),

    Dispatch = cowboy_router:compile([
        {'_', [{"/", shping_handler, []}]}
    ]),
    {ok, _} = cowboy:start_clear(
        my_http_listener,
        [{port, 8080}],
        #{env => #{dispatch => Dispatch}}
    ),

    shping_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
