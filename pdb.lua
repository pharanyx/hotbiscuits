module("pdb", package.seeall)


-- Hot Biscuits player database tracking

schema = {
	org = "unset",
	ally = false,
	enemy = false,
	guild = "unset",
	demigod = false,
	race = "unset",
	in_alliance = false,
	in_area = false,
	in_room = false,
}

players = {

}

add = function(self, name)
	local name = name:title()
	if not pdb.players[name] then
		pdb.players[name] = shallowcopy(pdb.schema)
		e:echo("Player database entry added for <SpringGreen>"..name..".")
		pdb:get_api_data(name)
	end
end

del = function(self, name)
	local name = name:title()
	pdb.players[name] = nil
	e:echo("Player database entry removed for <SpringGreen>"..name..".")
end

save = function()
	local sep = string.char(getMudletHomeDir():byte()) == "/" and "/" or "\\"
	local sysdir = getMudletHomeDir()..sep.."Hot Biscuits"..sep.."pdb"..sep
	table.save(sysdir.."playerdb.lua", pdb.players)
end

load = function()
	local sep = string.char(getMudletHomeDir():byte()) == "/" and "/" or "\\"
	local sysdir = getMudletHomeDir()..sep.."Hot Biscuits"..sep.."pdb"..sep
	table.load(sysdir .. "playerdb.lua", pdb.players)
	e:echo("Player database loaded.")
end

get_api_data = function (self, name)
	local name = name:title()
	local sep = string.char(getMudletHomeDir():byte()) == "/" and "/" or "\\"
	local sysdir = getMudletHomeDir()..sep.."Hot Biscuits"..sep.."pdb"..sep
	if not lfs.attributes(sysdir) then
		e:error("Character data folder not found or deleted!")
	else
		downloadFile(sysdir..name..".json", "http://api.lusternia.com/characters/"..name..".json")
	end
end

is_ally = function (self, name)
	local name = name:title()
	return pdb.players[name].ally == true and true or false
end

is_enemy = function (self, name)
	local name = name:title()
	return pdb.players[name].enemy == true and true or false
end

is_demigod = function (self, name)
	local name = name:title()
	return pdb.players[name].demigod == true and true or false
end

in_alliance = function (self, name)
	local name = name:title()
	return pdb.players[name].in_alliance == true and true or false
end

in_area = function (self, name)
	local name = name:title()
	return pdb.players[name].in_area == true and true or false
end

in_room = function (self, name)
	local name = name:title()
	return pdb.players[name].in_room == true and true or false
end


function got_pdb_data(self, _, fn)
	if not fn:find(".json", 1, true) then return end
	local file = io.open(fn, "r")
	local content = file:read "*a"
	local data = yajl.to_value(content)
	file:close()

	local ally_orgs = { 
		"celest", 
		"hallifax", 
		"serenwilde" 
	}

	local races = {
		"aslaran",
		"dracnari",   
		"dwarf",    
		"elfen",     
		"faeling",      
		"fink",         
		"furrikin",     
		"gnome",         
		"human",       
		"igasho",         
		"illithoid",     
		"kephera",       
		"krokani",       
		"loboshigaru", 
		"lucidian",      
		"merian",      
		"mugwump",     
		"orclach",       
		"tae'dae",      
		"taurian",     
		"trill",       
		"viscanti",     
		"wildewood",    
		"wyrdenwood"   
	}

	players[data.name].org = data.city:title()
	players[data.name].guild = data.guild
	players[data.name].demigod = tonumber(data.level) >= 100 and true or false
	players[data.name].in_alliance = table.contains(ally_orgs, data.city) and true or false
	players[data.name].ally = table.contains(ally_orgs, data.city) and true or false

	for _, v in ipairs(races) do
		if data.race:find(v) then
			players[data.name].race = v:title()
		end
	end
end



