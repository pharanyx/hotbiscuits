module("ui", package.seeall)



-- Hot Biscuits user interface


function header(self, title, extra)
    local replen = 55 - (13 + title:len())
    cecho("\n<firebrick>+<slate_blue>----- <firebrick>[<slate_grey> "..title:title().." <firebrick>] "..string.rep("<slate_blue>-", replen).." <firebrick>(<dark_khaki> "..getTime(true, "hh:mma - dd/MM/yyyy").." <firebrick>) <slate_blue>-----<firebrick>+\n\n")
end


function footer()
    cecho("\n<firebrick>+<slate_blue>"..string.rep("-", 55).."<firebrick> [<slate_grey> Taerbot-".."0.9b".." <firebrick>]<slate_blue> "..string.rep("-", 11).."<firebrick>+\n")
end



function combat_echo(self, text, colour, width)
	if not text then
		text = tostring(text)
		if not text then
			e:error("Invalid argument #1 to combat_echo(): String expected.")
			return
		end
	end

  text = string.gsub(text, "%a", "%1 "):sub(1, -2)
  text = "+    +    +    " .. text:upper() .. "    +    +    +"
	local width = width or 80
	if #text + 4 > width then
		width = #text + 4
	end

	local lindent = math.floor(((width - #text) / 2) - 1)
	local rindent = math.ceil(((width - #text) / 2) - 1)

	local colours = {
		red     = "<black:red>",
		blue    = "<navajo_white:midnight_blue>",
		green   = "<navajo_white:dark_green>",
		yellow  = "<black:gold>",
		purple  = "<navajo_white:DarkViolet>",
		orange  = "<black:dark_orange>",
	}

	local selection = colours[colour] or colours["yellow"]

	cecho("\n" .. selection .. "+" .. string.rep("-", (width - 2)) .. "+")
	cecho("\n" .. selection .. "|" .. string.rep(" ", lindent) .. text .. string.rep(" ", rindent) .. "|")
	cecho("\n" .. selection .. "+" .. string.rep("-", (width - 2)) .. "+")
end



function oecho(self, txt, colour, pleft)
	local colour = colour or "orange"
 	local pleft = pleft or 70
 	local pright = 80 - pleft
 	local left = create_line_gradient(true, pleft - string.len(txt)) .. "[ "
 	local middle = "<" .. colour .. ">" .. txt
 	local right = " |caaaaaa]" .. create_line_gradient(false, pright)
 	hecho("\n" .. left)
 	cecho(middle)
 	hecho(right)
end



function create_line_gradient(self, left, width)
	local hex = left and "1" or "a"
	local width = width or 10
	local gradient = ""
	local length = 0
     
	while length < width do
		gradient = gradient .. "|c" .. string.rep(hex, 6) .. "-"
		if left and hex == "9" then
			hex = "a"
		elseif left and hex ~= "a" then
			hex = tostring(tonumber(hex) + 1)
		elseif not left and width - length < 10 and hex == "a" then
			hex = "9"
		elseif not left and width - length < 10 and hex ~= "1" then
			hex = tostring(tonumber(hex) - 1)
		end

		length = length + 1
	end
     
	return gradient
end



function viswarn(self, text, duration)
	local width, height = getMainWindowSize()
	local strLen = text:len()
	local label = randomstring(8, "%l%d")

	tmp.labels[label] = {label = label, text = text, duration = (duration or 5)}
	createLabel(label, 0, 0, 0, 0, 1)
	setLabelStyleSheet(label, [[
		background-color: qlineargradient(spread:pad, x1:0, y1:2, x2:0, y2:0, stop:0 rgba(184, 206, 250), stop:1 rgba(184, 206, 250));
		border-radius: 16px;
		border-width: 8px;
		border-style: double;
		border-color: rgb(50, 0, 75);
		text-align: center;
	]])
               
	resizeWindow(label, strLen * 25, 70)
	local tabLen, offset = counttable(tmp.labels), 100
	local topPos = (height / 2.0) - (tabLen * 75)
	if topPos > 0 then
		moveWindow(label, (width - (strLen * 25)) / 3, topPos)
	end

	echo(label, [[<p style="font-size:18px; font-family: 'Crushed';"><b><center><font color="brown">]] .. text .. [[</font></center></b></p>]])
        
	if topPos > 0 then
		showWindow(label)
		table.insert(tmp.displayed_labels, label)
	else
		hideWindow(label)
		table.insert(tmp.label_queue, label)
	end

	resetFormat()
end



function viswarn_loop()
	if not tmp.labels then return end
	local to_hide = {}
	local need_redraw = false

	for index, label in pairs(tmp.displayed_labels) do
		tmp.labels[label].duration = tmp.labels[label].duration - 0.5
		if tmp.labels[label].duration <= 0 then
			to_hide[label] = true
			need_redraw = true
		end
	end

	for i = 1, #(tmp.displayed_labels) do
		if not tmp.displayed_labels[i] then 
			break 
		end
			
		if to_hide[tmp.displayed_labels[i]] then
			hideWindow(tmp.displayed_labels[i])
			tmp.labels[tmp.displayed_labels[i]] = nil
			table.remove(tmp.displayed_labels, i)
			i = i - 1
		end
	end
        
	local width, height = getMainWindowSize()
	if need_redraw or (#(tmp.displayed_labels) == 0 and #(tmp.label_queue) > 0) then
		local brk = false
		local iter = 1
		while not brk do
			local topPos = (height / 2.0) - ((iter) * 75)
			if tmp.displayed_labels[iter] then
				local label = tmp.displayed_labels[iter]
				moveWindow(label, (width - (#(tmp.labels[label].text) * 25)) / 3, topPos)
			elseif topPos >= 0 and #(tmp.label_queue) > 0 then
				local label = table.remove(tmp.label_queue, 1)
				table.insert(tmp.displayed_labels, label)
				moveWindow(label, (width - (#(tmp.labels[label].text) * 25)) / 3, topPos)
				showWindow(label)
			else
				brk = true
				break;
			end
                        
			iter = iter + 1
		end
	end
end


function set_interface_dynamics()
	local x, y = getMainWindowSize()
	local l = round(x * 0.04)
	local t = round(y * 0.04)
	local r = round(x * 0.52)
	local b = round(y * 0.04)

	setBorderLeft(l)
	setBorderTop(t)
	setBorderRight(0)
	setBorderBottom(b)

	local f = {
		["3841"] = "24px",
		["2561"] = "18px",
		["1921"] = "16px",
		["1601"] = "13px",
		["1361"] = "12px",
		["801"]  = "10px",
		["641"]  = "8px"
	}

	local i = 1
	for r, p in pairs(f) do
		if l > tonumber(r) then
			i = i + 1
		else
			core.font_size = "10px"
			break
		end
	end
end

function define_stylesheets()
	css.default = [[
		QLabel{
			background-color: qlineargradient(spread:pad, x1:0, y1:2, x2:0, y2:0, stop:0 rgba(255,228,196), stop:1 rgba(255,228,196));
			border-radius: 12px;
			border-width: 4px;
			border-style: double;
			border-color: rgb(120, 120, 120);
			text-align: center;
		}

		QLabel::hover{
			background-color: qlineargradient(spread:pad, x1:0, y1:2, x2:0, y2:0, stop:0 rgba(255,228,225), stop:1 rgba(255,228,225));
			border-radius: 12px;
			border-width: 4px;
			border-style: double;
			border-color: rgb(244, 164, 96);
			text-align: center;
		}
	]]
end

function set_stylesheets()
	labels.header:setStyleSheet(css.default)
	labels.status:setStyleSheet(css.default)
end

function update_statusbar()
	local out = [[<p style="font-size: ]] .. core.font_size .. [[; font-family: ']] .. core.ui_font .. [[';"><b><font color="brown">* Target:<font color="dark_slate_grey"> ]] .. tmp.target .. [[ <font color="brown">  |  Status:<font color="dark_slate_grey"> ]] .. core.state .. [[ <font color="brown"> ]] .. tmp.extra_info .. [[ <font color="brown"> |  Gold:<font color="dark_slate_grey"> ]] .. tmp.gold .. [[ <font color="brown"> |  Bank:<font color="dark_slate_grey"> ]] .. tmp.banked_gold .. [[<font color="brown"> |  Messages:<font color="dark_slate_grey"> ]] .. core.messages .. [[<font color="brown"> |  Unread News Count:<font color="dark_slate_grey"> ]] .. tmp.unread_news .. [[</font></p>]]
	labels.status:echo(out)

	e:echo("Target set to: "..tmp.target)
end


chat = chat or {}
tabs_to_blink = tabs_to_blink or {}
chat.config = chat.config or {}
tabs = tabs or {}
windows = windows or {}
chat.config.active_colours = chat.config.active_colours or {}
chat.config.inactive_colours = chat.config.inactive_colours or {}
use = true
chat.config.timestamp = "HH:mm:ss"
chat.config.timestamp_custom_colour = false
chat.config.timestamp_fg = "red"
chat.config.timestamp_bg = "blue"

chat.config.channels = {
	"All",
	"City",
	"Guild",
	"Clans",
	"Tells",
	"Misc",
	"Combat",
}

chat.config.all_tab = "All"
chat.config.blink = true
chat.config.blink_time = 3
chat.config.blink_from_all = false
chat.config.font_size = 8
chat.config.preserve_background = false
chat.config.gag = false
chat.config.lines = 15
chat.config.width = 50

chat.config.active_colours = {
	r = 188, 
	g = 210,
	b = 238,
}

chat.config.inactive_colours = {
	r = 0,
	g = 0,
	b = 0,
}

chat.config.window_colours = {
	r = 0,
	g = 0,
	b = 0,
}

chat.config.active_tab_text = "purple"
chat.config.inactive_tab_text = "white"
current_tab = chat.config.all_tab

function Geyser.MiniConsole:clear()
   clearWindow(self.name)
end

function Geyser.MiniConsole:append()
  appendBuffer(self.name)
end

function chat_cecho(chat, message)
	local alltab = chat.config.all_tab
	local blink = chat.config.blink
	cecho(string.format("win%s", chat), message)
	if alltab and chat ~= alltab then 
		cecho(string.format("win%s", alltab), message)
	end
	if blink and chat ~= current_tab then
		if (alltab == current_tab) and not chat.config.blink_on_all then
			return
		else
			tabs_to_blink[chat] = true
		end
	end
end

function chat_decho(chat, message)
	local alltab = chat.config.all_tab
	local blink = chat.config.blink
	decho(string.format("win%s", chat), message)
	if alltab and chat ~= alltab then 
		decho(string.format("win%s", alltab), message)
	end
	if blink and chat ~= current_tab then
		if (alltab == current_tab) and not chat.config.blink_on_all then
			return
		else
			tabs_to_blink[chat] = true
		end
	end
end

function chat_hecho(chat, message)
	local alltab = chat.config.all_tab
	local blink = chat.config.blink
	hecho(string.format("win%s", chat), message)
	if alltab and chat ~= alltab then 
		hecho(string.format("win%s", alltab), message)
	end
	if blink and chat ~= current_tab then
		if (alltab == current_tab) and not chat.config.blink_on_all then
			return
		else
			tabs_to_blink[chat] = true
		end
	end
end

function chat_echo(chat, message)
	local alltab = chat.config.all_tab
	local blink = chat.config.blink
	echo(string.format("win%s", chat), message)
	if alltab and chat ~= alltab then 
		echo(string.format("win%s", alltab), message)
	end
	if blink and chat ~= current_tab then
		if (alltab == current_tab) and not chat.config.blink_on_all then
			return
		else
			tabs_to_blink[chat] = true
		end
	end
end

function chat_switch(chan)
	local r = chat.config.inactive_colours.r
	local g = chat.config.inactive_colours.g
	local b = chat.config.inactive_colours.b
	local newr = chat.config.active_colours.r
	local newg = chat.config.active_colours.g
	local newb = chat.config.active_colours.b
	local oldchat = current_tab
	if current_tab ~= chan then
		windows[oldchat]:hide()
		tabs[oldchat]:setColor(r, g, b)
		tabs[oldchat]:setStyleSheet([[
			QLabel{
				background-color: qlineargradient(spread:pad, x1:0, y1:1, x2:0, y2:0, stop:0 rgba(0, 0, 0), stop:1 rgba(188, 210, 238));
				border-radius: 12px;
				border-width: 4px;
				border-style: double;
				border-color: rgb(120, 120, 120);
				text-align: center;
			}

			QLabel::hover{
				background-color: qlineargradient(spread:pad, x1:0, y1:1, x2:0, y2:0, stop:0 rgba(0, 0, 0), stop:1 rgba(188, 210, 238));
				border-radius: 12px;
				border-width: 4px;
				border-style: double;
				border-color: rgb(244, 164, 96);
				text-align: center;
				text-decoration: underline;
			}
		]])

		local out = [[<p style="font-size: ]] .. core.font_size .. [[; font-family: ']] .. core.ui_font .. [[';"><b><center><font color="MistyRose">]] .. oldchat .. [[</b></center></p>]]
		tabs[oldchat]:echo(out)
		if chat.config.blink and tabs_to_blink[chan] then
			tabs_to_blink[chan] = nil
		end
		if chat.config.blink and chan == chat.config.all_tab then
			tabs_to_blink = {}
		end
	end

	tabs[chan]:setColor(newr, newg, newb)
	tabs[chan]:setStyleSheet([[
		QLabel{
			background-color: qlineargradient(spread:pad, x1:0, y1:1, x2:0, y2:0, stop:0 rgba(0, 0, 0), stop:1 rgba(0, 0, 0));
			border-radius: 12px;
			border-width: 4px;
			border-style: double;
			border-color: rgb(120, 120, 120);
			text-align: center;
		}

		QLabel::hover{
			background-color: qlineargradient(spread:pad, x1:0, y1:1, x2:0, y2:0, stop:0 rgba(0, 0, 0), stop:1 rgba(0, 0, 0));
			border-radius: 12px;
			border-width: 4px;
			border-style: double;
			border-color: rgb(244, 164, 96);
			text-align: center;
		}
	]])

	local out = [[<p style="font-size: ]] .. core.font_size ..[[; font-family: ']] .. core.ui_font .. [[';"><b><center><font color="LightCyan">]] .. chan .. [[</b></center></p>]]
	tabs[chan]:echo(out)
	windows[chan]:show()
	current_tab = chan
end

function reset()
	local x, y = getMainWindowSize()
	local h = (y * 0.04)
	tab_box = Geyser.HBox:new({
		x = 0,
		y = 0,
		width = "100%",
		height = h,
		name = "tab_box",
	}, containers.chat)
end

function draw_chat()
	reset()
	local r = chat.config.inactive_colours.r
	local g = chat.config.inactive_colours.g
	local b = chat.config.inactive_colours.b
	local winr = chat.config.window_colours.r
	local wing = chat.config.window_colours.g
	local winb = chat.config.window_colours.b
	local x, y = getMainWindowSize()
	local h = (y * 0.04)

	for i, tab in ipairs(chat.config.channels) do
		tabs[tab] = Geyser.Label:new({
			name = string.format("tab%s", tab),
		}, tab_box)

		local out = [[<p style="font-size: ]] .. core.font_size .. [[; font-family: ']] .. core.ui_font .. [[';"><b><center><font color="MistyRose">]] .. tab .. [[</b></center></p>]]
		tabs[tab]:echo(out)
		tabs[tab]:setColor(r, g, b)
		tabs[tab]:setStyleSheet([[
			QLabel{
				background-color: qlineargradient(spread:pad, x1:0, y1:1, x2:0, y2:0, stop:0 rgba(0, 0, 0), stop:1 rgba(188, 210, 238));
				border-radius: 12px;
				border-width: 4px;
				border-style: double;
				border-color: rgb(120, 120, 120);
				text-align: center;
			}

			QLabel::hover{
				background-color: qlineargradient(spread:pad, x1:0, y1:1, x2:0, y2:0, stop:0 rgba(0, 0, 0), stop:1 rgba(188, 210, 238));
				border-radius: 12px;
				border-width: 4px;
				border-style: double;
				border-color: rgb(244, 164, 96);
				text-align: center;
			}
		]])
		tabs[tab]:setClickCallback("chat_switch", tab)

		windows[tab] = Geyser.MiniConsole:new({
			x = 0,
			y = 35,
			height = "100%",
			width = "100%",
			name = string.format("win%s", tab),
		}, containers.chat)

		windows[tab]:setFontSize(chat.config.font_size)
		windows[tab]:setColor(winr, wing, winb)
		windows[tab]:setWrap(chat.config.width)
		windows[tab]:hide()
	end

	local showme = chat.config.Alltab or chat.config.channels[1]
	chat_switch(showme)

	if chat.config.blink and not blink_timer_on then
		blink()
	end
end


function append(self, chan)
	local r = chat.config.window_colours.r
	local g = chat.config.window_colours.g
	local b = chat.config.window_colours.b
	selectCurrentLine()
	local ofr, ofg, ofb = getFgColor()
	local obr, obg, obb = getBgColor()
	if chat.config.preserve_background then
		setBgColor(r, g, b)
	end
	copy()
	if chat.config.timestamp then
 		local timestamp = getTime(true, chat.config.timestamp)
 		local tsfg = {}
 		local tsbg = {}
 		local color_leader = ""
 		if chat.config.timestamp_custom_colour then
			if type(chat.config.timestamp_fg) == "string" then
				tsfg = color_table[chat.config.timestamp_fg]
			else
				tsfg = chat.config.timestamp_fg
			end
      
			if type(chat.config.timestamp_bg) == "string" then
				tsbg = color_table[chat.config.timestamp_bg]
			else
				tsbg = chat.config.timestamp_bg
			end
  
			color_leader = string.format("<%s,%s,%s:%s,%s,%s>", tsfg[1], tsfg[2], tsfg[3], tsbg[1], tsbg[2], tsbg[3])
		else
			color_leader = string.format("<%s,%s,%s:%s,%s,%s>", ofr, ofg, ofb, obr, obg, obb)
		end

		local fullstamp = string.format("%s%s", color_leader, timestamp)
		windows[chan]:decho(fullstamp)
		windows[chan]:echo(" ")
		if chat.config.all_tab then 
			windows[chat.config.all_tab]:decho(fullstamp)
			windows[chat.config.all_tab]:echo(" ")
		end
	end
 
	windows[chan]:append()
	if chat.config.gag then 
		deleteLine() 
		tempLineTrigger(1, 1, [[if isPrompt() then deleteLine() end]])
	end

	if chat.config.all_tab then appendBuffer(string.format("win%s", chat.config.all_tab)) end
	if chat.config.blink and chan ~= current_tab then 
		if (chat.config.all_tab == current_tab) and not chat.config.blink_on_all then
			return
		else
			tabs_to_blink[chan] = true
		end
	end
end

function blink()
	if blink_id then killTimer(blink_id) end
	if not chat.config.blink then 
		blink_timer_on = false
		return 
	end

	for tab, _ in pairs(tabs_to_blink) do
		tabs[tab]:flash()
	end
  
	blink_id = tempTimer(chat.config.blink_time, function () blink() end)
end

function capture_comms()
	local channels = {
		["newbie"] = "Misc",
		["market"] = "Misc",
		["coven"] = "Combat",
		["ct"] = "City",
		["cgt"] = "Guild",
		["gt"] = "Guild",
		["gts"] = "Guild",
		["gnt"] = "Guild",
		["clt"] = "Clans",
		["sqt"] = "Combat",
		["tell"] = "Tells",
		["says"] = "Misc",
		["ot"] = "Order",
		["oto"] = "Order",
		["shipt"] = "Misc",
		["ft"] = "Misc",
		["envoys"] = "Misc",
		["guidet"] = "Misc"
	}

	local ch = gmcp.Comm.Channel.Start

	for c, t in pairs(channels) do
		if ch:find(c) then
			tmp.last_chan = t
			break
		end
	end

	enableTrigger("Comms Capture")
end


function draw_containers()
	containers.main = Geyser.Container:new({
		name = "containers.main",
		x = "0%", y = "0%",
		width = "100%", height = "100%"
	})

	containers.header = Geyser.Container:new({
		name = "containers.header",
		x = "0%", y = "0%",
		width = "70%", height = "4%"
	}, containers.main)

	containers.status = Geyser.Container:new({
		name = "containers.status",
		x = "0%", y = "96%",
		width = "70%", height = "4%"
	}, containers.main)

	containers.chat = Geyser.Container:new({
		name = "containers.chat",
		x = "70%", y = "0%",
		width = "29%", height = "40%"
	}, containers.main)

	containers.mapper = Geyser.Container:new({
		name = "containers.mapper",
		x = "70%", y = "55%",
		width = "29%", height = "45%"
	}, containers.mapper)
end


function draw_labels()
	labels.header = Geyser.Label:new({
		name = "labels.header",
		x = "0%", y = "0%",
		width = "100%", height = "100%",
		fgColor = "dark_orchid",
		message = [[<p style="font-size: ]] .. core.font_size .. [[; font-family: ']] .. core.ui_font .. [[';"><b><font color="brown">> Hot Biscuits for Mudlet v<font color="dark_slate_grey">]] .. core.version ..[[ <font color="brown">  |   Name:<font color="dark_slate_grey"> ]] .. "..." .. [[<font color="brown">   |   Guild:<font color="dark_slate_grey"> ]] .. "..." .. [[</font></p>]]
	}, containers.header)

	labels.status = Geyser.Label:new({
		name = "labels.status",
		x = "0%", y = "0%",
		width = "100%", height = "100%",
		fgColor = "dark_orchid",
		message = [[<p style="font-size: ]] .. core.font_size .. [[; font-family: ']] .. core.ui_font .. [[';"><b><font color="brown">* Target:<font color="dark_slate_grey"> ]] .. tmp.target .. [[ <font color="brown">  |  Status:<font color="dark_slate_grey"> ]] .. core.state .. [[ <font color="brown"> ]] .. tmp.extra_info .. [[ <font color="brown"> |  Gold:<font color="dark_slate_grey"> ]] .. tmp.gold .. [[ <font color="brown"> |  Bank:<font color="dark_slate_grey"> ]] .. tmp.banked_gold .. [[<font color="brown"> |  Messages:<font color="dark_slate_grey"> ]] .. tmp.messages .. [[<font color="brown"> |  Unread News Count:<font color="dark_slate_grey"> ]] .. tmp.unread_news .. [[</font></p>]]
	}, containers.status)
end


function draw_map()
	labels.mapper = Geyser.Mapper:new({
		name = "labels.mapper",
		x = 0, y = 0, 
		width = "100%", height = "100%"
	}, containers.mapper)
end





sendGMCP([[Core.Supports.Add ["Comm.Channel 1"] ]])
draw_ui()