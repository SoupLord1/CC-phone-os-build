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

function window_builder.widgets.navbar()
	return "" -- return a navbar
end

-- return the table to be used a as module in another file
return window_builder