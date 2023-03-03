local scrw,scrh = ScrW(),ScrH()
local abilityPanel = nil 

hook.Add("HUDPaint","AbilityTime",function()
    if abilityPanel == nil then 
        return 
    elseif LocalPlayer().cooldown == nil then
        return 
    elseif LocalPlayer().cooldown <= CurTime() then 
        return 
    end 
    draw.SimpleText(LocalPlayer().cooldown - CurTime(),"ChatFont",scrw * 0.475,scrh * 0.9,Color(255,255,255))
end)

net.Receive("AbilityUse",function()
    LocalPlayer().cooldown = net.ReadInt(32)
    local icon = net.ReadString()
    local cd = net.ReadInt(16)
    abilityPanel:SetMaterial("porosenok.png")

    timer.Create("AbilityCD",cd,1,function()
        abilityPanel:SetMaterial(icon)
    end)
end)

net.Receive("SkanAbility",function()
    hook.Add("HUDPaint","Skan",function()
        for k,v in ipairs(ents.FindInSphere(LocalPlayer():GetPos(),500)) do
            if v:IsNPC() or v:IsPlayer() then
                local coord = (v:GetPos() + v:OBBCenter()):ToScreen()
                draw.SimpleText("Обнаружен живой объект","ChatFont",coord.x,coord.y,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            end
        end
    end)
    --[[local reload = vgui.Create("DLabel")
    reload:SetPos(scrw * 0.5,scrh * 0.8)
    reload:SetSize(250,250)
    reload:SetText("Reloading...")
    --]]
    timer.Simple(10,function()
        hook.Remove("HUDPaint","Skan")
    end)
end)

function HudAbility(name,desc,icon)
    abilityPanel = vgui.Create("ContentIcon")
    abilityPanel:SetPos(scrw * 0.475,scrh * 0.8)
    abilityPanel:SetSize(100,100)
    abilityPanel:SetName(name)
    abilityPanel:SetTooltip(desc)
    abilityPanel:SetMaterial(icon)
end

net.Receive("AbilityHUD",function()
    local desc = net.ReadString()
    local name = net.ReadString()
    local icon = net.ReadString()
    if desc == nil then return end 
    HudAbility(name,desc,icon)   
end)

net.Receive("HUDRemove",function()
    abilityPanel:Remove()
    LocalPlayer().cooldown = 0
end)

net.Receive("Speed",function()
    
end)


