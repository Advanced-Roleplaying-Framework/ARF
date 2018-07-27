----------------------------------------------------------------------------------------------------------------
----------------------------If you touch anything in here and you complain about it:----------------------------
--I'll literally link you to ESX's release page saying "This is what always works for special people like you"--
----------------------------------------------------------------------------------------------------------------

ARF = nil

RegisterCommand('setdept', function(source, args, raw)
	local _source = args[1]
	ARF.SetDepartmentData(_source, args[2], args[3])
end, false)

RegisterCommand('getdata', function(source, args, raw)
	local _source = source
	local target = args[1]
	local player = ARF.GetPlayerData(_source, target)
end, false)

RegisterNetEvent('arf:getClientData')
AddEventHandler('arf:getClientData', function()
	local _source = source
	ARF.GetClientData(_source)
	ARF.GetDepartmentData()
end)

TriggerEvent('arf:getSharedObject', function(data)
	ARF = data
end)