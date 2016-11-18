while {!isNil{HMG_Hardfreeze_ON}} do {
			
	if (serverCommandAvailable"#kick") then {
		private ["_int"];

		NSA_actConfirmState = 0;
		NSA_hf_adminActions = [];
				
// Отключить ХФ у всех //--------------------------------------------------------------------------------------------------------------------------------//
		_int = player addAction ["<t color='#b900fb'>Admin: Отключить хардфриз у всех</t>", {
			// private "_actDisableHF_all";
			
			_actDisableHF_all = {
				HMG_Hardfreeze_ON = 0;
				publicVariableServer "HMG_Hardfreeze_ON";
				NSA_actConfirmState = 0;
			};
			
			NSA_actConfirmState = 1;
			["Отключить хардфриз у всех", 10, _actDisableHF_all, {NSA_actConfirmState = 0}] spawn HMG_Central_fnc_confirmActDialog;		// ["Текст_Сообщения", Время_ожидания, {Скрипт_при_подтверждении}, {Скрипт_при_отмене}] spawn HMG_Central_fnc_confirmActDialog;			
			
		}, 1, 0, false, false, "", "(HMG_Hardfreeze_ON != 0) && (NSA_actConfirmState == 0)"];
		
		NSA_hf_adminActions pushBack _int;
		
// ВКЛЮЧИТЬ ХФ у всех //--------------------------------------------------------------------------------------------------------------------------------//
		_int = player addAction ["<t color='#b900fb'>Admin: ВКЛЮЧИТЬ хардфриз у всех</t>", {
			// private "_actDisableHF_all";
			
			_actEnableHF_all = {
				
				HMG_Hardfreeze_ON = 2;
				publicVariableServer "HMG_Hardfreeze_ON";
				// [[ [], {
					// ["<t color='#FF0000' size = '1'>Игровой администратор включил хардфриз</t>", 0,-0.1,10,0.7,0,782] spawn bis_fnc_dynamictext;	
				// }],"BIS_fnc_call"] call BIS_fnc_MP;	
				
				NSA_actConfirmState = 0;
			};
			
			NSA_actConfirmState = 1;
			["ВКЛЮЧИТЬ хардфриз у всех", 10, _actEnableHF_all, {NSA_actConfirmState = 0}] spawn HMG_Central_fnc_confirmActDialog;		// ["Текст_Сообщения", Время_ожидания, {Скрипт_при_подтверждении}, {Скрипт_при_отмене}] spawn HMG_Central_fnc_confirmActDialog;			
			
		}, 1, 0, false, false, "", "(HMG_Hardfreeze_ON < 2) && (NSA_actConfirmState == 0)"];
		
		NSA_hf_adminActions pushBack _int;
		

		waitUntil {
			sleep 1; 
			if !(serverCommandAvailable"#kick") exitWith { 
				{ player removeAction _x; } forEach NSA_hf_adminActions;
				NSA_hf_adminActions = nil;
				NSA_actConfirmState = nil;
				true
			}; 
		};
	};
	
	sleep 4.06;
};