while {!isNil{HMG_Hardfreeze_ON}} do {
			
	if (serverCommandAvailable"#kick") then {
		private ["_int"];

		NSA_actConfirmState = 0;
		NSA_hf_adminActions = [];
		
		if ((("NSA_hf_modeParam" call BIS_fnc_getParamValue) == 1) && (HMG_Hardfreeze_ON != 0)) then { HMG_Hardfreeze_ON = 1;};
				
// Отключить ХФ у всех //--------------------------------------------------------------------------------------------------------------------------------//
		_int = player addAction ["<t color='#b900fb'>Admin: Отключить хардфриз у всех</t>", {
			// private "_actDisableHF_all";
			
			_actDisableHF_all = {
				HMG_Hardfreeze_ON = 0;
				publicVariable "HMG_Hardfreeze_ON";
				// publicVariableServer "HMG_Hardfreeze_ON";	// testing -- local hf
				NSA_actConfirmState = 0;
			};
			
			NSA_actConfirmState = 1;
			["Отключить хардфриз у всех", 10, _actDisableHF_all, {NSA_actConfirmState = 0}] spawn NSA_fn_confirmActDialog;		// ["Текст_Сообщения", Время_ожидания, {Скрипт_при_подтверждении}, {Скрипт_при_отмене}] spawn NSA_fn_confirmActDialog;			
			
		}, 1, 0, false, false, "", "(HMG_Hardfreeze_ON != 0) && (NSA_actConfirmState == 0)"];
		
		NSA_hf_adminActions pushBack _int;
		
// ВКЛЮЧИТЬ ХФ у всех //--------------------------------------------------------------------------------------------------------------------------------//
		_int = player addAction ["<t color='#b900fb'>Admin: ВКЛЮЧИТЬ хардфриз у всех</t>", {
			// private "_actDisableHF_all";
			
			_actEnableHF_all = {
				
				diag_log "NSA_Hardfreeze (admin): HF manually activated --timestamp";	  //testing -- тест прямой связи при лагах
				
				HMG_Hardfreeze_ON = 2;
				publicVariable "HMG_Hardfreeze_ON";
				[[ [], { 
					HMG_Hardfreeze_ON = 2;
					["<t color='#FF0000' size = '1'>Игровой администратор включил хардфриз</t>", 0,-0.1,10,0.7,0,782] spawn bis_fnc_dynamictext;
					
					if (isServer) then {
						diag_log "NSA_Hardfreeze (server): HF manually activated --timestamp";  //testing -- тест прямой связи при лагах
					} else {
						diag_log "NSA_Hardfreeze (client): HF manually activated --timestamp"; //testing -- тест прямой связи при лагах
					};
					
				}],"BIS_fnc_call"] call BIS_fnc_MP;	
				
				NSA_actConfirmState = 0;
			};
			
			NSA_actConfirmState = 1;
			["ВКЛЮЧИТЬ хардфриз у всех", 10, _actEnableHF_all, {NSA_actConfirmState = 0}] spawn NSA_fn_confirmActDialog;		// ["Текст_Сообщения", Время_ожидания, {Скрипт_при_подтверждении}, {Скрипт_при_отмене}] spawn NSA_fn_confirmActDialog;			
			
		}, 1, 0, false, false, "", "(HMG_Hardfreeze_ON < 2) && (NSA_actConfirmState == 0)"];
		
		NSA_hf_adminActions pushBack _int;
		

		waitUntil {
			sleep 1; 
			if (!(serverCommandAvailable"#kick") || !(alive player) ) exitWith { 
				{ player removeAction _x; } forEach NSA_hf_adminActions;
				NSA_hf_adminActions = nil;
				NSA_actConfirmState = nil;
				true
			}; 
		};
	};
	
	sleep 4.06;
};