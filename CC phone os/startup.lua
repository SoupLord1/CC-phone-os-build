wb = require("window_builder")



screen = {}
screen["width"], screen["height"] = term.getSize()

mobile_device = false

if screen["width"] == 26 then
    mobile_device = true
end

term.clear()



term.setCursorPos(1, 1)

wb.widgets.navbar(1, 4, colors.red)

wb.widgets.navbar(8, 5, colors.blue)

while true do
    sleep(0.01)
end