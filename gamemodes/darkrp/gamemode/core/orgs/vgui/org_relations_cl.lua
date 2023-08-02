local a = {}
local b = Color(51, 51, 51)

function a:Init()
end

function a:Paint(c, d)
    draw.RoundedBox(5, 0, 0, c, d, b)
end

vgui.Register('org_relations', a, 'Panel')