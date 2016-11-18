
// waitUntil {sleep 0.1; (player == player) && (!isNil{HMG_Hardfreeze_ON})};

switch (_this select 0) do {
	
	case 0: {
		if (alive player) then {
			["<t color='#00FF00' size = '.9'>Хардфриз отключен</t>", 0,0.2,5,0.7,0,781] spawn bis_fnc_dynamictext; 
		};
	};
	
	case 2: {
		waitUntil {sleep 0.51; !(simulationEnabled player) || !(alive player) };
		
		while {!(simulationEnabled player) && (alive player)} do {
		
			["<t color='#FF0000' size = '.9'>Активирован хардфриз</t><br/><t color='#FF0000' size = '.45'>Пожалуйста, подождите...</t>", 0,0.2,1,0.7,0,781] spawn bis_fnc_dynamictext;
			
			sleep 3.5;
		};
	};
	
};