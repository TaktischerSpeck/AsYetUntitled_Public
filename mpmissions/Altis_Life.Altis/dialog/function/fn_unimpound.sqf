#include "..\..\script_macros.hpp"
/*
    File: fn_unimpound.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Yeah... Gets the vehicle from the garage.
*/
private ["_vehicle","_vehicleLife","_vid","_pid","_unit","_price","_price","_storageFee","_purchasePrice"];
disableSerialization;
if ((lbCurSel 2802) isEqualTo -1) exitWith {[ localize "STR_Global_NoSelection",true,'fast'] call AYU_Client_fnc_notification_system;};
_vehicle = lbData[2802,(lbCurSel 2802)];
_vehicle = (call compile format ["%1",_vehicle]) select 0;
_vehicleLife = _vehicle;
_vid = lbValue[2802,(lbCurSel 2802)];
_pid = getPlayerUID player;
_unit = player;
_spawntext = localize "STR_Garage_spawn_Success";
if (isNil "_vehicle") exitWith {[ localize "STR_Garage_Selection_Error",true,'fast'] call AYU_Client_fnc_notification_system;};
if (!isClass (missionConfigFile >> "LifeCfgVehicles" >> _vehicleLife)) then {
    _vehicleLife = "Default"; //Use Default class if it doesn't exist
    diag_log format ["%1: LifeCfgVehicles class doesn't exist",_vehicle];
};

_price = M_CONFIG(getNumber,"LifeCfgVehicles",_vehicleLife,"price");
_storageFee = LIFE_SETTINGS(getNumber,"vehicle_storage_fee_multiplier");

switch (playerSide) do {
    case civilian: {_purchasePrice = _price * LIFE_SETTINGS(getNumber,"vehicle_purchase_multiplier_CIVILIAN");};
    case west: {_purchasePrice = _price * LIFE_SETTINGS(getNumber,"vehicle_purchase_multiplier_COP");};
    case independent: {_purchasePrice = _price * LIFE_SETTINGS(getNumber,"vehicle_purchase_multiplier_MEDIC");};
    case east: {_purchasePrice = _price * LIFE_SETTINGS(getNumber,"vehicle_purchase_multiplier_OPFOR");};
};
_price = _purchasePrice * _storageFee;

if (!(_price isEqualType 0) || _price < 1) then {_price = 500;};
if (BANK < _price) exitWith {[ format [(localize "STR_Garage_CashError"),[_price] call life_fnc_numberText],true,'fast'] call AYU_Client_fnc_notification_system;};

if (life_garage_sp isEqualType []) then {
    if (life_HC_isActive) then {
        [_vid,_pid,(life_garage_sp select 0),_unit,_price,(life_garage_sp select 1),_spawntext] remoteExec ["HC_fnc_spawnVehicle",HC_Life];
    } else {
        [_vid,_pid,(life_garage_sp select 0),_unit,_price,(life_garage_sp select 1),_spawntext] remoteExec ["TON_fnc_spawnVehicle",RSERV];
    };
} else {
    if (life_garage_sp in ["medic_spawn_1","medic_spawn_2","medic_spawn_3"]) then {
        if (life_HC_isActive) then {
            [_vid,_pid,life_garage_sp,_unit,_price,0,_spawntext] remoteExec ["HC_fnc_spawnVehicle",HC_Life];
        } else {
            [_vid,_pid,life_garage_sp,_unit,_price,0,_spawntext] remoteExec ["TON_fnc_spawnVehicle",RSERV];
        };
    } else {
        if (life_HC_isActive) then {
            [_vid,_pid,(getMarkerPos life_garage_sp),_unit,_price,markerDir life_garage_sp,_spawntext] remoteExec ["HC_fnc_spawnVehicle",HC_Life];
        } else {
            [_vid,_pid,(getMarkerPos life_garage_sp),_unit,_price,markerDir life_garage_sp,_spawntext] remoteExec ["TON_fnc_spawnVehicle",RSERV];
        };
    };
};

[ localize "STR_Garage_SpawningVeh",true,'fast'] call AYU_Client_fnc_notification_system;
BANK = BANK - _price;
[1] call SOCK_fnc_updatePartial;
closeDialog 0;
