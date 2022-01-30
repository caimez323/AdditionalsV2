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
local game = Game()
local hud = Game():GetHUD()
--Set the costumes
Additionals.COSTUME_DEMON_RING= Isaac.GetCostumeIdByPath("gfx/characters/demon_ring.anm2")
Additionals.COSTUME_WHITE_FLOWER= Isaac.GetCostumeIdByPath("gfx/characters/white_flower.anm2")
Additionals.COSTUME_TRANSFORMATION_OPHIUSCUS = Isaac.GetCostumeIdByPath("gfx/characters/transformation_ophiuscus.anm2")

--Reset some variables now
local Zodiac = {
  Count = 0,
  Transformed = false,
  ToBeStat = false,
  }

local chanceToReplace = 50

local AlreadyBothGrail = false
local removeNextTears = false


TearVariant.STARS = Isaac.GetEntityVariantByName("Stars")
TearVariant.DARK_STARS = Isaac.GetEntityVariantByName("Dark_Stars")
TearVariant.DOOM_STARS = Isaac.GetEntityVariantByName("Doom_Stars")

--Match each Item an Id
local FrozenItemId = Isaac.GetItemIdByName("Frozen Body")
local frozenFam = Isaac.GetEntityVariantByName("frozenbody")
local laserFam = Isaac.GetEntityVariantByName("LaserDrone")
local LaserDroneID = Isaac.GetItemIdByName("Laser Drone")



local Proteins = Isaac.GetItemIdByName("Proteins")
local Wind = Isaac.GetItemIdByName("Freezy Wind")
local TransfusionId = Isaac.GetItemIdByName("Transfusion")
local DemonRingId = Isaac.GetItemIdByName("Demon Ring")
local StarterPackId = Isaac.GetItemIdByName("Starter pack")
local TmpId = Isaac.GetItemIdByName("Not-Glass Cannon")
local RevengeId = Isaac.GetItemIdByName("Revenge")
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
local SoulStealerID = Isaac.GetItemIdByName("Soul Stealer") -- soul stealer item



local BiKeeperId= Isaac.GetCardIdByName("BiKeeper")
local SecretId = Isaac.GetCardIdByName("Secret Passage")


DIRECTION_FLOAT_ANIM = {
	[Direction.NO_DIRECTION] = "FloatDown", 
	[Direction.LEFT] = "FloatLeft",
	[Direction.UP] = "FloatUp",
	[Direction.RIGHT] = "FloatRight",
	[Direction.DOWN] = "FloatDown"
}

DIRECTION_SHOOT_ANIM = {
	[Direction.NO_DIRECTION] = "FloatShootDown",
	[Direction.LEFT] = "FloatShootRight",
	[Direction.UP] = "FloatShootUp",
	[Direction.RIGHT] = "FloatShootLeft",
	[Direction.DOWN] = "FloatShootDown"
}


local StatGT = {
      AddDamage = 0;
      AddFireDelay = 0;
      AddShotSpeed = 0;
      AddLuck = 0
  }


--To spawn the customs cards, we look for a spawned card then add a chance to replace it
function Additionals:getCard(rng,current,playing,runes,onlyrunes)
  local randomcardid1 = rng:RandomInt(chanceToReplace)
  if randomcardid1 == 1 and not onlyrunes and current ~= Card.CARD_CHAOS then 
    return BiKeeperId
  end
  local randomcardid2 = rng:RandomInt(chanceToReplace);
  if randomcardid2 == 1 and not onlyrunes and current ~= Card.CARD_CHAOS then 
    return SecretId
  end
end
Additionals:AddCallback(ModCallbacks.MC_GET_CARD, Additionals.getCard);

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



--COSTUMES AND RESET VARIABLES
--This function is called each 0.5s
function Additionals:onUpdate(player)
  
  if game:GetFrameCount() == 1 then -- First frame of a run, don't trigger on continue
    Isaac.ConsoleOutput("F1")
    
    HasWhiteFlower = false -- Apply Costumes
    HasDemon = false
    
    max = 0 --Transfusion
    
    timeRevengeA =0 -- Revenge
    timeRevengeB=0
    
    TryFlyVerter = false --FlyVerter
    
    AtLeastOne = false -- Give and Take
    GTNoDMG = true
    BossRoom = false
    
    rangeBoost=0 --Change range with Squid ink
    
    timeRevengeA = 0 --Revenge
    timeRevengeB = 0
    
    FlameTear = false
    FlameTimeA=0
    FlameTimeB=0
    
    
    
    
    AlreadyStart = false
    AlreadyBothGrail = false
    AlreadyProteins = false
    
    Zodiac.Transformed=false -- Zodiac
    Zodiac.Count = 0
    
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
  end
  -- get frame count for Matches
  FlameTimeB=player.FrameCount 
  --Applied costume if player haven't it yet and has the item
  if not HasWhiteFlower and player:HasCollectible(FlowerId) then
    player:AddNullCostume(Additionals.COSTUME_WHITE_FLOWER)
    HasWhiteFlower= true
  end
  
  --A fix for adding wisp when use The fly-verter without soul hearts
  
  if player:HasCollectible(584) and player:HasCollectible(flyverterId) and TryFlyVerter then
      local entwisp = Isaac.FindByType(3,206,-1)
      if #entwisp>0 then
        entwisp[1]:Remove()
      end
      TryFlyVerter = false
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
__eidItemDescriptions[RevengeId] = "Has a chance to damage all enemies in the room when taking a lot of damage"
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
__eidItemDescriptions[SoulStealerID] = "Shoot a fire that deal damage to enemies.#If it kills the enemy, add a permanent familiar"


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
      if not HasDemon then
        player:AddBlackHearts(2)
        player:AddNullCostume(Additionals.COSTUME_DEMON_RING)
        HasDemon=true
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
          rangeBoost = rangeBoost -5
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
      if (Zodiac.Transformed and not Zodiac.ToBeStat) then -- If we just transform and the stats has not been given
        --Player has Zodiac movement speed
        player.MoveSpeed = player.MoveSpeed + 0.35
        Zodiac.ToBeStat = true
      end
    end
    if cacheFlag == CacheFlag.CACHE_FLYING then
      
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
  
  --Familiars Cache
  
  if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		local boxUses = player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS)
		local FrozenItem = player:GetCollectibleNum(FrozenItemId)
    local LaserItem = player:GetCollectibleNum(LaserDroneID)
		local numFrozens = (FrozenItem > 0 and (FrozenItem + boxUses) or 0)
		local numLaser = (LaserItem > 0 and (LaserItem + boxUses) or 0)
		player:CheckFamiliar(frozenFam, numFrozens, player:GetCollectibleRNG(FrozenItem), Isaac.GetItemConfig():GetCollectible(FrozenItem))
		player:CheckFamiliar(laserFam, numLaser, player:GetCollectibleRNG(LaserItem), Isaac.GetItemConfig():GetCollectible(LaserItem))
  end
  
end
Additionals:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Additionals.onEvaluateItems)

--This function is called each 0.5s and focus on the tearUpdate
function Additionals:tearUpdate(player)
    local room = Game():GetRoom()
    
    if AtLeastOne and GTNoDMG and room:GetAliveEnemiesCount() == 0 and player:HasCollectible(GiveTakeID) then --When we clear a room
        --Chance to give bonus
        local limStage = game:GetLevel():GetStage()+1 
        if limStage%2 == 1 then
          limStage = limStage -1
        end
        limStage = 7- (limStage/2)
        if math.random(1,limStage) == 1 then 
          Additionals:GiveBonus()
        end
      AtLeastOne = false
      
      if BossRoom then
        Additionals:GiveBonus()
        Additionals:GiveBonus()
        BossRoom = false
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

--Make sure everything is allright to restart a new initalisation
function Additionals:onExit()
  DJrestart=false
end
Additionals:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT,Additionals.onExit)

--This part detect if the player take a damage
--If he has the item, add a chance to not take the damage (return false) and damage all enemies in room if the framecount between 2 damages was close

function Additionals:onDamageRevenge(target, dmgAmount, dmgFlag, source, dmgCountDownFrames)
local player = Isaac.GetPlayer(0)
local pos = Vector(player.Position.X,player.Position.Y)

  if(player:HasCollectible(RevengeId) and source ~=nil) then
    if timeRevengeA ==0 then
        timeRevengeA = player.FrameCount
        return true
    elseif timeRevengeA ~=0 then
        timeRevengeB = player.FrameCount
    end

    if ((timeRevengeB - timeRevengeA) <=75) then
        timeRevengeA=0
        if math.random(1,2) ==1 then
          local entities = Isaac.GetRoomEntities()
          for i = 1, #entities do
            if(entities[i]:IsVulnerableEnemy()) then
              entities[ i ]:TakeDamage(30, 0,player,0)
            end
          end
          player:StopExtraAnimation() 
          player:AnimateCollectible(RevengeId, "UseItem", "PlayerPickup")
          player:AddSoulHearts(2)
          return false
        end
        return true
    end
  end
  
  if player:HasCollectible(GiveTakeID) and source ~=nil then -- G&T The player took a damage
    GTNoDMG = false
  end
  
end
Additionals:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG,Additionals.onDamageRevenge,EntityType.ENTITY_PLAYER)


function Additionals:OnDamage(entity, dmgAmount, dmgFlag, source, dmgCountDownFrames)
  if source.Type == EntityType.ENTITY_TEAR and source.Variant == TearVariant.DARK_STARS then
      for _, entity in pairs(Isaac.GetRoomEntities()) do
          if entity.Type == EntityType.ENTITY_TEAR then
            local TearData = entity:GetData()
            local tear = entity:ToTear()
            if entity.SpawnerType == EntityType.ENTITY_PLAYER then
              local enemiesRad = Isaac.FindInRadius(tear.Position,120,EntityPartition.ENEMY)
              if #enemiesRad>1 then
                local enemy1pos = enemiesRad[2].Position
                local laser = EntityLaser.ShootAngle(2,tear.Position,(enemy1pos-tear.Position):GetAngleDegrees(),1,Vector(0,0),player)
                laser.CollisionDamage = player.Damage * 0.3
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
    Zodiac.Count = Zodiac.Count+1
  end
  if player:HasCollectible(CollectibleType.COLLECTIBLE_TAURUS) and not HasT then
    HasT = true
    Zodiac.Count = Zodiac.Count+1
  end
  if player:HasCollectible(CollectibleType.COLLECTIBLE_GEMINI) and not HasG then
    HasG = true
    Zodiac.Count = Zodiac.Count+1
  end
  if player:HasCollectible(CollectibleType.COLLECTIBLE_CANCER) and not HasCR then
    HasCR = true
    Zodiac.Count = Zodiac.Count+1
  end
  if player:HasCollectible(CollectibleType.COLLECTIBLE_LEO) and not HasLE then
    HasLE = true
    Zodiac.Count = Zodiac.Count+1
  end
  if player:HasCollectible(CollectibleType.COLLECTIBLE_VIRGO) and not HasV then
    HasV = true
    Zodiac.Count = Zodiac.Count+1
  end
  if player:HasCollectible(CollectibleType.COLLECTIBLE_LIBRA) and not HasLI then
    HasLI = true
    Zodiac.Count = Zodiac.Count+1
  end
  if player:HasCollectible(CollectibleType.COLLECTIBLE_SCORPIO) and not HasSC then
    HasSC = true
    Zodiac.Count = Zodiac.Count+1
  end
  if player:HasCollectible(CollectibleType.COLLECTIBLE_SAGITTARIUS) and not HasSA then
    HasSA = true
    Zodiac.Count = Zodiac.Count+1
  end
  if player:HasCollectible(CollectibleType.COLLECTIBLE_CAPRICORN) and not HasCA then
    HasCA = true
    Zodiac.Count = Zodiac.Count+1
  end
  if player:HasCollectible(CollectibleType.COLLECTIBLE_AQUARIUS) and not HasAQ then
    HasAQ = true
    Zodiac.Count = Zodiac.Count+1
  end
  if player:HasCollectible(CollectibleType.COLLECTIBLE_PISCES) and not HasP then
    HasP = true
    Zodiac.Count = Zodiac.Count+1
  end
  --If he had enough add transformation, hearts, and revaluate to give stats
  if Zodiac.Count >= 3 and not Zodiac.Transformed then --Not transformed yet
    
    Zodiac.Transformed = true
    Zodiac.ToBeStat = false
    
    player:StopExtraAnimation() 
    SFXManager():Play(SoundEffect.SOUND_POWERUP_SPEWER, 0.9, 0, false, 1)
    Isaac.ExecuteCommand("goto s.planetarium")
    hud:ShowItemText("Ophiuscus !","", false)
    
    player:AddNullCostume(Additionals.COSTUME_TRANSFORMATION_OPHIUSCUS)
    player:AddCacheFlags(CacheFlag.CACHE_SPEED)
    
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

Additionals:AddCallback(ModCallbacks.MC_USE_ITEM,Additionals.use_Trans, TransfusionId)
--Reset on new Room
function Additionals:newRoom()
  local vel = Vector(0,0)
  local player = Isaac.GetPlayer(0)
  local pos = Vector(player.Position.X,player.Position.Y)
  
  local room = game:GetRoom() -- G&T
  AtLeastOne = room:GetAliveEnemiesCount ()>0  -- G&T
  GTNoDMG = true
  
  player.Damage = player.Damage-(max) -- Transfusion
  max = 0 -- Transfusion
  --Matches reset
  FlameTimeA=0
  FlameTimeB=0
  FlameTear=false
  
  if player:HasCollectible(GiveTakeID) then
    local TabEnemies = Isaac.GetRoomEntities()
    for _, entity in pairs(TabEnemies) do
      if entity:IsVulnerableEnemy() and entity:ToNPC():IsBoss() then
        BossRoom = true
      end
    end
  end
end

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
    TryFlyVerter = true --fake activation
  end
  

end
Additionals:AddCallback(ModCallbacks.MC_USE_ITEM,Additionals.use_flyverter, flyverterId)


local PhantomFamiliar = Isaac.GetEntityVariantByName("Phantom") -- phantom entity
local SoulStealerEntity = Isaac.GetEntityVariantByName("Soul Stealer") -- Soul Stealer entity
local deleteNextTear = false
local S_Stealer = {
 Active = false,
 Direction = Direction.NO_DIRECTION,
 DirectionStart = 1,
 EntityVariant = SoulStealerEntity,
 Flame = nil,
 Entity = nil,
 Phantom = {
   Damage = 1.5,
   DamageCap = 10,
   FireRate = 50,
   FireRateCap = 10,
   }
}

local PickupTail = {
  [Direction.NO_DIRECTION] = "WalkDown",
  [Direction.LEFT] = "WalkLeft",
  [Direction.UP] = "WalkUp",
  [Direction.RIGHT] = "WalkRight",
  [Direction.DOWN] = "WalkDown",
  
  }

function Additionals:soul_stealer_update(player)
  
  if deleteNextTear then
   --Delete next tear
      local entities = Isaac.FindInRadius(player.Position,10)
      local deletedTear = false
      for i =1, #entities do
        if entities[i].Type == EntityType.ENTITY_TEAR and not deletedTear then
          entities[i]:Remove()
          deletedTear = true
          deleteNextTear = false
        end
      end
  end
  
  if S_Stealer.Active then --If the item is active
    if player:GetShootingJoystick():Length() > 0.1 then --If the fire key is pressed, fire
      S_Stealer.Active = false
      S_Stealer.Entity:Remove()
      player:StopExtraAnimation()
      S_Stealer.Flame = Isaac.Spawn(EntityType.ENTITY_EFFECT, 10,0, player.Position, player:GetShootingJoystick():Normalized()*14 + player.Velocity, player):ToEffect()
      
        local color = Color(1,1,1,1,0,0,0)
        color:SetColorize(0.82,0.82,0.82,1)
        local sprite = S_Stealer.Flame:GetSprite()
        sprite.Color = color
        
      S_Stealer.Entity = nil
      
      S_Stealer.Flame:SetTimeout(60)
      deleteNextTear = true
     
    else -- Walking
      local CurrentDirection= player:GetMovementDirection()
      local CurrentFrame = game:GetFrameCount()
      if S_Stealer.Direction ~= CurrentDirection --Move
      or CurrentFrame > S_Stealer.DirectionStart + 20 --Time pass
      or CurrentDirection == Direction.NO_DIRECTION --Change direction
      then -- We need to refresh the animation
        player:PlayExtraAnimation("Pickup" .. PickupTail[CurrentDirection])
        S_Stealer.DirectionStart = CurrentFrame
        S_Stealer.Direction = CurrentDirection
      end
      S_Stealer.Entity.Position = player.Position + Vector(0,1)
    end
  end
  
  if S_Stealer.Flame ~= nil then --The flame isn't here
    if S_Stealer.Flame.FrameCount == 60 then --existing for too long
      player:FullCharge(4)
    end
  end
end
Additionals:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE,Additionals.soul_stealer_update)

function Additionals:use_soul_stealer()
  S_Stealer.Active =  true
  local player = Isaac.GetPlayer(0)
  if S_Stealer.Entity == nil then
    S_Stealer.Entity = Isaac.Spawn(EntityType.ENTITY_EFFECT,S_Stealer.EntityVariant,0,player.Position,Vector(0,0), player) --spawn entity that the player hold
  end
end
Additionals:AddCallback(ModCallbacks.MC_USE_ITEM,Additionals.use_soul_stealer, SoulStealerID)


function Additionals:S_StealerOnDamage(target,dmg,flags,source,countdown)

  local player = Isaac.GetPlayer(0)
  if S_Stealer.Flame ~= nil and source.Entity.Index == S_Stealer.Flame.Index then
    S_Stealer.Flame:Remove()
    S_Stealer.Flame = nil
    
    if target.HitPoints <= 8 and target.Type ~= EntityType.ENTITY_FIREPLACE then --the entity'll die of the fire
      local phantoms = Isaac.FindByType(EntityType.ENTITY_FAMILIAR,PhantomFamiliar, 0)
      if #phantoms < 1 then
        phantom = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, PhantomFamiliar, 0, player.Position, Vector(0,0), player):ToFamiliar()
        
      else
        upgradeEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.POOF02,0,phantom.Position,Vector(0,0),player):ToEffect()
        effectColor = Color(1,1,1,1,0,0,0)
        effectColor:SetColorize(0.2,0.1,0.8,1)
        local effectSprite = upgradeEffect:GetSprite()
        effectSprite.Color = effectColor
        Additionals.Upgrade()
      end
    end
    
    target:TakeDamage(8,0,EntityRef(player),countdown) -- Normal damage
    return false --Don't do initial damage
    
  elseif source.SpawnerVariant == PhantomFamiliar and source.Type == EntityType.ENTITY_TEAR and source.SpawnerType == EntityType.ENTITY_FAMILIAR then
    --the target has been hitting by the phantom
    target:TakeDamage(S_Stealer.Phantom.Damage,0,EntityRef(player),countdown) -- Normal damage
    return false
  end
  
end
Additionals:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG,Additionals.S_StealerOnDamage)

function Additionals:Upgrade()
  
  
  if (math.random(0,1) == 0) then 
    if S_Stealer.Phantom.Damage+1 <= S_Stealer.Phantom.DamageCap then
      S_Stealer.Phantom.Damage = S_Stealer.Phantom.Damage +1
    end
  else
    if S_Stealer.Phantom.FireRate-5 >= S_Stealer.Phantom.FireRateCap then
      S_Stealer.Phantom.FireRate = S_Stealer.Phantom.FireRate -5
    end
  end
end


function Additionals:onInitPhantom(phantom)
  --Default animation "FloatDown"
  phantom.IsFollower = true
	phantom:AddToFollowers()
	phantom.FireCooldown = 3
end

Additionals:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, Additionals.onInitPhantom, PhantomFamiliar)


function Additionals:onPhantomUpdate(phantom)
  local player = Isaac.GetPlayer(0)
  local move_dir = player:GetMovementDirection()
  local sprite = phantom:GetSprite()
  local player_fire_direction = player:GetFireDirection()
  
  --Change Animation
  if player_fire_direction == Direction.NO_DIRECTION then
    sprite:Play(DIRECTION_FLOAT_ANIM[move_dir], false)
  else
    local animDirection = player_fire_direction
    sprite:Play(DIRECTION_SHOOT_ANIM[animDirection], false)
  end
  
  --Fire
  if player:GetShootingJoystick():Length() > 0.1 and phantom.FireCooldown <= 0 then --the player shoot
    tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.DARK_MATTER,0,phantom.Position,player:GetShootingJoystick():Normalized()*14 + phantom.Velocity,phantom):ToTear()
    
    if player:HasTrinket(Isaac.GetTrinketIdByName("Forgotten Lullaby")) then
				phantom.FireCooldown = math.floor(S_Stealer.Phantom.FireRate *0.666667)
			else --Reset FireRate
				phantom.FireCooldown = S_Stealer.Phantom.FireRate
			end
  end
  phantom.FireCooldown = phantom.FireCooldown -1
  phantom:FollowParent()
end
Additionals:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE,Additionals.onPhantomUpdate, PhantomFamiliar)



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
  fam:AddToFollowers()
end

Additionals:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, onInit, frozenFam)
Additionals:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE,onFamiliarUpdate, frozenFam)

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
    
    local laser1 = EntityLaser.ShootAngle(typelas,fam.Position,45,duration,Vector(0,0),player)
    laser1.CollisionDamage = damageL
    local laser2 = EntityLaser.ShootAngle(typelas,fam.Position,135,duration,Vector(0,0),player)
    laser2.CollisionDamage = damageL
    local laser3 = EntityLaser.ShootAngle(typelas,fam.Position,225,duration,Vector(0,0),player)
    laser3.CollisionDamage = damageL
    local laser4 = EntityLaser.ShootAngle(typelas,fam.Position,315,duration,Vector(0,0),player)
    laser4.CollisionDamage = damageL
  end
end

Additionals:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE,onFamiliarUpdate2, laserFam)