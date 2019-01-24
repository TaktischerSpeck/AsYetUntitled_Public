#include "..\..\script_macros.hpp"
/*
    File: fn_gangInvitePlayer.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Invites the player into the gang.
*/
private "_unit";
disableSerialization;

if ((lbCurSel 2632) isEqualTo -1) exitWith {[ localize "STR_GNOTF_SelectPerson",false,"fast"] call AYU_Client_fnc_notification_system;};
_unit = call compile format ["%1",CONTROL_DATA(2632)];

if (isNull _unit) exitWith {}; //Bad unit?
if (_unit == player) exitWith {[ localize "STR_GNOTF_InviteSelf",false,"fast"] call AYU_Client_fnc_notification_system;};
if (!isNil {(group _unit) getVariable "gang_name"}) exitWith {[ localize "STR_GNOTF_playerAlreadyInGang",false,"fast"] call AYU_Client_fnc_notification_system;}; //Added

if (count(group player getVariable ["gang_members",8]) == (group player getVariable ["gang_maxMembers",8])) exitWith {[ localize "STR_GNOTF_MaxSlot",false,"fast"] call AYU_Client_fnc_notification_system;};

_action = [
    format [localize "STR_GNOTF_InvitePlayerMSG",_unit getVariable ["realname",name _unit]],
    localize "STR_Gang_Invitation",
    localize "STR_Global_Yes",
    localize "STR_Global_No"
] call BIS_fnc_guiMessage;

if (_action) then {
    [profileName,group player] remoteExec ["life_fnc_gangInvite",_unit];
    _members = group player getVariable "gang_members";
    _members pushBack getPlayerUID _unit;
    group player setVariable ["gang_members",_members,true];
    [ format [localize "STR_GNOTF_InviteSent",_unit getVariable ["realname",name _unit]],false,"fast"] call AYU_Client_fnc_notification_system;
} else {
    [ localize "STR_GNOTF_InviteCancel",false,"fast"] call AYU_Client_fnc_notification_system;
};
