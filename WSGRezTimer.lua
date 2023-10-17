WSGRezTimer = {
    timeSinceLastUpdate = 0;
    updateInterval = 1;
    rezInterval = nil;
};

Zone = "Warsong Gulch";

function WSGRezTimer_OnLoad()
    DEFAULT_CHAT_FRAME:AddMessage("|cffFF5733WSGRezTimer|r was initialized. Have fun in WSG! - Urtica");
    getglobal("WSGRezTimerFrame"):RegisterEvent("ZONE_CHANGED_NEW_AREA");
    getglobal("WSGRezTimerFrame"):RegisterEvent("CHAT_MSG_ADDON");
end

function WSGRezTimer_OnEvent(event)
    if (event == "ZONE_CHANGED_NEW_AREA" and GetRealZoneText() == Zone) then
        -- DEFAULT_CHAT_FRAME:AddMessage(event);
        getglobal("WSGRezTimerFrame"):Show();
    end
    if (event == "ZONE_CHANGED_NEW_AREA" and GetRealZoneText() ~= Zone) then
        -- DEFAULT_CHAT_FRAME:AddMessage(event);
        WSGRezTimer.rezInterval = nil;
        getglobal("WSGRezTimerFrame"):Hide();
    end
    if (event == "CHAT_MSG_ADDON" and GetRealZoneText() == Zone) then
        if(string.find(arg1, "WSGRezTimer") ~= nil and string.find(arg1, UnitName("player")) == nil and UnitIsGhost("player") == nil) then
            if(arg2 ~= nil) then
                -- DEFAULT_CHAT_FRAME:AddMessage(arg1);
                WSGRezTimer.rezInterval = arg2;
            end
        end
    end
end

function WSGRezTimer_OnUpdateTimer(elapsed)
    WSGRezTimer.timeSinceLastUpdate = (WSGRezTimer.timeSinceLastUpdate or 0) + elapsed;
    
    if (WSGRezTimer.timeSinceLastUpdate > WSGRezTimer.updateInterval) then
        if (WSGRezTimer.rezInterval == 0) then
            WSGRezTimer.rezInterval = 30;
        end
        if (UnitIsGhost("player") == 1) then
            if (UnitBuff("player", 1)) then
                WSGRezTimer.rezInterval = GetAreaSpiritHealerTime()+1;
                SendAddonMessage("WSGRezTimer" .. "/" .. UnitName("player"), WSGRezTimer.rezInterval, "Battleground");
            end
        end
        if (WSGRezTimer.rezInterval ~= nil) then 
            WSGRezTimer.rezInterval = WSGRezTimer.rezInterval-1;
            getglobal("WSGRezTimerDisplay"):SetText("Next rez in: " .. WSGRezTimer.rezInterval);
        else 
            getglobal("WSGRezTimerDisplay"):SetText("No timer available yet.");
        end

        WSGRezTimer.timeSinceLastUpdate = 0;
    end
end