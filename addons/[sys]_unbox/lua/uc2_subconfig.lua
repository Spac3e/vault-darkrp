BUC2 = {}
BUC2.ITEMS = {} 
BUC2.ItemToID = {}
BUC2.IDToItem = {}  
BUC2.UpgradeToItems = {} 

function bu_addCrate(id, name1 , name2 , c , candrop , canBuy , price)
	BUC2.ItemToID[name1] = id 
	BUC2.IDToItem[id] = name1
	BUC2.ITEMS[name1] = {
		items = {},
		color = c,
		canDrop = candrop,
		name1 = name1,
		name2 = name2,
		itemType = "Crate",
		canBuy = canBuy, 
		price = price
	}
end

function bu_addWeapon(id, name1 , name2,  weaponName , model, c , crateName , chance , isPermanent)
	BUC2.ItemToID[name1] = id 
	BUC2.IDToItem[id] = name1
	if BUC2.ITEMS[crateName] ~= nil then 	
		BUC2.ITEMS[name1] = {
			name1 = name1, 
			name2 = name2,
			itemType = "Weapon",
			model = model,
			chance = chance,
			color = c, 
			canBuy = false,
			permanent = isPermanent,
			weaponName = weaponName
		}
		table.insert(BUC2.ITEMS[crateName].items , name1)
	else
		print("[UNBOXING ERROR] THE CRATE '"..crateName.."' FOR '"..name1.."' DOES NOT EXTIST.")
	end
end

function bu_addMoney(id, name1 , name2 , amount , c , crateName, chance)
	BUC2.ItemToID[name1] = id 
	BUC2.IDToItem[id] = name1
	if BUC2.ITEMS[crateName] ~= nil then 	
		BUC2.ITEMS[name1] = {
			name1 = name1, 
			name2 = name2,
			itemType = "IGS",
			amount = amount,
			chance = chance,
			color = c, 
			canBuy = false,
		}
		table.insert(BUC2.ITEMS[crateName].items , name1)
	else
		print("[UNBOXING ERROR] THE CRATE '"..crateName.."' FOR '"..name1.."' DOES NOT EXTIST.")
	end
end


