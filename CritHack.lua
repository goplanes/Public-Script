local CritAttack = {}
CritAttack.optionEnable = Menu.AddOption({"Utility", "CritHack"}, "Activation", "")
CritAttack.key = Menu.AddKeyOption({"Utility","CritHack"},"Key for critattak only target",Enum.ButtonCode.BUTTON_CODE_NONE)

function CritAttack.OnUnitAnimation(animation)
	if not Menu.IsEnabled(CritAttack.optionEnable) then return end
	if not Menu.IsKeyDown(CritAttack.key) then return end
	local myHero = Heroes.GetLocal()
	if not myHero then return end
	if animation.unit == myHero then
		for _,j in pairs(critattak) do
			if j == animation.sequenceName then
				timer = GameRules.GetGameTime() + NPC.GetAttackTime(myHero)/2
			end
		end
		for _,k in pairs(attacanim) do
			if k == animation.sequenceName then
				Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_STOP, myHero, Vector(0,0,0), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_HERO_ONLY)
			end
		end
	end
end

function CritAttack.OnPrepareUnitOrders(orders)
	if orders.order == 4 then
		target = orders.target
	elseif orders.order == 3 then
		
	else
		target = nil
	end
	return true
end

function CritAttack.OnUpdate()
	if not Menu.IsEnabled(CritAttack.optionEnable) then return end
	local myHero = Heroes.GetLocal()
	if not myHero then return end
	if Menu.IsKeyDown(CritAttack.key) then
		if target then
			if Entity.IsAlive(target) then
				if timer <= GameRules.GetGameTime() then
					Player.AttackTarget(Players.GetLocal(),myHero,target)
					if NPC.GetAttackTime(myHero)/2.5 < 0.3 then
						timer = GameRules.GetGameTime() + 0.3
					else
						timer = GameRules.GetGameTime() + NPC.GetAttackTime(myHero)/2.3
					end
				end
			end
		end
	end
end

function CritAttack.init()
	target = nil
	timer = 0
	critattak = {
	 "phantom_assassin_attack_crit_anim"
	,"attack_crit_anim"
	,"attack_crit_alt_anim"
	}
	attacanim = {
	"attack01_fast"
	,"attack02_fast"
	,"attack01_faster"
	,"attack02_faster"
	,"phantom_assassin_attack_anim"
	,"phantom_assassin_attack_alt1_anim"
	,"attack3_anim"
	,"attack2_anim"
	,"attack_anim"
	,"attack_alt1_anim"
	,"attack"
	,"attack2"
	}
end
function CritAttack.OnGameStart()
	CritAttack.init()
end
function CritAttack.OnGameEnd()
	CritAttack.init()
end
CritAttack.init()

return CritAttack