if pdash and texture then return end -- https://t.me/c/1353676159/41153
-- Thanks to SuperiorServers.co
-- require 'hash'

texture = {}

local TEXTURE = {
	__tostring = function(self)
		return self.Name
	end
}
TEXTURE.__index = TEXTURE
TEXTURE.__concat = TEXTURE.__tostring

debug.getregistry().Texture = TEXTURE

texture.textures = {}
texture.proxyurl = 'https://imgkit.gmod.app/?image=%s&size=%i'

if (not file.IsDir('texture', 'DATA')) then
	file.CreateDir 'texture'
end

function texture.Create(name)
	texture.Delete(name)

	local ret = setmetatable({
		Name 	= name,
		URL 	= '',
		Width 	= 1024,
		Height 	= 1024,
		Busy 	= false,
		Cache 	= true,
		Proxy 	= true,
		Format 	= 'jpg',
	}, TEXTURE)
	texture.textures[name] = ret
	return ret
end

function texture.Get(name)
	if texture.textures[name] then
		return texture.textures[name]:GetMaterial()
	end
end

function texture.Delete(name)
	texture.textures[name] = nil
end

function TEXTURE:SetSize(w, h)
	self.Width, self.Height = w, h
	return self
end

function TEXTURE:SetFormat(format) -- valid formats are whatever your webserver proxy can handle.
	self.Format = format
	return self
end

function TEXTURE:EnableCache(enable)
	self.Cache = enable
	return self
end

function TEXTURE:EnableProxy(enable)
	self.Proxy = enable
	return self
end


function TEXTURE:GetName()
	return self.Name
end

function TEXTURE:GetUID(reaccount)
	if (not self.UID) or reaccount then
		self.UID = hash.MD5(self.Name .. self.URL .. self.Width .. self.Height .. self.Format)
	end
	return self.UID
end

function TEXTURE:GetSize()
	return self.Width, self.Height
end

function TEXTURE:GetFormat()
	return self.Format
end

function TEXTURE:GetURL()
	return self.URL
end

function TEXTURE:GetFile()
	return self.File
end

function TEXTURE:GetMaterial()
	return self.IMaterial
end

function TEXTURE:GetError()
	return self.Error
end

function TEXTURE:IsBusy()
	return self.Busy == true
end

function TEXTURE:Download(url, onsuccess, onfailure)
	if (self.Name == nil) then
		self.Name = 'Web Material: ' .. url
	end
	self.URL = url
	self.File = 'texture/' .. self:GetUID() .. '.png'

	if self.Cache and file.Exists(self.File, 'DATA') then
		self.IMaterial = Material('data/' .. self.File, 'smooth')
		if onsuccess then
			onsuccess(self, self.IMaterial)
		end
	else
		self.Busy = true

		http.Fetch(self.Proxy and string.format(texture.proxyurl, url:URLEncode(), self.Width, self.Height, self.Format) or url, function(body, len, headers, code)
			if (self.Cache) then
				file.Write(self.File, body)
			end

			local tempfile = 'texture/tmp_' .. os.time() .. '_' .. self:GetUID() .. '.png'
			file.Write(tempfile, body)
			self.IMaterial = Material('data/' .. tempfile, 'smooth')
			file.Delete(tempfile)

			if onsuccess then
				onsuccess(self, self.IMaterial)
			end

			self.Busy = false
		end, function(error)

			self.Error = error

			if onfailure then
				onfailure(self, self.Error)
			end

			self.Busy = false
		end)
	end
	return self
end

function TEXTURE:RenderManual(func, callback)
	local cachefile = 'texture/' .. self:GetUID() .. '-render.png'

	if file.Exists(cachefile, 'DATA') then
		self.File = cachefile
		self.IMaterial = Material('data/' .. self.File, 'smooth')

		if callback then
			callback(self, self.IMaterial)
		end
	else
		hook.Add('HUDPaint', 'texture.render' .. self:GetName(), function()
			if self:IsBusy() then return end

			local w, h = self.Width, self.Height

			local drawRT = GetRenderTarget('texture_rt', w, h, true)
			local oldRT = render.GetRenderTarget()

			render.SetRenderTarget(drawRT)
				render.Clear(0, 0, 0, 0)
				render.ClearDepth()

				render.SetViewPort(0, 0, w, h) -- may need to tweak this all a bit later when I find use cases this doesn't work well for.
					func(self, w, h)

					if self.Cache then
						self.File = 'texture/' .. self:GetUID() .. '-render.png'
						file.Write(self.File, render.Capture({
							format = 'png',
							quality = 100,
							x = 0,
							y = 0,
							h = h,
							w = w
						}))
					end
				render.SetViewPort(0, 0, ScrW(), ScrH())
			render.SetRenderTarget(oldRT)

			self.IMaterial = Material('data/' .. self.File)

			if callback then
				callback(self, self.IMaterial)
			end

			hook.Remove('HUDPaint', 'texture.render' .. self:GetName())
		end)
	end
	return self
end

function TEXTURE:Render(func, callback)
	return self:RenderManual(function(self, w, h)
		cam.Start2D()
			func(self, w, h)
		cam.End2D()
	end, callback)
end
