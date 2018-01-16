
NUM_ACTIONS = 3; --move to creep, hold, move to base
NUM_STATES_DISTANCE = 7; -- >= 1500, 1500 - 1300, 1300 - 600, 600 - 400, 400 - 200, < 200, no creeps
STATES_DISTANCE_BORDERS = {1500, 1300, 600, 400, 200};
NUM_STATES_BEARING = 8;
lut = {};
epsilon = 0.1;
alpha = 0.01;
gamma = 0.01;

prevAction = nil;
prevDistanceState = nil;
prevBearingState = nil;

for i=1,NUM_STATES_DISTANCE do
  lut[i] = {};
  for j=1,NUM_STATES_BEARING do
    lut[i][j] = {};
    for k=1,NUM_ACTIONS do
      lut[i][j][k] = 0;
    end
  end
end

creepsTableIndex = 1;
creepsTable = {};
lastTimeDamagedByCreep = 0;

XP_RANGE = 1500;

RADIANT_FOUNTAIN_COORDS = Vector(-6750,-6550,512);

--------- TESTING XP RANGE ----------
previousXpToLevel = 200;
creepDiedInRangeButNoXpGained = false;
--------------------------------------

------------ STATS -----------------
tickCounter = 0;
numAction1 = 0;
numAction2 = 0;
numAction3 = 0;
------------------------------------

function Think()
  
  tickCounter = tickCounter + 1;
  if (tickCounter % 300 == 0) then
    for k,v in pairs(lut) do
      print(lut[k][1][1],lut[k][1][2],lut[k][1][3]);
    end
    print(numAction1, numAction2, numAction3);
    numAction1 = 0;
    numAction2 = 0;
    numAction3 = 0;
  end
  
  local npcBot = GetBot();
  
  if (not npcBot:IsAlive()) then return; end
  
  --------- TESTING XP RANGE ----------
  if (creepDiedInRangeButNoXpGained) then DebugDrawCircle(npcBot:GetLocation(), 400, 255, 0, 0); end
  --------------------------------------
  
  local distance_state = -1;
  local bearing_state = -1;
  local action = 1;
  
  local distanceFurthestCreep = 999999;
  local creepList = GetUnitList(UNIT_LIST_ENEMY_CREEPS);
  local furthestCreep = nil;
  
  local qMax = 0;
  local reward = 0;
  
  for k,creep in pairs(creepList) do
    
    if (math.abs(GetUnitToUnitDistance(npcBot, creep)) < distanceFurthestCreep) then
      
      furthestCreep = creep;
      distanceFurthestCreep = math.abs(GetUnitToUnitDistance(npcBot, creep));
      
    end
    
    
    local alreadyInTable = false;
    
    for kk,listCreep in pairs(creepsTable) do
      
      if (listCreep == creep) then alreadyInTable = true; end
      
    end
    
    if (not alreadyInTable) then
      creepsTable[creepsTableIndex] = creep;
      creepsTableIndex = creepsTableIndex + 1;
    end
    
    -- TESTING ------------------------------------------------------
    if (not creep:IsAlive()) then print("NOT ALIVE CREEP"); end
    -- TESTING ------------------------------------------------------
    
  end
  
  if (furthestCreep ~= nil) then
    
    for state,border in pairs(STATES_DISTANCE_BORDERS) do
      if (distanceFurthestCreep > border) then distance_state = state; break; end
    end
    if (distance_state == -1) then distance_state = NUM_STATES_DISTANCE - 1; end
      
    bearing_state = 1;
    
  else
    
    distance_state = 5;
    bearing_state = 1;
    
  end
  
  for i=2,NUM_ACTIONS do
    if (lut[distance_state][bearing_state][i] > lut[distance_state][bearing_state][action]) then
      action = i;
    end
  end
  
  qMax = lut[distance_state][bearing_state][action];
  
  if (math.random() < epsilon) then
    action = math.random(1,NUM_ACTIONS);
  end
  
  if (npcBot:TimeSinceDamagedByCreep() < lastTimeDamagedByCreep) then
    reward = reward - 15;
    print("DAMAGED!");
  end
  
  for k,creep in pairs(creepsTable) do
    if (not creep:IsAlive()) then
      creepsTable[k] = nil;
      if (GetUnitToUnitDistance(npcBot, creep) < XP_RANGE) then
        reward = reward + creep:GetBountyXP();
        if (previousXpToLevel == npcBot:GetXPNeededToLevel()) then
          creepDiedInRangeButNoXpGained = true;
        end
      end
    end
  end
  
  if (prevAction ~= nil) then
    
    lut[prevDistanceState][prevBearingState][prevAction] = lut[prevDistanceState][prevBearingState][prevAction]
      + alpha * (reward + gamma * qMax - lut[prevDistanceState][prevBearingState][prevAction]);
    
  end
  
  if (action == 1) then
    if (furthestCreep ~= nil) then 
      npcBot:Action_MoveToLocation(furthestCreep:GetLocation());
    else
      npcBot:Action_MoveToLocation(Vector(-500,-500,512));
    end
    numAction1 = numAction1 + 1;
  elseif (action == 2) then
    npcBot:Action_ClearActions(true);
    numAction2 = numAction2 + 1;
  else
    npcBot:Action_MoveToLocation(RADIANT_FOUNTAIN_COORDS);
    numAction3 = numAction3 + 1;
  end
  
  previousXpToLevel = npcBot:GetXPNeededToLevel();
  prevAction = action;
  prevDistanceState = distance_state;
  prevBearingState = bearing_state;
  lastTimeDamagedByCreep = npcBot:TimeSinceDamagedByCreep();
end
