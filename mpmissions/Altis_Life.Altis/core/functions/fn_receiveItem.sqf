#include "..\..\script_macros.hpp"
/*
    File: fn_receiveItem.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Receive an item from a player.
*/
private ["_unit","_val","_item","_from","_diff"];
_unit = _this select 0;
if !(_unit isEqualTo player) exitWith {};
_val = _this select 1;
_item = _this select 2;
_from = _this select 3;

_diff = [_item,(parseNumber _val),life_carryWeight,life_maxWeight] call life_fnc_calWeightDiff;

if (!(_diff isEqualTo (parseNumber _val))) then {
    if ([true,_item,_diff] call life_fnc_handleInv) then {
        [ format [localize "STR_MISC_TooMuch_3",_from getVariable ["realname",name _from],_val,_diff,((parseNumber _val) - _diff)],true,"fast"] call AYU_Client_fnc_notification_system;
        [_from,_item,str((parseNumber _val) - _diff),_unit] remoteExecCall ["life_fnc_giveDiff",_from];
    } else {
        [_from,_item,_val,_unit,false] remoteExecCall ["life_fnc_giveDiff",_from];
    };
} else {
    if ([true,_item,(parseNumber _val)] call life_fnc_handleInv) then {
        private "_type";
        _type = M_CONFIG(getText,"VirtualItems",_item,"displayName");
        [ format [localize "STR_NOTF_GivenItem",_from getVariable ["realname",name _from],_val,(localize _type)],true,"fast"] call AYU_Client_fnc_notification_system;
    } else {
        [_from,_item,_val,_unit,false] remoteExecCall ["life_fnc_giveDiff",_from];
    };
};