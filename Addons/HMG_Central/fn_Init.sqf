
[] call HMG_Central_fnc_Main;


// NSA_PrivateBox //--------------------------------------------------------------------------------------------------------------------------------//
if (isServer) then {
	[] spawn HMG_Central_fnc_pb_server;
};

if !(isDedicated) then {
	[] spawn HMG_Central_fnc_pb_client;
};
// NSA_PrivateBox //--------------------------------------------------------------------------------------------------------------------------------//


// hmg_hardfreeze //--------------------------------------------------------------------------------------------------------------------------------//
[] spawn HMG_Central_fnc_hardfreeze;
// hmg_hardfreeze //--------------------------------------------------------------------------------------------------------------------------------//
