if CLIENT then
    local inventory = inventory or {}
    local canOpenInv = true
    local itemArray = {}
    local arrayWithItems = {}
    local arrayModelname = {}
    local arrayClassname = {}
    local lengthOfInv

    net.Receive("openInvMenu", function(len, ply)
        if (canOpenInv) then
            drawPlayerInv()
        end
    end)

    net.Receive("itemModelname", function(len, ply)
        table.insert(arrayModelname, net.ReadString())
    end)

    net.Receive("itemClassname", function(len, ply)
        table.insert(arrayClassname, net.ReadString())
    end)

    net.Receive("sendNotification", function(len, ply)
        notification.AddLegacy("Der Ort wo du dein Item spawnen willst ist zu weit entfernt!", NOTIFY_ERROR, 2)
    end)

    -- Danke Sonex fürs melden
    hook.Add("OnContextMenuOpen", "prohibitToOpenInv", function()
        canOpenInv = false
    end)

    hook.Add("OnContextMenuClose", "allowToOpenTheInv", function()
        canOpenInv = true
    end)

    function drawPlayerInv()
        if (net.ReadBool("openInvMenu")) then
            lengthOfInv = LocalPlayer():GetNWInt("lengthOfInv", 0)
            gui.EnableScreenClicker(true)
            local frameWithItems = vgui.Create("DPanel")
            frameWithItems:SetSize(ScrW() - (ScrW() - 600), ScrH() - (ScrH() - 100))
            frameWithItems:CenterHorizontal(0.5)
            frameWithItems:CenterVertical(0.7)
            frameWithItems:SetVisible(true)
            function frameWithItems:Paint(w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 240))
            end

            local itemFrameCloseButton = vgui.Create("DImageButton", frameWithItems)
            itemFrameCloseButton:SetImage("icon16/cross.png")
            itemFrameCloseButton:SetSize(16,16)
            itemFrameCloseButton:CenterHorizontal(0.985)
            itemFrameCloseButton:CenterVertical(0.09)
            function itemFrameCloseButton:DoClick()
                frameWithItems:Remove()
                gui.EnableScreenClicker(false)
            end

            local x = 45
            for i = 1, lengthOfInv do
                itemArray[i] = vgui.Create("SpawnIcon", frameWithItems)
                itemArray[i]:SetPos(x, 20)
                itemArray[i]:SetModel(arrayModelname[i])
                itemArray[i]:SetToolTip(false)
                local itemButton = itemArray[i]
                function itemButton:DoClick()
                    print(arrayClassname[i])
                    net.Start("spawnItemFromInv")
                    net.WriteString(arrayClassname[i])
                    net.SendToServer()
                end
                x = x + 75
            end
                
            --PrintTable(itemArray)
        end
    end

end

if SERVER then
    util.AddNetworkString("openInvMenu")
	util.AddNetworkString("itemModelname")
	util.AddNetworkString("itemClassname")
    util.AddNetworkString("spawnItemFromInv")
    util.AddNetworkString("sendNotification")

    itemsToStore = {
        "item_healthkit",
        "item_healthvial",
        "item_battery",
        "arccw_mifl_fas2_ak47",
        "arccw_mifl_fas2_deagle",
        "arccw_mifl_fas2_famas",
        "arccw_mifl_fas2_g36c",
        "arccw_mifl_fas2_g3",
        "arccw_mifl_fas2_g20",
        "arccw_mifl_fas2_ks23",
        "arccw_mifl_fas2_m1911",
        "arccw_mifl_fas2_m24",
        "arccw_mifl_fas2_m3",
        "arccw_mifl_fas2_m4a1",
        "arccw_mifl_fas2_m79",
        "arccw_mifl_fas2_m82",
        "arccw_mifl_fas2_mac11",
        "arccw_fml_fas2_custom_mass26",
        "arccw_mifl_fas2_minimi",
        "arccw_mifl_fas2_mp5",
        "arccw_mifl_fas2_p226",
        "arccw_mifl_fas2_ragingbull",
        "arccw_mifl_fas2_rpk",
        "arccw_mifl_fas2_sg55x",
        "arccw_mifl_fas2_sr25",
        "arccw_mifl_fas2_toz34"
    }
    local inventory = inventory or {}
    local plyMeta = FindMetaTable("Player")

    net.Receive("spawnItemFromInv", function(len, ply)
        local itemClassnameToSpawn = net.ReadString()
        if (itemClassnameToSpawn != nil) then
            if (ply:EyePos():DistToSqr(ply:GetEyeTrace().HitPos) < 15000) then
                local item = ents.Create(itemClassnameToSpawn)
                item:SetPos(ply:GetEyeTrace().HitPos)
                item:Spawn()
            else
                net.Start("sendNotification")
                net.Send(ply)
            end
        end
    end)

    hook.Add("PlayerInitialSpawn", "addPlayerIDToTheTable", function(ply, trans)
        inventory[ply:SteamID64()] = {}
    end)

    hook.Add("PlayerDisconnected", "RemoveInvFromPlayer", function(ply)
        ply:SetNWInt("lengthOfInv", 0)
        inventory[ply:SteamID64()] = {}
    end)

    function plyMeta:AddItemToPlayerInv(item)
        local ply = self
        local canStoreItem = false

        if (!inventory[ply:SteamID64()]) then
            inventory[ply:SteamID64()] = {}
        end
        table.insert(inventory[ply:SteamID64()], item:GetClass())
        ply:SetNWInt("lengthOfInv", ply:GetNWInt("lengthOfInv", 0) + 1)
        ply:SetNWString("getModelname", item:GetModel())
        ply:SetNWString("getClassname", item:GetClass())

            --PrintTable(inventory)
        item:Remove()
        print(#inventory[ply:SteamID64()])
    end

    function plyMeta:SpawnItemFromInv(item)
        local ply = self
        --PrintTable(inventory[ply:SteamID64()])
        --ents.Create()
        for k, v in pairs(inventory[ply:SteamID64()]) do
            if (self:EyePos():DistToSqr(ply:GetEyeTrace().HitPos) < 15000) then
                local item = ents.Create(v)
                item:SetPos(ply:GetEyeTrace().HitPos)
                item:Spawn()
            end
        end
        --print(#inventory[ply:SteamID64()])
    end
end