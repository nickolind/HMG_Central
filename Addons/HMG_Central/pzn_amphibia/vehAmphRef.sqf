// #include "vehPassabilityRef.sqf"

pzn_amphlist_default = [
	// Уникальный класнеймы (без вариантов):
	// "rhs_bmp2_vv",
	// "rhs_bmp2e_vv",
	// "rhs_bmp1_vv",
	// "rhs_bmd2",
	// "rhs_bmd1",
	// "LOP_IA_BMP2",
	// "LOP_IA_BMP1",
	// "rhs_pts_vmf",
	
	/* 	Модели с неск. вариациями или копиями у разных фракций - указывать в виде '#CAPITAL_LETTERS_OR_DIGITS'
		Вариации располагать в порядке: <Сначала вариант с наиболее длинным индексом>, .. , <Базовая модель последняя>
	*/
	
	"#BMD",	
	"#BMP",	
	"#PTS"
];

pzn_amphlist_exclude = [

	"#BMP2D",
	"#BMP1D"

];