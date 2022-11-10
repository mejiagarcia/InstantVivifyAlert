local frame = CreateFrame("Frame")
local mainFrame = CreateFrame("FRAME", nil, UIParent)

frame:RegisterEvent("PLAYER_ENTERING_WORLD")

-- Constants --
local UNIT_AURA_EVENT = "UNIT_AURA"
local PLAYER_UNIT = "player"
local ARENA_INSTANCE_TYPE = "arena"
local SPELL_ID = 392883
local ADDON_WELCOME_MESSAGE = "|cffffcc00 InstantVivifyAlert |cffffffff loaded"
local ADDON_ARENA_MESSAGE = "|cffffcc00 Arena detected: |cffffffff Vivacious Vivification check enabled"
local ADDON_WORLD_MESSAGE = "|cffffcc00 World detected: |cffffffff Vivacious Vivification check disabled"
local ADDON_SPELL_AV_MESSAGE = "Instant Vivify Available!"

frame:SetScript("OnEvent", function(self, event, ...)
	mainFrame:Hide()
	
	if event == UNIT_AURA_EVENT then
		frame:CheckCurrentUnitAuras(self, event, ...)
		return
	end

	local _, instanceType = IsInInstance()

	if instanceType == ARENA_INSTANCE_TYPE then
		print(ADDON_ARENA_MESSAGE)
		frame:RegisterEvent(UNIT_AURA_EVENT)
		frame:SetupMessageFrame()
	else
		frame:UnregisterEvent(UNIT_AURA_EVENT)
		print(ADDON_WORLD_MESSAGE)
	end
end)

function frame:SetupMessageFrame()
	mainFrame:SetFrameStrata("BACKGROUND")
	mainFrame:SetWidth(42)
	mainFrame:SetHeight(42)
	mainFrame:SetPoint("TOP", "UIParent", 0, -250)
	mainFrame:SetFrameStrata("TOOLTIP")
	mainFrame.text = mainFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	mainFrame.text:SetPoint("BOTTOM", 0, -25)
	mainFrame.text:SetText(ADDON_SPELL_AV_MESSAGE)
	mainFrame.text:SetTextScale(1.2)
	mainFrame.text:SetTextColor(255, 255, 255)
	mainFrame.icon = mainFrame:CreateTexture(nil, "ARTWORK")
	mainFrame.icon:SetAllPoints(true)
end

function frame:CheckCurrentUnitAuras(unit)
	local index = 1
	local buff = UnitBuff(PLAYER_UNIT, index)

	while buff do
		index = index + 1

		buff = UnitBuff(PLAYER_UNIT, index)

		local _, _, icon, _, _, _, _, _, _, spellId = UnitBuff(PLAYER_UNIT, index)
		
		if spellId == SPELL_ID then
			local _,_,dsIcon = GetSpellInfo(SPELL_ID)
			mainFrame.icon:SetTexture(dsIcon)
			mainFrame:Show()
			break
		else
			mainFrame:Hide()
		end
	end
end

DEFAULT_CHAT_FRAME:AddMessage(ADDON_WELCOME_MESSAGE)
