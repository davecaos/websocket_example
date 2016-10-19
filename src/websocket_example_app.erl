%%%-------------------------------------------------------------------
%% @doc test00 public API
%% @end
%%%-------------------------------------------------------------------

-module(websocket_example_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
  Dispatch = cowboy_router:compile([
      {'_', [
        {"/factorial", fact_handler, []}
      ]}
    ]),
    {ok, _} = cowboy:start_http(http, 100, [{port, 8082}],
        [{env, [{dispatch, Dispatch}]}]),
    ok = cachetes:start(),
    websocket_example_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
  ok = cachetes:stop().



%%====================================================================
%% Internal functions
%%====================================================================
