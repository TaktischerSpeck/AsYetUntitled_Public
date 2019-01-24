/*
    File: fn_copHouseOwner.sqf
    Author:

    Description:
    Displays the house owner
*/
private ["_house"];
_house = [_this,0,objNull,[objNull]] call BIS_fnc_param;
if (isNull _house || !(_house isKindOf "House_F")) exitWith {};
if (isNil {(_house getVariable "house_owner")}) exitWith {[ localize "STR_House_Raid_NoOwner",true,"fast"] call AYU_Client_fnc_notification_system;};
[ parseText format ["<t color='#FF0000'><t size='2'>" +(localize "STR_House_Raid_Owner")+ "</t></t><br/>%1",(_house getVariable "house_owner") select 1],true,"fast"] call AYU_Client_fnc_notification_system;