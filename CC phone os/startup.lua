wb = require("window_builder")



screen = {}
screen["width"], screen["height"] = term.getSize()

mobile_device = false

if screen["width"] == 26 then
    mobile_device = true
end

term.clear()



term.setCursorPos(1, 1)

wb.main_gui.gui()

while true do
    wb.main_gui.update()
    sleep(0.01)
end