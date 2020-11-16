#
# This file is part of the SlowActors.jl Julia package, 
# MIT license, part of https://github.com/JuliaActors
#

function _start_on_send(lk::Link{Mailbox})
    if !isnothing(lk.chn.A)
        if isnothing(lk.chn.A.t) || istaskdone(lk.chn.A.t)
            startActor(lk.chn)
        end
    end
end

"""
```
send!(lk::Link{Mailbox}, msg::Msg)
send!(lk::Link{Mailbox}, msg...)
```

Send a message `msg` to a slow actor. Start it if it doesn't run.

**Note:** You must reeimplement those as methods of `Actors.send!`.
"""
Actors.send!(lk::Link{Mailbox}, msg::Msg) = (push!(lk.chn, msg); _start_on_send(lk))
Actors.send!(lk::Link{Mailbox}, msg...) = (push!(lk.chn, msg); _start_on_send(lk))

# ------------------------------------------
# In order to make Actors.jl receive! work,
# you must reimplement the following three
# functions with your Link parameter:
# ------------------------------------------
Base.isready(mbx::Mailbox) = !isempty(mbx)
function Base.fetch(mbx::Mailbox) # this waits for a message
    timedwait(60, pollint=0.01) do 
        !isempty(mbx)
    end == :ok ?
        lock(()->first(mbx.box), mbx.lock) :
        :timed_out
end
Base.take!(mbx::Mailbox) = popfirst!(mbx)
