-- define a table for the functions to be stored in
local window_builder = {}

window_builder.default = {} -- default values stored here
window_builder.widgets = {} -- store widgets here
window_builder.main_gui = {} -- store main gui components here

window_builder.default.height = 26
window_builder.default.width = 19

function window_builder.builder()
	return "" -- builds a window
end

function window_builder.drawer(window)
	return "" --draws the window to screen
end

function window_builder.main_gui.gui()
	paintutils.drawFilledBox(1, 1, screen["width"], 1, colors.gray)
	

	paintutils.drawFilledBox(1, screen["height"], screen["width"], screen["height"], colors.gray)
	paintutils.drawFilledBox(screen["width"]/2-3, screen["height"], screen["width"]/2+3, screen["height"], colors.lightGray)

end

function window_builder.main_gui.update()
	term.setBackgroundColor(colors.gray)
	term.setCursorPos(1, 1)
	term.write("OS v1.0")

	term.setCursorPos(screen["width"]-10,1)
	term.write(os.date("%r"))
end

-- return the table to be used a as module in another file
return window_builder