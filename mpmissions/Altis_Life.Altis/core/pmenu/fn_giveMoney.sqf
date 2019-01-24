#include "..\..\script_macros.hpp"
/*
    File: fn_giveMoney.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Gives the selected amount of money to the selected player.
*/
private ["_unit","_amount"];
_amount = ctrlText 2018;
ctrlShow[2001,false];
if ((lbCurSel 2022) isEqualTo -1) exitWith {[ localize "STR_NOTF_noOneSelected",true,"fast"] call AYU_Client_fnc_notification_system;ctrlShow[2001,true];};
_unit = lbData [2022,lbCurSel 2022];
_unit = call compile format ["%1",_unit];
if (isNil "_unit") exitWith {ctrlShow[2001,true];};
if (_unit == player) exitWith {ctrlShow[2001,true];};
if (isNull _unit) exitWith {ctrlShow[2001,true];};

//A series of checks *ugh*
if (!life_use_atm) exitWith {[ localize "STR_NOTF_recentlyRobbedBank",true,"fast"] call AYU_Client_fnc_notification_system;ctrlShow[2001,true];};
if (!([_amount] call TON_fnc_isnumber)) exitWith {[ localize "STR_NOTF_notNumberFormat",true,"fast"] call AYU_Client_fnc_notification_system;ctrlShow[2001,true];};
if (parseNumber(_amount) <= 0) exitWith {[ localize "STR_NOTF_enterAmount",true,"fast"] call AYU_Client_fnc_notification_system;ctrlShow[2001,true];};
if (parseNumber(_amount) > CASH) exitWith {[ localize "STR_NOTF_notEnoughtToGive",true,"fast"] call AYU_Client_fnc_notification_system;ctrlShow[2001,true];};
if (isNull _unit) exitWith {ctrlShow[2001,true];};
if (isNil "_unit") exitWith {ctrlShow[2001,true]; [ localize "STR_NOTF_notWithinRange",true,"fast"] call AYU_Client_fnc_notification_system;};

[ format [localize "STR_NOTF_youGaveMoney",[(parseNumber(_amount))] call life_fnc_numberText,_unit getVariable ["realname",name _unit]],true,"fast"] call AYU_Client_fnc_notification_system;
CASH = CASH - (parseNumber(_amount));
[0] call SOCK_fnc_updatePartial;

[_unit,_amount,player] remoteExecCall ["life_fnc_receiveMoney",_unit];
[] call life_fnc_p_updateMenu;

ctrlShow[2001,true];