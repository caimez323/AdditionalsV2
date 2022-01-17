--[[
    Hey ! thanks for downloading my mod
    I hope you had/will have fun with it
    Feel free to check the code here
    I added some commentary to help
    But it's a disaster so good luck !
    Mod made by caimez_
--]]



--Settings for the mod
local Additionals = RegisterMod("AdditionalsV2",1)



--Set the costumes
Additionals.COSTUME_DEMON_RING= Isaac.GetCostumeIdByPath("gfx/characters/demon_ring.anm2")
Additionals.COSTUME_WHITE_FLOWER= Isaac.GetCostumeIdByPath("gfx/characters/white_flower.anm2")
Additionals.COSTUME_TRANSFORMATION_OPHIUSCUS = Isaac.GetCostumeIdByPath("gfx/characters/transformation_ophiuscus.anm2")

--Reset some variables now
local DJrestart = false
local Zodiac_C = 0
local Zodiac_T = false
local Zodiac_TBS = false
local Zodiac_TBF = false
local AlreadyGaveFrozen = false
local AlreadyGaveLaserDrone = false
local AlreadyDemon = false
local AlreadyGrail =false
local AlreadyCursedGrail =false
local max = 0
local timeA =0
local timeB=0
local chancetospawnBikeeper= 38
local chancetospawnSecretPassage= 39
local OneRemain = false
local GTNoDMG = true
local e
local b
local Afterflyver = false
local rangeBoost=0
local AlreadyBothGrail = false
local WzBoss = false


TearVariant.STARS = Isaac.GetEntityVariantByName("Stars")
TearVariant.DARK_STARS = Isaac.GetEntityVariantByName("Dark_Stars")
TearVariant.DOOM_STARS = Isaac.GetEntityVariantByName("Doom_Stars")

--Match each Item an Id
local FrozenItemId = Isaac.GetItemIdByName("Frozen Body")
local variant = Isaac.GetEntityVariantByName("frozenbody")
local variant1 = Isaac.GetEntityVariantByName("LaserDrone")
local LaserDroneID = Isaac.GetItemIdByName("Laser Drone")


local Proteins = Isaac.GetItemIdByName("Proteins")
local Wind = Isaac.GetItemIdByName("Freezy Wind")
local TransfusionId = Isaac.GetItemIdByName("Transfusion")
local DemonRingId = Isaac.GetItemIdByName("Demon Ring")
local StarterPackId = Isaac.GetItemIdByName("Starter pack")
local TmpId = Isaac.GetItemIdByName("Not-Glass Cannon")
local EnoughId = Isaac.GetItemIdByName("Revenge")
local InkId = Isaac.GetItemIdByName("Squid Ink")
local FlowerId = Isaac.GetItemIdByName("White Flower")
local MatchesId= Isaac.GetItemIdByName("Matches")
local GateId = Isaac.GetItemIdByName("Hell's Gate")
local SuperDamageId = Isaac.GetItemIdByName("Super Damages")
local RottenFleshId = Isaac.GetItemIdByName("Rotten Flesh")
local DartsId = Isaac.GetItemIdByName("Darts")
local DivineGrailId = Isaac.GetItemIdByName("Divine Grail")
local flyverterId = Isaac.GetItemIdByName("The Fly-verter")
local CursedGrailId = Isaac.GetItemIdByName("Cursed Grail")
local GiveTakeID = Isaac.GetItemIdByName("Give And Take")

local BiKeeperId= Isaac.GetCardIdByName("BiKeeper")
local SecretId = Isaac.GetCardIdByName("Secret Passage")



local StatGT = {
      AddDamage = 0;
      AddFireDelay = 0;
      AddShotSpeed = 0;
      AddLuck = 0
  }


--Bikeeper and Secret Passage card
function Additionals:onBikeeper(...)
   Isaac.ExecuteCommand("goto s.shop.5")
end

function Additionals:onSecret(...)
  local rand = math.random(0,4)
  local vel = Vector(0,0)
  local player = Isaac.GetPlayer(0)
  local pos = Vector(player.Position.X,player.Position.Y)
    if rand == 0 then
      Isaac.ExecuteCommand("goto s.blackmarket.1")
    else
      Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COIN,CoinSubType.COIN_PENNY,pos, vel, player)
    end
end
--Callbacks when use card and cardId equal custom cards
Additionals:AddCallback(ModCallbacks.MC_USE_CARD, Additionals.onSecret, SecretId)
Additionals:AddCallback(ModCallbacks.MC_USE_CARD, Additionals.onBikeeper, BiKeeperId)


--To spawn the customs cards, we search for a spawn card then add a chance to replace it
function Additionals:getCard(rng,current,playing,runes,onlyrunes)
  local randomcardid1 = rng:RandomInt(chancetospawnBikeeper)
  if randomcardid1 == 1 and not onlyrunes and current ~= Card.CARD_CHAOS then 
    return BiKeeperId
  end
  local randomcardid2 = rng:RandomInt(chancetospawnSecretPassage);
  if randomcardid2 == 1 and not onlyrunes and current ~= Card.CARD_CHAOS then 
    return SecretId
  end
end
Additionals:AddCallback(ModCallbacks.MC_GET_CARD, Additionals.getCard);



--COSTUMES AND RESET VARIABLES
--This function is called each 0.5s
function Additionals:onUpdate(player)
local game = Game()
  if (game:GetFrameCount() == 1 )then
    Zodiac_T=false
    Zodiac_C = 0
    HasWhiteFlower = false
    HasDemonRing = false
    AlreadyDemon = false
    Afterflyver = false
    FlameTear = false
    FlameTimeA=0
    FlameTimeB=0
    OneRemain = false
    GTNoDMG = true
    rangeBoost=0
    WzBoss = false
    --Reset items that have an already
    timeA = 0
    timeB = 0
    AlreadyStart = false
    AlreadyBothGrail = false
    AlreadyGaveFrozen = false
    AlreadyGaveLaserDrone = false
    AlreadyProteins = false
    AlreadyDemon = false
    AlreadyGrail =false
    AlreadyCursedGrail =false
    if not DJrestart then -- When we leave the run
      Zodiac_T=false
      Zodiac_C = 0
      HasAR=false
      HasT=false
      HasG=false
      HasCR=false
      HasCA=false
      HasLE=false
      HasV=false
      HasLI=false
      HasSC=false
      HasSA=false
      HasAQ=false
      HasP=false
      player.CanFly = false
      DJrestart = true
    end
  end
  -- get frame count for Matches
  FlameTimeB=player.FrameCount 
  --Applied costume if player haven't it yet and has the item
  if not HasDemonRing and player:HasCollectible(DemonRingId) then
    player:AddNullCostume(Additionals.COSTUME_DEMON_RING)
    HasDemonRing = true
  end
  if not HasWhiteFlower and player:HasCollectible(FlowerId) then
    player:AddNullCostume(Additionals.COSTUME_WHITE_FLOWER)
    HasWhiteFlower= true
  end
  
  
  --A fix for adding wisp when use The fly-verter without soul hearts
  if player:HasCollectible(584) and Afterflyver and player:HasCollectible(flyverterId) then
      local entwisp = Isaac.FindByType(3,206,-1)
      if #entwisp>0 then
        entwisp[1]:Remove()
        Afterflyver = false
      end
  end
  
end
Additionals:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Additionals.onUpdate)






-- External Item Descriptions support.
if not __eidItemDescriptions then
  __eidItemDescriptions = {}
end
--Part is to make the mod compatible with eid
__eidItemDescriptions[Proteins] = "Hp up, +0.2 speed +2 damages#Charge your item twice"
__eidItemDescriptions[DemonRingId] = "All devil deals are now Angel rooms"
__eidItemDescriptions[FrozenItemId] = "Spawns a familiar that slows enemies#Gives 2 soulhearts"
__eidItemDescriptions[StarterPackId] = "Gives 10 coins, gold bomb, gold key, an HP up, a soulheart and +1 luck and +0.2 speed"
__eidItemDescriptions[TmpId] = "Dmg up but slooooooow down a bit (+10dmg and dmg*1.3)"
__eidItemDescriptions[EnoughId] = "Has a chance to damage all enemies in the room when taking a lot of damage"
__eidItemDescriptions[TransfusionId] = "More enemies, More stats !"
__eidItemDescriptions[InkId] = "+0.75 damage, +2 fire rate, range down#Has a chance to create creep with your tears"
__eidItemDescriptions[FlowerId] = "+ 4 soulhearts"
__eidItemDescriptions[MatchesId] = "Burns all enemies#Your tears and your familiars' burn enemies"
__eidItemDescriptions[GateId] = "Spawns a demon-boss ally for the room"
__eidItemDescriptions[SuperDamageId] = "Damage, Speed and Shot-Speed up#+Half a soul heart#Deal bonus damages against bosses (even more if champions)"
__eidItemDescriptions[RottenFleshId] = "At each new level, spawns 6 flies and 4 spiders#If you have less than 3 rotten hearts, give you one each new level#+1 luck"
__eidItemDescriptions[DartsId] = "+0.2 speed, -2 FireDelay#Move fast !"
__eidItemDescriptions[DivineGrailId] = "+2 Hearts#+5 damages, +0.2 speed, 0.5 shotspeed, +2 fire rate"
__eidItemDescriptions[flyverterId] = "Convert one soulheart into 3 flies#Has a chance to spawn an item related to flies#If you alreay have the item that spawns, gives 10 flies instead"
__eidItemDescriptions[CursedGrailId] = "Add a 1.5* damage multiplier, +1 damage, +2 fire rate and 0.25 shotspeed#When your tears hit an enemy or a wall, has a chance to create a red laser that will hit enemies"
__eidItemDescriptions[GiveTakeID] = "Stats down but each time you clear a room without taking damage, has a chance to give you a stat up#Chances of getting a bonus increase the deeper you are"
__eidItemDescriptions[LaserDroneID] = "Spawns a familiar that bounces and shoots lasers#Its damage, speed, and fire rate are based on the number of pickups in the room"
__eidItemDescriptions[Wind] = "Freezes and burns all enemies in the room#Adds half a soulheart"


--This function is called when the player's stats need to be changed
--The CacheFlag stats is changed as long as the player has the item
--Careful with cacheFlag/CacheFlag
function Additionals:onEvaluateItems(player,cacheFlag)
    local vel = Vector(0,0)
    local game = Game()
    local level= game:GetLevel()
    local player = Isaac.GetPlayer(0)
    local pos = Vector(player.Position.X,player.Position.Y)
    
    
--PROTEINS
    if player:HasCollectible(Proteins)then
      if cacheFlag==CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage +2;
      end
      if cacheFlag == CacheFlag.CACHE_SPEED then 
          player.MoveSpeed = player.MoveSpeed +0.2;
      end
      if not(AlreadyProteins) then
        --Make some effects
          Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.BLOOD_PARTICLE,0, player.Position,Vector(0,0),player)
          Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.BLOOD_PARTICLE,0, player.Position,Vector(0,0),player)
          player:SetActiveCharge(999)
          AlreadyProteins =true
      end
    end
--DEMON RING
    if(player:HasCollectible(DemonRingId))then
      if AlreadyDemon == false then
        player:AddBlackHearts(2)
        AlreadyDemon=true
      end
        level= Game():GetLevel()
        level:AddAngelRoomChance(1)
    end
    
--STARTER PACK
    if(player:HasCollectible(StarterPackId)) then
      if cacheFlag==CacheFlag.CACHE_LUCK then
        player.Luck = player.Luck +1;
        player.MoveSpeed = player.MoveSpeed +0.2;
      end
      if not AlreadyStart then
        Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COIN,CoinSubType.COIN_DIME,Game():GetLevel():GetCurrentRoom():FindFreePickupSpawnPosition(pos, 0, false, true), vel, player)
        Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_KEY,KeySubType.KEY_GOLDEN,Game():GetLevel():GetCurrentRoom():FindFreePickupSpawnPosition(pos, 0, false, true) , vel, player)
        Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_BOMB,BombSubType.BOMB_GOLDEN,Game():GetLevel():GetCurrentRoom():FindFreePickupSpawnPosition(pos, 0, false, true),vel,player)
        AlreadyStart = true
      end
    end

--Glass Cannon
    if(player:HasCollectible(TmpId)) then
     player.TearColor= Color(200,15,100,100,200,0,-1)
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
          player.Damage = player.Damage + 10;
          player.Damage = math.ceil(player.Damage*1.3)
        end
        if cacheFlag == CacheFlag.CACHE_SPEED then
          player.MoveSpeed = player.MoveSpeed-0.5
        end
        if cacheFlag == CacheFlag.CACHE_FIREDELAY then
          player.MaxFireDelay = player.MaxFireDelay+20;
        end
    end
    
--Super Damage
    if(player:HasCollectible(SuperDamageId)) then
      if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage +0.5
      end
      if cacheFlag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed +0.1
      end
      if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        player.ShotSpeed = player.ShotSpeed +0.25
      end
    end
    
--Rotten flesh
    if (player:HasCollectible(RottenFleshId)) then
       if cacheFlag == CacheFlag.CACHE_LUCK then
        player.Luck = player.Luck +1
      end
    end
    
--Darts
    if player:HasCollectible(DartsId) then
        if cacheFlag == CacheFlag.CACHE_SPEED then
          player.MoveSpeed = player.MoveSpeed+0.2
        end
        if cacheFlag == CacheFlag.CACHE_FIREDELAY then
          player.MaxFireDelay = player.MaxFireDelay-2
        end
    end

--Squid ink
    if player:HasCollectible(InkId) then
      if cacheFlag == CacheFlag.CACHE_DAMAGE then
          player.Damage = player.Damage+0.5
      end
      if cacheFlag == CacheFlag.CACHE_FIREDELAY then
          player.MaxFireDelay = player.MaxFireDelay-1.5
      end
      if cacheFlag == CacheFlag.CACHE_RANGE then
          --player.TearFallingSpeed = player.TearFallingSpeed-0.5
          rangeBoost = rangeBoost -5
          --player.TearHeight = player.TearHeight -5
          
          
      end
    end
    
--Divine Grail
    if player:HasCollectible(DivineGrailId) then
      if cacheFlag == CacheFlag.CACHE_FIREDELAY then
        player.MaxFireDelay = player.MaxFireDelay-2
      end
      if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage+5
      end
      if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        player.ShotSpeed = player.ShotSpeed+0.5
      end
      if cacheFlag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed+0.2
      end
    end

--Cursed grail
    if player:HasCollectible(CursedGrailId) then
      if cacheFlag == CacheFlag.CACHE_FIREDELAY then
        player.MaxFireDelay = player.MaxFireDelay -2
      end
      if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage *1.5
        player.Damage = player.Damage +0.5
      end
      if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        player.ShotSpeed = player.ShotSpeed+0.25
      end
    end

  --Transformation Grail
  --Cursed Grail/Doom's Grail
  if (player:HasCollectible(CursedGrailId) and player:HasCollectible(DivineGrailId)) and not AlreadyBothGrail then
      player:StopExtraAnimation() 
      SFXManager():Play(SoundEffect.SOUND_POWERUP_SPEWER, 0.9, 0, false, 1)
      local hud = Game():GetHUD()
      hud:ShowItemText("You are the power !!","", false)
      player:AddBlackHearts(4)
      AlreadyBothGrail= true
    
    
  end

--Transformation Ophiuscus
--The transformation's stat is updated here !!!! Update to think to check if the player has already the bonus instead of checking if he has the transformation
    if cacheFlag == CacheFlag.CACHE_SPEED then
      if (Zodiac_T and not Zodiac_TBS) then -- If we just transform and the stats has not been given
        --Player has Zodiac movement speed
        player.MoveSpeed = player.MoveSpeed + 0.35
        Zodiac_TBS = true
      end
    end
    if cacheFlag == CacheFlag.CACHE_FLYING then
      if Zodiac_T and not Zodiac_TBF then
        --Player has Zodiac Fly
        player:StopExtraAnimation() 
        --player:AddSoulHearts(4)
        SFXManager():Play(SoundEffect.SOUND_POWERUP_SPEWER, 0.9, 0, false, 1)
        local hud = Game():GetHUD()
        Isaac.ExecuteCommand("goto s.planetarium")
        hud:ShowItemText("Ophiuscus !","", false)
        --player:AddNullCostume(Additionals.COSTUME_TRANSFORMATION_OPHIUSCUS)
        Zodiac_TBF = true
        
      end
    end
    
  --Give And Take
  if player:HasCollectible(GiveTakeID) then
    if cacheFlag == CacheFlag.CACHE_FIREDELAY then
      player.MaxFireDelay = player.MaxFireDelay +0.75
      player.MaxFireDelay = player.MaxFireDelay - ( StatGT.AddFireDelay *0.25)
    end
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
      player.Damage = player.Damage -0.75
      player.Damage = player.Damage + ( StatGT.AddDamage *0.25)
    end
    if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
      player.ShotSpeed = player.ShotSpeed -0.3
      player.ShotSpeed = player.ShotSpeed + (StatGT.AddShotSpeed *0.1)
    end
    if cacheFlag == CacheFlag.CACHE_LUCK then
      player.Luck = player.Luck -0.75
      player.Luck = player.Luck + (StatGT.AddLuck *0.25)
    end
  end
end
Additionals:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Additionals.onEvaluateItems)

--This function is called each 0.5s and focus on the tearUpdate
function Additionals:tearUpdate(player)
    local room = Game():GetRoom()
    
    if room:GetAliveEnemiesCount() > 0 then
      OneRemain = true
    end

    if OneRemain and room:GetAliveEnemiesCount() == 0 and player:HasCollectible(GiveTakeID) then --When we clear a room
      if GTNoDMG then
        local limStage = Game():GetLevel():GetStage()+1 
        if limStage%2 == 1 then
          limStage = limStage -1
        end
        limStage = 7- (limStage/2)
        if math.random(1,limStage) == 1 then 
          Additionals:GiveBonus()
        end
      end
      OneRemain = false
      
      if WzBoss then
        Additionals:GiveBonus()
        Additionals:GiveBonus()
        WzBoss = false
      end
    end
    
    local vel = Vector(0,0)
    local player = Isaac.GetPlayer(0)
    local pos = Vector(player.Position.X,player.Position.Y)
    local ChanceB = 5
    local MaxLuck =11
    
    --SQUID INK
    --We check the item then the entities in the room, then if it's a tear and if it collide with something
    if(player:HasCollectible(InkId)) then
        for _, entity in pairs(Isaac.GetRoomEntities()) do
          if entity.Type == EntityType.ENTITY_TEAR then
            local TearData = entity:GetData()
            local Tear = entity:ToTear()
            Tear.FallingAcceleration = 0.02 + -0.02 * rangeBoost
            if(Tear.Height >=-5 or Tear:CollidesWithGrid()) and TearData.Ink == nil then
              local roll = math.random(0,100)
              if (roll <=((100-ChanceB) * player.Luck /MaxLuck + ChanceB)) then
                local roll2 = math.random(0,92)
                if(roll2 >=0 and roll2 <=19) then
              Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_WHITE,0, Tear.Position, vel,player):ToEffect() --20
                elseif(roll2 >=20 and roll2 <=39) then
              Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_BLACK,0, Tear.Position, vel,player):ToEffect() --20
                elseif(roll2 >=40 and roll2 <=59) then
              Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED,0, Tear.Position, vel,player):ToEffect() --20
                elseif(roll2 >=60 and roll2 <=79) then
              Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_GREEN,0, Tear.Position, vel,player):ToEffect() --20
                elseif(roll2 >=80 and roll2 <=83) then
              Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_LEMON_MISHAP,0, Tear.Position, vel,player):ToEffect()-- F 4
                elseif(roll2 >=84 and roll2 <=87) then
              Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_HOLYWATER,0, Tear.Position, vel,player):ToEffect()-- F 4
                elseif(roll2 >=88 and roll2 <=91) then
              Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_PUDDLE_MILK,0, Tear.Position, vel,player):ToEffect()--F 4
                elseif(roll2==92) then
              Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_LEMON_PARTY,0, Tear.Position, vel,player):ToEffect()--FF 1
                end
              end
            end
          end
        end
    end
    
    --MATCHES
    --FlameTear correspond to if the item is still on use (FrameA-FrameB)
    if(FlameTear and FlameTimeB-FlameTimeA<300)then
      for _, entity in pairs(Isaac.GetRoomEntities()) do
        if entity.Type == EntityType.ENTITY_TEAR then
          local Matches_Tear = entity:ToTear()
          Matches_Tear.TearFlags = TearFlags.TEAR_BURN
        end
      end
    end
    if((FlameTimeB-FlameTimeA)>300) then
      FlameTear=false
    end
    
    --Divine Grail
    if player:HasCollectible(DivineGrailId) and not(player:HasCollectible(CursedGrailId)) then
      for _, entity in pairs(Isaac.GetRoomEntities()) do
        if entity.Type == EntityType.ENTITY_TEAR and entity.SpawnerType == EntityType.ENTITY_PLAYER then
          local tear = entity:ToTear()
          if entity.Variant~=TearVariant.STARS then
            tear:ChangeVariant(TearVariant.STARS)
            tear:SetSize(tear.Size, Vector(1.2,1.2), 8)
            tear.SpriteScale = tear.SpriteScale * 1.2
          end
        end
      end
    end
    
    --Cursed Grail
    if player:HasCollectible(CursedGrailId) and not(player:HasCollectible(DivineGrailId)) then
      for _, entity in pairs(Isaac.GetRoomEntities()) do
        if entity.Type == EntityType.ENTITY_TEAR and entity.SpawnerType == EntityType.ENTITY_PLAYER then
          local tear = entity:ToTear()
          if entity.Variant~=TearVariant.DARK_STARS then
            tear:ChangeVariant(TearVariant.DARK_STARS)
            tear:SetSize(tear.Size, Vector(1.2,1.2), 8)
            tear.SpriteScale = tear.SpriteScale * 1.2
          end
        end
      end
      --player:FireTechLaser(pos, LaserOffset.LASER_MOMS_EYE_OFFSET, Vector(0,0),0,0)
      for _, entity in pairs(Isaac.GetRoomEntities()) do
        if entity.Type == EntityType.ENTITY_TEAR then
          local TearData = entity:GetData()
          local tear = entity:ToTear()
          if(tear.Height >=-5 or tear:CollidesWithGrid()) and TearData.Cursed_Grail == nil and entity.SpawnerType == EntityType.ENTITY_PLAYER then
            --if math.random(0,2) == 0 then
              local enemiesRad = Isaac.FindInRadius(tear.Position,120,EntityPartition.ENEMY)
              if #enemiesRad>0 then
                local enemy1pos = enemiesRad[1].Position
                --player:FireTechLaser(pos, LaserOffset.LASER_MOMS_EYE_OFFSET, enemy1pos-pos,0,0)
                local laser = EntityLaser.ShootAngle(2,tear.Position,(enemy1pos-tear.Position):GetAngleDegrees(),1,Vector(0,0),player)
                laser.CollisionDamage = player.Damage * 0.3 *0.5
              --end
            end
          end
        end
      end
    end
    --Doom Stars
    if player:HasCollectible(DivineGrailId) and player:HasCollectible(CursedGrailId) then
      for _, entity in pairs(Isaac.GetRoomEntities()) do
        if entity.Type == EntityType.ENTITY_TEAR and entity.SpawnerType == EntityType.ENTITY_PLAYER then
          local tear = entity:ToTear()
          if entity.Variant~=TearVariant.DOOM_STARS then
            tear:ChangeVariant(TearVariant.DOOM_STARS)
            tear:SetSize(tear.Size, Vector(1.2,1.2), 6)
            tear.SpriteScale = tear.SpriteScale * 1
          end
        end
      end
    end
    
end
Additionals:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE,Additionals.tearUpdate)

--Add a bonus with G&T
function Additionals:GiveBonus()
  local player = Isaac.GetPlayer(0)
    local GTAddPointRNG = math.random(0,3)
    if GTAddPointRNG == 0 then
      StatGT.AddDamage = StatGT.AddDamage+1
      player.Damage = player.Damage + 0.25
    elseif GTAddPointRNG == 1 then
      StatGT.AddFireDelay = StatGT.AddFireDelay+1
      player.MaxFireDelay = player.MaxFireDelay - 0.25
    elseif GTAddPointRNG == 2 then
      StatGT.AddLuck =StatGT.AddLuck+ 1
      player.Luck = player.Luck + 0.25
    else
      StatGT.AddShotSpeed = StatGT.AddShotSpeed+1
      player.ShotSpeed = player.ShotSpeed + 0.1
    end
    player:EvaluateItems()
    --Isaac.ConsoleOutput("\nBonus done\n")

end


--Reset some others Variables at the initialisation of the player (like the count of the items needed for the transformation)
--IN REPENTANCE IT ALSO TRIGGER ON CONTINUE
function Additionals:start()
  --[[local vel = Vector(0,0)
  local player = Isaac.GetPlayer(0)
  --Reset items that have an already
  Isaac.ConsoleOutput("Restart")
  timeA = 0
  timeB = 0
  AlreadyStart = false
  Zodiac_T=false
  Zodiac_C = 0
  Zodiac_TBF = false
  AlreadyGaveFrozen = false
  Zodiac_TBS = false
  CountMore = -1
  AlreadyProteins = false
  AlreadyDemon = false
  AlreadyGrail =false
  AlreadyCursedGrail =false
  if not DJrestart then
  CountMore=-1
  Zodiac_T=false
  Zodiac_C = 0
  HasAR=false
  HasT=false
  HasG=false
  HasCR=false
  HasCA=false
  HasLE=false
  HasV=false
  HasLI=false
  HasSC=false
  HasSA=false
  HasAQ=false
  HasP=false
  player.CanFly = false
  DJrestart = true
  end--]]
end
Additionals:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, Additionals.start)






--Make sure everything is allright to restart a new initalisation
function Additionals:onExit()
  DJrestart=false
end
Additionals:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT,Additionals.onExit)

--This part detect if the player take a damage
--If he has the item, add a chance to not take the damage (return false) and damage all enemies in room if the framecount between 2 damages was close
--ENOUGH !
function Additionals:Ennauf(entity, dmgAmount, dmgFlag, source, dmgCountDownFrames)
local vel = Vector(0,0)
local player = Isaac.GetPlayer(0)
local pos = Vector(player.Position.X,player.Position.Y)
local timerCount

  if(player:HasCollectible(EnoughId) and source ~=nil) then
    if timeA ==0 then
        timeA = player.FrameCount
        return true;
    elseif timeA ~=0 then
        timeB = player.FrameCount
    end
    --debugText=timeA ..  "," .. timeB .. "," ..timeB-timeA
    if ((timeB - timeA) <=75) then
      timerCount = true
    else
      timeA = 0
      return true
    end
    if(timerCount) then
      timeA=0
      timeB=0
      timerCount=false
      r = math.random(1,2)
      if r==1 then
        local entities = Isaac.GetRoomEntities()
        for i = 1, #entities do
          if(entities[i]:IsVulnerableEnemy()) then
              entities[ i ]:TakeDamage(30, 0,source,0)
          end
        end
        player:StopExtraAnimation() 
        player:AnimateCollectible(EnoughId, "UseItem", "PlayerPickup")
        player:AddSoulHearts(2)
      return false
      end
    end
  end
  
  if player:HasCollectible(GiveTakeID) and source ~=nil then
    GTNoDMG = false
  end
  
end
Additionals:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG,Additionals.Ennauf,EntityType.ENTITY_PLAYER)


function Additionals:OnDamage(entity, dmgAmount, dmgFlag, source, dmgCountDownFrames)
  if source.Type == EntityType.ENTITY_TEAR and source.Variant == TearVariant.DARK_STARS then
    --if math.random(0,2) == 0 then
      for _, entity in pairs(Isaac.GetRoomEntities()) do
          if entity.Type == EntityType.ENTITY_TEAR then
            local TearData = entity:GetData()
            local tear = entity:ToTear()
            if entity.SpawnerType == EntityType.ENTITY_PLAYER then
              local enemiesRad = Isaac.FindInRadius(tear.Position,120,EntityPartition.ENEMY)
              if #enemiesRad>1 then
                local enemy1pos = enemiesRad[2].Position
                --player:FireTechLaser(pos, LaserOffset.LASER_MOMS_EYE_OFFSET, enemy1pos-pos,0,0)
                local laser = EntityLaser.ShootAngle(2,tear.Position,(enemy1pos-tear.Position):GetAngleDegrees(),1,Vector(0,0),player)
                laser.CollisionDamage = player.Damage * 0.3
            --  end
            end
          end
      end
    end
  end

end
Additionals:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG,Additionals.OnDamage)--]]

--Ophiuscus Transformation
--Count the number of item for the transformation the player has
function Additionals:Transform()
  local vel = Vector(0,0)
  local player = Isaac.GetPlayer(0)
  local pos = Vector(player.Position.X,player.Position.Y)
  if player:HasCollectible(CollectibleType.COLLECTIBLE_ARIES) and not HasA then
    HasA = true
    Zodiac_C = Zodiac_C+1
  end
  if player:HasCollectible(CollectibleType.COLLECTIBLE_TAURUS) and not HasT then
    HasT = true
    Zodiac_C = Zodiac_C+1
  end
  if player:HasCollectible(CollectibleType.COLLECTIBLE_GEMINI) and not HasG then
    HasG = true
    Zodiac_C = Zodiac_C+1
  end
  if player:HasCollectible(CollectibleType.COLLECTIBLE_CANCER) and not HasCR then
    HasCR = true
    Zodiac_C = Zodiac_C+1
  end
  if player:HasCollectible(CollectibleType.COLLECTIBLE_LEO) and not HasLE then
    HasLE = true
    Zodiac_C = Zodiac_C+1
  end
  if player:HasCollectible(CollectibleType.COLLECTIBLE_VIRGO) and not HasV then
    HasV = true
    Zodiac_C = Zodiac_C+1
  end
  if player:HasCollectible(CollectibleType.COLLECTIBLE_LIBRA) and not HasLI then
    HasLI = true
    Zodiac_C = Zodiac_C+1
  end
  if player:HasCollectible(CollectibleType.COLLECTIBLE_SCORPIO) and not HasSC then
    HasSC = true
    Zodiac_C = Zodiac_C+1
  end
  if player:HasCollectible(CollectibleType.COLLECTIBLE_SAGITTARIUS) and not HasSA then
    HasSA = true
    Zodiac_C = Zodiac_C+1
  end
  if player:HasCollectible(CollectibleType.COLLECTIBLE_CAPRICORN) and not HasCA then
    HasCA = true
    Zodiac_C = Zodiac_C+1
  end
  if player:HasCollectible(CollectibleType.COLLECTIBLE_AQUARIUS) and not HasAQ then
    HasAQ = true
    Zodiac_C = Zodiac_C+1
  end
  if player:HasCollectible(CollectibleType.COLLECTIBLE_PISCES) and not HasP then
    HasP = true
    Zodiac_C = Zodiac_C+1
  end
  --If he had enough add transformation, hearts, and revaluate to give stats
  if Zodiac_C >= 3 and not Zodiac_T then --Not transformed yet
    player:AddCacheFlags(CacheFlag.CACHE_SPEED)
    player:AddCacheFlags(CacheFlag.CACHE_FLYING)
    Zodiac_T = true
    Zodiac_TBS = false
    Zodiac_TBF = false
    player:EvaluateItems()
  end
end
Additionals:AddCallback(ModCallbacks.MC_POST_UPDATE, Additionals.Transform)


--This part if for the active items
--FREEZY WIND
function Additionals:use_Wind()  
  local vel = Vector(0,0)
  local player = Isaac.GetPlayer(0)
  local pos = Vector(player.Position.X,player.Position.Y)
  local entities = Isaac.GetRoomEntities()
  local color = Color(0,1,1,1,0,0,0)
  color:SetColorize(131, 251, 255, 1)
  player:AnimateCollectible(Wind, "UseItem", "PlayerPickup")
  player:AddSoulHearts(1)
    for i = 1, #entities do
      if(entities[ i ]:IsVulnerableEnemy()) then
         entities[ i ]:SetColor(color,130,0,0,0)
         entities[ i ]:AddFreeze(EntityRef(player),900)
         entities[ i ]:AddBurn(EntityRef(player),60,player.Damage)
    end
  end
end
Additionals:AddCallback(ModCallbacks.MC_USE_ITEM,Additionals.use_Wind, Wind)


--MATCHES
function Additionals:use_Matches()  
  local vel = Vector(0,0)
  local player = Isaac.GetPlayer(0)
  local pos = Vector(player.Position.X,player.Position.Y)
  FlameTear=true
  FlameTimeA=player.FrameCount
  player:AnimateCollectible(MatchesId, "UseItem", "PlayerPickup")
    for _, entity in pairs(Isaac.GetRoomEntities()) do
      Matches_TearData = entity:GetData()
      Matches_Tear = entity:ToTear()
      if(entity:IsVulnerableEnemy()) then
        entity:AddBurn(EntityRef(player),60,player.Damage)
      end
    end
end
Additionals:AddCallback(ModCallbacks.MC_USE_ITEM,Additionals.use_Matches, MatchesId)	

--HELLS GATE
function Additionals:use_Gate()  
  local vel = Vector(0,0)
  local player = Isaac.GetPlayer(0)
  local pos = Vector(player.Position.X,player.Position.Y)
  player:AnimateCollectible(GateId, "UseItem", "PlayerPickup")
  local rngHell = math.random(1,99)
  if rngHell >=1 and rngHell <=19 then
    GateEntity= Isaac.Spawn(81, 1, 0, pos, vel,player)
    GateEntity:ToNPC().Scale = 0.8
  elseif rngHell>=20 and rngHell<39 then
    GateEntity= Isaac.Spawn(EntityType.ENTITY_LITTLE_HORN, 0, 0, pos, vel,player)
    GateEntity:ToNPC().Scale = 0.8
  elseif rngHell>=40 and rngHell<=54 then
    GateEntity= Isaac.Spawn(EntityType.ENTITY_BIG_HORN, 0, 0, pos, vel,player)
    GateEntity:ToNPC().Scale = 0.6
  elseif rngHell>=55 and rngHell<=69 then
    GateEntity= Isaac.Spawn(EntityType.ENTITY_DARK_ONE, 0, 0, pos, vel,player)
    GateEntity:ToNPC().Scale = 0.8
  elseif rngHell>=70 and rngHell<=84 then
    GateEntity= Isaac.Spawn(81, 0, 0, pos, vel,player)
    GateEntity:ToNPC().Scale = 0.8
  elseif rngHell>=85 and rngHell<=94 then
    GateEntity= Isaac.Spawn(268, 0, 0, pos, vel,player)
    GateEntity:ToNPC().Scale = 0.8
  else
    GateEntity= Isaac.Spawn(84, 10, 0, pos, vel,player)
    GateEntity:ToNPC().Scale = 1.2
  end
  GateEntity:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
  GateEntity:AddEntityFlags(EntityFlag.FLAG_CHARM)
end
Additionals:AddCallback(ModCallbacks.MC_USE_ITEM,Additionals.use_Gate, GateId)

--Transfusion activation and reset
function Additionals:use_Trans()
  local player = Isaac.GetPlayer(0)
  --When the player re-use the item, make sur to remove the previous stats to prevent abuse/bug
  player.Damage  = player.Damage - (max)
  max = 0
  local vel = Vector(0,0)
  local pos = Vector(player.Position.X,player.Position.Y)
  local entities = Isaac.GetRoomEntities()
  player:AnimateCollectible(TransfusionId, "UseItem", "PlayerPickup")
  for i = 1, #entities do
    if(entities[ i ]:IsVulnerableEnemy()) then
    max = max + 1
    end
  end
  --Count and add dmg as max
  player.Damage  = player.Damage + (max)
end
--When need to reset the Dmg while entering in new room and reset max
--I also reset the timer for Matches since it's the same CallBack
function Additionals:newRoom()
  local vel = Vector(0,0)
  local player = Isaac.GetPlayer(0)
  local pos = Vector(player.Position.X,player.Position.Y)
  --Isaac.ConsoleOutput(Game():GetStagesWithoutDamage())
  OneRemain = false
  GTNoDMG = true
  player.Damage = player.Damage-(max)
  max = 0
  --Matches reset
  FlameTimeA=0
  FlameTimeB=0
  FlameTear=false
  
  if player:HasCollectible(GiveTakeID) then
    local TabEnemies = Isaac.GetRoomEntities()
    for _, entity in pairs(TabEnemies) do
      if entity:IsVulnerableEnemy() and entity:ToNPC():IsBoss() then
        WzBoss = true
      end
    end
  end
end
Additionals:AddCallback(ModCallbacks.MC_USE_ITEM,Additionals.use_Trans, TransfusionId)
Additionals:AddCallback(ModCallbacks.MC_POST_NEW_ROOM,Additionals.newRoom)

--Fly-Verter
function Additionals:use_flyverter()  
  local vel = Vector(0,0)
  local player = Isaac.GetPlayer(0)
  local pos = Vector(player.Position.X,player.Position.Y)
  if player:GetSoulHearts()>1 then
    player:AnimateCollectible(flyverterId, "UseItem", "PlayerPickup")
    if player:GetSoulHearts() == 2 and player:GetHearts() == 0 then
      player:AddSoulHearts(-2)
      player:Die()
    end
    player:AddSoulHearts(-2)
    local rngFlyverter = math.random(0,6)
    if rngFlyverter == 0 then
        local rngFly0 = math.random(0,10)
        if rngFly0 == 1 then
          if not(player:HasCollectible(CollectibleType.COLLECTIBLE_INFESTATION)) then
            Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE,CollectibleType.COLLECTIBLE_INFESTATION, Vector(player.Position.X,player.Position.Y + 10),vel,player)
          else
            player:AddBlueFlies(10,pos,player)
          end
        elseif rngFly0 == 2 then
          if not(player:HasCollectible(CollectibleType.COLLECTIBLE_SKATOLE)) then
            Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE,CollectibleType.COLLECTIBLE_SKATOLE, Vector(player.Position.X,player.Position.Y + 10),vel,player)
          else
            player:AddBlueFlies(10,pos,player)
          end
        elseif rngFly0 == 3 then
          if not(player:HasCollectible(CollectibleType.COLLECTIBLE_HIVE_MIND)) then
            Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE,CollectibleType.COLLECTIBLE_HIVE_MIND, Vector(player.Position.X,player.Position.Y + 10),vel,player)
          else
            player:AddBlueFlies(10,pos,player)
          end
        elseif rngFly0 == 4 then
          if not(player:HasCollectible(CollectibleType.COLLECTIBLE_PARASITOID)) then
            Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE,CollectibleType.COLLECTIBLE_PARASITOID, Vector(player.Position.X,player.Position.Y + 10),vel,player)
          else
            player:AddBlueFlies(10,pos,player)
          end
        elseif rngFly0 == 5 then
          if not(player:HasCollectible(CollectibleType.COLLECTIBLE_MULLIGAN)) then
            Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE,CollectibleType.COLLECTIBLE_MULLIGAN, Vector(player.Position.X,player.Position.Y + 10),vel,player)
          else
            player:AddBlueFlies(10,pos,player)
          end
        elseif rngFly0 == 6 then
          if not(player:HasCollectible(CollectibleType.COLLECTIBLE_OBSESSED_FAN)) then
            Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE,CollectibleType.COLLECTIBLE_OBSESSED_FAN, Vector(player.Position.X,player.Position.Y + 10),vel,player)
          else
            player:AddBlueFlies(10,pos,player)
          end
        elseif rngFly0 == 7 then
          if not(player:HasCollectible(CollectibleType.COLLECTIBLE_JUICY_SACK)) then
            Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE,CollectibleType.COLLECTIBLE_JUICY_SACK, Vector(player.Position.X,player.Position.Y + 10),vel,player)
          else
            player:AddBlueFlies(10,pos,player)
          end
        elseif rngFly0 == 8 then
          if not(player:HasCollectible(CollectibleType.COLLECTIBLE_SISSY_LONGLEGS)) then
            Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE,CollectibleType.COLLECTIBLE_SISSY_LONGLEGS, Vector(player.Position.X,player.Position.Y + 10),vel,player)
          else
            player:AddBlueFlies(10,pos,player)
          end
        elseif rngFly0 == 9 then
          if not(player:HasCollectible(CollectibleType.COLLECTIBLE_ROTTEN_BABY)) then
            Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE,CollectibleType.COLLECTIBLE_ROTTEN_BABY, Vector(player.Position.X,player.Position.Y + 10),vel,player)
          else
            player:AddBlueFlies(10,pos,player)
          end
        elseif rngFly0 == 10 then
          if not(player:HasCollectible(CollectibleType.COLLECTIBLE_DISTANT_ADMIRATION)) then
            Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE,CollectibleType.COLLECTIBLE_DISTANT_ADMIRATION, Vector(player.Position.X,player.Position.Y + 10),vel,player)
          else
            player:AddBlueFlies(10,pos,player)
          end
        else
          if not(player:HasCollectible(CollectibleType.COLLECTIBLE_BIG_FAN)) then
            Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE,CollectibleType.COLLECTIBLE_BIG_FAN, Vector(player.Position.X,player.Position.Y + 10),vel,player)
          else
            player:AddBlueFlies(10,pos,player)
          end
        end
    else
      player:AddBlueFlies(3,pos, player)
    end
  else  
    Afterflyver = true
  end
  

end
Additionals:AddCallback(ModCallbacks.MC_USE_ITEM,Additionals.use_flyverter, flyverterId)


Additionals:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, Amount, Flag, Source, Countdown)
	local player = Isaac.GetPlayer(0);
  
  if player:HasCollectible(DartsId) then
    if entity:IsVulnerableEnemy() and Flag ~= DamageFlag.DAMAGE_CLONES and Source.Type < 9 then
        --entity:TakeDamage(0.25*0.25*Amount*(player.MoveSpeed), DamageFlag.DAMAGE_CLONES, EntityRef(player),0);
        entity:TakeDamage(Amount*math.max(math.abs(player.Velocity.X),math.abs(player.Velocity.Y))*0.25*0.25, DamageFlag.DAMAGE_CLONES, EntityRef(player),0);
    end
  end
  
	if player:HasCollectible(SuperDamageId) then
		if entity:IsVulnerableEnemy() and Flag ~= DamageFlag.DAMAGE_CLONES and Source.Type < 9 then
			if (entity:ToNPC():IsBoss() and entity.SubType > 0) then
				entity:TakeDamage(0.66*Amount*2, DamageFlag.DAMAGE_CLONES, EntityRef(player), 0);
			elseif(entity:ToNPC():IsBoss()) then
        entity:TakeDamage(0.66*Amount, DamageFlag.DAMAGE_CLONES, EntityRef(player), 0);
      end
		end
	end
end);

function Additionals.Rotten_Spawn()
  local player = Isaac.GetPlayer(0)
  local vel = Vector(0,0)
  local pos = Vector(player.Position.X,player.Position.Y)
  if player:HasCollectible(RottenFleshId) then
    player:AddBlueFlies(5,pos,player)
    player:AddBlueSpider(pos)
    player:AddBlueSpider(pos)
    player:AddBlueSpider(pos)
    player:AddBlueSpider(pos)
    if player:CanPickRottenHearts() and player:GetRottenHearts()<3 then
      player:AddRottenHearts(2)
    end
  end
end

Additionals:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL,Additionals.Rotten_Spawn)
---Familiars part---
--FAMILIARS
--Caracteristics of the familiar on update
local function onFamiliarUpdate(_,fam)
  local player = Isaac.GetPlayer(0)
  local vel = Vector(0,0)
  local pos = Vector(player.Position.X,player.Position.Y)
  --fam:FollowPosition(player.Position)
  fam:FollowParent()
  if (fam.FrameCount%5 ==0) then
    local r = math.random(0,100)
     if (r>30)then
      Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_WHITE, 0, fam.Position, Vector(0,0), e):ToEffect()
    end
    
  end
end

--Initialization of the familiar if needed
local function onInit(_,fam)
  local player = Isaac.GetPlayer(0)
  fam.IsFollower=true
end
--Spawn of the familiar if we have the item and add a name if we need to change something (in local)
local function onEvaluateCache(_,_,cacheFlag)
  local player = Isaac.GetPlayer(0)
  if (not(player:HasCollectible(FrozenItemId))) and AlreadyGaveFrozen then
    e:Remove()
    AlreadyGaveFrozen = false
  end
  if cacheFlag == CacheFlag.CACHE_FAMILIARS and player:HasCollectible(FrozenItemId) then
    if(not AlreadyGaveFrozen) then
      e = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, variant, 0, player.Position, Vector(0,0), player)
      AlreadyGaveFrozen = true
    end
  end
  
  if (not(player:HasCollectible(LaserDroneID))) and AlreadyGaveLaserDrone then
    b:Remove()
    AlreadyGaveLaserDrone = false
  end
  if cacheFlag == CacheFlag.CACHE_FAMILIARS and player:HasCollectible(LaserDroneID) then
    if(not AlreadyGaveLaserDrone) then
      b = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, variant1, 0, player.Position, Vector(0,0), player)
      AlreadyGaveLaserDrone = true
    end
  end
  
end

Additionals:AddCallback(ModCallbacks.MC_EVALUATE_CACHE,onEvaluateCache)
Additionals:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, onInit, variant)
Additionals:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE,onFamiliarUpdate, variant)

--Caracteristics of the familiar on update
local function onFamiliarUpdate2(_,fam)
  local player = Isaac.GetPlayer(0)
  local vel = Vector(0,0)
  local pos = Vector(player.Position.X,player.Position.Y)
  --fam:FollowPosition(player.Position)
  
  local pick = Isaac.FindByType(5,-1,-1)
  if(#pick ~= 0) then
    if((((#pick)*0.5*0.25+0.4))<=9) then
    fam:MoveDiagonally ((#pick)*0.5*0.25+0.4)
    else
    fam:MoveDiagonally (9)
    end
  else
    fam:MoveDiagonally (0.5)
  end
  
  fam.CollisionDamage= 10
  
  local lim = 170-(#pick*4)
  if lim<=20 then
    lim = 20
  end
  
  
  if(Game():GetFrameCount()%lim >= 0 and Game():GetFrameCount()%lim <= 10) then
    local duration = 1
    local typelas = 10
    local damageL = 1.5
    
    if(damageL*0.2*#pick >damageL) then
      damageL = damageL*0.2*#pick
    end
    if damageL >20 then
      damageL = 20
    end
    
    --[[local laser1 = EntityLaser.ShootAngle(2,fam.Position,0,duration,Vector(0,0),player)
    local laser2 = EntityLaser.ShootAngle(2,fam.Position,90,duration,Vector(0,0),player)
    local laser3 = EntityLaser.ShootAngle(2,fam.Position,180,duration,Vector(0,0),player)
    local laser4 = EntityLaser.ShootAngle(2,fam.Position,270,duration,Vector(0,0),player)--]]
    local laser5 = EntityLaser.ShootAngle(typelas,fam.Position,45,duration,Vector(0,0),player)
    laser5.CollisionDamage = damageL
    local laser6 = EntityLaser.ShootAngle(typelas,fam.Position,135,duration,Vector(0,0),player)
    laser6.CollisionDamage = damageL
    local laser7 = EntityLaser.ShootAngle(typelas,fam.Position,225,duration,Vector(0,0),player)
    laser7.CollisionDamage = damageL
    local laser8 = EntityLaser.ShootAngle(typelas,fam.Position,315,duration,Vector(0,0),player)
    laser8.CollisionDamage = damageL
  end
end

Additionals:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE,onFamiliarUpdate2, variant1)