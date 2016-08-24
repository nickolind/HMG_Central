/* 

Обычный вызов:
	null = [] spawn compile preprocessFileLineNumbers "fn_hardfreeze.sqf";

Ручное выключение:

	comment "on server";
	HMG_Hardfreeze_ON = 0;
	publicVariable "HMG_Hardfreeze_ON";
	
	0 - полное отключение
	1 - отключение для клиентов
	2 - все включено

	
	
	class Params
	{
		class NSA_hf_modeParam
		{
			title = "Режим хардфриза"; 															// Param name visible in the list
			values[] = 	{	0,			1, 			2 			}; 								// 60, 100, 130, max (160)
			texts[] = 	{	"Выкл.", 	"Авто",		"Ручной"	}; 								// Description of each selectable item
			default = 1; 																		// Default value; must be listed in 'values' array, otherwise 0 is used
		};
	};
	
*/

NSA_fn_confirmActDialog = compile preprocessFileLineNumbers "fn_confirmActDialog.sqf";
NSA_fn_hardfreeze_admin = compile preprocessFileLineNumbers "fn_hardfreeze_admin.sqf";

private ["_hf_modeParam"];
_hf_modeParam = 0;

_hf_modeParam = "NSA_hf_modeParam" call BIS_fnc_getParamValue;

if (_hf_modeParam == 0) exitWith {
	HMG_Hardfreeze_ON = 0;
	publicVariable "HMG_Hardfreeze_ON";
};

"HMG_enableSimObj" addPublicVariableEventHandler {
	(_this select 1) enableSimulation true;
};

"HMG_disableSimObj" addPublicVariableEventHandler {
	(_this select 1) enableSimulation false;
};

[] spawn {
	if !(isDedicated) then {
				
		waitUntil {sleep 0.1; (player == player) && (!isNil{HMG_Hardfreeze_ON})};

		// Действия для админа //--------------------------------------------------------------------------------------------------------------------------------//
		[] spawn NSA_fn_hardfreeze_admin;
		
		
		if (HMG_Hardfreeze_ON < 2) then { 
			player enableSimulation true; 
			HMG_enableSimObj = player;
			publicVariable "HMG_enableSimObj";
		};
		
		// private ["_condition"];
// #ifdef WMT_pub_frzState
		// _condition = { (!isNil{HMG_Hardfreeze_ON}) && (alive player) && (WMT_pub_frzState < 3) };		// Отключение после окончания фризтайма WMT
// #else
		// _condition = { (!isNil{HMG_Hardfreeze_ON}) && (alive player) };
// #endif
		// while {call _condition} do {

		while {(!isNil{HMG_Hardfreeze_ON}) && (alive player)} do {
			
			if (HMG_Hardfreeze_ON >= 2) then {	
				player enableSimulation false;			// testing -- local hf
				HMG_disableSimObj = player;
				publicVariable "HMG_disableSimObj";
			
				waitUntil {
					if ( !(alive player) || (isNil{HMG_Hardfreeze_ON}) ) exitWith { true};
					
					if (HMG_Hardfreeze_ON < 2) exitWith {
						["<t color='#00FF00' size = '.9'>Хардфриз отключен</t>", 0,0.2,5,0.7,0,781] spawn bis_fnc_dynamictext; 
						player enableSimulation true; 
						HMG_enableSimObj = player;
						publicVariable "HMG_enableSimObj";
						true
					};
					
					["<t color='#FF0000' size = '.9'>Активирован хардфриз</t><br/><t color='#FF0000' size = '.45'>Пожалуйста, подождите...</t>", 0,0.2,1,0.7,0,781] spawn bis_fnc_dynamictext;
					
					sleep 3.5;
				};
			};
			
			sleep 5.03;
		};

	};
};


if (isServer) then {
	
	
// testing -- local hf
	// "HMG_Hardfreeze_ON" addPublicVariableEventHandler {
		// publicVariable "HMG_Hardfreeze_ON";
		// switch (_this select 1) do {
			// case 0: {
				// {
					// _x enableSimulationGlobal true;
				// } forEach playableUnits;
			// };
			
			// case 2: {
				// {
					// _x enableSimulationGlobal false;
				// } forEach playableUnits;
			// };
		// };
	// };
	
	
	//----------------------------------------- Ручной режим -----------------------------------------
	if (_hf_modeParam == 2) then {
		HMG_Hardfreeze_ON = 2;
		publicVariable "HMG_Hardfreeze_ON";
		{
			_x enableSimulationGlobal false;
		} forEach playableUnits;
	};
	
	//----------------------------------------- Авто режим -----------------------------------------
	if (_hf_modeParam == 1) then {
		
		private ["_sn","_hf_groupLeaders"];
		_hf_groupLeaders = [[],[],[],[]];		// [east,west,resistance,civilian]
			
		{
			if (leader group _x == _x) then {
				_sn = [east,west,resistance,civilian] find (side group _x);
				
				(_hf_groupLeaders select _sn) pushBack _x;		
			};
		} forEach playableUnits;
		
		
		HMG_Hardfreeze_ON = 2;
		publicVariable "HMG_Hardfreeze_ON";
		{
			_x enableSimulationGlobal false;
		} forEach playableUnits;
		
		HMG_Hardfreeze_ON = 1;
		waitUntil {sleep 1.01; time > 0};

		sleep 30;
		
		
		if (HMG_Hardfreeze_ON == 1) then {
		
			// Разморозка КО
			while {( (count (_hf_groupLeaders select 0)) + (count (_hf_groupLeaders select 1)) + (count (_hf_groupLeaders select 2)) + (count (_hf_groupLeaders select 3)) ) > 0 } do {
				waitUntil {
					if (diag_fps > 3) exitWith {true}; 
					sleep 2; 
				};
				
				if (HMG_Hardfreeze_ON != 1) exitWith {_hf_groupLeaders = [[],[],[],[]];};
				
				{
					if ((count _x) > 0) then {
						[[ [], { 
							HMG_Hardfreeze_ON = 1;
						}],"BIS_fnc_call", (_x select 0)] call BIS_fnc_MP;
						
						_x deleteAt 0;
					};
				} forEach _hf_groupLeaders;

				sleep 2;
			};
		
		} else { _hf_groupLeaders = [[],[],[],[]]; };
		
		sleep 30;
		
		waitUntil {
			if ( (diag_fps > 3) || (HMG_Hardfreeze_ON != 1) ) exitWith {true}; 
			sleep 1; 
		};
		
		// Разморозка всех
		if (HMG_Hardfreeze_ON == 1) then {
			HMG_Hardfreeze_ON = 0;
			publicVariable "HMG_Hardfreeze_ON";
			{
				_x enableSimulationGlobal true;
			} forEach playableUnits;
		};
	};
};


// Тестовый скрипт (testing) //--------------------------------------------------------------------------------------------------------------------------------//
/*

comment "Client";
[] spawn HMG_hf_TestSpawn;

comment "Server";
(owner HMG_GameAdmin) publicVariableClient hf_testArray;
*/

comment "Client";
HMG_hf_TestSpawn = {
	
	HMG_GameAdmin = player;
	publicVariableServer "HMG_GameAdmin";



	if (isServer) then {
		hf_testArray = [];
		"hmg_hf_testResult" addPublicVariableEventHandler {
			hf_testArray pushBack (_this select 1);
		};
		
		hmg_hf_testGO = true;
		publicVariable "hmg_hf_testGO";
	};
	
	
	
	if !(isDedicated) then {
		waitUntil {sleep 0.5; (!isNil{hmg_hf_testGO})};
		
		private ["_hft_str"];
		_hft_str = format ["%1 - %2 (%3)", 
					group player, 
					name player,
					getText (configFile >> "CfgVehicles" >> (typeof vehicle player) >> "displayName")
				];
		hmg_hf_testResult = [true, _hft_str];
		
		{
			if ((isPlayer _x) && !(simulationEnabled _x)) then {hmg_hf_testResult set [0,false];};
		} forEach playableUnits;
		
		publicVariableServer "hmg_hf_testResult";
	};
};

