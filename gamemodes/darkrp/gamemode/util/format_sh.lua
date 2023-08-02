local string_comma = string.Comma
-- деньги доларосы
function rp.FormatMoney(n)
	return '$' .. string_comma(n)
end
function rp.formatNumber(n)
	return string_comma(n)
end