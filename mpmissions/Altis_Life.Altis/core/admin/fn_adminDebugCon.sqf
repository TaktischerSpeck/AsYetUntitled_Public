#include "..\..\script_macros.hpp"
/*
    File: fn_adminDebugCon.sqf
    Author: ColinM9991

    Description:
    Opens the Debug Console.
*/
if (FETCH_CONST(life_adminlevel) < 5) exitWith {closeDialog 0; [ localize "STR_NOTF_adminDebugCon",false,"fast"] call AYU_Client_fnc_notification_system;};
life_admin_debug = true;

createDialog "RscDisplayDebugPublic";
[0,format [localize "STR_NOTF_adminHasOpenedDebug",profileName]] remoteExecCall ["life_fnc_broadcast",RCLIENT];
