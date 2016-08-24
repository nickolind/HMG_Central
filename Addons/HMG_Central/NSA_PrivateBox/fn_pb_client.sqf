waitUntil {sleep 1;  !(isNull player) };	

player addEventHandler ["InventoryOpened", {
	private ["_result","_unit", "_container","_tArray","_str"];
	_result = false;
	_unit = _this select 0;
	_container = _this select 1; 
	
	if !(_container isKindOf "Thing") then {
		{
			if (_x in NSA_pb_privateBoxes) then {_container = _x;};
		} forEach ((position _unit) nearEntities ["Thing", 2]);
	};
	
	if ((_container in NSA_pb_privateBoxes)) then {
		_tArray = (_container getVariable "NSA_pb_boxOwnedBy");
		_str = "";
		{
			if (!isNull(_tArray select _forEachIndex)) then {
				_str = _str + groupId (_tArray select _forEachIndex) + " (" + str (side (_tArray select _forEachIndex)) + ")<br/>(Com.: " + name leader (_tArray select _forEachIndex) + ")<br/><br/>";
			} else {_str = "N/A";};
		} forEach _tArray;
		if !(group _unit in _tArray ) then {
			_result = true;
			hint parseText format ["<t color='#ff0000'>%1</t><br/><br/>%2<br/>%3", localize "STR_NSA_pb_noAccess", localize "STR_NSA_pb_boxOwner", _str];
			[_container] spawn HMG_Central_fnc_pb_showBoxContents_HintC;											
			// [_container] spawn HMG_Central_fnc_pb_showBoxContents_ACE;													
		} else {
			hint parseText format ["%1<br/>%2", localize "STR_NSA_pb_boxOwner", _str];
		}; 
	};
	_result
}];