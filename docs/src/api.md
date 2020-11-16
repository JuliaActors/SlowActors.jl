# Actor API

```@meta
CurrentModule = SlowActors
```

## Installation

```@docs
SlowActors
SlowActors.version
```

`SlowActors` uses and reexports `Actors`. So the functionality of `Actors` is available to work with "slow" actors.

## Starting Actors, creating Links

`SlowActors` are actually a complete different implementation of actors than those in `Actors`. They implement a `Mailbox` type for communication. Slow actors don`t run in a loop listening to a channel, but are actually started as tasks when a message is sent to them.

But both libraries use a common `Link{T}` for communication. The following functions for creating actors or links return `Link{Mailbox}` as concrete type:

```@docs
spawn
newLink
```

`SlowActors` exports only those two functions.

## Primitives

SlowActors reimplements actually only one actor primitive:

```@docs
send!
```

The other actor primitives such as `become!` or `self` are plugged in from `Actors`. See the source how that works.

## User API

Likewise with the user API. SlowActors doesn't implement any user API functions but uses the message protocol of `Actors` and thus gets the `Actors` API.
