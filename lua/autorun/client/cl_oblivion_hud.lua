function OblivionHUD() -- Do not touch this

	OblivionDrawBase() -- Do not touch this
	OblivionDrawExtra() -- Do not touch this
	local ply = LocalPlayer() -- Do not touch this
	LocalPlayer().HasOblivionHUD = true -- Do not touch this, this basically tells my other addons that this HUD is installed

	--	BASIC INSTRUCTIONS												--
	--	USE THE "local" VARIABLES TO SET THE VARIABLES TO YOUR LIKING 	--
	--	VARIABLES SET TO "nil" WILL BE SET TO THE DEFAULT SETTING		--
	--	PLEASE DON'T MESSAGE ME ON HOW TO DO X/Y/Z, USE THE WIKI		--
	--	PLEASE DO MESSAGE ME IF YOU ENCOUNTER ANY BUGS WITH THIS SCRIPT	--

	-- Red Bar
	-- Normally displays health
	local CurHealth = nil
	local MaxHealth = nil
	OblivionDrawHealth(CurHealth,MaxHealth) -- Do not touch this, use above
	
	--Blue Bar
	--Normally displays armor
	--Used by my Oblivion Magic Addon if nil is set and the addon is installed
	local CurMana = nil
	local MaxMana = nil
	OblivionDrawMana(CurMana,MaxMana) -- Do not touch this, use above
	
	--Green Bar
	--Normally Displays full stamina, not modified by anything
	--Used by my Basic Stamina Addon if nil is set and the addon is installed
	local CurStamina = nil
	local MaxStamina = nil
	OblivionDrawStamina(CurStamina,MaxStamina) -- Do not touch this, use above
	
	
	--Compass
	--Offset is measured in degrees (useful if you have another compass addon and the two compasses don't match up)
	--For you nerds out there, +Y == N, -Y == S, +X == E, -X == W at 0 offset
	local Offset = 0
	OblivionDrawCompass(Offset) -- Do not touch this, use above

end -- Do not touch this

----------------------------------------------------------------------------------------------
-----EVERYTHING BELOW HERE SHOULD NOT BE TOUCHED UNLESS YOU REALLY KNOW WHAT YOU'RE DOING-----
----------------------------------------------------------------------------------------------

hook.Add( "HUDPaint", "Oblivion HUD",  OblivionHUD )

local Scale = 1

local BaseBar = Material("vgui/ob_hudelements/hud_ribbon_health_empty")
local SliderWidget = Material("vgui/ob_hudelements/ribbon_slider")
local HealthBar = Material("vgui/ob_hudelements/hud_ribbon_health_full")
local ManaBar = Material("vgui/ob_hudelements/hud_ribbon_magic_full")
local StaminaBar = Material("vgui/ob_hudelements/hud_ribbon_fatigue_full")

function OblivionDrawBase()

	surface.SetDrawColor(Color(255,255,255,255))
	surface.SetMaterial(BaseBar)
	surface.DrawTexturedRectRotated(256 * Scale, ScrH() - (16/2 + 16*1 + 32) * Scale, 256 * Scale,16 * Scale,0)
	surface.DrawTexturedRectRotated(256 * Scale, ScrH() - (16/2 + 16*2 + 32) * Scale, 256 * Scale,16 * Scale,0)
	surface.DrawTexturedRectRotated(256 * Scale, ScrH() - (16/2 + 16*3 + 32) * Scale, 256 * Scale,16 * Scale,0)

end

function OblivionDrawHealth(CurHealth,MaxHealth)

	local Health

	if CurHealth == nil and MaxHealth == nil then
		Health = math.Clamp(LocalPlayer():Health()/LocalPlayer():GetMaxHealth(),0,1)
	else
		Health = math.Clamp(CurHealth/MaxHealth,0,1)
	end

	surface.SetMaterial(HealthBar)
	surface.DrawTexturedRectRotated( ( 256*0.5*Health + 128 + 8 + 4 ) * Scale, ScrH() - (16/2 - 2 + 32 + 16*3) * Scale , 256*Health * Scale,16 * Scale,0)
	
	surface.SetMaterial(SliderWidget)
	surface.DrawTexturedRectRotated( (165*Health + 128 + 16) * Scale , ScrH() - (16/2 + 32 + 16*3) * Scale, 16 * Scale, 16 * Scale,0)

end

function OblivionDrawMana(CurMana,MaxMana)

	local Mana
	
	if CurMana == nil and MaxMana == nil then

		if LocalPlayer():GetActiveWeapon() ~= NULL then
			if LocalPlayer():GetActiveWeapon():GetClass() == "weapon_bur_magic" then
				Mana = LocalPlayer():GetActiveWeapon():Clip1() / 100
			else
				Mana = math.Clamp(LocalPlayer():Armor()/100,0,1)
			end
		else
			Mana = math.Clamp(LocalPlayer():Armor()/100,0,1)
		end
		
	else
		Mana = math.Clamp(CurMana/MaxMana,0,1)
	end

	surface.SetMaterial(ManaBar)
	surface.DrawTexturedRectRotated( (256*0.5*Mana  + 128 + 8 + 4 ) * Scale, ScrH() - (16/2 - 2 + 32 + 16*2) * Scale, 256*Mana * Scale, 16 * Scale,0)
	
	surface.SetMaterial(SliderWidget)
	surface.DrawTexturedRectRotated( (165*Mana + 128 + 16) * Scale , ScrH() - (16/2 + 32 + 16*2) * Scale, 16 * Scale, 16 * Scale,0)

end


function OblivionDrawStamina(CurStamina,MaxStamina)

	local Stamina
	
	if CurStamina == nil and MaxStamina == nil then
		if LocalPlayer().BurgerStamina then
			Stamina = math.Clamp(LocalPlayer().BurgerStamina / LocalPlayer().BurgerMaxStamina,0,1)
		else
			Stamina = 1
		end
	else
		Stamina = math.Clamp(CurStamina/MaxStamina,0,1)
	end
	
	surface.SetMaterial(StaminaBar)
	surface.DrawTexturedRectRotated( (256*0.5*Stamina  + 128 + 8 + 4 ) * Scale, ScrH() - (16/2 - 2 + 32 + 16*1) * Scale, 256*Stamina * Scale, 16 * Scale,0)

	surface.SetMaterial(SliderWidget)
	surface.DrawTexturedRectRotated( (165*Stamina + 128 + 16) * Scale , ScrH() - (16/2 + 32 + 16*1) * Scale, 16 * Scale, 16 * Scale,0)

end



local Sword = Material("vgui/ob_hudelements/umbrasword")
local Icon = Material("vgui/ob_hudelements/icon_enchanted_item")
local Spell = Material("vgui/ob_hudelements/fire_damage")
local CompassFrame = Material("vgui/ob_hudelements/hud_compass_frame")
local CompassCord = Material("vgui/ob_hudelements/hud_compass_face")

function OblivionDrawExtra()

	surface.SetDrawColor(Color(255,255,255,255))
	surface.SetMaterial(Sword)
	surface.DrawTexturedRectRotated( (256 + 128) * Scale , ScrH() - (64 + 8) * Scale, (64 * 0.75) * Scale, (64 * 0.75) * Scale,0)
	
	surface.SetMaterial(Icon)
	surface.DrawTexturedRectRotated( (256 + 128 - 16) * Scale , ScrH() - (64 - 12) * Scale, (32) * Scale , (32) * Scale,0)
	
	local ActualSpell = Spell
	
	if LocalPlayer():GetActiveWeapon() ~= NULL then
		if LocalPlayer():GetActiveWeapon():GetClass() == "weapon_bur_magic" then
			ActualSpell = Material("vgui/ob_icons/" .. LocalPlayer():GetActiveWeapon().SpellSlot[LocalPlayer():GetActiveWeapon().WeaponSlot].DamageType )
		end
	end
	
	surface.SetMaterial(ActualSpell)
	surface.DrawTexturedRectRotated( (256 + 256 - 64) * Scale , ScrH() - (64 + 8) * Scale , (64*0.75) * Scale, (64*0.75) * Scale,0)

end

function OblivionDrawCompass(Offset)

	local Yaw = (-LocalPlayer():EyeAngles().y + 45 + Offset)/90
	
	--Desired Size of the Material
	local CurrentSizeX = 152
	local CurrentSizeY = 64
	
	--Original Size of the Material
	local OriginalSizeX = 640 - 32
	local OriginalSizeY = 64

	--U and V
	local UStart =  (CurrentSizeX / OriginalSizeX)*Yaw
	local VStart = 0
	local UEnd = ( CurrentSizeX / OriginalSizeX ) + ((CurrentSizeX / OriginalSizeX)*Yaw)
	local VEnd = 1
	
	surface.SetMaterial(CompassCord)
	surface.DrawTexturedRectUV( (356 + 128) * Scale , ScrH() - (64 + 32) * Scale, CurrentSizeX * Scale, CurrentSizeY * Scale, UStart * Scale, VStart * Scale, UEnd * Scale, VEnd * Scale )
	
	surface.SetMaterial(CompassFrame)
	surface.DrawTexturedRectRotated( (448 + 128) * Scale , ScrH() - (64 - 4) * Scale, (256*0.75) * Scale , (128*0.75) * Scale,0)

end




hook.Add( "HUDShouldDraw", "Oblivion Clear HUD", function( name )
	
	 if ( name == "CHudHealth" or name == "CHudBattery" ) then
		 return false
	 end
	
end )