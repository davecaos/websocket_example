-module(factorial).

-export([calculate/1]).

calculate(Number) ->
  do_tail(Number, 1).


do_tail(0, Acc) -> Acc;
do_tail(Number, Acc) -> 
   do_tail(Number -1, Acc * Number).