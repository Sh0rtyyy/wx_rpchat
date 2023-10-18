ESX = exports["es_extended"]:getSharedObject()

local function havePermission(xPlayer)
	local group = xPlayer.getGroup()
	if wx.AdminGroups[group] then
		return true
	end
	return false
end

ESX.RegisterServerCallback('wx_rpchat:getPlayerGroup', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(tonumber(source))
	if xPlayer then
		local playergroup = xPlayer.getGroup()
		cb(tostring(playergroup))
	else
		cb('user')
	end
end)

RegisterCommand("report", function(source, args, raw)
	local xPlayer = ESX.GetPlayerFromId(source)
	local name = GetPlayerName(source)
	local content = table.concat(args, " ")
	TriggerClientEvent("wx_rpchat:send", -1, source, name, content)
	local discord = "Not Found"
	local ip = "Not Found"
	local steam = "Not Found"
	for k, v in pairs(GetPlayerIdentifiers(source)) do
	  if string.sub(v, 1, string.len("steam:")) == "steam:" then
		steam = v
	  elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
		discord = v
	  elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
		ip = v
	  end
	end
	if wx.AdminGroups[xPlayer.getGroup()] then
		local message = content
		local xAll = ESX.GetPlayers()
		for i=1, #xAll, 1 do
			local xTarget = ESX.GetPlayerFromId(xAll[i])
			if wx.AdminGroups[xTarget.getGroup()] then
				TriggerClientEvent('chat:addMessage', xTarget.source, {
					template = '<div style="padding: 0.4vw; margin: 0.4vw; background-color: rgba(30, 30, 46, 0.45); border-radius: 3px;"><font style="padding: 0.22vw; margin: 0.22vw; background-color: #c1121f; border-radius: 2px; font-size: 15px;"> <i class="fa-solid fa-people-group"></i> <b>REPORTY</b></font> [{0}] <strong>{1}</strong>:  <font style="background-color:rgba(20, 20, 20, 0); font-size: 17px; margin-left: 0px; padding-bottom: 2.5px; padding-left: 3.5px; padding-top: 2.5px; padding-right: 3.5px;border-radius: 0px;"></font>   <font style=" font-weight: 800; font-size: 15px; margin-left: 5px; padding-bottom: 3px; border-radius: 0px;"><b></b></font><font style=" font-weight: 200; font-size: 14px; border-radius: 0px;">{2}</font></div>',
					args = { source, name, message, string.upper(xPlayer.getGroup()) }
				})
			end
		end
	
	end
	log("**New Report**", source, name, content,steam,discord,ip,Webhooks['reports'])

end, false)


