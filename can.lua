module("can", package.seeall)


-- Can we do something?


act = function () return 
	not affs:has("paralysis")
	and core.bals.balance
	and core.bals.equilibrium
	and true
	or false
end

apply = function () return 
	not affs:has("paralysis")
	and not affs:has("slickness")
	and not flags.asleep
	and true
	or false
end

beast = function () return 
	not flags.blind
	and not flags.asleep
	--and has_beast("229172")
	and true
	or false
end

drink = function () return 
	not affs:has("anorexia")
	and not flags.asleep
	and true
	or false
end

eat = function () return 
	not affs:has("anorexia")
	and not flags.asleep
	and true
	or false
end

scroll = function () return 
	not flags.blind
	and not flags.asleep
	and true
	or false
end

sip = function () return 
	not affs:has("anorexia")
	and not affs:has("damagedthroat")
	and not flags.asleep
	and true
	or false
end

smoke = function () return 
	not affs:has("asthma")
	and not affs:has("paralysis")
	and not flags.asleep
	and true
	or false
end

sparkle = function () return 
	not affs:has("anorexia")
	and not flags.asleep
	and true
	or false
end

writhe = function () return 
	not affs:has("paralysis")
	and not flags.asleep
	and true
	or false
end
