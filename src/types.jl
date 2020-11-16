#
# This file is part of the SlowActors.jl Julia package, 
# MIT license, part of https://github.com/JuliaActors
#

mutable struct SlowActor
    t::Union{Nothing,Task}
    sticky::Bool
    act::_ACT
end

struct Mailbox
    box::Deque
    lock::ReentrantLock
    A::Union{Nothing,SlowActor}
end

"""
    newLink()

Create a mailbox (without an actor) which can be used to 
communicate with slow actors. 
"""
newLink() = Link(Mailbox(Deque{Any}(), ReentrantLock(), nothing),
                 myid(), :local)

Base.push!(mbx::Mailbox, items...) = lock(mbx.lock) do 
    push!(mbx.box, items...)
end
Base.popfirst!(mbx::Mailbox) = lock(mbx.lock) do 
    popfirst!(mbx.box)
end
Base.isempty(mbx::Mailbox) = lock(mbx.lock) do 
    isempty(mbx.box)
end
