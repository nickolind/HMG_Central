if (isDedicated) exitWith {};

#include "vehAmphRef.sqf"

if (isNil{pzn_amphlist_map}) then {pzn_amphlist_map = []} else {
	if (typeName pzn_amphlist_map != "ARRAY") then {pzn_amphlist_map = []};
};


// --------------------- Определение плавучести в соотв. с массивом ---------------------
	NSA_pa_fnc_checkLine = {
		private ["_vehicle","_thisList","_result"];
		
		_vehicle = _this select 0;
		_thisList = _this select 1;
		_result = false;
		{	
			if ( _x == typeof _vehicle ) exitWith {_result = true};
			if ( 
				(((toArray _x) select 0) == 35) // 35 = "#"
				&& 
				( ( toUpper(typeof _vehicle) find (_x select [1]) ) != -1 )
			
			) exitWith {_result = true};	
			
		} forEach _thisList;
		
		_result
	};

	NSA_pa_fnc_isAmphibia = {
		private ["_vehicle","_vcn_result"];
		
		_vehicle = _this select 0;
		_vcn_result = false;
		
		if ([_vehicle, (pzn_amphlist_map + pzn_amphlist_default)] call NSA_pa_fnc_checkLine) then {_vcn_result = true};	// Есть ли в списках плав.средств
		
		if (_vcn_result) then {
			if ([_vehicle, pzn_amphlist_exclude] call NSA_pa_fnc_checkLine) then {_vcn_result = false};				// Есть ли в списке исключений
		};
		
		_vcn_result
	};
// --------------------- Определение плавучести в соотв. с массивом ---------------------




pzn_speedMultiplier = 0;


waitUntil { sleep 0.1; !isNull (findDisplay 46) };
s7_keyHandler = { // Speed increase by Blender
    private["_s7_keyPressed","_vcl","_vel","_dir"];
    _s7_keyPressed = _this select 1;
    _vcl = vehicle player;
    if (_vcl == player) exitWith {};
    // if( ([_vcl] call NSA_pa_fnc_isAmphibia) && isEngineOn _vcl && (surfaceIsWater (getpos _vcl)) && (((getPosASL _vcl) select 2) < 0.5) ) then {
    // if( ([_vcl] call NSA_pa_fnc_isAmphibia) && isEngineOn _vcl && (surfaceIsWater (getpos _vcl)) && (!(isTouchingGround _vcl) || (((getPosASL _vcl) select 2) < 0.5)) ) then {
    if( 
		([_vcl] call NSA_pa_fnc_isAmphibia) 
		&& 
		isEngineOn _vcl 
		&& 
		(surfaceIsWater (getpos _vcl)) 
		&& 
		( 
			
			(((getPosASL _vcl) select 2) < 0.5)		// заход в море
			|| 
			(										// заход в озера
				(((getPosAtL _vcl) select 2) < 2) 
				|| 
				( !(isTouchingGround _vcl) && (((getPos _vcl) select 2) < 2) )
			)
		) 
			
	) then {
        _vel = velocity _vcl;
            _maxmultipler = 3.7;
        if (_s7_keyPressed in (actionKeys "MoveForward")) then {
            pzn_speedMultiplier = (pzn_speedMultiplier + 0.01) min _maxmultipler;
            _dir = direction _vcl;
            _vcl setVelocity [(sin _dir) * pzn_speedMultiplier, (cos _dir) * pzn_speedMultiplier, 0];
        };
        if (_s7_keyPressed in (actionKeys "MoveBack")) then {
            pzn_speedMultiplier = (pzn_speedMultiplier - 0.01) max (_maxmultipler * -.5);
            _dir = direction _vcl;
            _vcl setVelocity [(sin _dir) * pzn_speedMultiplier, (cos _dir) * pzn_speedMultiplier, 0];
        };
        if (_s7_keyPressed in (actionKeys "TurnLeft")) then {
            _dir = direction _vcl - .3;
            // hint str _vel;
            _vcl setdir _dir;
            _vcl setVelocity [(sin _dir) * pzn_speedMultiplier, (cos _dir) * pzn_speedMultiplier,0 ];
        };
        if (_s7_keyPressed in (actionKeys "TurnRight")) then {
            _dir = direction _vcl + .3;
            // hint str _vel;
            _vcl setdir _dir;
            _vcl setVelocity [(sin _dir) * pzn_speedMultiplier, (cos _dir) * pzn_speedMultiplier, 0];
        };
    };
    false
};
(findDisplay 46) displayAddEventHandler ["keyDown", "_this call s7_keyHandler"];