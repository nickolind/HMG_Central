/* 

Обычный вызов:
	null = [] spawn compileFinal preprocessFileLineNumbers "NSA_hardfreeze.sqf";

Вызов с перегрузкой параметра:
	null = [_override_hf_modeParam] spawn compileFinal preprocessFileLineNumbers "NSA_hardfreeze.sqf";


_hf_modeParam:
	0 - Выкл
	1 - Авто
	2 - Ручной

Ручное выключение:

	comment "on server";
	HMG_Hardfreeze_ON = -1;
	publicVariable "HMG_Hardfreeze_ON";

	
	
*/
private ["_hf_modeParam"];
_hf_modeParam = 0;

if (count _this > 0) then {
	_hf_modeParam = _this select 0;
} else {
	_hf_modeParam = "NSA_hf_modeParam" call BIS_fnc_getParamValue;
};


if (_hf_modeParam == 0) exitWith {
	HMG_Hardfreeze_ON = -1;
	publicVariable "HMG_Hardfreeze_ON";
};

[] spawn {
	if !(isDedicated) then {
		
		
		waitUntil {sleep 0.1; (player == player) && (!isNil{HMG_Hardfreeze_ON})};
		
		[] spawn {
			private ["_int"];
			
			while {(HMG_Hardfreeze_ON > -1)} do {
				
				if (serverCommandAvailable"#kick") then {
					NSA_hf_adminActions = [];
					NSA_hf_actDisGL = 1;
					
					_int = player addAction ["<t color='#b900fb'>Admin: Отключить хардфриз у КО</t>", {
						HMG_Hardfreeze_ON = 0;
						{
							if (leader group _x == _x) then {
								(owner _x) publicVariableClient "HMG_Hardfreeze_ON";		
							};
						} forEach playableUnits;
						
						NSA_hf_actDisGL = 0;
					}, 1, 0, false, false, "", "NSA_hf_actDisGL == 1"];
					
					NSA_hf_adminActions pushBack _int;

					
					
					_int = player addAction ["<t color='#b900fb'>Admin: Отключить хардфриз у всех</t>", {
						HMG_Hardfreeze_ON = -1;
						publicVariable "HMG_Hardfreeze_ON";
						{
							player removeAction _x;
						} forEach NSA_hf_adminActions;
						NSA_hf_adminActions = [];
					}, 1, 0, false, false, "", ""];
					
					NSA_hf_adminActions pushBack _int;
					
					

					waitUntil {
						sleep 1; 
						if (!(serverCommandAvailable"#kick") || (HMG_Hardfreeze_ON == -1)) exitWith { 
							{
								player removeAction _x;
							} forEach NSA_hf_adminActions;
							NSA_hf_actDisGL = nil;
							NSA_hf_adminActions = nil;
							true
						}; 
					};
				};
				
				sleep 1.06;
			};

		};
		
		[] spawn {
			while {(alive player)} do {
				if ((HMG_Hardfreeze_ON > 0)) then {
					["<t color='#FF0000' size = '.9'>Активирован хардфриз</t><br/><t color='#FF0000' size = '.45'>Пожалуйста, подождите...</t>", 0,0.2,1,0.7,0,785] spawn bis_fnc_dynamictext;
				};
				sleep 3.5;
			};
		};
		
		
		if ( (HMG_Hardfreeze_ON == 1) ) then {
			player enableSimulation false;
			
			waitUntil {sleep 0.5; (HMG_Hardfreeze_ON < 1)};
			player enableSimulation true;
		};
		
		

	};
};


if (isServer) then {
	
	//----------------------------------------- Ручной режим -----------------------------------------
	if (_hf_modeParam == 2) then {
		HMG_Hardfreeze_ON = 1;
		publicVariable "HMG_Hardfreeze_ON";
		{
			_x enableSimulationGlobal false;
		} forEach playableUnits;
		
		waitUntil {sleep 1.02; (HMG_Hardfreeze_ON == -1)};
		publicVariable "HMG_Hardfreeze_ON";
		// {
			// _x enableSimulationGlobal true;
		// } forEach playableUnits;
	};
	
	//----------------------------------------- Авто режим -----------------------------------------
	if (_hf_modeParam == 1) then {
		private ["_groupLeaders","_sn"];
		
		HMG_Hardfreeze_ON = 1;
		publicVariable "HMG_Hardfreeze_ON";
		{
			_x enableSimulationGlobal false;
		} forEach playableUnits;
		
		
		_groupLeaders = [[],[],[],[]];		// [east,west,resistance,civilian]
		
		{
			if (leader group _x == _x) then {
				_sn = [east,west,resistance,civilian] find (side group _x);
				
				(_groupLeaders select _sn) pushBack _x;		
			};
		} forEach playableUnits;
		
		waitUntil {sleep 1.01; time > 0};
		sleep 10;

		HMG_Hardfreeze_ON = 0;
		
		// Разморозка КО
		while {( (count (_groupLeaders select 0)) + (count (_groupLeaders select 1)) + (count (_groupLeaders select 2)) + (count (_groupLeaders select 3)) ) > 0 } do {
			waitUntil {
				if (diag_fps > 3) exitWith {true}; 
				sleep 2; 
			};
			
			{
				if ((count _x) > 0) then {
					(owner (_x select 0)) publicVariableClient "HMG_Hardfreeze_ON";
					_x deleteAt 0;
				};
			} forEach _groupLeaders;
			
			if (HMG_Hardfreeze_ON == -1) exitWith {};
			
			sleep 2;
		};
		
		sleep 30;
		
		waitUntil {
			if ( (diag_fps > 3) || (HMG_Hardfreeze_ON == -1) ) exitWith {true}; 
			sleep 1; 
		};
		
		// Разморозка всех
		HMG_Hardfreeze_ON = -1;
		publicVariable "HMG_Hardfreeze_ON";
		// {
			// _x enableSimulationGlobal true;
		// } forEach playableUnits;
	};
};


