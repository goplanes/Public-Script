local AquilaMacroGame = {}
AquilaMacroGame.optionEnable = Menu.AddOption({"Utility", "Aquila Macro Game"}, "Activation", "")
AquilaMacroGame.key = Menu.AddKeyOption({"Utility","Aquila Macro Game"},"Key",Enum.ButtonCode.BUTTON_CODE_NONE)
AquilaMacroGame.fontnpc = Renderer.LoadFont("Tahoma", 15, Enum.FontWeight.EXTRABOLD)

function AquilaMacroGame.OnUpdate()
	if not Menu.IsEnabled(AquilaMacroGame.optionEnable) then return end
	local myHero = Heroes.GetLocal()
	if not myHero then return end
	if timer <= GameRules.GetGameTime() then
		if NPC.HasItem(myHero,"item_ring_of_aquila") then
			ring = NPC.GetItem(myHero,"item_ring_of_aquila")
			AquilaMacroGame.RingGame(ring)
		elseif NPC.HasItem(myHero,"item_ring_of_basilius") then
			ring = NPC.GetItem(myHero,"item_ring_of_basilius")
			AquilaMacroGame.RingGame(ring)
		end
	end
end


function AquilaMacroGame.RingGame(ring)
	if ring and Ability.IsReady(ring) then
		if not AquilaMacroGame.NeedActivate() and not Ability.GetToggleState(ring) then
			Ability.Toggle(ring)
		elseif AquilaMacroGame.NeedActivate() and Ability.GetToggleState(ring) then
			Ability.Toggle(ring)
			timer = GameRules.GetGameTime() + 0.5
		end
	end
end

function AquilaMacroGame.NeedActivate()
	local activ = false
	for _,npc_1 in pairs(NPCs.InRadius(Entity.GetAbsOrigin(Heroes.GetLocal()),900,Entity.GetTeamNum(Heroes.GetLocal()),Enum.TeamType.TEAM_FRIEND)) do
		if npc_1 and NPC.IsCreep(npc_1) then
			local creep_hp = Entity.GetHealth(npc_1)
			for _,npc_2 in pairs(NPCs.InRadius(Entity.GetAbsOrigin(npc_1),1000,Entity.GetTeamNum(npc_1),Enum.TeamType.TEAM_ENEMY)) do
				if npc_2 and NPC.IsHero(npc_2) then
					local damage_to_creep = ((NPC.GetTrueDamage(npc_2)+NPC.GetTrueMaximumDamage(npc_2))/2)-NPC.GetPhysicalDamageReduction(npc_1)*((NPC.GetTrueDamage(npc_2)+NPC.GetTrueMaximumDamage(npc_2))/2)
					if creep_hp<=damage_to_creep and NPC.IsPositionInRange(npc_2,Entity.GetOrigin(npc_1),NPC.GetAttackRange(npc_2)+20) then
						return true
					elseif creep_hp>=damage_to_creep or not NPC.IsPositionInRange(npc_2,Entity.GetOrigin(npc_1),NPC.GetAttackRange(npc_2)+20) then
						activ = false
					end
				end
			end
		end
	end
	return activ
end

function AquilaMacroGame.init()
	ring = nil
	timer = 0
	triger = false
end
function AquilaMacroGame.OnGameStart()
	AquilaMacroGame.init()
end
function AquilaMacroGame.OnGameEnd()
	AquilaMacroGame.init()
end
AquilaMacroGame.init()

return AquilaMacroGame