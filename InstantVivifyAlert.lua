local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

local mainFrame = CreateFrame("FRAME", nil, UIParent)
mainFrame:SetFrameStrata("BACKGROUND")
mainFrame:SetWidth(42)
mainFrame:SetHeight(42)
mainFrame:SetPoint("TOP", "UIParent", 0, -250)
mainFrame:SetFrameStrata("TOOLTIP")
mainFrame.text = mainFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
mainFrame.text:SetPoint("BOTTOM", 0, -25)
mainFrame.text:SetText("Instant Vivify Available!")
mainFrame.text:SetTextScale(1.2)
mainFrame.text:SetTextColor(255, 255, 255)
mainFrame.icon = mainFrame:CreateTexture(nil, "ARTWORK")
mainFrame.icon:SetAllPoints(true)

frame:SetScript("OnEvent", function(self, event, ...)
	mainFrame:Hide()
	
	if event == "UNIT_AURA" then
		frame:CheckCurrentUnitAuras(self, event, ...)
		return
	end

	local _, instanceType = IsInInstance()

	if instanceType == "arena" then
		print("Arena detected | Vivacious Vivification check enabled")
		frame:RegisterEvent("UNIT_AURA")
	else
		frame:UnregisterEvent("UNIT_AURA")
		print("World detected | Vivacious Vivification check disabled")
	end
end)

function frame:CheckCurrentUnitAuras(unit)
	local index = 1
	local buff = UnitBuff("player", index)

	while buff do
		index = index + 1

		buff = UnitBuff("player", index)

		local _, _, icon, _, _, _, _, _, _, spellId = UnitBuff("player", index)
		
		if spellId == 392883 then
			local _,_,dsIcon = GetSpellInfo(392883)
			mainFrame.icon:SetTexture(dsIcon)
			mainFrame:Show()
			break
		else
			mainFrame:Hide()
		end
	end
end

DEFAULT_CHAT_FRAME:AddMessage("InstantVivifyAlert loaded")
