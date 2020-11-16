#
# This file is part of the SlowActors.jl Julia package, 
# MIT license, part of https://github.com/JuliaActors
#

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

function startActor(mbx::Mailbox)
    mbx.A.t = Task() do 
        _act(mbx)
    end
    mbx.A.t.sticky = mbx.A.sticky
    schedule(mbx.A.t) 
end

"""
    spawn(bhv::Func; sticky=false)

Create a new slow actor with a behavior `bhv`. If `sticky=true` 
it is started on the same thread as the sender of a message.

**Note:** a slow actor is actually started as a task if a
message is sent to it.
"""
function spawn(bhv::Func; sticky=false)
    lk = Link(
        Mailbox(Deque{Any}(), ReentrantLock(), 
            SlowActor(nothing, sticky, _ACT())),
        myid(), :local
    )
    lk.chn.A.act.bhv = bhv
    lk.chn.A.act.self = lk
end
