     __              __
    |__)  /\   |\/| /__`  /\  \ /
    |  \ /~~\  |  | .__/ /~~\  |

Named after one of the [famous] [1] Scottish watchmaker, `ramsay` aims
to simplify handling of time values in your Erlang applications.

[1]: http://en.wikipedia.org/wiki/David_Ramsay_(watchmaker)

Is it any good? [![Build Status](https://secure.travis-ci.org/HollyBrolly/ramsay.png)](http://travis-ci.org/HollyBrolly/ramsay)
---------------

Yes. And **very** useful!

Why do I need it?
-----------------

Almost all Erlang applications **have** to deal with time values in one
way or another. For example, here's a bit from [Riak] [2] configuration
file:

```erlang
{default_bucket_props, [
    {n_val, 3},
    {gossip_interval, 60000},
    {last_write_wins, false},
]}
```

Although the unit of `gossip_interval` is documented on [Riak Wiki] [2],
it's hard to tell **what** is it, just looking at the configuration file.
Of course, one way of dealing with this is by having a convention; for
example you might decide that *all time values are in milliseconds*. But
we think a better way is to use *tagged* values:

```erlang
{default_bucket_props, [
    {n_val,3},
    {gossip_interval, {minutes, 1}},
    {last_write_wins, false},
]}
```

Neat, huh? here's how this value can be used from inside the application:

```erlang
start([]) ->
    RawGossipInterval = proplists:get_value(gossip_interval,
                                            DefaultBucketProps)
    {{milli, seconds}, GossipInterval} = ramsay:measure(GossipInterval,
                                                        {milli, seconds})
    %% ... more code here
```

[2]: http://wiki.basho.com/Configuration-Files.html
