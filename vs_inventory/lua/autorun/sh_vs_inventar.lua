if CLIENT then
    net.Receive("openInvMenu", function(len, ply)
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
        end
    end)
end


if SERVER then
    local inventory = {}
    local plyMeta = FindMetaTable("Player")
    local i, j

    hook.Add("PlayerInitialSpawn", "addPlayerIDToTheTable", function(ply, trans)
        for i = 0, #inventory do
            if (inventory[j] == ply:SteamID64()) then
                table.insert(inventory, tonumber(ply:SteamID64()))  
            end
        end
    end)

    hook.Add("PlayerDisconnected", "RemoveInvFromPlayer", function(ply)
        for i = 1, #inventory do
            if (inventory[i] == tonumber(ply:SteamID64())) then table.remove(inventory, i) end
        end
        i = 0
    end)

    function plyMeta:AddItemToPlayerInv(item, ply)
        for j = 1, #inventory do
            PrintTable(inventory)
            if (inventory[j] == tonumber(ply:SteamID64())) then
                print("seexooo with " .. ply:Nick())
                inventory[j] = {} 
                --inventory[j].items = item
            end
        end
        j = 0
        PrintTable(inventory)
    end
end