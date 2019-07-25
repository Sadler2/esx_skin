local HELMETS_HAIR = Set {-1,0,15,19,25,34,35,57,100,120,128,133}
local HELMETS_CLOSED = Set { 49,50,51,52,90,114,122 }
local MASKS_HAIR = Set {-1,0,4,6,11,12,14,15,16,29,30,33,36,38,43,44,45,50,51,73,74,75,90,101,105,107,108,111,116,121,124,127,128,133}

function text_add_key(text, val, delim)
	if val ~= nil and #val > 0 then
		if #text > 0 then text = text .. delim end
		return text .. val
	end

	return text
end

function skinDescriptionToText(desc)
		local text = ""
		text = text_add_key(text, desc["skin"], ", ")
		text = text_add_key(text, desc["hair_color"], ", ")
		text = text_add_key(text, desc["hair"], ", ")
		text = text_add_key(text, desc["beard"], ", ")
		text = text_add_key(text, desc["mask"], ", ")
		text = text_add_key(text, desc["chain"], ", ")
		text = text_add_key(text, desc["glasses"], ", ")
		text = text_add_key(text, desc["helmet"], ", ")
		text = text_add_key(text, desc["torso"], ", ")
		text = text_add_key(text, desc["pants"], ", ")
		text = text_add_key(text, desc["shoes"], ", ")
		text = text_add_key(text, desc["armed"], ", ")
		return text
end

function getSkinDescription(skin)
		local result = {}
		local ped = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(ped, false)

		local current_helmet = GetPedPropIndex(ped, 0)
		local current_glasses = GetPedPropIndex(ped, 1)
		local current_mask = GetPedDrawableVariation(ped, 1)

		local text = ""

		local sex_prefix = "m_"

		if skin["sex"] ~= 0 then
			sex_prefix = "f_"
		end

		result['skin'] = format_part(_(sex_prefix.."skin"), skin["skin"])
		if current_mask > 0 or HELMETS_CLOSED[current_helmet] == true then
			result['skin'] = format_part(_(sex_prefix.."skin"), -1) -- hide skin color if using the mask
		end

		result['hair']       = format_part(_(sex_prefix.."hair_"..skin["hair_1"]), skin["hair_2"])
		result['hair_color'] = format_part(_(sex_prefix.."hair_color"), skin["hair_color_1"])
		result['beard']      = format_part(_("beard_"..skin["beard_1"]), skin["beard_3"])

		result['torso']   = format_part(_(sex_prefix.."torso_"..skin["torso_1"]), skin["torso_2"])
		result['pants']   = format_part(_(sex_prefix.."pants_"..skin["pants_1"]), skin["pants_2"])
		result['chain']   = format_part(_(sex_prefix.."chain_"..skin["chain_1"]), skin["chain_2"])
		result['shoes']   = format_part(_(sex_prefix.."shoes_"..skin["shoes_1"]), skin["shoes_2"])
		result['mask']    = format_part(_("mask_"..skin["mask_1"]), skin["mask_2"])
		result['helmet']  = format_part(_(sex_prefix.."helmet_"..skin["helmet_1"]), skin["helmet_2"])
		result['glasses'] = format_part(_(sex_prefix.."glasses_"..skin["glasses_1"]), skin["glasses_2"])

		-- hide hair description under some masks and helmets
		if result['hair'] == "[[bald]]" or HELMETS_HAIR[current_helmet] == false or MASKS_HAIR[current_mask] == false or HELMETS_CLOSED[current_helmet] == true then
			result['hair_color'] = nil
			result['hair'] = nil
		end

		-- hide beard description under some masks and helmets
		if skin["beard_2"] <= 3 or current_mask ~= 0 or HELMETS_CLOSED[current_helmet] == true then
			result['beard'] = nil
		end

		if GetPedDrawableVariation(ped, 1) <= 0 then
			result['mask'] = nil
		end

                -- put off glasses
		if current_glasses == -1 then
			result['glasses'] = nil
		end

		if current_helmet == -1 then
			result['helmet'] = nil
		end

		local pedWeapon = GetSelectedPedWeapon(ped)

		if pedWeapon ~= GetHashKey("WEAPON_UNARMED") and vehicle == 0 then
--		if IsPedArmed(ped, 7) then
			local group = GetWeapontypeGroup(GetSelectedPedWeapon(ped))

			local group_text = "unknown"
			if group == -1609580060 then
				group_text = "knuckles"
			elseif group == -728555052 then
				group_text = "melee"
			elseif group == 690389602 then
--				group_text = "shocker"
			elseif group == 1159398588 then
				group_text = "machinegun"
			elseif group == 416676503 then
				group_text = "pistol"
			elseif group == -957766203 then
				group_text = "smg"
			elseif group == 970310034 then
				group_text = "rifle"
			elseif group == -1212426201 then
				group_text = "sniper"
			elseif group == 860033945 then
				group_text = "shotgun"
			elseif group == -1569042529 then
				group_text = "heavy"
--			elseif group == 1548507267 then
--				group_text = "grenade"
			elseif pedWeapon == GetHashKey("WEAPON_GRENADE") or pedWeapon == GetHashKey("WEAPON_SMOKEGRENADE") or pedWeapon == GetHashKey("WEAPON_BZGAS") then
				group_text = "grenade"
			elseif pedWeapon == GetHashKey("WEAPON_STICKYBOMB") or pedWeapon == GetHashKey("WEAPON_PIPEBOMB ") then
				group_text = "explosives"
			end

			if group_text ~= "unknown" then
				result['armed'] = format_part(_(sex_prefix.."suspect_armed"), group_text)
			end
		end

		return result
end

RegisterNetEvent('esx_skin:requestSkinInfo')
AddEventHandler('esx_skin:requestSkinInfo', function()
	TriggerEvent('skinchanger:getSkin', function(skin)
		local desc = getSkinDescription(skin)
		local text = skinDescriptionToText(desc)
		TriggerEvent('chat:addMessage', { args = { '^1SYSTEM', text } })
	end)
end)
