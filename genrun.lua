module("genrun", package.seeall)


-- Genrunner. Be careful :)


function init()
	timing:start("genrun plot time")
	e:echo("Genrunner plotting: " .. getRoomAreaName(getRoomArea(mmp.currentroom)) .. "...")
	local r = getAreaRooms(getRoomArea(mmp.currentroom))
	rooms = {}
	reverse_path = {}
	for _, vnum in ipairs(r) do
		if getPath(mmp.currentroom, vnum) then
			rooms[vnum] = {}
			local exits = getRoomExits(vnum)
			for direction, to_room in pairs(exits) do
				rooms[vnum][to_room] = {
					dir = direction,
				}
			end
		end
	end

	rooms[mmp.currentroom] = {}
	local exits = getRoomExits(mmp.currentroom)
	for direction, to_room in pairs(exits) do
		rooms[mmp.currentroom][to_room] = {
			dir = direction,
		}
	end

	rooms_left_to_touch = {}
	starting_room = mmp.currentroom
	for vnum, exits in pairs(rooms) do
		if vnum ~= starting_room then
			rooms_left_to_touch[vnum] = true
		end
	end

	e:echo("Parsed " .. counttable(rooms_left_to_touch) .. " rooms. (Took " .. timing:stop("genrun plot time") .. ")\n")
	raiseEvent("genrun start")
end


function walk()
	for links_to, room_info in pairs(rooms[mmp.currentroom]) do
		if rooms_left_to_touch[links_to] then
			walking_to = links_to
			table.insert(reverse_path, mmp.currentroom)
			return mmp.gotoRoom(walking_to)
		end
	end
	
	backtrack()
end


function backtrack()
	backtracking = true
	if #reverse_path > 0 then
		walking_to = table.remove(reverse_path)
		return mmp.gotoRoom(walking_to)
	else
		e:echo("Genrun this area has been completed.")
		raiseEvent("genrun completed")
	end
end


function stop()
	mmp.stop()
	walking = false
	rooms = {}
	walking_to = 0
	backtracking = false
	raiseEvent("genrun stop")
	if config.return_to_start then
		e:echo("Returning you to your starting room!")
		mmp.gotoRoom(starting_room)
	end
end


function genrun_walk()
	walking = true
	for name, number in pairs(tmp.roomitems) do
		local items_to_pickup = { "sovereigns", "shard", "essence", "cocoon", "fragment" }
		for _, i in ipairs(items_to_pickup) do
			if name:find(i) then
				send("get " .. i)
			end
		end
	end
  
	walk()
end


function genrun_look()
	local vnum = gmcp.Room.Info.num
	if vnum ~= walking_to then
		return
	end
	if backtracking then
		backtracking = false
	else
		rooms_left_to_touch[vnum] = nil
	end
	raiseEvent("genrun arrived")
	walking = false
end