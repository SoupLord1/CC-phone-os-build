--TODO
-- 1. Make each special keycode output its assigned char in textbox


-- define a table for the functions to be stored in

local keyword_to_key = require("keyword_to_key")

local window_builder = {}

window_builder.default = {} -- default values stored here
window_builder.widgets = {} -- store widgets here
window_builder.main_gui = {} -- store main gui components here


window_builder.widgets.textbox = {}
window_builder.widgets.textbox.textboxes = {}

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

function window_builder.widgets.textbox.create_textbox(textbox_id, max_chars)
	window_builder.widgets.textbox.textboxes[textbox_id] = {text=""}
	window_builder.widgets.textbox.textboxes[textbox_id].max_chars = max_chars
end

function window_builder.widgets.textbox.draw_textbox(x, y, textbox_id, bgcolor, color)
	
	term.setBackgroundColor(bgcolor)
	term.setTextColor(color)

	for i = 0, window_builder.widgets.textbox.textboxes[textbox_id].max_chars, 1 do
		term.setCursorPos(x+i, y)
		term.write(" ")
	end

	term.setCursorPos(x, y)
	term.write(window_builder.widgets.textbox.textboxes[textbox_id].text)
end

held_keys = {}
held_keys[keys.leftShift] = false

function window_builder.widgets.textbox.update_textbox(textbox_id)

	--TODO
	-- FIX THIS BS CODE
	
	local event, key = os.pullEvent()

	if event == "key" then

		held_keys[key] = true
		if key == keys.backspace then
			window_builder.widgets.textbox.textboxes[textbox_id].text = string.sub(window_builder.widgets.textbox.textboxes[textbox_id].text, 1, string.len(window_builder.widgets.textbox.textboxes[textbox_id].text) - 1)
		elseif string.len(window_builder.widgets.textbox.textboxes[textbox_id].text) < window_builder.widgets.textbox.textboxes[textbox_id].max_chars then
			if held_keys[keys.leftShift] == true and key ~= keys.leftShift then
				if key ~= keys.backspace then
					window_builder.widgets.textbox.textboxes[textbox_id].text = window_builder.widgets.textbox.textboxes[textbox_id].text .. string.upper(keyword_to_key[keys.getName(key)])
				end
			elseif string.len(window_builder.widgets.textbox.textboxes[textbox_id].text) < window_builder.widgets.textbox.textboxes[textbox_id].max_chars then
				window_builder.widgets.textbox.textboxes[textbox_id].text = window_builder.widgets.textbox.textboxes[textbox_id].text .. keyword_to_key[keys.getName(key)]
		
			end
		end
	elseif event == "key_up" then
		held_keys[key] = false
	end
	
end
-- return the table to be used a as module in another file
return window_builder