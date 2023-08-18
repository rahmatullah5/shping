-module(shping_handler).
-export([init/2]).
-export([terminate/2]).
-export([content_types_provided/2]).
-export([shping_to_html/2]).
-export([shping_to_json/2]).
-export([shping_to_text/2]).

init(Req, Opts) ->
    {cowboy_rest, Req, Opts}.

content_types_provided(Req, State) ->
    {
        [
            {<<"application/json">>, shping_to_json},
            {<<"text/plain">>, shping_to_text},
            {<<"text/html">>, shping_to_html}
        ],
        Req,
        State
    }.

shping_to_html(Req, State) ->
    Body =
        <<
            "<html>\n"
            "<head>\n"
            "	<meta charset=\"utf-8\">\n"
            "	<title>REST Hello World!</title>\n"
            "</head>\n"
            "<body>\n"
            "	<p>REST Hello World as HTML!</p>\n"
            "</body>\n"
            "</html>"
        >>,
    {Body, Req, State}.

shping_to_json(Req, State) ->
    case coinbase_api:get_shping_usd_ticker() of
        {ok, Body} ->
            Body0 = list_to_binary(Body),

            #{<<"price">> := PriceBin} = jsx:decode(Body0),
            PriceFloat = binary_to_float(PriceBin),
            PriceInAUD = PriceFloat * 1.4,
            Response = jsx:encode(#{
                <<"coin">> => <<"Shping">>,
                <<"currency">> => <<"AUD">>,
                <<"rate">> => PriceInAUD
            }),
            {Response, Req, State};
        {error, Reason} ->
            Response = jsx:encode(#{<<"error">> => list_to_binary(io_lib:format("~p", [Reason]))}),
            {Response, Req, State}
    end.

shping_to_text(Req, State) ->
    {<<"REST Hello World as text!">>, Req, State}.

terminate(_Req, _State) ->
    ok.
