GCDBar = GCDBar or { }
local gb = GCDBar

local lockUI = true

function gb.buildMenu()
	local LAM = LibStub("LibAddonMenu-2.0")

	local panelData = {
		type = "panel",
		name = "GCD Bar",
		displayName = "|cff0c4dG|rCD Bar",
		author = "Wheels",
		version = ""..gb.version,
		registerForRefresh = true,
	}

	LAM:RegisterAddonPanel(gb.name.."Options", panelData)

	local options = {
		{
			type = "header",
			name = "Display Options",
		},
		{
			type = "checkbox",
			name = "Lock UI",
			tooltip = "Enable repositioning the cooldown bar",
			getFunc = function() return lockUI end,
			setFunc = function(value)
				gb.UI.setHudToggle(value)
				gb.UI.gbFrame:SetMouseEnabled(not value)
				gb.UI.gbFrame:SetMovable(not value)
				gb.UI.gbFrame:SetHidden(value)
				lockUI = value
			end,
		},
		{
			type = "checkbox",
			name = "Toggle Action Bar Cooldowns",
			tooltip = "Toggles radial cooldowns on the action bar",
			getFunc = function() return gb.savedVars.abCooldown end,
			setFunc = function(value)
				ZO_ActionButtons_ToggleShowGlobalCooldown()
				gb.savedVars.abCooldown = value
			end,
		},
		{
			type = "slider",
			name = "Bar Scale",
			tooltip = "Adjust size of GCD Bar frame",
			min = 0.5,
			max = 2,
			step = 0.1,
			getFunc = function() return gb.savedVars.scale end,
			setFunc = function(value)
				gb.savedVars.scale = value
				gb.UI.setProperties()
			end,
		},
		{
			type = "colorpicker",
			name = "Bar Color",
			tooltip = "Color of the GCD Bar (what did you think it was?)",
			getFunc = function() return unpack(gb.savedVars.color) end,
			setFunc = function(r,g,b,a)
				gb.savedVars.color = {r,g,b,a}
				gb.UI.setProperties()
			end,
		},
	}

	LAM:RegisterOptionControls(gb.name.."Options", options)
end
