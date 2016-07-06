-module(factorial_server).

-behaviour(gen_server).

-export([start_link/0, calculate/1]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).


start_link() -> 
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

calculate(Number) ->
   gen_server:call(?MODULE, {factorial, Number}).

init([]) ->
  {ok, []}.

handle_call({factorial, Number}, _From, State) ->
  {reply, factorial:calculate(Number), State};
handle_call(terminate, _From, State) ->
  {stop, normal, ok, State}.


handle_cast(_, State) ->
  {noreply, State}.

handle_info(_Message, State) -> 
  {noreply, State}.
terminate(_Reason, _State) -> 
  ok.
code_change(_OldVersion, State, _Extra) -> 
  {ok, State}.