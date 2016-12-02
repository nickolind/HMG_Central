
if (isServer) then {

	// HMG_Hardfreeze_ON = "HMG_hardfreeze_modeParam" call BIS_fnc_getParamValue;
	if (isNil{HMG_Hardfreeze_ON}) then {HMG_Hardfreeze_ON = 1};
	publicVariable "HMG_Hardfreeze_ON";
	
	nsa_fpsThreshold = 5;

	if (HMG_Hardfreeze_ON > 0) then {
		{
			_x enableSimulationGlobal false;
		} forEach playableUnits;
	};
	
	"HMG_Hardfreeze_ON" addPublicVariableEventHandler {
		publicVariable "HMG_Hardfreeze_ON";
		switch (_this select 1) do {
			case 0: {
				{
					_x enableSimulationGlobal true;
					if (isPlayer _x) then {
						// [[0],"HMG_Central_fnc_hardfreeze_local", _x] call BIS_fnc_MP;
						[[9],"HMG_Central_fnc_hardfreeze_local", _x] call BIS_fnc_MP; // DEBUG
					};
				} forEach (playableUnits + vehicles);
			};
			
			case 2: {
				{
					_x enableSimulationGlobal false;
					if (isPlayer _x) then {
						[[2],"HMG_Central_fnc_hardfreeze_local", _x] call BIS_fnc_MP;
					};
				} forEach (playableUnits + vehicles);
			};
		};
	};
	
	
	//----------------------------------------- Авто режим -----------------------------------------
	if (HMG_Hardfreeze_ON == 1) then {
		
		private ["_sn","_hf_gl"];
		_hf_gl = [[],[],[],[]];		// [east,west,resistance,civilian]
			
		{
			if (leader group _x == _x) then {
				_sn = [east,west,resistance,civilian] find (side group _x);
				
				(_hf_gl select _sn) pushBack _x;		
			};
		} forEach playableUnits;
		
		[_hf_gl] spawn {
			_hf_groupLeaders = _this select 0;
			
			waitUntil {sleep 1.01; time > 0};

			sleep 30;
			
			
			if (HMG_Hardfreeze_ON == 1) then {
			
				waitUntil {
					if ( ((diag_fps > nsa_fpsThreshold) && (diag_fpsMin > nsa_fpsThreshold)) || (HMG_Hardfreeze_ON != 1) ) exitWith {true}; 
					sleep 1; 
				};
			
				// Разморозка КО
				while {( (count (_hf_groupLeaders select 0)) + (count (_hf_groupLeaders select 1)) + (count (_hf_groupLeaders select 2)) + (count (_hf_groupLeaders select 3)) ) > 0 } do {
					waitUntil {
						if ((diag_fps > nsa_fpsThreshold) && (diag_fpsMin > nsa_fpsThreshold)) exitWith {true}; 
						sleep 2; 
					};
					
					if (HMG_Hardfreeze_ON != 1) exitWith {_hf_groupLeaders = [[],[],[],[]];};
					
					{
						if ((count _x) > 0) then {
						
							(_x select 0) enableSimulationGlobal true;
							
							if (isPlayer (_x select 0)) then {
								// [[0],"HMG_Central_fnc_hardfreeze_local", (_x select 0)] call BIS_fnc_MP;
								[[8],"HMG_Central_fnc_hardfreeze_local", _x] call BIS_fnc_MP; // DEBUG
							};
							
							_x deleteAt 0;
						};
					} forEach _hf_groupLeaders;

					sleep 2;
				};
			
			};
			
			sleep 30;
			
			waitUntil {
				if ( ((diag_fps > nsa_fpsThreshold) && (diag_fpsMin > nsa_fpsThreshold)) || (HMG_Hardfreeze_ON != 1) ) exitWith {true}; 
				sleep 1; 
			};
			
			// Разморозка всех
			if (HMG_Hardfreeze_ON == 1) then {
				HMG_Hardfreeze_ON = 0;
				publicVariable "HMG_Hardfreeze_ON";
				{
					_x enableSimulationGlobal true;
					if (isPlayer _x) then {
						// [[0],"HMG_Central_fnc_hardfreeze_local", _x] call BIS_fnc_MP;
						[[7],"HMG_Central_fnc_hardfreeze_local", _x] call BIS_fnc_MP; // DEBUG
					};
				} forEach playableUnits;
			};
		};
	};
};

if !(isDedicated) then {

	// Действия для админа //--------------------------------------------------------------------------------------------------------------------------------//
	waitUntil {sleep 1.05; (player == player) && (!isNil{HMG_Hardfreeze_ON})};
	[] spawn HMG_Central_fnc_hardfreeze_admin;
	
	if (HMG_Hardfreeze_ON > 0) then {
		[2] spawn HMG_Central_fnc_hardfreeze_local;
	};
};

