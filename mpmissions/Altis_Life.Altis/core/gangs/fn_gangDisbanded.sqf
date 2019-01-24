/*
    File: fn_gangDisbanded.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Notifies members that the gang has been disbanded.
*/
private "_group";
_group = param [0,grpNull,[grpNull]];
if (isNull _group) exitWith {}; //Fail horn please.
if (!isNull (findDisplay 2620)) then {closeDialog 2620};

[ localize "STR_GNOTF_DisbandWarn_2",false,"fast"] call AYU_Client_fnc_notification_system;
[player] joinSilent (createGroup civilian);

if (units _group isEqualTo []) then {
    deleteGroup _group;
};
