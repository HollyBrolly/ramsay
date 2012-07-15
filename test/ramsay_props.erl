-module(ramsay_props).

-include_lib("proper/include/proper.hrl").
-include_lib("eunit/include/eunit.hrl").

%% Generators

prefix() ->
    oneof([mega, kilo, milli, micro, nano]).

unit() ->
    oneof([seconds, minutes, hours, days,
           tuple([prefix(), seconds])]).

%% Properties

prop_indentity() ->
    ?FORALL({Value, From, To}, {pos_integer(), unit(), unit()},
            begin
                {To, NewValue} = ramsay:measure({From, Value}, To),
                case ramsay:measure({To, NewValue}, From) of
                    {From, OldValue} -> abs(OldValue - Value) =< 0.0000001;
                    _Any -> false
                end
            end).

%% Suite

proper_test_() ->
    {timeout, 600,
     ?_assertEqual([], proper:module(?MODULE, [{to_file, user},
                                               {numtests, 1000}]))}.
