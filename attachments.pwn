// Attachments filterscript by: Gammix
// Special thanks to: Zeex & Yashas - IZCMD include

#include <a_samp>
#include <SAMP_Fixer/fix_attachments>
#include <dialogs>
#include <izcmd>

#define SAVE_ATTACHMENTS //comment this if you want to disable saving attachments

#undef 	MAX_PLAYER_ATTACHED_OBJECTS
#define MAX_PLAYER_ATTACHED_OBJECTS 10 //maximum limit is 10, if you want less number of slots, set the value here

#if defined SAVE_ATTACHMENTS
	#include <yoursql>
#endif

#define DIALOG_ID_SEARCH (10)
#define DIALOG_ID_BONE (11)
#define DIALOG_ID_REPLACE (12)
#define DIALOG_ID_EDIT_MODEL (13)
#define DIALOG_ID_DUPLICATE (14)
#define DIALOG_ID_ATTACHMENTS (15)
#define DIALOG_ID_COLOR (16)
#define DIALOG_ID_COLOR_LIST (18)
#define DIALOG_ID_CUSTOM_COLOR (17)

new
	pSlot[MAX_PLAYERS],
	pSelected[MAX_PLAYERS],
	pColor[MAX_PLAYERS]
;

enum e_ATTACHMENTS
{
    attachModel,
    attachName[25]
};

new const gAttachments[][e_ATTACHMENTS] =
{
	{18632, "FishingRod"},
	{18633, "GTASAWrench1"},
	{18634, "GTASACrowbar1"},
	{18635, "GTASAHammer1"},
	{18636, "PoliceCap1"},
	{18637, "PoliceShield1"},
	{18638, "HardHat1"},
	{18639, "BlackHat1"},
	{18640, "Hair1"},
	{18975, "Hair2"},
	{19136, "Hair4"},
	{19274, "Hair5"},
	{18641, "Flashlight1"},
	{18642, "Taser1"},
	{18643, "LaserPointer1"},
	{19080, "LaserPointer2"},
	{19081, "LaserPointer3"},
	{19082, "LaserPointer4"},
	{19083, "LaserPointer5"},
	{19084, "LaserPointer6"},
	{18644, "Screwdriver1"},
	{18645, "MotorcycleHelmet1"},
	{18865, "MobilePhone1"},
	{18866, "MobilePhone2"},
	{18867, "MobilePhone3"},
	{18868, "MobilePhone4"},
	{18869, "MobilePhone5"},
	{18870, "MobilePhone6"},
	{18871, "MobilePhone7"},
	{18872, "MobilePhone8"},
	{18873, "MobilePhone9"},
	{18874, "MobilePhone10"},
	{18875, "Pager1"},
	{18890, "Rake1"},
	{18891, "Bandana1"},
	{18892, "Bandana2"},
	{18893, "Bandana3"},
	{18894, "Bandana4"},
	{18895, "Bandana5"},
	{18896, "Bandana6"},
	{18897, "Bandana7"},
	{18898, "Bandana8"},
	{18899, "Bandana9"},
	{18900, "Bandana10"},
	{18901, "Bandana11"},
	{18902, "Bandana12"},
	{18903, "Bandana13"},
	{18904, "Bandana14"},
	{18905, "Bandana15"},
	{18906, "Bandana16"},
	{18907, "Bandana17"},
	{18908, "Bandana18"},
	{18909, "Bandana19"},
	{18910, "Bandana20"},
	{18911, "Mask1"},
	{18912, "Mask2"},
	{18913, "Mask3"},
	{18914, "Mask4"},
	{18915, "Mask5"},
	{18916, "Mask6"},
	{18917, "Mask7"},
	{18918, "Mask8"},
	{18919, "Mask9"},
	{18920, "Mask10"},
	{18921, "Beret1"},
	{18922, "Beret2"},
	{18923, "Beret3"},
	{18924, "Beret4"},
	{18925, "Beret5"},
	{18926, "Hat1"},
	{18927, "Hat2"},
	{18928, "Hat3"},
	{18929, "Hat4"},
	{18930, "Hat5"},
	{18931, "Hat6"},
	{18932, "Hat7"},
	{18933, "Hat8"},
	{18934, "Hat9"},
	{18935, "Hat10"},
	{18936, "Helmet1"},
	{18937, "Helmet2"},
	{18938, "Helmet3"},
	{18939, "CapBack1"},
	{18940, "CapBack2"},
	{18941, "CapBack3"},
	{18942, "CapBack4"},
	{18943, "CapBack5"},
	{18944, "HatBoater1"},
	{18945, "HatBoater2"},
	{18946, "HatBoater3"},
	{18947, "HatBowler1"},
	{18948, "HatBowler2"},
	{18949, "HatBowler3"},
	{18950, "HatBowler4"},
	{18951, "HatBowler5"},
	{18952, "BoxingHelmet1"},
	{18953, "CapKnit1"},
	{18954, "CapKnit2"},
	{18955, "CapOverEye1"},
	{18956, "CapOverEye2"},
	{18957, "CapOverEye3"},
	{18958, "CapOverEye4"},
	{18959, "CapOverEye5"},
	{18960, "CapRimUp1"},
	{18961, "CapTrucker1"},
	{18962, "CowboyHat2"},
	{18963, "CJElvisHead"},
	{18964, "SkullyCap1"},
	{18965, "SkullyCap2"},
	{18966, "SkullyCap3"},
	{18967, "HatMan1"},
	{18968, "HatMan2"},
	{18969, "HatMan3"},
	{18970, "HatTiger1"},
	{18971, "HatCool1"},
	{18972, "HatCool2"},
	{18973, "HatCool3"},
	{18974, "MaskZorro1"},
	{18976, "MotorcycleHelmet2"},
	{18977, "MotorcycleHelmet3"},
	{18978, "MotorcycleHelmet4"},
	{18979, "MotorcycleHelmet5"},
	{19006, "GlassesType1"},
	{19007, "GlassesType2"},
	{19008, "GlassesType3"},
	{19009, "GlassesType4"},
	{19010, "GlassesType5"},
	{19011, "GlassesType6"},
	{19012, "GlassesType7"},
	{19013, "GlassesType8"},
	{19014, "GlassesType9"},
	{19015, "GlassesType10"},
	{19016, "GlassesType11"},
	{19017, "GlassesType12"},
	{19018, "GlassesType13"},
	{19019, "GlassesType14"},
	{19020, "GlassesType15"},
	{19021, "GlassesType16"},
	{19022, "GlassesType17"},
	{19023, "GlassesType18"},
	{19024, "GlassesType19"},
	{19025, "GlassesType20"},
	{19026, "GlassesType21"},
	{19027, "GlassesType22"},
	{19028, "GlassesType23"},
	{19029, "GlassesType24"},
	{19030, "GlassesType25"},
	{19031, "GlassesType26"},
	{19032, "GlassesType27"},
	{19033, "GlassesType28"},
	{19034, "GlassesType29"},
	{19035, "GlassesType30"},
	{19036, "HockeyMask1"},
	{19037, "HockeyMask2"},
	{19038, "HockeyMask3"},
	{19039, "WatchType1"},
	{19040, "WatchType2"},
	{19041, "WatchType3"},
	{19042, "WatchType4"},
	{19043, "WatchType5"},
	{19044, "WatchType6"},
	{19045, "WatchType7"},
	{19046, "WatchType8"},
	{19047, "WatchType9"},
	{19048, "WatchType10"},
	{19049, "WatchType11"},
	{19050, "WatchType12"},
	{19051, "WatchType13"},
	{19052, "WatchType14"},
	{19053, "WatchType15"},
	{19085, "EyePatch1"},
	{19086, "ChainsawDildo1"},
	{19090, "PomPomBlue"},
	{19091, "PomPomRed"},
	{19092, "PomPomGreen"},
	{19093, "HardHat2"},
	{19094, "BurgerShotHat1"},
	{19095, "CowboyHat1"},
	{19096, "CowboyHat3"},
	{19097, "CowboyHat4"},
	{19098, "CowboyHat5"},
	{19099, "PoliceCap2"},
	{19100, "PoliceCap3"},
	{19101, "ArmyHelmet1"},
	{19102, "ArmyHelmet2"},
	{19103, "ArmyHelmet3"},
	{19104, "ArmyHelmet4"},
	{19105, "ArmyHelmet5"},
	{19106, "ArmyHelmet6"},
	{19107, "ArmyHelmet7"},
	{19108, "ArmyHelmet8"},
	{19109, "ArmyHelmet9"},
	{19110, "ArmyHelmet10"},
	{19111, "ArmyHelmet11"},
	{19112, "ArmyHelmet12"},
	{19113, "SillyHelmet1"},
	{19114, "SillyHelmet2"},
	{19115, "SillyHelmet3"},
	{19116, "PlainHelmet1"},
	{19117, "PlainHelmet2"},
	{19118, "PlainHelmet3"},
	{19119, "PlainHelmet4"},
	{19120, "PlainHelmet5"},
	{19137, "CluckinBellHat1"},
	{19138, "PoliceGlasses1"},
	{19139, "PoliceGlasses2"},
	{19140, "PoliceGlasses3"},
	{19141, "SWATHelmet1"},
	{19142, "SWATArmour1"},
	{19160, "HardHat3"},
	{19161, "PoliceHat1"},
	{19162, "PoliceHat2"},
	{19163, "GimpMask1"},
	{19317, "bassguitar01"},
	{19318, "flyingv01"},
	{19319, "warlock01"},
	{19330, "fire_hat01"},
	{19331, "fire_hat02"},
	{19346, "hotdog01"},
	{19347, "badge01"},
	{19348, "cane01"},
	{19349, "monocle01"},
	{19350, "moustache01"},
	{19351, "moustache02"},
	{19352, "tophat01"},
	{19487, "tophat02"},
	{19488, "HatBowler6"},
	{19513, "whitephone"},
	{19578, "Banana"},
	{19418, "HandCuff"},
	{321, "Dildo"},
	{322, "PurpleDildo"},
	{323, "Vibrator"},
    {324, "SilverVibrator"},
	{325, "Flowers"},
	{326, "Cane"},
	{330, "CellPhone"},
	{331, "BrassKnuckle"},
	{333, "GolfClub"},
    {334, "NiteStick"},
	{335, "Knife"},
	{336, "Bat"},
	{337, "Shovel"},
    {338, "PoolCue"},
	{339, "Katana"},
	{341, "Chainsaw"},
	{342, "Grenade"},
    {343, "Teargas"},
	{344, "Molotov"},
	{345, "Missile"},
	{346, "9mm"},
    {347, "Silenced-9mm"},
	{348, "DesertEagle"},
	{349, "Shotgun"},
	{350, "Sawnoff-Shotgun"},
    {351, "Combat-Shotgun"},
	{352, "UZI"},
	{353, "MP5"},
	{354, "Flare"},
    {355, "AK-47"},
	{356, "M4"},
	{357, "Rifle"},
	{358, "SniperRifle"},
    {359, "RPG"},
	{360, "HS-Rocket"},
	{361, "Flamethrower"},
	{362, "Minigun"},
    {363, "SatchelCharge"},
	{364, "Detonator"},
	{365, "Spraycan"},
	{366, "FireEstringuisher"},
    {367, "Camera"},
	{368, "Night-Vision-Goggles"},
	{369, "InfraRed-Vision-Goggles"}
};

#if defined SAVE_ATTACHMENTS
	public OnFilterScriptInit()
	{
	    yoursql_open("server.db");
		new
		    buf[50]
		;
	    for (new i; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
	    {
	        format(buf, sizeof(buf), "attachment_slot%i", i);
			yoursql_verify_table(SQL:0, buf);
			
	        format(buf, sizeof(buf), "attachment_slot%i/user", i);
			yoursql_verify_column(SQL:0, buf, SQL_STRING);
	        format(buf, sizeof(buf), "attachment_slot%i/modelid", i);
			yoursql_verify_column(SQL:0, buf, SQL_NUMBER);
	        format(buf, sizeof(buf), "attachment_slot%i/boneid", i);
			yoursql_verify_column(SQL:0, buf, SQL_NUMBER);
	        format(buf, sizeof(buf), "attachment_slot%i/fOffsetX", i);
			yoursql_verify_column(SQL:0, buf, SQL_FLOAT);
	        format(buf, sizeof(buf), "attachment_slot%i/fOffsetY", i);
			yoursql_verify_column(SQL:0, buf, SQL_FLOAT);
	        format(buf, sizeof(buf), "attachment_slot%i/fOffsetZ", i);
			yoursql_verify_column(SQL:0, buf, SQL_FLOAT);
	        format(buf, sizeof(buf), "attachment_slot%i/fRotX", i);
			yoursql_verify_column(SQL:0, buf, SQL_FLOAT);
	        format(buf, sizeof(buf), "attachment_slot%i/fRotY", i);
			yoursql_verify_column(SQL:0, buf, SQL_FLOAT);
	        format(buf, sizeof(buf), "attachment_slot%i/fRotZ", i);
			yoursql_verify_column(SQL:0, buf, SQL_FLOAT);
	        format(buf, sizeof(buf), "attachment_slot%i/fScaleX", i);
			yoursql_verify_column(SQL:0, buf, SQL_FLOAT);
	        format(buf, sizeof(buf), "attachment_slot%i/fScaleY", i);
			yoursql_verify_column(SQL:0, buf, SQL_FLOAT);
	        format(buf, sizeof(buf), "attachment_slot%i/fScaleZ", i);
			yoursql_verify_column(SQL:0, buf, SQL_FLOAT);
		}
	    return 1;
	}
	
	public OnFilterScriptExit()
	{
	    yoursql_close(SQL:0);
	    return 1;
	}
	
	public OnPlayerSpawn(playerid)
	{
	    new
	        SQLRow:	rowid,
			        name[MAX_PLAYER_NAME],
				    buf[50]
		;
		GetPlayerName(playerid, name, MAX_PLAYER_NAME);
	    for (new i; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
	    {
	        format(buf, sizeof(buf), "attachment_slot%i", i);
			if ((rowid = yoursql_get_row(SQL:0, buf, "user = %s", name)) == SQL_INVALID_ROW)
			{
			    continue;
			}
			
			new
					    modelid,
						boneid,
				Float:	fOffsetX,
				Float:	fOffsetY,
				Float:	fOffsetZ,
				Float:	fRotX,
				Float:	fRotY,
				Float:	fRotZ,
				Float:	fScaleX,
				Float:	fScaleY,
				Float:	fScaleZ
			;
	        format(buf, sizeof(buf), "attachment_slot%i/modelid", i);
			modelid = yoursql_get_field_int(SQL:0, buf, rowid);

	        format(buf, sizeof(buf), "attachment_slot%i/boneid", i);
			boneid = yoursql_get_field_int(SQL:0, buf, rowid);

	        format(buf, sizeof(buf), "attachment_slot%i/fOffsetX", i);
			fOffsetX = yoursql_get_field_float(SQL:0, buf, rowid);
	        format(buf, sizeof(buf), "attachment_slot%i/fOffsetY", i);
			fOffsetY = yoursql_get_field_float(SQL:0, buf, rowid);
	        format(buf, sizeof(buf), "attachment_slot%i/fOffsetZ", i);
			fOffsetZ = yoursql_get_field_float(SQL:0, buf, rowid);

	        format(buf, sizeof(buf), "attachment_slot%i/fRotX", i);
			fRotX = yoursql_get_field_float(SQL:0, buf, rowid);
	        format(buf, sizeof(buf), "attachment_slot%i/fRotY", i);
			fRotY = yoursql_get_field_float(SQL:0, buf, rowid);
	        format(buf, sizeof(buf), "attachment_slot%i/fRotZ", i);
			fRotZ = yoursql_get_field_float(SQL:0, buf, rowid);

	        format(buf, sizeof(buf), "attachment_slot%i/fScaleX", i);
			fScaleX = yoursql_get_field_float(SQL:0, buf, rowid);
	        format(buf, sizeof(buf), "attachment_slot%i/fScaleY", i);
			fScaleY = yoursql_get_field_float(SQL:0, buf, rowid);
	        format(buf, sizeof(buf), "attachment_slot%i/fScaleZ", i);
			fScaleZ = yoursql_get_field_float(SQL:0, buf, rowid);
			
			SetPlayerAttachedObject(playerid, i, modelid, boneid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ);
		}
	    return 1;
	}
#endif

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	ShowPlayerDialog(playerid, DIALOG_ID_COLOR, DIALOG_STYLE_LIST, "Set attachment color:", "Materialcolor 1\nMaterialcolor 2", "Select", "Cancel");

	#if defined SAVE_ATTACHMENTS
		new
	 		SQLRow:	rowid,
			   		name[MAX_PLAYER_NAME],
			    	buf[50]
		;
		GetPlayerName(playerid, name, MAX_PLAYER_NAME);

	 	format(buf, sizeof(buf), "attachment_slot%i", index);
		if ((rowid = yoursql_get_row(SQL:0, buf, "user = %s", name)) == SQL_INVALID_ROW)
		{
			yoursql_set_row(SQL:0, buf, "user = %s", name);
			rowid = yoursql_get_row(SQL:0, buf, "user = %s", name);
		}
		format(buf, sizeof(buf), "attachment_slot%i/modelid", index);
		yoursql_set_field_int(SQL:0, buf, rowid, modelid);

		format(buf, sizeof(buf), "attachment_slot%i/boneid", index);
		yoursql_set_field_int(SQL:0, buf, rowid, boneid);

		format(buf, sizeof(buf), "attachment_slot%i/fOffsetX", index);
		yoursql_set_field_float(SQL:0, buf, rowid, fOffsetX);
	 	format(buf, sizeof(buf), "attachment_slot%i/fOffsetY", index);
		yoursql_set_field_float(SQL:0, buf, rowid, fOffsetY);
	 	format(buf, sizeof(buf), "attachment_slot%i/fOffsetZ", index);
		yoursql_set_field_float(SQL:0, buf, rowid, fOffsetZ);

		format(buf, sizeof(buf), "attachment_slot%i/fRotX", index);
		yoursql_set_field_float(SQL:0, buf, rowid, fRotX);
		format(buf, sizeof(buf), "attachment_slot%i/fRotY", index);
		yoursql_set_field_float(SQL:0, buf, rowid, fRotY);
	 	format(buf, sizeof(buf), "attachment_slot%i/fRotZ", index);
		yoursql_set_field_float(SQL:0, buf, rowid, fRotZ);

		format(buf, sizeof(buf), "attachment_slot%i/fScaleX", index);
		yoursql_set_field_float(SQL:0, buf, rowid, fScaleX);
	 	format(buf, sizeof(buf), "attachment_slot%i/fScaleY", index);
		yoursql_set_field_float(SQL:0, buf, rowid, fScaleY);
	 	format(buf, sizeof(buf), "attachment_slot%i/fScaleZ", index);
		yoursql_set_field_float(SQL:0, buf, rowid, fScaleZ);
	#endif
	
	return 1;
}

CMD:att(playerid)
{
 	new
     	buf[25 * MAX_PLAYER_ATTACHED_OBJECTS]
	;
	for (new x; x < MAX_PLAYER_ATTACHED_OBJECTS; x++)
	{
  		format(buf, sizeof(buf), "%sSlot %i%s", buf, x, (IsPlayerAttachedObjectSlotUsed(playerid, x)) ? ("{00FF00} (Used)\n") : ("\n"));
	}
  	ShowPlayerDialog(playerid, DIALOG_ID_ATTACHMENTS, DIALOG_STYLE_LIST, "Attachment slot selection:", buf, "Select", "Cancel");
	
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch (dialogid)
	{
	    case DIALOG_ID_ATTACHMENTS:
	    {
	        if (response)
	        {
	            pSlot[playerid] = listitem;

				if (IsPlayerAttachedObjectSlotUsed(playerid, listitem))
				{
				    new
				        buf[100]
					;
					format(buf, sizeof(buf), "Attachment already in use {00FF00}(slot %i):", listitem);
				    ShowPlayerDialog(playerid, DIALOG_ID_REPLACE, DIALOG_STYLE_LIST, buf, "Edit Object\nEdit Model\nDelete Object\nDuplicate Object", "Select", "Cancel");
				}
				else
				{
					const
					    size = sizeof(gAttachments)
					;
					new
					    models[size],
					    labels[size][25]
					;
					for (new x; x < size; x++)
					{
					    models[x] = gAttachments[x][attachModel];
					    strcat(labels[x], gAttachments[x][attachName]);
					}
					ShowPlayerPreviewModelDialog(playerid, DIALOG_ID_SEARCH, DIALOG_STYLE_PREVMODEL, "Model selection:", models, labels, "Select", "Cancel");
	        	}
	        }
	    }
		case DIALOG_ID_SEARCH:
		{
		    if (response)
		    {
				pSelected[playerid] = listitem;

			    ShowPlayerDialog(playerid, DIALOG_ID_BONE, DIALOG_STYLE_TABLIST, "Bone selection:", "Spine\nHead\nLeft upper arm\nRight upper arm\nLeft hand\nRight hand\nLeft thigh\nRight thigh\nLeft foot\nRight foot\nRight calf\nLeft calf\nLeft forearm\nRight forearm\nLeft clavicle\nRight clavicle\nNeck\nJaw", "Edit", "Back");
			}
		}
		case DIALOG_ID_BONE:
		{
		    if (response)
		    {
		        SetPlayerAttachedObject(playerid, pSlot[playerid], gAttachments[pSelected[playerid]][attachModel], listitem + 1);
		        EditAttachedObject(playerid, pSlot[playerid]);

                SendClientMessage(playerid, 0x00FF00FF, "ATTACHMENT: {FFFFFF}Use {FFFF00}~k~~PED_SPRINT~ {FFFFFF}to look around while editing, Press {FFFF00}ESC {FFFFFF}to quick save and quit editing.");
   			}
		    else
		    {
				const
				    __size = sizeof(gAttachments)
				;
				new
				    __models[__size],
				    __labels[__size][25]
				;
				for (new i; i < __size; i++)
				{
				    __models[i] = gAttachments[i][attachModel];
				    strcat(__labels[i], gAttachments[i][attachName]);
				}
				return ShowPlayerPreviewModelDialog(playerid, DIALOG_ID_SEARCH, DIALOG_STYLE_PREVMODEL, "Model selection:", __models, __labels, "Select", "Cancel");
			}
		}
		case DIALOG_ID_REPLACE:
		{
		    if (response)
		    {
		        switch (listitem)
		        {
		            case 0:
		            {
				        EditAttachedObject(playerid, pSlot[playerid]);

		                SendClientMessage(playerid, 0x00FF00FF, "ATTACHMENT: {FFFFFF}Use {FFFF00}~k~~PED_SPRINT~ {FFFFFF}to look around while editing, Press {FFFF00}ESC {FFFFFF}to quick save and quit editing.");
			        }
			        case 1:
			        {
			            const
						    _size = sizeof(gAttachments)
						;
						new
						    _models[_size],
						    _labels[_size][25]
						;
						for (new i; i < _size; i++)
						{
						    _models[i] = gAttachments[i][attachModel];
						    strcat(_labels[i], gAttachments[i][attachName]);
						}
						return ShowPlayerPreviewModelDialog(playerid, DIALOG_ID_EDIT_MODEL, DIALOG_STYLE_PREVMODEL, "Edit attachment model:", _models, _labels, "Change", "Cancel");
			        }
		            case 2:
		            {
				        new
							text[150]
						;
						format(text, sizeof(text), "ATTACHMENT: {FFFFFF}You have deleted the attachment from slot %i.", pSlot[playerid]);
						SendClientMessage(playerid, 0x00FF00FF, text);

						RemovePlayerAttachedObject(playerid, pSlot[playerid]);

						#if defined SAVE_ATTACHMENTS
							new
						 		SQLRow:	rowid,
								   		name[MAX_PLAYER_NAME],
								    	buf[50]
							;
							GetPlayerName(playerid, name, MAX_PLAYER_NAME);

						 	format(buf, sizeof(buf), "attachment_slot%i", pSlot[playerid]);
							if ((rowid = yoursql_get_row(SQL:0, buf, "user = %s", name)) != SQL_INVALID_ROW)
							{
								yoursql_delete_row(SQL:0, buf, rowid);
							}
						#endif
					}
					case 3:
					{
					    return ShowPlayerDialog(playerid, DIALOG_ID_DUPLICATE, DIALOG_STYLE_INPUT, "Duplicate attachment:", "{FFFFFF}Insert an attachment slot you want to duplicate this object to.\n\nNOTE: The slot must be empty.", "Duplicate", "Cancel");
					}
				}
		    }
		}
		case DIALOG_ID_EDIT_MODEL:
		{
		    if (response)
		    {
		        new
						    modelid,
							boneid,
					Float:	fOffsetX,
					Float:	fOffsetY,
					Float:	fOffsetZ,
					Float:	fRotX,
					Float:	fRotY,
					Float:	fRotZ,
					Float:	fScaleX,
					Float:	fScaleY,
					Float:	fScaleZ,
							color1,
							color2
				;
		        GetPlayerAttachedObject(playerid, pSlot[playerid], modelid, boneid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ, color1, color2);
		        SetPlayerAttachedObject(playerid, pSlot[playerid], gAttachments[listitem][attachModel], boneid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ, color1, color2);

				new
					text[150]
				;
				format(text, sizeof(text), "ATTACHMENT: {FFFFFF}You have edited the modelid of attachment slot %i.", pSlot[playerid]);
				SendClientMessage(playerid, 0x00FF00FF, text);
		    }
		}
		case DIALOG_ID_DUPLICATE:
		{
		    if (response)
		    {
				if (inputtext[0] == ' ' || ! inputtext[0])
				{
				    ShowPlayerDialog(playerid, DIALOG_ID_DUPLICATE, DIALOG_STYLE_INPUT, "Duplicate attachment:", "{FFFFFF}Insert an attachment slot you want to duplicate this object to.\n\nNOTE: The slot must be empty.", "Duplicate", "Cancel");
				    return SendClientMessage(playerid, 0xFF0000FF, "ERROR: {FFFFFF}You cannot leave the box blank.");
				}
				
		        new
		            duplicate = strval(inputtext)
				;
                if (duplicate < 0 || duplicate >= MAX_PLAYER_ATTACHED_OBJECTS)
				{
				    ShowPlayerDialog(playerid, DIALOG_ID_DUPLICATE, DIALOG_STYLE_INPUT, "Duplicate attachment:", "{FFFFFF}Insert an attachment slot you want to duplicate this object to.\n\nNOTE: The slot must be empty.", "Duplicate", "Cancel");
				    return SendClientMessage(playerid, 0xFF0000FF, "ERROR: {FFFFFF}The attachment slot must be between 0 - "#MAX_PLAYER_ATTACHED_OBJECTS - 1".");
				}
				
				if (IsPlayerAttachedObjectSlotUsed(playerid, duplicate))
				{
				    ShowPlayerDialog(playerid, DIALOG_ID_DUPLICATE, DIALOG_STYLE_INPUT, "Duplicate attachment:", "{FFFFFF}Insert an attachment slot you want to duplicate this object to.\n\nNOTE: The slot must be empty.", "Duplicate", "Cancel");
				    return SendClientMessage(playerid, 0xFF0000FF, "ERROR: {FFFFFF}The slot specigfied is already used, please insert an empty one.");
				}
				
		        new
						    modelid,
							boneid,
					Float:	fOffsetX,
					Float:	fOffsetY,
					Float:	fOffsetZ,
					Float:	fRotX,
					Float:	fRotY,
					Float:	fRotZ,
					Float:	fScaleX,
					Float:	fScaleY,
					Float:	fScaleZ,
							color1,
							color2
				;
		        GetPlayerAttachedObject(playerid, pSlot[playerid], modelid, boneid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ, color1, color2);
		        SetPlayerAttachedObject(playerid, duplicate, modelid, boneid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ, color1, color2);

				new
					text[150]
				;
				format(text, sizeof(text), "ATTACHMENT: {FFFFFF}You have duplicated attachment slot %i to new slot %i.", pSlot[playerid], duplicate);
				SendClientMessage(playerid, 0x00FF00FF, text);
		    }
		}
		case DIALOG_ID_COLOR:
		{
		    if (response)
		    {
		        pColor[playerid] = listitem;
		        
		        new
		            colors[500]
				;
				strcat(colors, "Custom Color (hex value)\n");
				strcat(colors, "{FFFFFF}White\n");
			    strcat(colors, "{000000}Black\n");
			    strcat(colors, "{808080}Grey\n");
			    strcat(colors, "{008080}Teal\n");
			    strcat(colors, "{003366}Navy blue\n");
			    strcat(colors, "{3366CC}Sky blue\n");
			    strcat(colors, "{000099}Dark blue\n");
			    strcat(colors, "{3399FF}Light blue\n");
			    strcat(colors, "{6600CC}Dark purple\n");
			    strcat(colors, "{6600FF}Purple\n");
			    strcat(colors, "{6666FF}Light purple\n");
			    strcat(colors, "{00FFFF}Cyan\n");
			    strcat(colors, "{00FFCC}Aqua\n");
			    strcat(colors, "{00CC99}Poision green\n");
			    strcat(colors, "{006666}Lawn green\n");
			    strcat(colors, "{00CC00}Green\n");
			    strcat(colors, "{CC99FF}Pink\n");
			    strcat(colors, "{FF99FF}Hot pink\n");
			    strcat(colors, "{FFFF99}Light yellow\n");
			    strcat(colors, "{FFFF66}Yellow\n");
			    strcat(colors, "{FF9933}Orange\n");
			    strcat(colors, "{660033}Magenta\n");
			    strcat(colors, "{800000}Marone\n");
			    strcat(colors, "{FF0000}Red\n");
			    strcat(colors, "{CC0000}Dark red\n");
			    strcat(colors, "{999966}Khaki\n");
			    strcat(colors, "{993333}Coral\n");
			    strcat(colors, "{CCFF99}Lime\n");
			    strcat(colors, "{663300}Brown\n");
			    strcat(colors, "{A9C4E4}SA-MP Blue");
		        if (! listitem)
		        {
		        	ShowPlayerDialog(playerid, DIALOG_ID_COLOR_LIST, DIALOG_STYLE_LIST, "Color selection ({00FF00}Materialcolor 1{FFFFFF}):", colors, "Set", "Back");
		        }
		        else
		        {
		        	ShowPlayerDialog(playerid, DIALOG_ID_COLOR_LIST, DIALOG_STYLE_LIST, "Color selection ({00FF00}Materialcolor 2{FFFFFF}):", colors, "Set", "Back");
		    	}
		    }
		}
		case DIALOG_ID_COLOR_LIST:
		{
		    if (response)
		    {
		        new
		            newcolor
				;
		        switch (listitem)
		        {
		            case 0:
		            {
		                ShowPlayerDialog(playerid, DIALOG_ID_CUSTOM_COLOR, DIALOG_STYLE_INPUT, "Custom color ({00FF00}Materialcolor 1{FFFFFF}):", "{FFFFFF}Insert an hex color value to set it as your object's material color:", "Set", "Back");
		            }
					case 1:
					{
						newcolor = 0xFFFFFFFF;
						SendClientMessage(playerid, 0x00FF00FF, "ATTACHMENT: {FFFFFF}You have changeed the object material colot to \"WHITE\".");
		            }
				    case 2:
					{
						newcolor = 0x000000FF;
						SendClientMessage(playerid, 0x00FF00FF, "ATTACHMENT: {FFFFFF}You have changeed the object material colot to \"BLACK\".");
		            }
				    case 3:
					{
						newcolor = 0x808080FF;
						SendClientMessage(playerid, 0x00FF00FF, "ATTACHMENT: {FFFFFF}You have changeed the object material colot to \"GREY\".");
		            }
				    case 4:
					{
						newcolor = 0x008080FF;
						SendClientMessage(playerid, 0x00FF00FF, "ATTACHMENT: {FFFFFF}You have changeed the object material colot to \"TEAL\".");
		            }
				    case 5:
					{
						newcolor = 0x003366FF;
						SendClientMessage(playerid, 0x00FF00FF, "ATTACHMENT: {FFFFFF}You have changeed the object material colot to \"NAVY BLUE\".");
		            }
				    case 6:
					{
						newcolor = 0x3366CCFF;
						SendClientMessage(playerid, 0x00FF00FF, "ATTACHMENT: {FFFFFF}You have changeed the object material colot to \"SKY BLUE\".");
		            }
				    case 7:
					{
						newcolor = 0x000099FF;
						SendClientMessage(playerid, 0x00FF00FF, "ATTACHMENT: {FFFFFF}You have changeed the object material colot to \"DARK BLUE\".");
		            }
				    case 8:
					{
						newcolor = 0x3399FFFF;
						SendClientMessage(playerid, 0x00FF00FF, "ATTACHMENT: {FFFFFF}You have changeed the object material colot to \"LIGHT BLUE\".");
		            }
				    case 9:
					{
						newcolor = 0x6600CCFF;
						SendClientMessage(playerid, 0x00FF00FF, "ATTACHMENT: {FFFFFF}You have changeed the object material colot to \"DARK PURPLE\".");
		            }
				    case 10:
					{
						newcolor = 0x6600FFFF;
						SendClientMessage(playerid, 0x00FF00FF, "ATTACHMENT: {FFFFFF}You have changeed the object material colot to \"PURPLE\".");
		            }
				    case 11:
					{
						newcolor = 0x6666FFFF;
						SendClientMessage(playerid, 0x00FF00FF, "ATTACHMENT: {FFFFFF}You have changeed the object material colot to \"LIGHT PURPLE\".");
		            }
				    case 12:
					{
						newcolor = 0x00FFFFFF;
						SendClientMessage(playerid, 0x00FF00FF, "ATTACHMENT: {FFFFFF}You have changeed the object material colot to \"CYAN\".");
		            }
				    case 13:
					{
						newcolor = 0x00FFCCFF;
					 	SendClientMessage(playerid, 0x00FF00FF, "ATTACHMENT: {FFFFFF}You have changeed the object material colot to \"AQUA\".");
		            }
				    case 14:
					{
						newcolor = 0x00CC99FF;
						SendClientMessage(playerid, 0x00FF00FF, "ATTACHMENT: {FFFFFF}You have changeed the object material colot to \"POISION GREEN\".");
		            }
				    case 15:
					{
						newcolor = 0x006666FF;
						SendClientMessage(playerid, 0x00FF00FF, "ATTACHMENT: {FFFFFF}You have changeed the object material colot to \"LAWN GREEN\".");
		            }
				    case 16:
					{
						newcolor = 0x00CC00FF;
						SendClientMessage(playerid, 0x00FF00FF, "ATTACHMENT: {FFFFFF}You have changeed the object material colot to \"GREEN\".");
		            }
				    case 17:
					{
						newcolor = 0xCC99FFFF;
						SendClientMessage(playerid, 0x00FF00FF, "ATTACHMENT: {FFFFFF}You have changeed the object material colot to \"PINK\".");
		            }
				    case 18:
					{
						newcolor = 0xFF99FFFF;
						SendClientMessage(playerid, 0x00FF00FF, "ATTACHMENT: {FFFFFF}You have changeed the object material colot to \"HOT PINK\".");
		            }
				    case 19:
					{
						newcolor = 0xFFFF99FF;
						SendClientMessage(playerid, 0x00FF00FF, "ATTACHMENT: {FFFFFF}You have changeed the object material colot to \"LIGHT YELLOW\".");
		            }
				    case 20:
					{
						newcolor = 0xFFFF66FF;
						SendClientMessage(playerid, 0x00FF00FF, "ATTACHMENT: {FFFFFF}You have changeed the object material colot to \"YELLOW\".");
		            }
				    case 21:
					{
						newcolor = 0xFF9933FF;
						SendClientMessage(playerid, 0x00FF00FF, "ATTACHMENT: {FFFFFF}You have changeed the object material colot to \"ORANGE\".");
		            }
				    case 22:
					{
						newcolor = 0x660033FF;
						SendClientMessage(playerid, 0x00FF00FF, "ATTACHMENT: {FFFFFF}You have changeed the object material colot to \"MAGENTA\".");
		            }
				    case 23:
					{
						newcolor = 0x800000FF;
						SendClientMessage(playerid, 0x00FF00FF, "ATTACHMENT: {FFFFFF}You have changeed the object material colot to \"MARONE\".");
		            }
				    case 24:
					{
						newcolor = 0xFF0000FF;
						SendClientMessage(playerid, 0x00FF00FF, "ATTACHMENT: {FFFFFF}You have changeed the object material colot to \"RED\".");
		            }
				    case 25:
					{
						newcolor = 0xCC0000FF;
						SendClientMessage(playerid, 0x00FF00FF, "ATTACHMENT: {FFFFFF}You have changeed the object material colot to \"DARK RED\".");
		            }
				    case 26:
					{
						newcolor = 0x999966FF;
						SendClientMessage(playerid, 0x00FF00FF, "ATTACHMENT: {FFFFFF}You have changeed the object material colot to \"KHAKI\".");
		            }
				    case 27:
					{
						newcolor = 0x993333FF;
						SendClientMessage(playerid, 0x00FF00FF, "ATTACHMENT: {FFFFFF}You have changeed the object material colot to \"CORAL\".");
		            }
				    case 28:
					{
						newcolor = 0xCCFF99FF;
						SendClientMessage(playerid, 0x00FF00FF, "ATTACHMENT: {FFFFFF}You have changeed the object material colot to \"LIME\".");
		            }
				    case 29:
					{
						newcolor = 0x663300FF;
						SendClientMessage(playerid, 0x00FF00FF, "ATTACHMENT: {FFFFFF}You have changeed the object material colot to \"BROWN\".");
		            }
				    case 30:
					{
						newcolor = 0xA9C4E4FF;
						SendClientMessage(playerid, 0x00FF00FF, "ATTACHMENT: {FFFFFF}You have changeed the object material colot to \"SAMP BLUE\".");
		            }
				}
				
				new
						    modelid,
							boneid,
					Float:	fOffsetX,
					Float:	fOffsetY,
					Float:	fOffsetZ,
					Float:	fRotX,
					Float:	fRotY,
					Float:	fRotZ,
					Float:	fScaleX,
					Float:	fScaleY,
					Float:	fScaleZ,
							color1,
							color2
				;
		        GetPlayerAttachedObject(playerid, pSlot[playerid], modelid, boneid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ, color1, color2);
		        SetPlayerAttachedObject(playerid, pSlot[playerid], modelid, boneid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ, (! pColor[playerid]) ? newcolor : color1, (pColor[playerid]) ? newcolor : color2);
			}

			ShowPlayerDialog(playerid, DIALOG_ID_COLOR, DIALOG_STYLE_LIST, "Set attachment color:", "Materialcolor 1\nMaterialcolor 2", "Select", "Cancel");
		}
		case DIALOG_ID_CUSTOM_COLOR:
		{
		    if (response)
		    {
		        new
					red[3],
					green[3],
					blue[3],
					alpha[3]
				;

	           	if (inputtext[0] == '0' && inputtext[1] == 'x') //using 0xFFFFFF format
	            {
	            	if (strlen(inputtext) != 8 && strlen(inputtext) != 10)
					{
					    SendClientMessage(playerid, 0xFF0000FF, "ERROR: {FFFFFF}You have entered an invalid hex color value.");
						return ShowPlayerDialog(playerid, DIALOG_ID_CUSTOM_COLOR, DIALOG_STYLE_INPUT, "Custom color ({00FF00}Materialcolor 1{FFFFFF}):", "{FFFFFF}Insert an hex color value to set it as your object's material color:", "Set", "Back");
	                }
					else
	                {
		             	format(red, sizeof(red), "%c%c", inputtext[2], inputtext[3]);
		                format(green, sizeof(green), "%c%c", inputtext[4], inputtext[5]);
		                format(blue, sizeof(blue), "%c%c", inputtext[6], inputtext[7]);
		               	if (inputtext[8] != '\0')
	                 	{
					 		format(alpha, sizeof(alpha), "%c%c", inputtext[8], inputtext[9]);
						}
						else
						{
						    alpha = "FF";
						}
	                }
	     		}
				else if (inputtext[0] == '#') //using #FFFFFF format
	            {
	            	if (strlen(inputtext) != 7 && strlen(inputtext) != 9)
					{
					    SendClientMessage(playerid, 0xFF0000FF, "ERROR: {FFFFFF}You have entered an invalid hex color value.");
						return ShowPlayerDialog(playerid, DIALOG_ID_CUSTOM_COLOR, DIALOG_STYLE_INPUT, "Custom color ({00FF00}Materialcolor 1{FFFFFF}):", "{FFFFFF}Insert an hex color value to set it as your object's material color:", "Set", "Back");
	                }
	                else
	                {
	     				format(red, sizeof(red), "%c%c", inputtext[1], inputtext[2]);
		                format(green, sizeof(green), "%c%c", inputtext[3], inputtext[4]);
		                format(blue, sizeof(blue), "%c%c", inputtext[5], inputtext[6]);
		                if (inputtext[7] != '\0')
	                 	{
						 	format(alpha, sizeof(alpha), "%c%c", inputtext[7], inputtext[8]);
						}
						else
						{
						    alpha = "FF";
						}
	                }
	  			}
			  	else //using FFFFFF format
	            {
	            	if (strlen(inputtext) != 6 && strlen(inputtext) != 8)
					{
					    SendClientMessage(playerid, 0xFF0000FF, "ERROR: {FFFFFF}You have entered an invalid hex color value.");
						return ShowPlayerDialog(playerid, DIALOG_ID_CUSTOM_COLOR, DIALOG_STYLE_INPUT, "Custom color ({00FF00}Materialcolor 1{FFFFFF}):", "{FFFFFF}Insert an hex color value to set it as your object's material color:", "Set", "Back");
	                }
	                else
	                {
		            	format(red, sizeof(red), "%c%c", inputtext[0], inputtext[1]);
		                format(green, sizeof(green), "%c%c", inputtext[2], inputtext[3]);
		                format(blue, sizeof(blue), "%c%c", inputtext[4], inputtext[5]);
	                 	if (inputtext[6] != '\0')
		                {
							format(alpha, sizeof(alpha), "%c%c", inputtext[6], inputtext[7]);
						}
						else
						{
						    alpha = "FF";
						}
	                }
				}

				new
				            newcolor = RGB(HexToInt(red), HexToInt(green), HexToInt(blue), HexToInt(alpha)),
				    		modelid,
							boneid,
					Float:	fOffsetX,
					Float:	fOffsetY,
					Float:	fOffsetZ,
					Float:	fRotX,
					Float:	fRotY,
					Float:	fRotZ,
					Float:	fScaleX,
					Float:	fScaleY,
					Float:	fScaleZ,
							color1,
							color2
				;
	   			GetPlayerAttachedObject(playerid, pSlot[playerid], modelid, boneid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ, color1, color2);
			    SetPlayerAttachedObject(playerid, pSlot[playerid], modelid, boneid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ, (! pColor[playerid]) ? newcolor : color1, (pColor[playerid]) ? newcolor : color2);
			}

			ShowPlayerDialog(playerid, DIALOG_ID_COLOR, DIALOG_STYLE_LIST, "Set attachment color:", "Materialcolor 1\nMaterialcolor 2", "Select", "Cancel");
		}
	}
	
	return 1;
}

RGB(red, green, blue, alpha)
{
	return (red * 16777216) + (green * 65536) + (blue * 256) + alpha;
}

HexToInt(string[])
{
  	if (! string[0])
	{
		return 0;
  	}

  	new
	  	cur = 1,
	  	res = 0
	;
  	for (new i = strlen(string); i > 0; i--)
  	{
    	if (string[i - 1] < 58)
		{
			res = res + cur * (string[i - 1] - 48);
		}
		else
		{
			res = res + cur * (string[i - 1] - 65 + 10);
    	}
		cur = cur * 16;
	}
	return res;
}
