local basalt = require("system.modules.basalt.basalt")

local JSON = require("system.modules.json.json")

local function exitOs()
    basalt.stop()
end



local main = basalt.createFrame()

local device_type = "desktop"
local device_width, device_height = term.getSize()

if device_width == 26 then
    device_type = "mobile"
end

local device_info = {}

device_info.device_type = device_type

local device_info_file = fs.open("os/system/apps/settings/data/device_info.json", "w")

device_info_file.write(JSON:encode(device_info))

device_info_file.close()

-- LOCK SCREEN


-- LOCK SCREEN END

local main_os = main:addFrame():setSize("parent.w", "parent.h")



local topBar = main_os:addFrame():setPosition(1,1):setSize("parent.w", 1):setBackground(colors.gray):setForeground(colors.white)
local versionLabel = topBar:addLabel():setText("OS v1.0"):setPosition(2, 1)
local Clock = topBar:addLabel():setText("Tempclock"):setPosition("parent.w-11", 1)

local desktop = main_os:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h-2"):setBackground(colors.black)





local bottomBar = main_os:addFrame():setPosition(1,"parent.h"):setSize("parent.w", 1):setBackground(colors.gray):setForeground(colors.white)
local exit_button = bottomBar:addButton():setText("Exit"):setBackground(colors.lightGray):setSize(6, 1):setPosition(1,1):onClick(exitOs)
local logout_button = bottomBar:addButton():setText("Logout"):setBackground(colors.lightGray):setSize(8, 1):setPosition("parent.w-self.w+1",1)
local home_button = bottomBar:addButton():setText("Home"):setBackground(colors.lightGray):setSize(6,1):setPosition("parent.w/2-self.w/2",1)

local current_app = desktop:addFrame()

local app_fetcher = require("system.modules.custom.app_fetcher")

local function start_app(config)
    local app = app_fetcher.fetch(config)
    local app_handle = app()(desktop)
    return app_handle
end

local function stop_app(app)
    app:remove()
end

local app_loader = require("system.modules.custom.app_loader")


local system_apps = app_loader.get_system_apps()

local current_page = 1
local total_desktop_pages = math.ceil(#system_apps / 9)

local desktop_pages = {}

for i = 1, total_desktop_pages, 1 do
    table.insert(desktop_pages, desktop:addFrame():setPosition(2,1):setSize("parent.w - 2", "parent.h"):setBackground(colors.black):hide())
end



local desktop_page_counter = 1
local row_counter = 1
local row_index = 1
for index, _ in ipairs(system_apps) do
    desktop_pages[desktop_page_counter]:addImage():loadImage(system_apps[index].icon_path):setPosition(3+(row_index-1)*8, 2 + (row_counter-1)*6):onClick(function () current_app = start_app(system_apps[index].config) end)
    

    --- format name into labels

    local labels = {}

    for str in string.gmatch(system_apps[index].config.name, "%S+") do
        if #str < 7 then
            table.insert(labels, " "..str)
        else 
            table.insert(labels, str)
        end
        
    end

    if labels[2] == nil then table.insert(labels,"") end
    
    desktop_pages[desktop_page_counter]:addLabel():setText(labels[1]):setPosition(2+(row_index-1)*8, 5 + (row_counter-1)*6):setForeground(colors.white) 
    desktop_pages[desktop_page_counter]:addLabel():setText(labels[2]):setPosition(2+(row_index-1)*8, 6 + (row_counter-1)*6):setForeground(colors.white) 
    
    row_index = row_index + 1
    if row_index > 3 then
        row_index = 1
        row_counter = row_counter + 1
        if row_counter > 3 then
            row_counter = 1
            desktop_page_counter = desktop_page_counter + 1
        end
    end
end





local leftButton = desktop:addButton():setText("<"):setPosition(1, "parent.h/2-self.h/2"):setSize(1, 5):setBackground(colors.lightGray)
local rightButton = desktop:addButton():setText(">"):setPosition("parent.w", "parent.h/2-self.h/2"):setSize(1, 5):setBackground(colors.lightGray)

local lock_screen = main:addFrame():setSize("parent.w", "parent.h")
local lock_screen_page = require("system.screens.locks_screen")(lock_screen)

local function Logout()
    lock_screen:show()
end

logout_button:onClick(Logout)

local function resetPages()
    for key, value in pairs(desktop_pages) do
        value:hide()
    end
    desktop_pages[current_page]:show()
    if total_desktop_pages == 1 then
        rightButton:setBackground(colors.gray)
        leftButton:setBackground(colors.gray)
    elseif current_page == total_desktop_pages then 
        rightButton:setBackground(colors.gray)
        leftButton:setBackground(colors.lightGray)
    elseif current_page == 1 then
        rightButton:setBackground(colors.lightGray)
        leftButton:setBackground(colors.gray)
    else
        rightButton:setBackground(colors.lightGray)
        leftButton:setBackground(colors.lightGray)
    end
end

resetPages()

local function nextPage()
    if current_page < total_desktop_pages then
        current_page = current_page + 1

        resetPages()
    end
end

local function prevPage()
    if current_page > 1 then
        current_page = current_page - 1

        resetPages()
    end
end

leftButton:onClick(prevPage)

rightButton:onClick(nextPage)



local function home(app)
    stop_app(app)
end

home_button:onClick(function () home(current_app) end)

-- MAIN OS


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


local clockThread = main_os:addThread()

--local imageThread = main:addThread()

clockThread:start(clockTick)
--imageThread:start(updateImages)

basalt.autoUpdate()