
--[[

~ yuck, anti cheats! ~

~ file stolen by ~
                __  .__                          .__            __                 .__               
  _____   _____/  |_|  |__ _____    _____ ______ |  |__   _____/  |______    _____ |__| ____   ____  
 /     \_/ __ \   __\  |  \\__  \  /     \\____ \|  |  \_/ __ \   __\__  \  /     \|  |/    \_/ __ \ 
|  Y Y  \  ___/|  | |   Y  \/ __ \|  Y Y  \  |_> >   Y  \  ___/|  |  / __ \|  Y Y  \  |   |  \  ___/ 
|__|_|  /\___  >__| |___|  (____  /__|_|  /   __/|___|  /\___  >__| (____  /__|_|  /__|___|  /\___  >
      \/     \/          \/     \/      \/|__|        \/     \/          \/      \/        \/     \/ 

~ purchase the superior cheating software at https://methamphetamine.solutions ~

~ server ip: 212.22.93.35_27015 ~ 
~ file: addons/plib_v2/lua/plib/extensions/file.lua ~

]]

local chunkSize		= 512 * 1024	-- Number of bytes to store in each chunk
local interval		= 0.1			-- Time between each chunk read/write
local workQueue = {}

local function processQueue(queue)
	if timer.Exists('file.DoStaggered') then return end
	if workQueue[1] then
		-- take something from the beginning of the queue and create
		-- a timer to repeatedly do it until it is odne
		local func = table.remove(workQueue, 1)
		timer.Create('file.DoStaggered', interval, 0, function()
			if func() then
				timer.Destroy('file.DoStaggered')
				processQueue()
			end
		end)
	else
		-- else there is no more work so we are done
		timer.Destroy('file.DoStaggered')
	end
end
function file.ReadStaggered(name, callback)
	-- open the file
	local f = file.Open(name, 'rb', 'DATA')
	if not f then error('failed to open file ' .. name .. '.') end

	-- we will construct a function
	-- to read the file in segments
	-- and call the callback when done
	do 
		local buffer = {}
		local function doRead()
			local data = f:Read(chunkSize)
			if not data or data:len() == 0 then
				f:Close()
				callback(table.concat(buffer))
				return true -- tell it to schedule the next job. this one is done.
			else
				buffer[#buffer + 1] = data
				return false
			end
		end
		table.insert(workQueue, doRead)
	end
	processQueue()
end

function file.WriteStaggered(name, str, callback)
	-- open the file
	local f = file.Open(name, 'wb', 'DATA')
	if not f then error('failed to open file ' .. name .. '.') end

	-- we will construct a function
	-- to read the file in segments
	-- and call the callback when done
	do 
		local len = str:len()
		local index = 0
		local function doWrite()
			local segment = string.sub(str, index * chunkSize, (index + 1) * chunkSize)
			f:Write(segment)
			index = index + 1
			if index * chunkSize > len then
				f:Close()
				callback(name)
				return true -- tell it to schedule the next job. this one is done.
			end
		end
		table.insert(workQueue, doWrite)
	end
	processQueue()
end