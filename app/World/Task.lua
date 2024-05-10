local function Thread(thread)

    local self = {}
    function self:destroy()
        task.cancel(thread)
    end
    return self
end
local function Spawn(scope, job,...)

    local thread = task.spawn(job,...)
    table.insert(scope, function() task.cancel(thread) end)

    return Thread(thread)
end
local function Delay(scope, delay, job,...)

    local thread = task.delay(delay, job,...)
    table.insert(scope, function() task.cancel(thread) end)

    return Thread(thread)
end
local function Sleep(scope, timeout: number)

    local thread = coroutine.running()
    local function cleaner() task.cancel(thread) end

    table.insert(scope, cleaner)
    task.wait(timeout)

    table.remove(scope, table.find(scope, cleaner))
    return Thread(thread)
end
return { Spawn = Spawn, Delay = Delay, Sleep = Sleep }