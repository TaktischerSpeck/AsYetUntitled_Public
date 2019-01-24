#include "..\..\script_macros.hpp"
/*
    File: fn_gangDeposit.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Deposits money into the players gang bank.
*/
private ["_value"];
_value = parseNumber(ctrlText 2702);
group player setVariable ["gbank_in_use_by",player,true];

//Series of stupid checks
if (isNil {(group player) getVariable "gang_name"}) exitWith {[ localize "STR_ATM_NotInGang",true,'fast'] call AYU_Client_fnc_notification_system;}; // Checks if player isn't in a gang
if (_value > 999999) exitWith {[ localize "STR_ATM_GreaterThan",true,'fast'] call AYU_Client_fnc_notification_system;};
if (_value < 0) exitWith {};
if (!([str(_value)] call TON_fnc_isnumber)) exitWith {[ localize "STR_ATM_notnumeric",true,'fast'] call AYU_Client_fnc_notification_system;};
if (_value > CASH) exitWith {[ localize "STR_ATM_NotEnoughCash",true,'fast'] call AYU_Client_fnc_notification_system;};
if ((group player getVariable ["gbank_in_use_by",player]) != player) exitWith {[ localize "STR_ATM_WithdrawMin",true,'fast'] call AYU_Client_fnc_notification_system;}; //Check if it's in use.

CASH = CASH - _value;
_gFund = GANG_FUNDS;
_gFund = _gFund + _value;
group player setVariable ["gang_bank",_gFund,true];

if (life_HC_isActive) then {
    [1,group player] remoteExecCall ["HC_fnc_updateGang",HC_Life];
} else {
    [1,group player] remoteExecCall ["TON_fnc_updateGang",RSERV];
};

[ format [localize "STR_ATM_DepositSuccessG",[_value] call life_fnc_numberText],true,'fast'] call AYU_Client_fnc_notification_system;
[] call life_fnc_atmMenu;
[6] call SOCK_fnc_updatePartial; //Silent Sync

if (LIFE_SETTINGS(getNumber,"player_moneyLog") isEqualTo 1) then {
    if (LIFE_SETTINGS(getNumber,"battlEye_friendlyLogging") isEqualTo 1) then {
        money_log = format [localize "STR_DL_ML_depositeGang_BEF",_value,[_gFund] call life_fnc_numberText,[BANK] call life_fnc_numberText,[CASH] call life_fnc_numberText];
    } else {
        money_log = format [localize "STR_DL_ML_depositeGang",profileName,(getPlayerUID player),_value,[_gFund] call life_fnc_numberText,[BANK] call life_fnc_numberText,[CASH] call life_fnc_numberText];
    };
    publicVariableServer "money_log";
};
