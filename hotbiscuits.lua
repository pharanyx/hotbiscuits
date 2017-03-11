module("hotbiscuits", package.seeall)


-- Hot Biscuits Combat & Curing System
-- Project Start Date: 3rd March 2017

-- Main System Module



  -- Namespace declaration

_G.affs = {}
_G.afftable = {}
_G.containers = {}
_G.core = {}
_G.css = {}
_G.defs = {}
_G.flags = {}
_G.labels = {}
_G.limiters = {}
_G.pvp = {}
_G.timers = {}
_G.timing = {}
_G.tmp = {}
_G.ui = {}

_G.core.ui_font = "Tahoma"
_G.core.version = "0.1-alpha"
_G.core.vitals = {}
_G.core.bals = {}
_G.core.state = "Active"
_G.core.current_toggle = "Mapper"

_G.timers.sets = {}

_G.tmp.banked_gold ="0"
_G.tmp.extra_info = ""
_G.tmp.gold = "0"
_G.tmp.labels = {}
_G.tmp.messages = "0"
_G.tmp.displayed_labels = {}
_G.tmp.label_queue = {}
_G.tmp.target = "Nothing"
_G.tmp.unread_news = "0"


  -- Define core system variables and functions

sep = "/"




  -- Load system modules

function load_modules()
	local path = package.path
	local cpath = package.cpath
	local home_dir = getMudletHomeDir()
	local lua_dir = string.format("%s/%s", home_dir, [[?.lua]])
	local init_dir = string.format("%s/%s", home_dir, [[?/init.lua]])
	local sysdir = string.format("%s/%s", getMudletHomeDir()..sep.."Hot Biscuits", [[?.lua]])
        
	package.path = string.format("%s;%s;%s;%s", path, lua_dir, init_dir, sysdir)
	package.cpath = string.format("%s;%s;%s;%s", cpath, lua_dir, init_dir, sysdir)

	local m = CORE_LOADED and { "affs", "can", "core", "genrun", "GMCP", "pdb", "rc4", "settings", "timing", "ui", "vitals" } or nil
	for _, n in ipairs(m) do
		local s, c = pcall(require, n)
		if not s then display(c) e:error("Failed to load module: "..n..".lua. Please contact Taer or Wobou.") end
		_G[n] = c
	end

	package.path = path
	package.cpath = cpath
end


load_modules()




