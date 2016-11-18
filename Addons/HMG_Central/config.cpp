class CfgPatches
{
	class HMG_Central
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 1.5;
		requiredAddons[] = {};
		author = "Nickorr";
        version = 0.1.0;
        versionStr = "0.1.0";
        versionAr[] = {0,1,0};
	};
};

class CfgFunctions
{
	class HMG_Central
	{
		class Main
		{
			file = "HMG_Central";
			class Init
			{
				preInit = 1;
			};
			class Main {};	
			class confirmActDialog {};	
		};
		
		class pzn_amphibia 
		{
			file = "HMG_Central\pzn_amphibia";
			class pzn_amphibia_main {};
		};
		class NSA_PrivateBox 
		{
			file = "HMG_Central\NSA_PrivateBox";
			class pb_client {};
			class pb_server {};
			class pb_showBoxContents_HintC {};
			class pb_showBoxContents_ACE {};
		};
		class hmg_hardfreeze 
		{
			file = "HMG_Central\hmg_hardfreeze";
			class hardfreeze {};
			class hardfreeze_admin {};
			class hardfreeze_local {};
		};
	};
};

// class Params
// {
	// class HMG_hardfreeze_modeParam
	// {
		// title = "Режим хардфриза"; 															// Param name visible in the list
		// values[] = 	{	0,			1, 			2 			}; 								// 60, 100, 130, max (160)
		// texts[] = 	{	"Выкл.", 	"Авто",		"Ручной"	}; 								// Description of each selectable item
		// default = 1; 																		// Default value; must be listed in 'values' array, otherwise 0 is used
	// };
// };