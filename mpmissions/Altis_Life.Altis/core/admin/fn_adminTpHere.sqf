#include "..\..\script_macros.hpp"
/*
    File: fn_adminTpHere.sqf
    Author: ColinM9991

    Description:
    Teleport selected player to you.
*/
if (FETCH_CONST(life_adminlevel) < 4) exitWith {closeDialog 0;};

private _target = lbData[2902,lbCurSel (2902)];
_target = call compile format ["%1", _target];
if (isNil "_target" || isNull _target) exitWith {};
if (_target == player) exitWith {[ localize "STR_ANOTF_Error",false,"fast"] call AYU_Client_fnc_notification_system;};

if (!(vehicle _target isEqualTo _target)) exitWith {[ localize "STR_Admin_CannotTpHere",false,"fast"] call AYU_Client_fnc_notification_system;};
_target setPos (getPos player);
[ format [localize "STR_NOTF_haveTPedToYou",_target getVariable ["realname",name _target]],false,"fast"] call AYU_Client_fnc_notification_system;
