-module(coinbase_api).
-export([get_shping_usd_ticker/0]).

%% URL for the Coinbase API endpoint for SHPING-USD ticker.
-define(URL, "https://api.exchange.coinbase.com/products/SHPING-USD/ticker").

%% Fetches the SHPING-USD ticker information from Coinbase.
get_shping_usd_ticker() ->
    Headers = [{"User-Agent", "MyErlangApp/1.0"}],
    Options = [{ssl, [{verify, verify_none}]}],

    case httpc:request(get, {?URL, Headers}, Options, []) of
        {ok, {{_, 200, _}, _Headers, Body}} ->
            {ok, Body};
        {ok, {{_, Status, _}, _Headers, _Body}} ->
            {error, {unexpected_status, Status}};
        {error, Reason} ->
            {error, Reason}
    end.
