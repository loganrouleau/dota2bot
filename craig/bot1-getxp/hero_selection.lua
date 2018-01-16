

----------------------------------------------------------------------------------------------------

function Think()


	if ( GetTeam() == TEAM_RADIANT )
	then
		if ( IsPlayerBot(0) ) then
			SelectHero( 0, "npc_dota_hero_lina" );
		end
		SelectHero( 1, "npc_dota_hero_storm_spirit" );
		SelectHero( 2, "npc_dota_hero_techies" );
		SelectHero( 3, "npc_dota_hero_techies" );
		SelectHero( 4, "npc_dota_hero_techies" );
	elseif ( GetTeam() == TEAM_DIRE )
	then
		if ( IsPlayerBot(5) ) then
			SelectHero( 5, "npc_dota_hero_techies" );
		end
		SelectHero( 6, "npc_dota_hero_techies" );
		SelectHero( 7, "npc_dota_hero_techies" );
		SelectHero( 8, "npc_dota_hero_techies" );
		SelectHero( 9, "npc_dota_hero_techies" );
	end

end

----------------------------------------------------------------------------------------------------
