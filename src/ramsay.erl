%%% @author Sergei Levedev <lebedev@selectel.ru>
%%%
%%% @doc Tagged time manipulation for Erlang.
%%% @end

-module(ramsay).

-export_types([prefix/0, unit/0, metric/1]).

-export([measure/1, measure/2]).

%% Note(Sergei): this is far from being complete, check out Wikipedia
%% for inspiration: 'http://en.wikipedia.org/wiki/Metric_prefix'.
-type prefix() :: mega | kilo | milli | micro | nano.
-type unit() :: seconds
              | minutes
              | hours
              | days
              | {prefix(), seconds}.
-type metric(Term) :: {unit(), Term}.

-spec measure(metric(number())) -> metric(number()).
measure({FromTag, Value}) ->
    measure({FromTag, Value}, {milli, seconds}).

-spec measure(metric(number()), unit()) -> metric(number()).
measure({FromTag, Value}, ToTag) ->
    {MulBy, DivBy} = howto(FromTag, ToTag),
    Measured = Value * MulBy / DivBy,
    {ToTag, Measured}.

-spec howto(unit(), unit()) -> {number(), number()}.
howto({FromPrefix, FromTag}, {ToPrefix, ToTag}) ->
    {MulBy, DivBy} = howto(FromTag, ToTag),
    {MulBy / modifier(ToPrefix), DivBy / modifier(FromPrefix)};
howto({FromPrefix, FromTag}, ToTag) ->
    {MulBy, DivBy} = howto(FromTag, ToTag),
    {MulBy, DivBy / modifier(FromPrefix)};
howto(FromTag, {ToPrefix, ToTag}) ->
    {MulBy, DivBy} = howto(FromTag, ToTag),
    {MulBy / modifier(ToPrefix), DivBy};
howto(seconds, minutes) -> {1, 60};
howto(seconds, hours)   -> {1, 3600};
howto(seconds, days)    -> {1, 86400};
howto(minutes, hours)   -> {1, 60};
howto(minutes, days)    -> {1, 1440};
howto(hours, days)      -> {1, 24};
howto(FromTag, ToTag)   ->
    case FromTag =:= ToTag of
        true  -> {1, 1};
        false ->
            %% HACK(Sergei): Try to inverse the relation.
            {MulBy, DivBy} = howto(ToTag, FromTag),
            {DivBy, MulBy}
    end.

-spec modifier(prefix()) -> number().
modifier(mega)  -> 100000;
modifier(kilo)  -> 1000;
modifier(milli) -> 0.001;
modifier(micro) -> 0.000001;
modifier(nano)  -> 0.000000001.
