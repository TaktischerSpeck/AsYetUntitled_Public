#include "..\..\script_macros.hpp"
/*
    File: fn_healHospital.sqf
    Author: Bryan "Tonic" Boardwine
    Reworked: Jesse "TKCJesse" Schultz

    Description:
    Prompts user with a confirmation dialog to heal themselves.
    Used at the hospitals to restore health to full.
    Note: Dialog helps stop a few issues regarding money loss.
*/
private ["_healCost","_action"];
if (life_action_inUse) exitWith {};
if ((damage player) < 0.01) exitWith {[ localize "STR_NOTF_HS_FullHealth",false,"fast"] call AYU_Client_fnc_notification_system;};
_healCost = LIFE_SETTINGS(getNumber,"hospital_heal_fee");
if (CASH < _healCost) exitWith {[ format [localize "STR_NOTF_HS_NoCash",[_healCost] call life_fnc_numberText],false,"fast"] call AYU_Client_fnc_notification_system;};

life_action_inUse = true;
_action = [
    format [localize "STR_NOTF_HS_PopUp",[_healCost] call life_fnc_numberText],
    localize "STR_NOTF_HS_TITLE",
    localize "STR_Global_Yes",
    localize "STR_Global_No"
] call BIS_fnc_guiMessage;

if (_action) then {
    titleText[localize "STR_NOTF_HS_Healing","PLAIN"];
    closeDialog 0;
    uiSleep 8;
    if (player distance (_this select 0) > 5) exitWith {life_action_inUse = false; titleText[localize "STR_NOTF_HS_ToFar","PLAIN"]};
    titleText[localize "STR_NOTF_HS_Healed","PLAIN"];
    player setDamage 0;
    CASH = CASH - _healCost;
    life_action_inUse = false;
} else {
    [ localize "STR_NOTF_ActionCancel",false,"fast"] call AYU_Client_fnc_notification_system;
    closeDialog 0;
    life_action_inUse = false;
};
