#include "..\..\script_macros.hpp"
/*
    File: fn_ticketGive.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Gives a ticket to the targeted player.
*/
if (isNil "life_ticket_unit") exitWith {[ localize "STR_Cop_TicketNil",true,"fast"] call AYU_Client_fnc_notification_system;};
if (isNull life_ticket_unit) exitWith {[ localize "STR_Cop_TicketExist",true,"fast"] call AYU_Client_fnc_notification_system;};

private _val = ctrlText 2652;

if (!([_val] call TON_fnc_isnumber)) exitWith {[ localize "STR_Cop_TicketNum",true,"fast"] call AYU_Client_fnc_notification_system;};
if ((parseNumber _val) > 200000) exitWith {[ localize "STR_Cop_TicketOver100",true,"fast"] call AYU_Client_fnc_notification_system;};

[0,"STR_Cop_TicketGive",true,[profileName,[(parseNumber _val)] call life_fnc_numberText,life_ticket_unit getVariable ["realname",name life_ticket_unit]]] remoteExecCall ["life_fnc_broadcast",RCLIENT];
[player,(parseNumber _val)] remoteExec ["life_fnc_ticketPrompt",life_ticket_unit];
closeDialog 0;
