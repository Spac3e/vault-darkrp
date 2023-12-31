-- 2021.01.18 Logging library
-- Author https://amd-nick.me/about

lolib = {}

-- https://colorswall.com/palette/3/
local COLOR_DEBUG   = Color(2, 117, 216)
local COLOR_FADED   = Color(247, 247, 247)
local COLOR_INFO    = Color(91, 192, 222)
local COLOR_WARNING = Color(255, 255, 0)
local COLOR_ERROR   = Color(240, 50, 50)

lolib.LEVELS = {
	DISABLE = 0,
	DEBUG   = 1,
	INFO    = 2,
	WARNING = 3,
	ERROR   = 4,

	{"D", COLOR_DEBUG,   COLOR_DEBUG},
	{"I", COLOR_INFO,    COLOR_FADED},
	{"W", COLOR_WARNING, COLOR_FADED},
	{"E", COLOR_ERROR,   COLOR_WARNING},
}

local function echo(pref_col, pref, text_col, text)
	MsgC(pref_col, pref, text_col, " " .. text .. "\n")
end

local function fp(a)
	local func = a[1]
	return function(...)
		return func(unpack(a, 2), ...)
	end
end

function lolib.new()
	local logger = {
		level   = lolib.default_level or 3,
		pattern = "{message}"
	}

	logger.build_message = function(fmt, ...)
		local args = {...}
		local count = 0
		return fmt:gsub("{}", function()
			count = count + 1
			local replacement_val = (args[count] ~= nil) and args[count]
			if istable(replacement_val) then
				return util.TableToJSON(replacement_val)
			else
				return tostring(replacement_val)
			end
		end)
	end

	logger.format = function(fmt, ...)
		local text = logger.build_message(fmt, ...)

		-- invalid capture index error. "foo %9 bar" > "foo %%9 bar"
		text = text:gsub("%%", "%%%%%")
		-- text = text:gsub("%%(%d)", "%%%%%1")

		return logger.pattern
			:gsub("{time}", os.date("%H:%M:%S"))
			:gsub("{message}", text)
	end

	logger.filter = function(tRecord)
		if tRecord.level < logger.level or logger.level == 0 then return end
		return true
	end

	logger.log = function(iLevel, fmt, ...)
		if not logger.filter({level = iLevel}) then return end

		local text = logger.format(fmt, ...)

		local level_data = lolib.LEVELS[iLevel]
		echo(level_data[2], "[" .. level_data[1] .. "]", level_data[3], text)
	end

	logger.debug   = fp{logger.log, lolib.LEVELS.DEBUG}
	logger.info    = fp{logger.log, lolib.LEVELS.INFO}
	logger.warning = fp{logger.log, lolib.LEVELS.WARNING}
	logger.error   = fp{logger.log, lolib.LEVELS.ERROR}

	logger.setLevel = function(iLevel)
		logger.level = iLevel
	end

	logger.setCvar = function(sVarName, iDefaultValue)
		local cvar = CreateConVar(sVarName, iDefaultValue or 0, FCVAR_ARCHIVE)

		cvars.AddChangeCallback(sVarName, function(_, _, new)
			local level = tonumber(new) or 0
			assert(level >= 0 and level <= 5)
			logger.setLevel(level)
			MsgN("logging level has been changed. New level is: " .. level)
		end, "lolib")

		logger.setLevel(cvar:GetInt())

		return cvar
	end

	logger.setFormat = function(sPattern)
		logger.pattern = sPattern
	end

	return logger
end

--[[
local log = lolib.new()
log.setLevel(lolib.LEVELS.INFO)

log.debug("debug value: {}", 123)
log.info("info value: {}", 123)
log.warning("warning value: {}", 123)
log.error("error value: {}", 123)
]]

-- return lolib
