local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
func = Tunnel.getInterface("own3d_perolas")

local processo = false
local tempo = 0

local locais = {
	{ ['id'] = 1, ['x'] = -362.54, ['y'] = 7345.95, ['z'] = -32.17, ['text'] = "COLETAR PEROLAS"} 
}

Citizen.CreateThread(function()
	Citizen.Wait(1000)
	while true do
		Citizen.Wait(1)
		for k,v in pairs(locais) do
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(v.x,v.y,v.z)
			local distance = GetDistanceBetweenCoords(v.x,v.y,cdz,x,y,z,true)
			if distance <= 25.0 and not processo then
				drawTxt("PRESSIONE  ~b~E~w~  PARA "..v.text,4,0.5,0.93,0.50,255,255,255,180)
				if IsControlJustPressed(0,38)  then
					if func.checkPayment(v.id) then
						TriggerEvent('cancelando',true)
						processo = true
						tempo = 10
					end
				end
			end
		end
		if processo then
			drawTxt("Coletando... (Aguarde "..tempo.." Segundos para coletar)",4,0.5,0.93,0.50,255,255,255,180)
		end
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(5000)
	while true do
		Citizen.Wait(1000)
		if tempo > 0 then
			tempo = tempo - 1
			if tempo == 0 then
				processo = false
				TriggerEvent('cancelando',false)
			end
		end
	end
end)

function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end