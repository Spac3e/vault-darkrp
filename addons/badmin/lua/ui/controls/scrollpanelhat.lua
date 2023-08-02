local SCROLLBAR = {}
function SCROLLBAR:Init()
	self.parent = self:GetParent()

	self.scrollButton = vgui.Create('Panel', self)
	self.scrollButton.OnMousePressed = function(s, mb)
		if (mb == MOUSE_LEFT and !self:GetParent().ShouldHideScrollbar) then
			local mx, my = s:CursorPos()

			s.scrolling = true
			s.mouseOffset = my
		end
	end
	self.scrollButton.OnMouseReleased = function(s, mb)
		if (mb == MOUSE_LEFT) then
			s.scrolling = false
			s.mouseOffset = nil
		end
	end

	self.height = 0
end

function SCROLLBAR:Think()
	if (self.scrollButton.scrolling) then
		if (!input.IsMouseDown(MOUSE_LEFT)) then
			self.scrollButton:OnMouseReleased(MOUSE_LEFT)
			return
		end

		local mx, my = self.scrollButton:CursorPos()

		local diff = my - self.scrollButton.mouseOffset

		local maxOffset = self.parent:GetCanvas():GetTall() - self.parent:GetTall()

		local perc = (self.scrollButton.y + diff) / (self:GetTall() - self.height)
		self.parent.yOffset = math.Clamp(perc * maxOffset, 0, maxOffset)

		self.parent:InvalidateLayout()
	end
end

function SCROLLBAR:PerformLayout()
	local maxOffset = self.parent:GetCanvas():GetTall() - self.parent:GetTall()

	self:SetPos(self.parent:GetWide() - self:GetWide(), 0)

	self.heightRatio = self.parent:GetTall() / self.parent:GetCanvas():GetTall()
	self.height = math.Clamp(math.ceil(self.heightRatio * self.parent:GetTall()), 20, math.huge)

	self.scrollButton:SetSize(self:GetWide() - 4, self.height)
	self.scrollButton:SetPos((self:GetWide() - self.scrollButton:GetWide()) * 0.5, math.Clamp((self.parent.yOffset / maxOffset), 0, 1) * (self:GetTall() - self.height))
end


function SCROLLBAR:OnMouseWheeled(delta)
	self.parent:OnMouseWheeled(delta)
end

vgui.Register('ui_scrollbarhat', SCROLLBAR, 'Panel')


local SCROLLABLE = {}
function SCROLLABLE:Init()
	self.scrollBar = vgui.Create('ui_scrollbarhat', self)
	self.scrollBar:SetMouseInputEnabled(true)


	self.contentContainer = vgui.Create('Panel', self)
	self.contentContainer:SetMouseInputEnabled(true)

	self.yOffset = 0
	self.ySpeed = 0
	self.scrollSize = 4
	self.SpaceTop = 1
	self.Padding = 0

	self.scrollBar:Dock(RIGHT)
	self.scrollBar:SetWidth(12)

	function self.contentContainer.OnChildRemoved(s, child)
		self:PerformLayout()
	end
end

function SCROLLABLE:Reset()
	self:GetCanvas():Clear(true)
	self.yOffset = 0
	self.ySpeed = 0
	self.scrollSize = 1

	self:PerformLayout()
end

function SCROLLABLE:AddItem(child)
	child:SetParent(self:GetCanvas())
	self:PerformLayout()
	return child
end

function SCROLLABLE:SetSpacing(i)
	self.SpaceTop = i
end

function SCROLLABLE:SetPadding(i)
	self.Padding = i
end

function SCROLLABLE:GetCanvas()
	return self.contentContainer
end

function SCROLLABLE:SetScrollSize(int)
	self.scrollSize = int
end

function SCROLLABLE:ScrollTo(y)
	self.yOffset = y

	self:InvalidateLayout()
end

function SCROLLABLE:OnMouseWheeled(delta)
	if ((delta > 0 and self.ySpeed < 0) or (delta < 0 and self.ySpeed > 0)) then
		self.ySpeed = 0
	else
		self.ySpeed = self.ySpeed + (delta * self.scrollSize)
	end

	if (system.IsOSX()) then
		self.ySpeed = self.ySpeed * 0.1
	end

	self:PerformLayout()
end

function SCROLLABLE:SetOffset(offSet)
	local maxOffset = (self:GetCanvas():GetTall() - self:GetTall())
	if (maxOffset < 0) then maxOffset = 0 end

	self.yOffset = math.Clamp(offSet, 0, maxOffset)

	self:PerformLayout()

	if (self.yOffset == 0 or self.yOffset == maxOffset) then return true end
end

function SCROLLABLE:Think()
	if (self.ySpeed != 0) then
		if (self:SetOffset(self.yOffset - self.ySpeed)) then
			self.ySpeed = 0
		else
			if (self.ySpeed < 0) then
				self.ySpeed = math.Clamp(self.ySpeed + (FrameTime() * self.scrollSize * 4), self.ySpeed, 0)
			else
				self.ySpeed = math.Clamp(self.ySpeed - (FrameTime() * self.scrollSize * 4), 0, self.ySpeed)
			end
		end
	end
end

function SCROLLABLE:PerformLayout()
	local canvas = self:GetCanvas()

	if (canvas:GetWide() != self:GetWide()) then
		canvas:SetWide(self:GetWide())
	end

	local y = 0
	local lastChild
	for k, v in ipairs(canvas:GetChildren()) do
		local childY = y + self.SpaceTop
		if (v.x != self.Padding or v.y != childY) then
			v:SetPos(math.max(0, self.Padding), y + self.SpaceTop)
		end
		if (v:GetWide() != self:GetWide() - self.Padding * 2) then
			v:SetWide(math.min(self:GetWide(), self:GetWide() - self.Padding * 2))
		end

		y = v.y + v:GetTall() + self.SpaceTop + self.Padding
		lastChild = v
	end
	y = lastChild and lastChild.y + lastChild:GetTall() or y
	if (canvas:GetTall() != y) then
		canvas:SetTall(y)
	end

	if (canvas:GetTall() <= self:GetTall() and self.scrollBar:IsVisible()) then
		canvas:SetTall(self:GetTall())

		self.scrollBar:SetVisible(false)
	elseif (canvas:GetTall() > self:GetTall() and !self.scrollBar:IsVisible()) then
		self.scrollBar:SetVisible(true)
	end

	local maxOffset = (self:GetCanvas():GetTall() - self:GetTall())

	if (self.yOffset > maxOffset) then
		self.yOffset = maxOffset
	end

	if (self.yOffset < 0) then
		self.yOffset = 0
	end
	
	if (canvas.x != 0 or canvas.y != -self.yOffset) then
		canvas:SetPos(0, -self.yOffset)
		self.scrollBar:InvalidateLayout()
	end
end

function SCROLLABLE:IsAtMaxOffset()
	local maxOffset = math.Clamp(self:GetCanvas():GetTall() - self:GetTall(), 0, math.huge)
	return self.yOffset == maxOffset
end


function SCROLLABLE:HideScrollbar(bool)
	self.ShouldHideScrollbar = bool
end

function SCROLLABLE:DockToFrame()
	local p = self:GetParent()
	local x, y = p:GetDockPos()
	self:SetPos(x, y)
	self:SetSize(p:GetWide() - 10, p:GetTall() - (y + 5))
end

vgui.Register('ui_scrollpanelhat', SCROLLABLE, 'Panel')

