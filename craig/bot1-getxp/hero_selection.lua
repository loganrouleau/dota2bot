
----------------------------------------------------------------------------------------------------

function Think()

	if ( GetTeam() == TEAM_RADIANT )
	then
    
    local radPlayers = GetTeamPlayers(TEAM_RADIANT);
    local mainBotSelected = false;
    
    for k,playerNo in pairs(radPlayers) do
      
      if (IsPlayerBot(playerNo)) then
        if (not mainBotSelected) then
          SelectHero( playerNo, "npc_dota_hero_storm_spirit" );
          mainBotSelected = true;
        else
          SelectHero( playerNo, "npc_dota_hero_techies" );
        end
      end
    end
    
	elseif ( GetTeam() == TEAM_DIRE )
	then
    
		local direPlayers = GetTeamPlayers(TEAM_DIRE);
    local mainBotSelected = false;
    
    for k,playerNo in pairs(direPlayers) do
      
      if (IsPlayerBot(playerNo)) then
        if (not mainBotSelected) then
          SelectHero( playerNo, "npc_dota_hero_techies" );
          mainBotSelected = true;
        else
          SelectHero( playerNo, "npc_dota_hero_techies" );
        end
      end
    end
	end
end

----------------------------------------------------------------------------------------------------
