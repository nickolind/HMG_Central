/*

	
	
	["Текст_Сообщения", Время_ожидания, {Скрипт_при_подтверждении}, {Скрипт_при_отмене}] spawn NSA_fn_confirmActDialog;			

Пример:
	["Отключить хардфриз у всех", 10, _actDisableHF_all, {NSA_actConfirmState = 0}] spawn NSA_fn_confirmActDialog;
	
	(addAction)
		Parameters array passed to the script upon activation in _this variable is: [target, caller, ID, arguments]
			target (_this select 0): Object - the object which the action is assigned to
			caller (_this select 1): Object - the unit that activated the action
			ID (_this select 2): Number - ID of the activated action (same as ID returned by addAction)
			arguments (_this select 3): Anything - arguments given to the script if you are using the extended syntax

*/

// private ["_i","_rand","_paramText","_paramTime","_paramScriptConfirm","_paramScriptCancel"];
private ["_ai","_i","_rand","_paramText","_paramTime","_timeMark"];

_paramText = _this select 0;
_paramTime = _this select 1;
_paramScriptConfirm = _this select 2;
_paramScriptCancel = _this select 3;

NSA_confirmActDialogID = [];
_rand = 1 + floor random 3;

for "_i" from 0 to 4 do {
	if (_i == _rand) then {
	
		_ai = player addAction [format ["<t color='#FFA700'>ПОДТВЕРДИТЬ - %1</t>", _paramText ], {
			_l_paramScriptConfirm = _this select 3;
			
			{ player removeAction _x; } forEach NSA_confirmActDialogID;
			NSA_confirmActDialogID = [];
			
			[] call _l_paramScriptConfirm;
			
		}, _paramScriptConfirm, 0, false, true, "", ""];
		NSA_confirmActDialogID pushBack _ai;
	
	} else {
	
		_ai = player addAction ["<t color='#a3a3a3'>Отмена подтверждения</t>", {
			_l_paramScriptCancel = _this select 3;
			
			{ player removeAction _x; } forEach NSA_confirmActDialogID;
			NSA_confirmActDialogID = [];
			
			[] call _l_paramScriptCancel;
			
		}, _paramScriptCancel, 0, false, true, "", ""];
		NSA_confirmActDialogID pushBack _ai;
	};
};


_timeMark = time;
	
waitUntil {
	sleep 0.5;
	
	if (count NSA_confirmActDialogID == 0) exitWith {NSA_confirmActDialogID = nil; true};
	
	if ((time - _timeMark) > _paramTime) exitWith {
		
		{ player removeAction _x; } forEach NSA_confirmActDialogID; 
		NSA_confirmActDialogID = nil;
		
		[] call _paramScriptCancel;
		
		true
	};
};


