#include "..\..\script_macros.hpp"
/*
    File: fn_serviceChopper.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Main functionality for the chopper service paid, to be replaced in later version.
*/
private ["_serviceCost"];
disableSerialization;
private ["_search","_ui","_progress","_cP","_pgText"];
if (life_action_inUse) exitWith {[ localize "STR_NOTF_Action",false,"fast"] call AYU_Client_fnc_notification_system;};

_serviceCost = LIFE_SETTINGS(getNumber,"service_chopper");
_search = nearestObjects[getPos air_sp, ["Air"],10];

if (count _search isEqualTo 0) exitWith {[ localize "STR_Service_Chopper_NoAir",false,"fast"] call AYU_Client_fnc_notification_system;};
if (CASH < _serviceCost) exitWith {[ localize "STR_Serive_Chopper_NotEnough",false,"fast"] call AYU_Client_fnc_notification_system;};

life_action_inUse = true;
"progressBar" cutRsc ["life_progress","PLAIN"];
_ui = uiNamespace getVariable "life_progress";
_progress = _ui displayCtrl 38201;
_pgText = _ui displayCtrl 38202;
_pgText ctrlSetText format [localize "STR_Service_Chopper_Servicing","waiting..."];
_progress progressSetPosition 0.01;
_cP = 0.01;

for "_i" from 0 to 1 step 0 do {
    uiSleep  0.2;
    _cP = _cP + 0.01;
    _progress progressSetPosition _cP;
    _pgText ctrlSetText format [localize "STR_Service_Chopper_Servicing",round(_cP * 100)];
    if (_cP >= 1) exitWith {};
};

if (!alive (_search select 0) || (_search select 0) distance air_sp > 15) exitWith {life_action_inUse = false; [ localize "STR_Service_Chopper_Missing",false,"fast"] call AYU_Client_fnc_notification_system;};

CASH = CASH - _serviceCost;
if (!local (_search select 0)) then {
    [(_search select 0),1] remoteExecCall ["life_fnc_setFuel",(_search select 0)];
} else {
    (_search select 0) setFuel 1;
};

(_search select 0) setDamage 0;

"progressBar" cutText ["","PLAIN"];
titleText [localize "STR_Service_Chopper_Done","PLAIN"];
life_action_inUse = false;
