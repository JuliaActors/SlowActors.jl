# Integration

`SlowActors` took the following steps to integrate with `Actors`:

## Actor Primitives

### 1. Reexport `Actors`

```julia
using Reexport
@reexport using Actors
```

### 2. Provide `Yourtype` as a `Link{T}` parameter

I the case of `SlowActors` this is `Mailbox`:

```julia
struct Mailbox
    box::Deque
    lock::ReentrantLock
    A::Union{Nothing,SlowActor}
end
```

### 3. Provide a concrete `Link` type

You then can create a new concrete `Link{Yourtype}` type:

```julia
newLink() = Link(Mailbox(Deque{Any}(), ReentrantLock(), nothing),
                 myid(), :local)
```

Your actor creation primitive, e.g. `spawn` must return that type too:

```julia
function spawn(bhv::Func; sticky=false)
    lk = Link(
        Mailbox(Deque{Any}(), ReentrantLock(), 
            SlowActor(nothing, sticky, _ACT())),
        myid(), :local
    )
    lk.chn.A.act.bhv = bhv
    lk.chn.A.act.self = lk
end
```

### 4. Export your primitives for link and actor creation

```julia
export newLink, spawn
```

### 5. Reimplement `send!` for your link type

```julia
Actors.send!(lk::Link{Mailbox}, msg::Msg) = (push!(lk.chn, msg); _start_on_send(lk))
Actors.send!(lk::Link{Mailbox}, msg...) = (push!(lk.chn, msg); _start_on_send(lk))
```

Then you can send messages between actors using the `Actors` interface. Still some further primitives are missing, e.g. `self()` and `become!`/`become`. You get those and much more if you plug in the messaging protocol of `Actors`.

## Plugin the `Actors` API

### 6. Provide your actor with the `_ACT` variable

The `_ACT` variable contains status information for each actor such as the behavior function, the actor link, init and exit functions, actor ties ...

Therefore on actor creation you create also `_ACT()`. As shown above, you must set the fields `bhv` and `self` with the behavior and the actor link respectively:

```julia
    ...
    lk.chn.A.act.bhv = bhv
    lk.chn.A.act.self = lk
end
```

When your actor task starts, it puts a reference to its `_ACT` variable into `task_local_storage`:

```julia
function _act(mbx::Mailbox)
    task_local_storage("_ACT", mbx.A.act)
    magic = hash(rand(Int))
    while true
        msg = lock(mbx.lock) do 
            isempty(mbx.box) ?
                magic : popfirst!(mbx.box)
        end
        msg == magic && break
        msg isa Actors.Exit && break
        onmessage(mbx.A.act, msg)
    end
end
```

### 7. Call `onmessage` to process a message

If a message of type `Msg` arrives, `onmessage` provides a finite state machine to process it. To call `onmessage(A::_ACT, msg)` enables the `Actors` messaging protocol.

You can extend `Msg` with new message types or create other message types. In that case you might want to extend `Actors.onmessage` to handle those other types if you don't want the standard behavior to pass it as last argument to the behavior function.

### 8. Enable `receive!`

The `Actors` API works with `receive!` to enable easy communication with actors. You enable `receive!` on your concrete link type if you extend three Base functions with your `Link{Yourtype}` parameter `Yourtype`, e.g.:

```julia
Base.isready(mbx::Mailbox) = !isempty(mbx)
function Base.fetch(mbx::Mailbox) # this waits for a message
    timedwait(60, pollint=0.01) do 
        !isempty(mbx)
    end == :ok ?
        lock(()->first(mbx.box), mbx.lock) :
        :timed_out
end
Base.take!(mbx::Mailbox) = popfirst!(mbx)
```
