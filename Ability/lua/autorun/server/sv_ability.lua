local plym = FindMetaTable("Player")
util.AddNetworkString("AbilityHUD")
util.AddNetworkString("HUDRemove")
util.AddNetworkString("HUDDestroy")
util.AddNetworkString("AbilityUse")

for k,v in pairs(nets) do
    util.AddNetworkString(v)
end


plym.Ability = nil 

hook.Add("PlayerSpawn","Ability",function(ply)
    ply.Ability = abilities[math.random(1,table.Count(abilities))]
    ply.Cooldown = 0 
    net.Start("AbilityHUD")
    net.WriteString(ply.Ability.description)
    net.WriteString(ply.Ability.name)
    net.WriteString(ply.Ability.icon)
    net.Send(ply)
end)

hook.Add("PlayerDeath","AbilityDelete",function(victim,inflictor,attacker)
    victim.Ability.death(victim)
    victim.Ability = nil 
    victim.Cooldown = 0
    net.Start("HUDRemove")
    net.Send(victim)
end)

hook.Add("PlayerButtonDown","AbilityActivate",function(ply,button)
    if button != KEY_T then return end
    if ply.Ability == nil then return end 
    if not ply:Alive() then return end 
    if ply.Cooldown <= CurTime() then
        print("Ability Activated")
        ply.Ability.use(ply)
        ply.Cooldown = CurTime() + ply.Ability.usetime
        net.Start("AbilityUse")
        net.WriteInt(ply.Cooldown,32)
        net.WriteString(ply.Ability.icon)
        net.WriteInt(ply.Ability.cooldown,16)
        net.Send(ply)
    else
        print("Ability is reloading")
    end
end)