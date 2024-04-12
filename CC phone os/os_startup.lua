local basalt = require("basalt")

local app_loader = require("app_loader")
local apps = app_loader.get_apps()

local function getImageFromString(filepath)
    local imageString = fs.open("test.bimg", "r")
    local image = loadstring("return"..imageString:readAll())()
    imageString:close()
    return image
end
local function exitOs()
    basalt.stop()
end

local main = basalt.createFrame()

local topBar = main:addFrame():setPosition(1,1):setSize("parent.w", 1):setBackground(colors.gray):setForeground(colors.white)
local versionLabel = topBar:addLabel():setText("OS v1.0"):setPosition(2, 1)
local Clock = topBar:addLabel():setText("Tempclock"):setPosition("parent.w-11", 1)

local desktop = main:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h-2"):setBackground(colors.black)

local bottomBar = main:addFrame():setPosition(1,"parent.h"):setSize("parent.w", 1):setBackground(colors.gray):setForeground(colors.white)
local exit_button = bottomBar:addButton():setText("Exit"):setBackground(colors.lightGray):setSize(6, 1):setPosition(1,1):onClick(exitOs)
local home_button = bottomBar:addButton():setText("Home"):setBackground(colors.lightGray):setSize(6,1):setPosition("parent.w/2-self.w/2",1)

local app_slots = {}
app_slots["app_frame"] = {}
app_slots["slot_handle"] = {}
for i = 1, #apps do
    app_slots["app_frame"][i] = apps[i]["handle"](desktop):hide()
end
for i = 1, #app_slots["app_frame"] do
    app_slots["slot_handle"][i] = {icon = desktop:addImage():setPosition(6*(i-1) + 3,2):setImage(apps[i]["icon"]):onClick(function () app_slots["app_frame"][i]:show(); end), name = desktop:addLabel():setText(apps[i]["name"]):setPosition(6*(i-1) + 3,5):setForeground(colors.white)}
end

local function home()
    for i = 1, #app_slots["app_frame"] do
        app_slots["app_frame"][i]:hide()
    end
end

home_button:onClick(home)

-- local function show_app(self)
--     basalt.debug(self)
-- end

-- local function hide_app()
--     apps["test_app"][1]:hide()
-- end



local leftButton = desktop:addButton():setText("<"):setPosition(1, "parent.h/2-self.h/2"):setSize(1, 5):setBackground(colors.lightGray)
local leftButton = desktop:addButton():setText(">"):setPosition("parent.w", "parent.h/2-self.h/2"):setSize(1, 5):setBackground(colors.lightGray)




-- TODO
-- Add a app title

-- IDEA
-- Try to store a frame in a file and send it like a module

-- local testApp = desktop:addImage():setPosition(3, 2):loadImage("test.bimg"):onClick(show_app)

local function clockTick()
    while true do
        Clock:setText(os.date("%r"))
        sleep(0.01)
    end
end

local clockThread = main:addThread()

--local imageThread = main:addThread()

clockThread:start(clockTick)
--imageThread:start(updateImages)

basalt.autoUpdate()