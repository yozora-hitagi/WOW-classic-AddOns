-------------------------------
-- ifarm.lua
-- by Icewater @ Bronze Dragonflight (EU)
-------------------------------

local FARM_HELP = {

["HELP"] = "显示帮助";
["ZONE"] = "显示你当前的区域";
["ENABLE"] = "启用 |cFFFF8000iFarm|cFFFFFFFF.";
["DISABLE"] = "禁用 |cFFFF8000iFarm|cFFFFFFFF.";
["CLEARGREYS"] = "删除你背包中所有灰色垃圾.";
["ISACTIVE"] = "显示 |cFFFF8000iFarm|cFFFFFFFF 是否激活.";
["SHOW"] = "显示 |cFFFF8000iFarm 小窗口|cFFFFFFFF.";
["LIST"] = "显示 |cFFFF8000全局删除列表|cFFFFFFFF 的所有物品.";
["CLEARLIST"] = "清除 |cFFFF8000全局删除列表|cFFFFFFFF.";
["ADD"] = "添加物品到全局删除列表";
["REM"] = "从全局删除列表删除物品";
["SCALE"] = "|cFFFF8000iFarm 小窗口|cFFFFFFFF的大小. 默认为 = 1.";
};

-- Saved Options
GLOBAL_DELETE = { };

Farm_Options = { 

["FREEZE"] = false;
["SHOW"] = false;
["ACTIVE"] = false;
["FSCALE"] = 0.8;

};

local slashCmdLoaded = false;
local delCount = 0;

function updateUi()
    if (Farm_Options["SHOW"]) then
		iFarmFrame:Show();
	else
		iFarmFrame:Hide();
	end
    iFarmFrame:SetScale(tonumber(Farm_Options["FSCALE"]));
	if (Farm_Options["ACTIVE"]) then
          btnStatus:SetText("禁用")
          FarmTitle:SetTextColor(0.3, 1, 0.3);
	else
          btnStatus:SetText("启用")
          FarmTitle:SetTextColor(1, 0.3, 0.3);
	end
    txtCount:SetText("自动删除物品数: " .. tostring(delCount));
end

function iFarm_OnEvent(frame, event)
--    Farm_Say("Event: " .. event .. " |cmd: " .. tostring(slashCmdLoaded));
    if (event=="LOOT_CLOSED") and Farm_Options["ACTIVE"]then
		checkGlobal();
        txtCount:SetText("自动删除物品数: " .. tostring(delCount));
    elseif (event=="ADDON_LOADED") and (slashCmdLoaded == false) then
        iFarmFrame:RegisterEvent("LOOT_CLOSED");
        iFarmFrame:RegisterForDrag("LeftButton");

        SlashCmdList["IFARM"] = ifarm_SlashCommandHandler;
        SLASH_IFARM1="/ifarm";

        Farm_Say("已加载!  输入 '/ifarm' 打开设置.");
        slashCmdLoaded = true;        
        txtCount:SetTextColor(0.3, 1, 0.3);
        iFarmFrame:UnregisterEvent("ADDON_LOADED");
        updateUi();
	elseif (event=="PLAYER_LOGOUT") then
		Farm_Options["ACTIVE"] = false;
	end
end

function iFarm_ToggleStatus()
	if (Farm_Options["ACTIVE"]) then
        Farm_Options["ACTIVE"] = false;
    else
        Farm_Options["ACTIVE"] = true;
    end
    updateUi();
end

function iFarm_AddItem()
    if (CursorHasItem()) then
        local iType, iName, iId = GetCursorInfo();
        if ( itemIsInList(iId) ) then
	        Farm_Say("物品已经在列表中.");
        else
            Farm_Say("添加 |cFF00FF00" .. iId .. "|cFFFFFFFF 到全局删除列表.");
            table.insert(GLOBAL_DELETE, getItemLink(iId));
        end
        ClearCursor();
    end
end

function getItemListString()
    local itemString = "";
    for k,v in pairs(GLOBAL_DELETE) do
        itemString = itemString .. v .. "|n";    
    end
    return itemString;
end
    
function ifarm_SlashCommandHandler(msg)

	if not (msg) then
		msg = "HELP";
	end

	local x = 0;
 
	repeat
		msg, x = gsub(msg, "  ", " ");
	until (x == 0)
	
	local Parsed = { strsplit(" ", (msg)); };

-- clearGreys
    if (Parsed[1] == "cleargreys") then
		iFarm_ClearGreys(); 
-- getZone
    elseif (Parsed[1] == "zone") then
		Farm_Say("当前区域: " .. GetZoneText());
-- Show
    elseif (Parsed[1] == "show") then
        iFarm_ToggleFrameVisible();
-- enable
    elseif (Parsed[1] == "enable") then
		Farm_Options["ACTIVE"] = true;
		Farm_Say("现在为 |cFF00FF00[启用]");
-- disable
    elseif (Parsed[1] == "disable") then
		Farm_Options["ACTIVE"] = false;
		Farm_Say("现在 |cFFFF2200[禁用]");
-- isactive
    elseif (Parsed[1] == "isactive") then
		if (Farm_Options["ACTIVE"]) then
			Farm_Say("当前 |cFF00FF00[启用]");
		else			
			Farm_Say("当前 |cFFFF2200[禁用]");
		end
-- list
    elseif (Parsed[1] == "list") then
        iFarm_PrintDeletionList();
-- clearlist
    elseif (Parsed[1] == "clearlist") then
        iFarm_ClearDeletionList();
-- add item
    elseif (Parsed[1] == "add") then
		local itemName = "";
		for i,v in ipairs(Parsed) do
			if ( i > 1 ) and itemName == "" then
				itemName = Parsed[i];
			elseif ( i > 1 ) then
				itemName = itemName .. " " .. Parsed[i];
			end
		end
		link = getItemLink(itemName);
		if (link == nil) then
			Farm_Say("物品: |cFFFF8000" .. itemName .. "|cFFFFFFFF 不是有效的物品名称.");
		else
			if ( itemIsInList(link) ) then
				Farm_Say("物品已在列表中.");
			else
				Farm_Say("添加: |cFF00FF00" .. link .. "|cFFFFFFFF 到全局删除列表.");
				table.insert(GLOBAL_DELETE, tostring(getItemLink(itemName)));
			end
		end
-- remove item
    elseif (Parsed[1] == "rem") then
		local itemName = "";
		for i,v in ipairs(Parsed) do
			if ( i > 1 ) and itemName == "" then
				itemName = Parsed[i];
			elseif ( i > 1 ) then
				itemName = itemName .. " " .. Parsed[i];
			end
		end
		if (type(Parsed[2] == "number")) then
			itemName = GLOBAL_DELETE[tonumber(Parsed[2])];
			Farm_Say("列表中删除: |cFF00FF00" .. GLOBAL_DELETE[tonumber(Parsed[2])] .. "|cFFFFFFFF");
            table.remove(GLOBAL_DELETE, tonumber(Parsed[2]));
		elseif (isValidItemName(itemName) == true) then
			link = getItemLink(itemName)
			if ( itemIsInList(link) ) then
				Farm_Say("列表中删除: |cFF00FF00" .. link .. "|cFFFFFFFF");
				for i,v in ipairs (GLOBAL_DELETE) do
					if ( v == itemName ) then
						table.remove(GLOBAL_DELETE,i);
					end
				end
			else
				Farm_Say("物品不在列表中，因此无法删除.");
			end
		else
			Farm_Say("物品: |cFFFF8000" .. itemName .. "|cFFFFFFFF 不是有效的物品名称.");
		end
-- scale frame
    elseif(Parsed[1] == "scale") then
        if (type(Parsed[2] == "number")) then
            local scale = tonumber(Parsed[2]);
            if (scale < 0.4) then 
                scale = 0.4; 
            elseif(scale > 2) then 
                scale = 2;
            end
            iFarmFrame:SetScale(scale);
            Farm_Options["FSCALE"] = scale;
         else
             Farm_Say("请输入一个介于0.2 - 3之间的数值");
         end
	else
		Farm_Say("Commands");
  		for k,v in pairs (FARM_HELP) do
			Farm_Say("|cFF00FF00" .. strlower(tostring(k)) .. "|cFFFFFF00: |cFFFFFFFF" .. strlower(v));
		end
    		Farm_Say("命令结束");
	end
	updateUi();
end

function itemIsInList(itemLink)
	local isInList = false;
	for i,v in ipairs (GLOBAL_DELETE) do
		if ( v == itemLink ) then
			return true;
		end
	end
	return false;
end

function Farm_Say(text)
	DEFAULT_CHAT_FRAME:AddMessage("|cFFFF8000[iFarm] |cFFFFFFFF" .. text);
end

function checkItem(itemName)
--    Farm_Say("checking: " .. itemName);
    if GetItemCount(itemName, false) > 0 then
		DeleteItem(itemName);
	end
end

function DeleteItem(itemToDelete)
	for i=0,4 do
		for j=1, GetContainerNumSlots(i) do
			local item = GetContainerItemLink(i,j)
			if item and item:find(itemToDelete) then
				PickupContainerItem(i,j);
				DeleteCursorItem();
                delCount = delCount + 1;
			end
		end
	end
end

function getItemRarity(item)
	local name, link, rarity, level, minlvl, typ, subtyp, stackcount, equiploc, texture = GetItemInfo(item);
	return rarity
end

function getItemLink(item)
	local name, link, rarity, level, minlvl, typ, subtyp, stackcount, equiploc, texture = GetItemInfo(item);
	return link
end

function getItemName(item)
	local name, link, rarity, level, minlvl, typ, subtyp, stackcount, equiploc, texture = GetItemInfo(item);
	return name
end

function isValidItemName(item)
	if (getItemLink(item) == nil) then 
		return false;
	else 
		return true;
	end
end

function iFarm_ClearGreys()
	local numItemsDeleted = 0;
	for i=0,4 do
		for j=1, GetContainerNumSlots(i) do
			local item = GetContainerItemLink(i,j);
			if not (item == nil) then
				if (getItemRarity(item)==0) then
                    numItemsDeleted = numItemsDeleted + 1;
					PickupContainerItem(i,j);
					DeleteCursorItem();
				end
			end
		end
	end
    delCount = delCount + numItemsDeleted;
    updateUi();
	Farm_Say("你的包很干净, |cFFFF3300" .. numItemsDeleted .. " |cFFFFFFFF 物品已被删除 ;)");
end

function checkGlobal()
    for i,v in ipairs(GLOBAL_DELETE) do
		checkItem(getItemName(v));
	end
end

function iFarm_ClearDeletionList()
    GLOBAL_DELETE = { };
    Farm_Say("你的自动删除列表已被清除.");
end

function iFarm_PrintDeletionList()
	for i,v in ipairs(GLOBAL_DELETE) do
		if not (v == nil) then
			Farm_Say(i .. ": " .. v);
		end
	end    
end

function iFarm_ToggleFrameVisible()
	if ( Farm_Options["SHOW"] ) then
		Farm_Options["SHOW"] = false;
		Farm_Say("小窗口现在 |cFFFF4400隐藏");
	else
		Farm_Options["SHOW"] = true;
		Farm_Say("小窗口现在 |cFF00FF00显示");
	end
    updateUi();
end