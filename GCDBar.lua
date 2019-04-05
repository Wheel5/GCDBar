GCDBar = GCDBar or { }
local gb = GCDBar

local EM = GetEventManager()

local defaults = {
	["frameX"] = 500,
	["frameY"] = 500,
	["scale"] = 1,
	["color"] = {1, 0, 0, .7},
	["abCooldown"] = false,
}

gb.name = "GCDBar"
gb.version = "1.0"

local function cdHandler()
	local remain, duration, global, globalSlotType = GetSlotCooldownInfo(3)
	gb.UI.gbFront:SetDimensions((remain/duration)*175, 50)
end

local function rebuildFunction()
	local updateCooldown = ActionButton.UpdateCooldown

	function ActionButton:UpdateCooldown(options)
		local slotNum = self:GetSlot()
		local remain, duration, global, globalSlotType = GetSlotCooldownInfo(slotNum)

		gb.UI.gbFront:SetHidden(global and not (duration > 0))

		if global and duration > 0 and slotNum == 3 then
			EM:RegisterForUpdate(gb.name.."cooldown", 20, cdHandler)
		elseif global and not (duration > 0) and slotNum == 3 then
			EM:UnregisterForUpdate(gb.name.."cooldown")
			gb.UI.gbFront:SetDimensions(175, 50)
		end

		updateCooldown(self, options)
	end
end

function gb.init(e, addonName)
	if addonName ~= gb.name then return end
	gb.savedVars = ZO_SavedVars:NewCharacterIdSettings("GCDBarSavedVars", 1, nil, defaults)
	gb.UI.buildUI()
	gb.UI.setProperties()
	rebuildFunction()
	gb.buildMenu()
	if gb.savedVars.abCooldown then ZO_ActionButtons_ToggleShowGlobalCooldown() end
end

EM:RegisterForEvent(gb.name.."Load", EVENT_ADD_ON_LOADED, gb.init)

