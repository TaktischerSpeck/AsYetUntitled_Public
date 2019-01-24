#include "..\..\script_macros.hpp"
/*
    File: fn_blastingCharge.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Blasting charge is used for the federal reserve vault and nothing  more.. Yet.
*/
private ["_vault","_handle"];
_vault = param [0,ObjNull,[ObjNull]];

if (isNull _vault) exitWith {}; //Bad object
if (typeOf _vault != "Land_CargoBox_V1_F") exitWith {[ localize "STR_ISTR_Blast_VaultOnly",true,"fast"] call AYU_Client_fnc_notification_system;};
if (_vault getVariable ["chargeplaced",false]) exitWith {[ localize "STR_ISTR_Blast_AlreadyPlaced",true,"fast"] call AYU_Client_fnc_notification_system;};
if (_vault getVariable ["safe_open",false]) exitWith {[ localize "STR_ISTR_Blast_AlreadyOpen",true,"fast"] call AYU_Client_fnc_notification_system;};
if (west countSide playableUnits < (LIFE_SETTINGS(getNumber,"minimum_cops"))) exitWith {
     [ format [localize "STR_Civ_NotEnoughCops",(LIFE_SETTINGS(getNumber,"minimum_cops"))],true,"fast"] call AYU_Client_fnc_notification_system;
};

private _vaultHouse = [[["WL_Rosche", "Land_Medevac_house_V1_F"]]] call TON_fnc_terrainSort;
private _WL_RoscheArray = [11074.2,11501.5,0.00137329];
private _pos = [[["WL_Rosche", _WL_RoscheArray]]] call TON_fnc_terrainSort;

if ((nearestObject [_pos,_vaultHouse]) getVariable ["locked",true]) exitWith {[ localize "STR_ISTR_Blast_Exploit",true,"fast"] call AYU_Client_fnc_notification_system;};
if (!([false,"blastingcharge",1] call life_fnc_handleInv)) exitWith {}; //Error?

_vault setVariable ["chargeplaced",true,true];
[0,"STR_ISTR_Blast_Placed",true,[]] remoteExecCall ["life_fnc_broadcast",west];
[ localize "STR_ISTR_Blast_KeepOff",true,"fast"] call AYU_Client_fnc_notification_system;

[] remoteExec ["life_fnc_demoChargeTimer",[west,player]];
[] remoteExec ["TON_fnc_handleBlastingCharge",2];
