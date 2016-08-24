/*

v. 2.02

by Nickorr


-------------------------------------------------------------------------

Description:
Mod attaches crates to some group (or couple of groups). Only attached groups can open the box, others can only preview box' contents and who is the owner of the box. 

How to use (in editor):
1. Put down some soldier / group of soldiers and some crate;
2. Synchronize the group with a box (Synchronisation (F5)).

Extra info:
- Multiple units/groups can be synced with a crate.
- Multiple crates can be synced with unit/group.
- If the box is not synchronized with any unit or group of units, it is open for everyone.
- Better not to place a crate closer than 2 meters to other crate or container.

-------------------------------------------------------------------------

*/

if (isNil "NSA_pb_privateBoxes") then {NSA_pb_privateBoxes = [];};

{
	_y = _x;
	{
		if (_x isKindOf "Thing") then {
			if !(_x in NSA_pb_privateBoxes) then {
				NSA_pb_privateBoxes pushBack _x; 
			};
			
			if (isNil {_x getVariable "NSA_pb_boxOwnedBy"}) then {
				_x setVariable ["NSA_pb_boxOwnedBy", [], true];
				_x getVariable "NSA_pb_boxOwnedBy" pushBack group _y; 							
				_x setVariable ["NSA_pb_boxOwnedBy", _x getVariable "NSA_pb_boxOwnedBy", true];	
			} else { 
				if !(group _y in (_x getVariable "NSA_pb_boxOwnedBy")) then {
					_x getVariable "NSA_pb_boxOwnedBy" pushBack group _y; 
					_x setVariable ["NSA_pb_boxOwnedBy", _x getVariable "NSA_pb_boxOwnedBy", true];
				};
			};
		};
	} forEach synchronizedObjects _y;
} forEach allUnits;
publicVariable "NSA_pb_privateBoxes";