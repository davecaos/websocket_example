-module(fact_handler).
-behaviour(cowboy_http_handler).
-behaviour(cowboy_websocket_handler).
-export([init/3, handle/2, terminate/3]).
-export([
    websocket_init/3, websocket_handle/3,
    websocket_info/3, websocket_terminate/3
]).

init({tcp, http}, _Req, _Opts) ->
  {upgrade, protocol, cowboy_websocket}.


handle(_Req, State) ->
    {ok, Req2} = cowboy_http_req:reply(404, [{'Content-Type', <<"text/html">>}]),
    {ok, Req2, State}.


websocket_init(_TransportName, Req, _Opts) ->
    {ok, Req, undefined_state}.

websocket_handle({text, NumberBinary}, Req, State) ->
    Number = binary_to_integer(NumberBinary),
    Result = chache_search(Number),
    NumberResult = list_to_binary(integer_to_list(Result)),
    {reply, {text, << "Factorial of ", NumberBinary/binary, " is " , NumberResult/binary>>}, Req, State, hibernate };

websocket_handle(_Any, Req, State) ->
    {reply, {text, << "whut?">>}, Req, State, hibernate }.


chache_search(Number) ->
  case cachetes:lookup(Number) of
    notfound ->  Factorial = factorial_server:calculate(Number),
                 cachetes:save(Number, Factorial),
                 Factorial;
    CachedFactorial -> CachedFactorial
  end.

websocket_info({timeout, _Ref, Msg}, Req, State) ->
    {reply, {text, Msg}, Req, State};

websocket_info(_Info, Req, State) ->
    lager:debug("websocket info"),
    {ok, Req, State, hibernate}.

websocket_terminate(_Reason, _Req, _State) ->
    ok.

terminate(_Reason, _Req, _State) ->
    ok.