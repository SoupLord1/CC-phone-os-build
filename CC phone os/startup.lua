wb = require("window_builder")

function os_main()
    while true do
        wb.main_gui.update()
        sleep(0.01)
    end
end


function events_main()
    while true do
        wb.widgets.textbox.update_textbox("input_1")
        if wb.widgets.textbox.textboxes["input_1"].text ~= "Hello" then
            wb.widgets.textbox.draw_textbox(6, 5, "input_1", colors.black, colors.white)
            wb.widgets.textlabel.draw_textlabel(1, 5, "Name", colors.black, colors.white)
        else
            wb.main_gui.clear_screen(1, 5, screen["width"], 0, colors.black)
        end
    end
end

screen = {}
screen["width"], screen["height"] = term.getSize()

mobile_device = false

if screen["width"] == 26 then
    mobile_device = true
end

term.clear()

term.setCursorPos(1, 1)

wb.main_gui.gui()

wb.widgets.textbox.create_textbox("input_1", 10)
wb.widgets.textlabel.create_textlabel("Name", "Name:")

parallel.waitForAny(os_main, events_main)