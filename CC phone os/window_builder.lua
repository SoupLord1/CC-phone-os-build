-- define a table for the functions to be stored in
local window_builder = {}

window_builder.default = {} -- default values stored here
window_builder.widgets = {} -- store widgets here

window_builder.default.height = 26
window_builder.default.width = 19

function window_builder.builder()
	return "" -- builds a window
end

function window_builder.drawer(window)
	return "" --draws the window to screen
end

function window_builder.widgets.navbar(y, height, color)
	i = 1
while i < screen["width"] + 1 do
    term.setBackgroundColor(color)
	for j = height - 1, 0, -1 do
		term.setCursorPos(i, y+j)
		term.write(" ")
    end
    i = i + 1
end
end

-- return the table to be used a as module in another file
return window_builder