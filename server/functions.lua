----------------------------------------------------------------------------------------------------------------
----------------------------If you touch anything in here and you complain about it:----------------------------
--I'll literally link you to ESX's release page saying "This is what always works for special people like you"--
----------------------------------------------------------------------------------------------------------------

ARF             = {}
ARF.Players     = {}
ARF.Departments = {}

ARF.GetDepartmentData = function()
	MySQL.Async.fetchAll("SELECT * FROM departments", {}, function(result)
		if result[1] == nil then
			TriggerClientEvent('chatMessage', -1, "^1[SYSTEM]^0: No departments exist. Add some in the database.")
		else
			for i=1, #result do
				MySQL.Async.fetchAll("SELECT * FROM ranks WHERE dept = '".. result[i].dept.."'", {}, function(data)
					local tempData = {
						name  = result[i].dept,
						title = result[i].dept_title,
						ranks = {}
					}
					for i=1, #data do
						table.insert(tempData.ranks, data[i].rank_name)
						tempData.ranks[data[i].rank_name] = {name = data[i].rank_name, title = data[i].rank_title}
					end
					ARF.SaveDepartmentData(tempData)
				end)
			end
		end
	end)
end

ARF.SetDepartmentData = function(_source, department, rank)
	local id = GetPlayerIdentifiers(_source)
	local rankExist       = false
	if ARF.Departments[""..department..""] == nil or ARF.Departments[""..department..""].ranks[""..rank..""] == nil then
		TriggerClientEvent('chatMessage', _source, '^1[SYSTEM]^0: The parameters set are ^1incorrect^0, please correct them.')
		return
	else
		MySQL.Async.execute("UPDATE users SET department = '"..department.."', rank = '"..rank.."'  WHERE identifier = '"..id[1].."';", {}, function(e) end)
		SetTimeout(250, function()
			ARF.GetClientData(_source)
		end)
	end
end

ARF.SaveDepartmentData = function(data)
	ARF.Departments[data.name] = {
		name = data.name, 
		title = data.title, 
		ranks = data.ranks
	}
end

ARF.SyncDataToClient = function(_source, data)
	local PlayerData = data
	ARF.Players[_source] = data
	TriggerClientEvent("arf:receiveClientData", _source, PlayerData)
end

ARF.GetClientData = function(_source)
	local id = GetPlayerIdentifiers(_source)
	MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = '"..id[1].."'", {}, function(result)
		if result[1] == nil then
			MySQL.Async.execute('INSERT INTO users (identifier, license, department, rank, permission_level) VALUES ("'..id[1]..'","'..id[2] ..'","'..config.newUsers.DefaultDepartment..'", "'..config.newUsers.DefaultRank ..'",'..config.newUsers.DefaultPermissionLevel..');', {}, function(e) end)
			SetTimeout(150, function()
				ARF.GetClientData(_source)
			end)
		else
			local data = result[1]
			ARF.SyncDataToClient(_source, data)
		end
	end)
end

ARF.GetPlayerData = function(_source, target)
	local id = ARF.Players[_source]
	return id
end

AddEventHandler('arf:getSharedObject', function(cb)
	cb(ARF)
end)