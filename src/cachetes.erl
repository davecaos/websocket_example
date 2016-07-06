-module(cachetes).

%% cache ets, spanish pun intented! 

-export([start/0, stop/0]).

-export([save/2]).
-export([lookup/1]).

-define(TABLENAME, factorial_cache).

-spec start() -> ok.
start() ->
  case exists() of
    false -> ?TABLENAME = ets:new(?TABLENAME, [set, named_table, public]);
    true  -> ok
  end,
  ok.

-spec stop() -> ok.
stop() ->
  true = ets:delete(?TABLENAME),
  ok.

save(Number, Factorial) ->
  true = ets:insert(?TABLENAME, {Number, Factorial}).

lookup(Number) ->
  case ets:lookup(?TABLENAME, Number) of
    []                      -> notfound;
    [{Number, Factorial}]   -> Factorial
  end.

exists() ->
  lists:member(?TABLENAME, ets:all()).