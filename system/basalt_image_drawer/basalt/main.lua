local basaltEvent = require("basaltEvent")()
local _OBJECTS = require("loadObjects")
local pluginSystem = require("plugin")
local utils = require("utils")
local log = require("basaltLogs")
local uuid = utils.uuid
local wrapText = utils.wrapText
local count = utils.tableCount
local moveThrottle = 300
local dragThrottle = 0
local renderingThrottle = 0

local baseTerm = term.current()
local version = "1.7.0"

local projectDirectory = fs.getDir(table.pack(...)[2] or "")

local activeKey, frames, monFrames, monGroups, variables, schedules = {}, {}, {}, {}, {}, {}
local mainFrame, activeFrame, focusedObject, updaterActive

local basalt = {}

if not  term.isColor or not term.isColor() then
    error('Basalt requires an advanced (golden) computer to run.', 0)
end

local defaultColors = {}
for k,v in pairs(colors)do
    if(type(v)=="number")then
        defaultColors[k] = {baseTerm.getPaletteColor(v)}
    end
end


local function stop()
    updaterActive = false    
    baseTerm.clear()
    baseTerm.setCursorPos(1, 1)
    for k,v in pairs(colors)do
        if(type(v)=="number")then
            baseTerm.setPaletteColor(v, colors.packRGB(table.unpack(defaultColors[k])))
        end
    end
end

function basalt.basaltError(errMsg)
    baseTerm.clear()
    baseTerm.setBackgroundColor(colors.black)
    baseTerm.setTextColor(colors.red)
    local w,h = baseTerm.getSize()
    if(basalt.logging)then
        log(errMsg, "Error")
    end

    local text = wrapText("Basalt error: "..errMsg, w)
    local yPos = 1
    for k,v in pairs(text)do
        baseTerm.setCursorPos(1,yPos)
        baseTerm.write(v)
        yPos = yPos + 1
    end 
    baseTerm.setCursorPos(1,yPos+1)
    updaterActive = false
end

local function schedule(f)
assert(f~="function", "Schedule needs a function in order to work!")
return function(...)
        local co = coroutine.create(f)
        local ok, result = coroutine.resume(co, ...)
        if(ok)then
            table.insert(schedules, co)
        else
            basalt.basaltError(result)
        end
    end
end

basalt.log = function(...)
    log(...)
end

local setVariable = function(name, var)
    variables[name] = var
end

local getVariable = function(name)
    return variables[name]
end

local bInstance = {
    getDynamicValueEventSetting = function()
        return basalt.dynamicValueEvents
    end,
    
    getMainFrame = function()
        return mainFrame
    end,

    setVariable = setVariable,
    getVariable = getVariable,

    setMainFrame = function(mFrame)
        mainFrame = mFrame
    end,

    getActiveFrame = function()
        return activeFrame
    end,

    setActiveFrame = function(aFrame)
        activeFrame = aFrame
    end,

    getFocusedObject = function()
        return focusedObject
    end,

    setFocusedObject = function(focused)
        focusedObject = focused
    end,
    
    getMonitorFrame = function(name)
        return monFrames[name] or monGroups[name][1]
    end,

    setMonitorFrame = function(name, frame, isGroupedMon)
        if(mainFrame == frame)then mainFrame = nil end
        if(isGroupedMon)then
            monGroups[name] = {frame, sides}
        else
            monFrames[name] = frame
        end
        if(frame==nil)then
            monGroups[name] = nil
        end
    end,

    getTerm = function()
        return baseTerm
    end,

    schedule = schedule,

    stop = stop,
    newFrame = Frame,
    debug = basalt.debug,
    log = basalt.log,

    getObjects = function()
        return _OBJECTS
    end,

    getObject = function(id)
        return _OBJECTS[id]
    end,

    getDirectory = function()
        return projectDirectory
    end
}

local function handleSchedules(event, p1, p2, p3, p4)
    if(#schedules>0)then
        local finished = {}
        for n=1,#schedules do
            if(schedules[n]~=nil)then 
                if (coroutine.status(schedules[n]) == "suspended")then
                    local ok, result = coroutine.resume(schedules[n], event, p1, p2, p3, p4)
                    if not(ok)then
                        basalt.basaltError(result)
                    end
                else
                    table.insert(finished, n)
                end
            end
        end
        for n=1,#finished do
            table.remove(schedules, finished[n]-(n-1))
        end
    end
end

local function drawFrames()
    if(updaterActive==false)then return end
    if(mainFrame~=nil)then
        mainFrame:render()
        mainFrame:updateTerm()
    end
    for _,v in pairs(monFrames)do
        v:render()
        v:updateTerm()
    end
    for _,v in pairs(monGroups)do
        v[1]:render()
        v[1]:updateTerm()
    end
end

local stopped, moveX, moveY = nil, nil, nil
local moveTimer = nil
local function mouseMoveEvent(_, stp, x, y)
    stopped, moveX, moveY = stp, x, y
    if(moveTimer==nil)then
        moveTimer = os.startTimer(moveThrottle/1000)
    end
end

local function moveHandlerTimer()
    moveTimer = nil
    mainFrame:hoverHandler(moveX, moveY, stopped)
    activeFrame = mainFrame
end

local btn, dragX, dragY = nil, nil, nil
local dragTimer = nil
local function dragHandlerTimer()
    dragTimer = nil
    mainFrame:dragHandler(btn, dragX, dragY)
    activeFrame = mainFrame
end

local function mouseDragEvent(_, b, x, y)
    btn, dragX, dragY = b, x, y
    if(dragThrottle<50)then 
        dragHandlerTimer() 
    else
        if(dragTimer==nil)then
            dragTimer = os.startTimer(dragThrottle/1000)
        end
    end
end


local renderingTimer = nil
local function renderingUpdateTimer()
    renderingTimer = nil
    drawFrames() 
end

local function renderingUpdateEvent(timer)
    if(renderingThrottle<50)then 
        drawFrames() 
    else
        if(renderingTimer==nil)then
            renderingTimer = os.startTimer(renderingThrottle/1000)
        end
    end
end

local function basaltUpdateEvent(event, ...)
    local a = {...}
    if(basaltEvent:sendEvent("basaltEventCycle", event, ...)==false)then return end
    if(event=="terminate")then basalt.stop() end
    if(mainFrame~=nil)then
        local mouseEvents = {
            mouse_click = mainFrame.mouseHandler,
            mouse_up = mainFrame.mouseUpHandler,
            mouse_scroll = mainFrame.scrollHandler,
            mouse_drag = mouseDragEvent,
            mouse_move = mouseMoveEvent,
        }
        local mouseEvent = mouseEvents[event]
        if(mouseEvent~=nil)then
            mouseEvent(mainFrame, ...)
            handleSchedules(event, ...)
            renderingUpdateEvent()
            return
        end
    end

    if(event == "monitor_touch") then
        if(monFrames[a[2]]~=nil)then
            monFrames[a[2]]:mouseHandler(1, a[2], a[3], true)
            activeFrame = monFrames[a[2]]
        end
        if(count(monGroups)>0)then
            for k,v in pairs(monGroups)do
                v[1]:mouseHandler(1, a[2], a[3], true, a[1])
            end
        end
        handleSchedules(event, ...)
        renderingUpdateEvent()
        return
    end

    if(activeFrame~=nil)then
    local keyEvents = {
        char = activeFrame.charHandler,
        key = activeFrame.keyHandler,
        key_up = activeFrame.keyUpHandler,
    }
    local keyEvent = keyEvents[event]
        if(keyEvent~=nil)then
            if(event == "key")then
                activeKey[a[1]] = true
            elseif(event == "key_up")then
                activeKey[a[1]] = false
            end
            keyEvent(activeFrame, ...)
            handleSchedules(event, ...)
            renderingUpdateEvent()
            return
        end
    end

    if(event=="timer")and(a[1]==moveTimer)then
        moveHandlerTimer()
    elseif(event=="timer")and(a[1]==dragTimer)then
        dragHandlerTimer()
    elseif(event=="timer")and(a[1]==renderingTimer)then
        renderingUpdateTimer()
    else
        for k, v in pairs(frames) do
            v:eventHandler(event, ...)
        end
        handleSchedules(event, ...)
        renderingUpdateEvent()
    end
end

basalt = {
    logging = false,
    dynamicValueEvents = false,
    setTheme = setTheme,
    getTheme = getTheme,
    drawFrames = drawFrames,
    log = log,
    getVersion = function()
        return version
    end,

    memory = function()
        return math.floor(collectgarbage("count")+0.5).."KB"
    end,

    setVariable = setVariable,
    getVariable = getVariable,

    setBaseTerm = function(_baseTerm)
        baseTerm = _baseTerm
    end,

    resetPalette = function()
        for k,v in pairs(colors)do
            if(type(v)=="number")then
                --baseTerm.setPaletteColor(v, colors.packRGB(table.unpack(defaultColors[k])))
            end
        end
    end,

    setMouseMoveThrottle = function(amount)
        if(_HOST:find("CraftOS%-PC"))then
            if(config.get("mouse_move_throttle")~=10)then config.set("mouse_move_throttle", 10) end
            if(amount<100)then
                moveThrottle = 100
            else
                moveThrottle = amount
            end
            return true
        end
        return false
    end,

    setRenderingThrottle = function(amount)
        if(amount<=0)then
            renderingThrottle = 0
        else
            renderingTimer = nil
            renderingThrottle = amount
        end
    end,

    setMouseDragThrottle = function(amount)
        if(amount<=0)then
            dragThrottle = 0
        else
            dragTimer = nil
            dragThrottle = amount
        end
    end,

    autoUpdate = function(isActive)
        updaterActive = isActive
        if(isActive==nil)then updaterActive = true end
        local function f()
            drawFrames()
            while updaterActive do
                basaltUpdateEvent(os.pullEventRaw())
            end
        end
        while updaterActive do
            local ok, err = xpcall(f, debug.traceback)
            if not(ok)then
                basalt.basaltError(err)
            end
        end
    end,
    
    update = function(event, ...)
        if (event ~= nil) then
            local ok, err = xpcall(basaltUpdateEvent, debug.traceback, event, ...)
            if not(ok)then
                basalt.basaltError(err)
                return
            end
        end
    end,
    
    stop = stop,
    stopUpdate = stop,
    
    isKeyDown = function(key)
        if(activeKey[key]==nil)then return false end
        return activeKey[key];
    end,
    
    getFrame = function(name)
        for _, value in pairs(frames) do
            if (value.name == name) then
                return value
            end
        end
    end,
    
    getActiveFrame = function()
        return activeFrame
    end,
    
    setActiveFrame = function(frame)
        if (frame:getType() == "Container") then
            activeFrame = frame
            return true
        end
        return false
    end,

    getMainFrame = function()
        return mainFrame
    end,
    
    onEvent = function(...)
        for _,v in pairs(table.pack(...))do
            if(type(v)=="function")then
                basaltEvent:registerEvent("basaltEventCycle", v)
            end
        end
    end,

    schedule = schedule,
    
    createFrame = function(name)
        for _, v in pairs(frames) do
            if (v:getName() == name) then
                return nil
            end
        end
        local newFrame = _OBJECTS["BaseFrame"](name, bInstance)
        newFrame:init()
        newFrame:load()
        newFrame:draw()
        table.insert(frames, newFrame)
        if(mainFrame==nil)and(newFrame:getName()~="basaltDebuggingFrame")then
            newFrame:show()
        end
        return newFrame
    end,
    
    removeFrame = function(name)
        frames[name] = nil
    end,

    setProjectDir = function(dir)
        projectDirectory = dir
    end,
}

_OBJECTS = pluginSystem.addPlugins(_OBJECTS, bInstance)

local basaltPlugins = pluginSystem.get("basalt")
if(basaltPlugins~=nil)then
    for k,v in pairs(basaltPlugins)do
        for a,b in pairs(v(basalt))do
            basalt[a] = b
            bInstance[a] = b
        end
    end
end
local basaltPlugins = pluginSystem.get("basaltInternal")
if(basaltPlugins~=nil)then
    for k,v in pairs(basaltPlugins)do
        for a,b in pairs(v(basalt))do
            bInstance[a] = b
        end
    end
end

return basalt
