/*

	[_container] spawn HMG_Central_fnc_pb_showBoxContents_HintC;

*/

private ["_unit", "_listedItemClasses", "_allGear", "_compText"];

_unit = _this select 0;

_allGear = [];
_listedItemClasses = [];

_allGear = (weaponCargo _unit + magazinecargo _unit + itemCargo _unit + backpackCargo _unit) call BIS_fnc_consolidateArray;

_compText = composeText [parseText format ["<t size='1.2' align='center' underline='true' shadow='2'>%1<br/></t>", localize "STR_NSA_pb_boxContainer"]];

{
  if (!((_x select 0) in _listedItemClasses)) then {
    private ["_item","_itemImage","_itemName","_invItem", "_itemCount"];
    _item = configFile >> "CfgMagazines" >> (_x select 0);
    if (isNil "_item" || str _item == "") then {
      _item = configFile >> "CfgWeapons" >> (_x select 0);
    };
	if (isNil "_item" || str _item == "") then {
      _item = configFile >> "CfgGlasses" >> (_x select 0);
    };
	if (isNil "_item" || str _item == "") then { 
      _item = configFile >> "CfgVehicles" >> (_x select 0);
    };
	
	_itemName = getText(_item >> "displayName");
	_itemCount = str (_x select 1);
	
	if (count _allGear < 30) then {
		_itemImage = parseText format ["<img size='1' image='%1'/>", getText(_item >> "picture")];
		_invItem = composeText [parseText "<br/>", _itemImage, " x", _itemCount, " - ", _itemName];
	} else {
		_itemImage = parseText format ["<img size='2.5' image='%1'/>", getText(_item >> "picture")];
		_invItem = composeText [_itemImage, "x", _itemCount, "       "];
	};

	_compText = composeText [_compText, _invItem];
    _listedItemClasses pushBack (_x select 0);
  };
} forEach (_allGear);


sleep 0.01;
"" hintC _compText;

hintC_arr_EH = findDisplay 72 displayAddEventHandler ["unload", {
	0 = _this spawn {
		_this select 0 displayRemoveEventHandler ["unload", hintC_arr_EH];
		hintSilent "";
		hintC_arr_EH = nil;
	};
}];