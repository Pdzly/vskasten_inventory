AddCSLuaFile()
if SERVER then
	util.AddNetworkString("openInvMenu")
end
SWEP.Author = "rAiZeN"
SWEP.Base = "weapon_base"
SWEP.PrintName = "Inventar"
SWEP.Instructions = [[Links-Klick: Hebt das Gegenstand ins Inventar 
Rechts-Klick: Öffnet Inventar]]
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.Slot = 0
SWEP.DrawAmmo = false 
SWEP.Spawnable = true
SWEP.ShouldDropOnDie = false

SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false

function SWEP:Initialize()
	self:SetHoldType("normal")
end

function SWEP:ShouldDrawViewModel()
	return false
end

function SWEP:PrimaryAttack()
	local tr = self.Owner:GetEyeTrace().Entity
	if self.Owner:EyePos():DistToSqr(tr:GetPos()) > 10000 then return end
	if SERVER then
		self.Owner:AddItemToPlayerInv(tr, self.Owner)
		tr:Remove()
	end
end

function SWEP:SecondaryAttack()
	if SERVER then
		net.Start("openInvMenu")
		net.WriteBool(true)
		net.Send(self.Owner)
	end
end