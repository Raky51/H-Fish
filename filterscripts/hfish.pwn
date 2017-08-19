/*
			---------------------------------------------
			H-Fishing system
			---------------------------------------------
			Author: HoussemGaming
			---------------------------------------------
			Credits:
				- SA-MP Team - a_samp
				- Zeex - ZCMD
				- Iconginto - Streamer
				HoussemGaming - Making this :D
			Credits:
			---------------------------------------------	
			Please don't remove the credits
			---------------------------------------------
*/
//--------------------------------------------------
#include <a_samp>
#include <zcmd>
#include <streamer>
//--------------------------------------------------
#define Tuna_Weight 50
#define Salmon_Weight 30
#define Shark_Weight 70

#define Rod_1_Price 300
#define Rod_2_Price 200
#define Rod_3_Price 100

#define Rod_1_Weight 1000
#define Rod_2_Weight 700
#define Rod_3_Weight 500	
//--------------------------------------------------
new bool:IsFishing[MAX_PLAYERS];
new Rod[MAX_PLAYERS];
new Weight[MAX_PLAYERS];
new pickup;
new cpgo;
new cpunload;

//--------------------------------------------------
#define 		COLOR_WHITE 		0xFFFFFFAA
#define 		COLOR_BLACK 		0x000000FF
#define 		COLOR_GREY			0xB4B5B7FF
#define 		COLOR_YELLOW 		0xFFFF00AA
#define 		COLOR_RED 			0xAA3333AA
#define 		COLOR_ORANGE 		0xF69521AA
#define 		COLOR_GREEN 		0x33AA33AA
#define 		COLOR_PURPLE 		0xC2A2DAAA
#define			COLOR_CYAN 			0x00FFFFFF
#define 		COLOR_GOLD	 		0xFFD700FF
#define 		COLOR_LIME 			0x00FF00FF
#define 		COLOR_TEAL          0x008080AA
#define 		COLOR_HOTPINK 		0xFF69B4FF
#define 		COLOR_LAVENDER 		0xE6E6FAFF
#define 		COLOR_LIGHTRED 		0xFF6347AA
#define 		COLOR_CYANBLUE	 	0x01FCFFC8
#define 		COLOR_LIGHTBLUE 	0x33CCFFAA
//--------------------------------------------------
public OnFilterScriptInit()
{
	pickup = CreatePickup(1239, 2, 359.3320,-2032.2393,7.8359);
	print("\nH-Fishing system has been loaded successfully\n");
	return 1;
}		
public OnFilterScriptExit()
{
	DestroyPickup(pickup);
	return 1;
}
public OnPlayerPickUpPickup(playerid, pickupid)
{
	if(pickupid == pickup)
	{
		ShowPlayerDialog(playerid, 987, DIALOG_STYLE_LIST, "Buy Rod", "Small Rod\nMedium Rod\nBig Rod", "Select", "Close");
		return 1;
	}
	return 1;
}
public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
	if(checkpointid == cpgo)
	{
		GameTextForPlayer(playerid, "~g~You found it", 1000, 3);
		IsFishing[playerid] = true;
		DestroyDynamicCP(cpgo);
		RemovePlayerMapIcon(playerid, 1);
		return 1;
	}	
	else if(checkpointid == cpunload)
	{
		GameTextForPlayer(playerid, "~g~You found it", 1000, 3);
		DestroyDynamicCP(cpunload);
		IsFishing[playerid] = false;
		RemovePlayerMapIcon(playerid, 2);
		return 1;
	}	
	return 1;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == 987)
	{
		if(!response) return 1;
		if(Rod[playerid] != 0) return SendClientMessage(playerid, COLOR_RED, "You already have a Rod");
		if(listitem == 0)
		{
			if(GetPlayerMoney(playerid) < Rod_3_Price) return SendClientMessage(playerid, COLOR_RED, "You don't have enough money to buy this !");
			Rod[playerid] = 3;
			GivePlayerMoney(playerid, -Rod_3_Price);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "You have purchased the small Rod");
			return 1;
		}	
		if(listitem == 1)
		{
			if(GetPlayerMoney(playerid) < Rod_2_Price) return SendClientMessage(playerid, COLOR_RED, "You don't have enough money to buy this !");
			Rod[playerid] = 2;
			GivePlayerMoney(playerid, -Rod_2_Price);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "You have purchased the medium Rod");
			return 1;
		}	
		if(listitem == 2)
		{
			if(GetPlayerMoney(playerid) < Rod_1_Price) return SendClientMessage(playerid, COLOR_RED, "You don't have enough money to buy this !");
			Rod[playerid] = 1;
			GivePlayerMoney(playerid, -Rod_1_Price);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "You have purchased the big Rod");
			return 1;
		}	
	}
	return 1;
}
public OnPlayerConnect(playerid)
{
	Rod[playerid] = 0;
	Weight[playerid] = 0;
	IsFishing[playerid] = false;
	return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
	Rod[playerid] = 0;
	Weight[playerid] = 0;
	IsFishing[playerid] = false;
	return 1;
}
public OnPlayerDeath(playerid)
{
	Rod[playerid] = 0;
	Weight[playerid] = 0;
	IsFishing[playerid] = false;
	return 1;
}
//--------------------------------------------------
CMD:gofish(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 383.3044,-2088.7949,7.8359))
	{
		if(IsFishing[playerid] == true) return SendClientMessage(playerid, COLOR_RED, "You are already in the fishing job");
		cpgo = CreateDynamicCP(383.3044,-2088.7949,7.8359, 1.8);
		SetPlayerMapIcon(playerid, 1, 383.3044,-2088.7949,7.8359, 0, 0);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "The fishing location is marked at your map.");
		return 1;
	}	
	else
	{
		if(IsFishing[playerid] == true) return SendClientMessage(playerid, COLOR_RED, "You are already in the fishing job");
		SendClientMessage(playerid, COLOR_ORANGE, "You are now fishing !");
		ApplyAnimation(playerid,"SWORD","sword_block",50.0 ,0,1,0,1,1);
		IsFishing[playerid] = true;
		return 1;
	}
}
CMD:stopfish(playerid, params[])
{
	if(IsFishing[playerid] == false) return SendClientMessage(playerid, COLOR_RED, "You are not in fishing job");
	IsFishing[playerid] = false;
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "You have stopped fishing !");
	return 1;
}
CMD:fish(playerid, params[])
{
	new string[56];
	if(IsFishing[playerid] == false) return SendClientMessage(playerid, COLOR_RED, "You are not in fishing job");
	if(Rod[playerid] == 0) return SendClientMessage(playerid, COLOR_RED, "You don't have a rod !");
	new rand = randomEx(30, 80);
	switch (rand)
	{
		case 30 .. 49:
		{
			format(string, 56, "*You have caught a Salmon, it's weight is %iKG", rand);
			SendClientMessage(playerid, COLOR_PURPLE, string);
			Weight[playerid] += rand;
			if(Rod[playerid] == 1 && Weight[playerid] > Rod_1_Weight || Rod[playerid] == 2 && Weight[playerid] > Rod_2_Weight || Rod[playerid] == 3 && Weight[playerid] > Rod_3_Weight)
			{
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "Your rod is full, Go to unload point to unload fish");
				IsFishing[playerid] = false;
				cpunload = CreateDynamicCP(2473.6323,-2710.8103,3.1963, 1.8);
				SetPlayerMapIcon(playerid, 1, 2473.6323,-2710.8103,3.1963, 0, 0);
				return 1;
			}
			return 1;
		}
		case 50 .. 69:
		{
			format(string, 56, "*You have caught a Tuna, it's weight is %iKG", rand);
			SendClientMessage(playerid, COLOR_PURPLE, string);
			Weight[playerid] += rand;
			if(Rod[playerid] == 1 && Weight[playerid] > Rod_1_Weight || Rod[playerid] == 2 && Weight[playerid] > Rod_2_Weight || Rod[playerid] == 3 && Weight[playerid] > Rod_3_Weight)
			{
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "Your rod is full, Go to unload point to unload fish");
				IsFishing[playerid] = false;
				cpunload = CreateDynamicCP(2473.6323,-2710.8103,3.1963, 1.8);
				SetPlayerMapIcon(playerid, 1, 2473.6323,-2710.8103,3.1963, 0, 0);
				return 1;
			}
			return 1;
		}
		case 70 .. 80:
		{
			format(string, 56, "*You have caught a Shark, it's weight is %iKG", rand);
			SendClientMessage(playerid, COLOR_PURPLE, string);
			Weight[playerid] += rand;
			if(Rod[playerid] == 1 && Weight[playerid] > Rod_1_Weight || Rod[playerid] == 2 && Weight[playerid] > Rod_2_Weight || Rod[playerid] == 3 && Weight[playerid] > Rod_3_Weight)
			{
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "Your rod is full, Go to unload point to unload fish");
				IsFishing[playerid] = false;
				cpunload = CreateDynamicCP(2473.6323,-2710.8103,3.1963, 1.8);
				SetPlayerMapIcon(playerid, 1, 2473.6323,-2710.8103,3.1963, 0, 0);
				return 1;
			}
			return 1;
		}
	}
	return 1;
}
CMD:myfish(playerid, params[])
{
	new string[100];
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "-------------------------------------------");
	format(string, 100, "You have the Rod number %i", Rod[playerid]);
	SendClientMessage(playerid, COLOR_GREEN, string);
	format(string, 100, "You have in total %i KG of fish", Weight[playerid]);
	SendClientMessage(playerid, COLOR_GREEN, string);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "-------------------------------------------");
	return 1;
}
CMD:unloadfish(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 3.0, 2473.6323,-2710.8103,3.1963))
	{
		new string[50];
		new rand = randomEx(500, 1500);
		Weight[playerid] = 0;
		Rod[playerid] = 0;
		IsFishing[playerid] = false;
		GivePlayerMoney(playerid, rand);
		format(string, 50, "You get $%i for unloading the fish", rand);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
		return 1;
	}	
	else
	{
		cpunload = CreateDynamicCP(2473.6323,-2710.8103,3.1963, 1.8);
		SetPlayerMapIcon(playerid, 1, 2473.6323,-2710.8103,3.1963, 0, 0);
		SendClientMessage(playerid, COLOR_ORANGE, "Go to the checkpoint to unload your fish");
		return 1;
	}
}
CMD:buyrod(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 3.0, 359.3320,-2032.2393,7.8359))
	{
		ShowPlayerDialog(playerid, 987, DIALOG_STYLE_LIST, "Buy Rod", "Small Rod\nMedium Rod\nBig Rod", "Select", "Close");
	}	
	else
	{
		SendClientMessage(playerid, COLOR_RED, "You are not near the Rod buy center");
	}
	return 1;
}
stock randomEx(min, max)
{    
    //Credits to y_less    
    new rand = random(max-min)+min;    
    return rand;
}
//--------------------------------------------------
