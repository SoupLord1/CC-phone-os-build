local basalt = require("basalt")

local function getImageFromString(filepath)
    local imageString = fs.open("test.bimg", "r")
    local image = loadstring("return"..imageString:readAll())()
    imageString:close()
    return image
end
local function exitOs()
    basalt.stop()
end

local screen = {}
screen.w, screen.h = term.getSize()

local main = basalt.createFrame()

local topBar = main:addFrame():setPosition(1,1):setSize(screen.w, 1):setBackground(colors.gray):setForeground(colors.white)
local versionLabel = topBar:addLabel():setText("OS v1.0"):setPosition(2, 1)
local Clock = topBar:addLabel():setText("Tempclock"):setPosition(screen.w-11, 1)

local bottomBar = main:addFrame():setPosition(1,screen.h):setSize(screen.w, 1):setBackground(colors.gray):setForeground(colors.white)
local exit_button = bottomBar:addButton():setText("Exit"):setBackground(colors.lightGray):setSize(6, 1):setPosition(1,1):onClick(exitOs)
local home_button = bottomBar:addButton():setText("Home"):setBackground(colors.lightGray):setSize(6,1):setPosition(screen.w/2-3,1)

local desktop = main:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h-2"):setBackground(colors.black)

local leftButton = desktop:addButton():setText("<"):setPosition(1, "parent.h/2-self.h/2"):setSize(1, 5):setBackground(colors.lightGray)
local leftButton = desktop:addButton():setText(">"):setPosition("parent.w", "parent.h/2-self.h/2"):setSize(1, 5):setBackground(colors.lightGray)

local function imageTest()
    local time = os.date("%r")
    basalt.debug(time)
end

local testImage = desktop:addImage():setPosition("parent.w/2-self.w/2", "parent.h/2-self.h/2"):loadImage("test.bimg"):onClick(appFunction)


local image = getImageFromString("test.bimg")
local function clockTick()
    while true do
        Clock:setText(os.date("%r"))
        sleep(0.01)
    end
end

local function updateImages()
    while true do
        image = getImageFromString("test.bimg");
        testImage:setImage(image)
        sleep(0.01)
    end
end

local clockThread = main:addThread()

--local imageThread = main:addThread()

clockThread:start(clockTick)
--imageThread:start(updateImages)

basalt.autoUpdate()