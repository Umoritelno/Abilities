print("Shared loaded!")
abilities = {}
nets = {}

function AddSkill(data) 
    local name = data.name 
    abilities[table.Count(abilities) + 1] = data 
    for k,v in pairs(data.nets) do
        table.Add(nets,data.nets)
    end
 end 
 
 AddSkill(
     {   name = "Skan",
         icon = "Skan.png",
         description = "Mark everyone near you",
         id = 1,
         cooldown = 20,
         usetime = 10,
         nets = {"SkanAbility",
                  "SkanDeath"},
         use = function(ply)
             net.Start("SkanAbility")
             net.WriteString("Skan.png")
             net.WriteInt(10,5)
             net.Send(ply)
         end,
         death = function(ply)
            net.Start("SkanDeath")
            hook.Remove("HUDPaint","Skan")
            net.Send(ply)
         end
     }
 )

AddSkill(
     {   name = "SpeedBoost",
         icon = "SpeedBoost.png",
         description = "Give you speed boost",
         id = 2,
         cooldown = 60,
         usetime = 15,
         nets = {"Speed",
                 "DeathSpeed"},
         use = function(ply)
            ply:ScreenFade( SCREENFADE.IN, Color( 255, 217, 0, 64), 15, 0 )
             ply:SetWalkSpeed(250)
             ply:SetRunSpeed(750)
             timer.Simple(15,function()
                ply:SetWalkSpeed(200)
                ply:SetRunSpeed(500)
             end)
             net.Start("Speed")
             net.Send(ply)
         end,
         death = function(ply)
            if ply:GetWalkSpeed() == 250 then 
            ply:SetWalkSpeed(200)
            ply:SetRunSpeed(500)
            end 
            net.Start("DeathSpeed")
            net.Send(ply)
         end,
     }
)