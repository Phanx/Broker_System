--[[--------------------------------------------------------------------
	Broker_System
	Shows latency. Click for game menu. Right-click to reload UI.
	Copyright (c) 2014-2015 Phanx. All rights reserved.
	https://github.com/Phanx/Broker_System
----------------------------------------------------------------------]]

local NORMAL_ICON   = "Interface\\Buttons\\UI-MicroButton-MainMenu-Up"
local STREAM_ICON   = "Interface\\Buttons\\UI-MicroStream-Green"

local NORMAL_COORDS = { 0.175, 0.825, 0.5, 0.825 }
local STREAM_COORDS = { 1, 1, 1, 1 }

local LATENCY = "Latency"
local TEXT    = "|cff%s%d ms|r"
if GetLocale() == "deDE" then
	LATENCY = "Latenz"
elseif GetLocale():match("^es") then
	LATENCY = "Latencia"
elseif GetLocale() == "esMX" then
	LATENCY = "Latencia"
elseif GetLocale() == "frFR" then
	LATENCY = "Latence"
elseif GetLocale() == "itIT" then
	LATENCY = "Latenza"
elseif GetLocale() == "ptBR" then
	LATENCY = "Latência"
elseif GetLocale() == "ruRU" then
	LATENCY = "Задержка"
	TEXT    = "%d мс"
elseif GetLocale() == "koKR" then
	LATENCY = "지연 시간"
elseif GetLocale() == "zhCN" then
	LATENCY = "延迟"
elseif GetLocale() == "zhTW" then
	LATENCY = "延遲"
	TEXT    = "|cff%s%d毫秒|r"
end

local function GetLatencyText(which)
	local _, _, latencyHome, latencyWorld = GetNetStats()
	local latency = which == 1 and latencyHome
		or which == 2 and latencyWorld
		or latencyHome > latencyWorld and latencyHome or latencyWorld
	if latency > PERFORMANCEBAR_MEDIUM_LATENCY then
		return format(TEXT, "ff3333", latency)
	elseif latency > PERFORMANCEBAR_LOW_LATENCY then
		return format(TEXT, "ffff33", latency)
	else
		return format(TEXT, "33ff33", latency)
	end
end

local obj = LibStub("LibDataBroker-1.1"):NewDataObject(LATENCY, {
	type = "data source",
	icon = NORMAL_ICON,
	iconCoords = NORMAL_COORDS,
	label = LATENCY,
	text = UNKNOWN,
	OnTooltipShow = function(tooltip)
		tooltip:AddLine(LATENCY, 1, 1, 1)
		tooltip:AddDoubleLine("Home:", "World:")
		tooltip:AddDoubleLine(GetLatencyText(1), GetLatencyText(2))
		tooltip:AddLine("Click to show the addon list.")
		tooltip:AddLine("Right-click to show the main menu.")
	end,
	OnClick = function(self, button)
		if button == "RightButton" then
			if GameMenuFrame:IsShown() then
				PlaySound("igMainMenuQuit")
				HideUIPanel(GameMenuFrame)
			else
				if VideoOptionsFrame:IsShown() then
					VideoOptionsFrameCancel:Click()
				elseif AudioOptionsFrame:IsShown() then
					AudioOptionsFrameCancel:Click()
				elseif InterfaceOptionsFrame:IsShown() then
					InterfaceOptionsFrameCancel:Click()
				end
				CloseMenus()
				CloseAllWindows()
				PlaySound("igMainMenuOpen")
				ShowUIPanel(GameMenuFrame)
			end
		elseif OptionHouse then
			if OptionHouse.frame and OptionHouse.frame:IsShown() then
				HideUIPanel(OptionHouse.frame)
			else
				OptionHouse:Open()
			end
		else
			ToggleFrame(AddonList)
		end
	end
})

local function Update()
	if GetFileStreamingStatus() ~= 0 or GetBackgroundLoadingStatus() ~= 0 then
		obj.icon = STREAM_ICON
		obj.iconCoords = STREAM_COORDS
	else
		obj.icon = NORMAL_ICON
		obj.iconCoords = NORMAL_COORDS
	end
	obj.text = GetLatencyText()
	C_Timer.After(30, Update)
end

C_Timer.After(15, Update)
