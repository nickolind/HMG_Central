class CfgPatches
{
	class HMG_Central
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 1.5;
		requiredAddons[] = {};
		author[] = { "Nickorr" };
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
	};
};