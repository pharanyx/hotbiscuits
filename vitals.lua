module("vitals", package.seeall)


-- Functions to deal with curing vital statistics.


function cure()
	sip()
	scroll()
	sparkle()
	beast_heal()
end

registerAnonymousEventHandler("act", "vitals.cure")



function sip()	
	local to_health = core.vitals.maxhp * (tonumber(settings.cures.sip_health) / 100)
	local to_mana = core.vitals.maxmp * (tonumber(settings.cures.sip_mana) / 100)
	local to_ego = core.vitals.maxego * (tonumber(settings.cures.sip_ego) / 100)

	if not can:sip() then return end

	if (tonumber(core.vitals.hp) <= to_health 
		or affs:has("blackout") 
		or (affs:has("recklessness") 
		and not tmp.manaswap))
		and core.bals.healing 
		and not limiters.healing
	then
		core.send_prio("sip health")
		tmp.manaswap = true
		core:fson("healing")

		if affs:has("blackout") then 
			core:fson("healing", 6) 
		end
	end		

	if (tonumber(core.vitals.ego) <= to_ego 
		or affs:has("blackout") 
		or (affs:has("recklessness")
		and not tmp.manaswap))
		and core.bals.healing 
		and not limiters.healing
	then
		core.send_prio("sip bromides")
		tmp.manaswap = true
		core:fson("healing")

		if affs:has("blackout") then 
			core:fson("healing", 6) 
		end
	end	

	if (tonumber(core.vitals.mp) <= to_mana 
		or affs:has("blackout") 
		or (affs:has("recklessness")
		and tmp.manaswap))
		and core.bals.healing
		and not limiters.healing
	then
		core.send_prio("sip mana")
		tmp.manaswap = false
		core:fson("healing")

		if affs:has("blackout") then 
			core:fson("healing", 6) 
		end
	end	
end


function scroll()
	local to_scroll_health = core.vitals.maxhp * (tonumber(settings.cures.scroll_health) / 100)
	local to_scroll_mana = core.vitals.maxmp * (tonumber(settings.cures.scroll_mana) / 100)
	local to_scroll_ego = core.vitals.maxego * (tonumber(settings.cures.scroll_ego) / 100)

	if not can:scroll() then return end

	if (( tonumber(core.vitals.mp) <= to_scroll_mana )
		or ( tonumber(core.vitals.ego) <= to_scroll_ego )
		or ( tonumber(core.vitals.hp) <= to_scroll_health )) 
		or affs:has("recklessness")
		or affs:has("blackout")
	then
		if core.bals.scroll
			and not limiters.scroll
		then
			core.send_prio("read healing;recharge healing from cube")
			core:fson("scroll")
		end
	end
end


function sparkle()
	local to_sparkle_health = core.vitals.maxhp * (tonumber(settings.cures.sparkle_health) / 100)
	local to_sparkle_mana = core.vitals.maxmp * (tonumber(settings.cures.sparkle_mana) / 100)
	local to_sparkle_ego = core.vitals.maxego * (tonumber(settings.cures.sparkle_ego) / 100)

	if not can:sparkle() then return end

	if (( tonumber(core.vitals.mp) <= to_sparkle_mana )
		or ( tonumber(core.vitals.ego) <= to_sparkle_ego )
		or ( tonumber(core.vitals.hp) <= to_sparkle_health )) 
		or affs:has("recklessness")
		or affs:has("blackout")
	then
		if core.bals.sparkleberry
			and not limiters.sparkleberry
		then
			core.send_prio("eat sparkleberry")
			core:fson("sparkleberry")
			
			if affs:has("blackout") then 
				core:fson("sparkleberry", 6) 
			end
		end
	end
end


function beast_heal()	
	local to_beast_health = core.vitals.maxhp * (tonumber(settings.cures.beast_health) / 100)
	local to_beast_mana = core.vitals.maxmp * (tonumber(settings.cures.beast_mana) / 100)	
	local to_beast_ego = core.vitals.maxego * (tonumber(settings.cures.beast_ego) / 100)	

	if not can:beast() 
		or not GMCP:has_skill("healing") 
	then 
		return 
	end

	if (tonumber(core.vitals.hp) <= to_beast_health 
		or affs:has("blackout") 
		or (affs:has("recklessness")
		and not tmp.manaswap))
		and core.bals.beastbal 
		and not limiters.beastheal
	then
		core.send_prio("beast order heal health")
		tmp.manaswap = true
		core:fson("beastheal")
		if affs:has("blackout") then 
			core:fson("beastheal", 6)
		end
	end		

	if (tonumber(core.vitals.ego) <= to_beast_ego 
		or affs:has("blackout") 
		or (affs:has("recklessness")
		and not tmp.manaswap))
		and core.bals.beastbal 
		and not limiters.beastheal
	then
		core.send_prio("beast order heal ego")
		tmp.manaswap = true
		core:fson("beastheal")
		if affs:has("blackout") then 
			core:fson("beastheal", 6) 
		end
	end	

	if (tonumber(core.vitals.mp) <= to_beast_mana 
		or affs:has("blackout") 
		or (affs:has("recklessness")
		and tmp.manaswap))
		and core.bals.beastbal
		and not limiters.beastheal
	then
		core.send_prio("beast order heal mana")
		tmp.manaswap = false
		core:fson("beastheal")
		if affs:has("blackout") then 
			core:fson("beastheal", 6) 
		end
	end	
end


