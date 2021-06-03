if CLIENT then
    local inventory = inventory or {}
    local canOpenInv = true
    local itemArray = {}
    local lengthOfInv = 0

    net.Receive("openInvMenu", function(len, ply)
        if (canOpenInv) then
            drawPlayerInv()
        end
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

            for i = 1, lengthOfInv do
                local x = 30
                local y = 50
                itemArray[i] = vgui.Create("SpawnIcon", frameWithItems)
                itemArary[i]:SetPos(x + 10, y + 20)
            end
            print(lengthOfInv)
        end
    end

end

if SERVER then
    local inventory = inventory or {}
    local itemsToStore = {
        [1] = "item_healthkit",
        [2] = "item_healthvial",
        [3]= "item_battery"
    }
    local plyMeta = FindMetaTable("Player")

    hook.Add("PlayerInitialSpawn", "addPlayerIDToTheTable", function(ply, trans)
        inventory[ply:SteamID64()] = {}
    end)

    hook.Add("PlayerDisconnected", "RemoveInvFromPlayer", function(ply)

    end)

    function plyMeta:AddItemToPlayerInv(item)
        local ply = self
        local canStoreItem = false

        if (!inventory[ply:SteamID64()]) then
            inventory[ply:SteamID64()] = {}
        end

        for i = 0, #itemsToStore do
            if (itemsToStore[i] == item:GetClass()) then canStoreItem = true print(canStoreItem) end
        end

        if (inventory[ply:SteamID64()] and canStoreItem) then
            print("seexooo with " .. ply:Nick())
            for k, v in pairs(inventory) do
                --print(k)
                --print(" ")
                --print(v)
            end
            table.insert(inventory[ply:SteamID64()], item:GetClass())
            --inventory[j].items = item
            ply:SetNWInt("lengthOfInv", ply:GetNWInt("lengthOfInv", 0) + 1)
            PrintTable(inventory)
            item:Remove()
        end
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
            --ents.Create(v):SetPos(ply:GetEyeTrace().HitPos)
        end
        print(#inventory[ply:SteamID64()])
        --ents.Create("item_healthkit"):SetPos(ply:GetEyeTrace().HitPos):Spawn()
    end
end