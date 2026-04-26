
local M = {}

local validBusSignData = {
	controllerName = "bus",
	functionName = "onGameplayEvent",
	variables = {
		[1] = {
			bus_onRouteChange = true,
			bus_onDepartedStop = true,
			bus_onAtStop = true,
			bus_onApproachStop = true,
			bus_setLineInfo = true,
			bus_onTriggerTick = true,
			bus_onSetStopRequest = true
		},
		[2] = {
			direction = "Not in Service",
			routeColor = "#FFA200",
			routeID = "00",
			tasklist = {
				[1] = {
					[1] = "not_in_service",
					[2] = "Not in Service",
					[3] = {
						999999,
						999999,
						999999
					}
				}
			}
		}
	}
}

local function receiveBusSignData(remoteData)
	if v.mpVehicleType == "R" then
		remoteData.controllerName = validBusSignData.controllerName
		remoteData.functionName = validBusSignData.functionName
		if not validBusSignData.variables[1][remoteData.variables[1]] then
			remoteData.variables[1] = "bus_setLineInfo"
		end
		for key, validValue in pairs(validBusSignData.variables[2]) do
			if type(remoteData.variables[2][key]) ~= type(validValue) then
				remoteData.variables[2][key] = validValue
			end
		end
		controllerSyncVE.OGcontrollerFunctionsTable[remoteData.controllerName][remoteData.functionName](remoteData.variables[1], remoteData.variables[2])
	end
end

local function transmitBusSignData(controllerName, funcName, localData, ...)
	controllerSyncVE.sendControllerData(localData)
	controllerSyncVE.OGcontrollerFunctionsTable[controllerName][funcName](...)
end

local includedControllerTypes = {
	["bus"] = {
		["onGameplayEvent"] = {
			receiveFunction = receiveBusSignData,
			ownerFunction = transmitBusSignData,
			storeState = true
		}
	}
}

local function loadFunctions()
	if controllerSyncVE ~= nil then
		controllerSyncVE.addControllerTypes(includedControllerTypes)
	else
		dump("controllerSyncVE not found")
	end
end

M.loadControllerSyncFunctions = loadFunctions

return M
