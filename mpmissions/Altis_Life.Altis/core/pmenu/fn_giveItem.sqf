#include "..\..\script_macros.hpp"

/*
    File: fn_giveItem.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Gives the selected item & amount to the selected player and
    removes the item & amount of it from the players virtual
    inventory.
*/

ctrlShow [2002,false];

call {
    private _value = ctrlText 2010;

    if ((lbCurSel 2023) isEqualTo -1) exitWith {
        [ localize "STR_NOTF_noOneSelected",true,"fast"] call AYU_Client_fnc_notification_system;
    };

    if ((lbCurSel 2005) isEqualTo -1) exitWith {
        [ localize "STR_NOTF_didNotSelectItemToGive",true,"fast"] call AYU_Client_fnc_notification_system;
    };


    private _unit = lbData [2023, lbCurSel 2023];
    _unit = call compile format ["%1",_unit];

    if (isNil "_unit") exitWith {
        [ localize "STR_NOTF_notWithinRange",true,"fast"] call AYU_Client_fnc_notification_system;
    };
    if (isNull _unit || {_unit isEqualTo player}) exitWith {};

    private _item = lbData [2005, lbCurSel 2005];

    if !([_value] call TON_fnc_isnumber) exitWith {
        [ localize "STR_NOTF_notNumberFormat",true,"fast"] call AYU_Client_fnc_notification_system;
    };
    if (parseNumber _value <= 0) exitWith {
        [ localize "STR_NOTF_enterAmountGive",true,"fast"] call AYU_Client_fnc_notification_system;
    };
    if !([false,_item, parseNumber _value] call life_fnc_handleInv) exitWith {
        [ localize "STR_NOTF_couldNotGive",true,"fast"] call AYU_Client_fnc_notification_system;
    };

    [_unit, _value, _item, player] remoteExecCall ["life_fnc_receiveItem", _unit];
    private _type = M_CONFIG(getText,"VirtualItems",_item,"displayName");
    [ format [localize "STR_NOTF_youGaveItem", _unit getVariable ["realname", name _unit], _value, localize _type],true,"fast"] call AYU_Client_fnc_notification_system;

    [] call life_fnc_p_updateMenu;
};

ctrlShow[2002,true];
