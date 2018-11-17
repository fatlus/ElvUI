local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G
local select = select

local CreateFrame = CreateFrame
local RegisterAsWidget, RegisterAsContainer

local function SkinDropdownPullout(self)
	if self.obj.pullout.frame.template and self.obj.pullout.slider.template then return end

	if not self.obj.pullout.frame.template then
		self.obj.pullout.frame:SetTemplate("Default", true)
	end

	if not self.obj.pullout.slider.template then
		self.obj.pullout.slider:SetTemplate("Default")
		self.obj.pullout.slider:Point("TOPRIGHT", self.obj.pullout.frame, "TOPRIGHT", -10, -10)
		self.obj.pullout.slider:Point("BOTTOMRIGHT", self.obj.pullout.frame, "BOTTOMRIGHT", -10, 10)
		if self.obj.pullout.slider:GetThumbTexture() then
			self.obj.pullout.slider:SetThumbTexture(E.media.normTex)
			self.obj.pullout.slider:GetThumbTexture():SetVertexColor(unpack(E.media.rgbvaluecolor))
			self.obj.pullout.slider:GetThumbTexture():Size(10, 14)
		end
	end
end

function S:SkinAce3()
	local AceGUI = LibStub("AceGUI-3.0", true)
	if not AceGUI then return end
	local oldRegisterAsWidget = AceGUI.RegisterAsWidget

	RegisterAsWidget = function(self, widget)
		if not E.private.skins.ace3.enable then
			return oldRegisterAsWidget(self, widget)
		end
		local TYPE = widget.type
		if TYPE == "MultiLineEditBox" then
			local frame = widget.frame
			local scrollBG = widget.scrollBG or select(2, frame:GetChildren())

			if not scrollBG.template then
				scrollBG:SetTemplate("Default")
			end

			S:HandleButton(widget.button)
			S:HandleScrollBar(widget.scrollBar)
			widget.scrollBar:Point("RIGHT", frame, "RIGHT", 0 -4)
			scrollBG:Point("TOPRIGHT", widget.scrollBar, "TOPLEFT", -2, 19)
			scrollBG:Point("BOTTOMLEFT", widget.button, "TOPLEFT")
			widget.scrollFrame:Point("BOTTOMRIGHT", scrollBG, "BOTTOMRIGHT", -4, 8)
		elseif TYPE == "CheckBox" then
			local check = widget.check
			local checkbg = widget.checkbg
			local highlight = widget.highlight

			checkbg:CreateBackdrop("Default")
			checkbg.backdrop:SetInside(checkbg, 4, 4)
			checkbg.backdrop:SetFrameLevel(checkbg.backdrop:GetFrameLevel() + 1)
			checkbg:SetTexture("")
			checkbg.SetTexture = E.noop

			check:SetTexture(E.media.normTex)
			check.SetTexture = E.noop
			check:SetVertexColor(unpack(E.media.rgbvaluecolor))
			check:SetInside(checkbg.backdrop)
			check:SetParent(checkbg.backdrop)

			highlight:SetTexture("")
			highlight.SetTexture = E.noop
		elseif TYPE == "Dropdown" then
			local frame = widget.dropdown
			local button = widget.button
			local button_cover = widget.button_cover
			local text = widget.text

			frame:StripTextures()

			S:HandleNextPrevButton(button, true)

			if not frame.backdrop then
				frame:CreateBackdrop("Default")
			end

			frame.backdrop:Point("TOPLEFT", 17, -2)
			frame.backdrop:Point("BOTTOMRIGHT", -21, 0)

			widget.label:ClearAllPoints()
			widget.label:Point("BOTTOMLEFT", frame.backdrop, "TOPLEFT", 2, 0)

			button:SetSize(20, 20)
			button:ClearAllPoints()
			button:Point("RIGHT", frame.backdrop, "RIGHT", -2, 0)
			button:SetParent(frame.backdrop)

			text:ClearAllPoints()
			text:Point("RIGHT", frame.backdrop, "RIGHT", -26, 2)
			text:Point("LEFT", frame.backdrop, "LEFT", 2, 0)
			text:SetParent(frame.backdrop)

			button:HookScript2("OnClick", SkinDropdownPullout)

			if button_cover then
				button_cover:HookScript2("OnClick", SkinDropdownPullout)
			end
		elseif TYPE == "LSM30_Font" or TYPE == "LSM30_Sound" or TYPE == "LSM30_Border" or TYPE == "LSM30_Background" or TYPE == "LSM30_Statusbar" then
			local frame = widget.frame
			local button = frame.dropButton
			local text = frame.text

			frame:StripTextures()

			S:HandleNextPrevButton(button, true)

			if not frame.backdrop then
				frame:CreateBackdrop("Default")
			end

			frame.label:ClearAllPoints()
			frame.label:Point("BOTTOMLEFT", frame.backdrop, "TOPLEFT", 2, 0)

			text:ClearAllPoints()
			text:Point("RIGHT", button, "LEFT", -2, 0)

			button:SetSize(20, 20)
			button:ClearAllPoints()
			button:Point("RIGHT", frame.backdrop, "RIGHT", -2, 0)

			frame.backdrop:Point("TOPLEFT", 0, -21)
			frame.backdrop:Point("BOTTOMRIGHT", -4, -1)

			if TYPE == "LSM30_Sound" then
				widget.soundbutton:SetParent(frame.backdrop)
				widget.soundbutton:ClearAllPoints()
				widget.soundbutton:Point("LEFT", frame.backdrop, "LEFT", 2, 0)
			elseif TYPE == "LSM30_Statusbar" then
				widget.bar:SetParent(frame.backdrop)
				widget.bar:ClearAllPoints()
				widget.bar:Point("TOPLEFT", frame.backdrop, "TOPLEFT", 2, -2)
				widget.bar:Point("BOTTOMRIGHT", button, "BOTTOMLEFT", -1, 0)
			--elseif TYPE == "LSM30_Border" or TYPE == "LSM30_Background" then -- Leave this here please. - Azilroka
			end

			button:SetParent(frame.backdrop)
			text:SetParent(frame.backdrop)

			button:HookScript2("OnClick", function(self)
				local dropdown = self.obj.dropdown
				if dropdown then
					dropdown:SetTemplate("Default", true)
					if dropdown.slider then
						dropdown.slider:SetTemplate("Transparent")
						dropdown.slider:Point("TOPRIGHT", dropdown, "TOPRIGHT", -10, -10)
						dropdown.slider:Point("BOTTOMRIGHT", dropdown, "BOTTOMRIGHT", -10, 10)

						if dropdown.slider:GetThumbTexture() then
							dropdown.slider:SetThumbTexture(E.media.normTex)
							dropdown.slider:GetThumbTexture():SetVertexColor(unpack(E.media.rgbvaluecolor))
							dropdown.slider:GetThumbTexture():Size(10, 14)
						end
					end

					if TYPE == "LSM30_Sound" then
						local frame = self.obj.frame
						local width = frame:GetWidth()
						dropdown:Point("TOPLEFT", frame, "BOTTOMLEFT")
						dropdown:Point("TOPRIGHT", frame, "BOTTOMRIGHT", width < 160 and (160 - width) or 30, 0)
					end
				end
			end)
		elseif TYPE == "EditBox" then
			local frame = widget.editbox
			local button = widget.button

			_G[frame:GetName().."Left"]:Kill()
			_G[frame:GetName().."Middle"]:Kill()
			_G[frame:GetName().."Right"]:Kill()

			frame:Height(17)
			frame:CreateBackdrop("Default")
			frame.backdrop:Point("TOPLEFT", 2, -2)
			frame.backdrop:Point("BOTTOMRIGHT", -2, 0)
			frame.backdrop:SetParent(widget.frame)
			frame:SetParent(frame.backdrop)
			frame:SetTextInsets(4, 43, 3, 3)
			frame.SetTextInsets = E.noop

			S:HandleButton(button)
			button:Point("RIGHT", frame.backdrop, "RIGHT", -2, 0)

			hooksecurefunc(frame, "SetPoint", function(self, a, b, c, d, e)
				if d == 7 then
					self:SetPoint(a, b, c, 0, e)
				end
			end)
		elseif TYPE == "Button" or TYPE == "Button-ElvUI" then
			local frame = widget.frame

			S:HandleButton(frame)

			frame:StripTextures()
			frame:CreateBackdrop("Default", true)
			frame.backdrop:SetInside()

			widget.text:SetParent(frame.backdrop)
		elseif TYPE == "Slider" then
			local frame = widget.slider
			local editbox = widget.editbox
			local lowtext = widget.lowtext
			local hightext = widget.hightext
			local HEIGHT = 12

			frame:StripTextures()
			frame:SetTemplate("Default")
			frame:Height(HEIGHT)

			frame:SetThumbTexture(E.media.normTex)
			frame:GetThumbTexture():SetVertexColor(unpack(E.media.rgbvaluecolor))
			frame:GetThumbTexture():Size(HEIGHT - 2, HEIGHT - 2)

			editbox:SetTemplate("Default")
			editbox:Height(15)
			editbox:Point("TOP", frame, "BOTTOM", 0, -1)

			lowtext:Point("TOPLEFT", frame, "BOTTOMLEFT", 2, -2)
			hightext:Point("TOPRIGHT", frame, "BOTTOMRIGHT", -2, -2)
		elseif TYPE == "Keybinding" then
			local button = widget.button
			local msgframe = widget.msgframe
			local msg = widget.msgframe.msg

			S:HandleButton(button)

			msgframe:StripTextures()
			msgframe:CreateBackdrop("Default", true)
			msgframe.backdrop:SetInside()
			msgframe:SetToplevel(true)

			msg:ClearAllPoints()
			msg:Point("LEFT", 10, 0)
			msg:Point("RIGHT", -10, 0)
			msg:SetJustifyV("MIDDLE")
			msg:Width(msg:GetWidth() + 10)
		elseif (TYPE == "ColorPicker" or TYPE == "ColorPicker-ElvUI") then
			local frame = widget.frame
			local colorSwatch = widget.colorSwatch

			if not frame.backdrop then
				frame:CreateBackdrop("Default")
			end

			frame.backdrop:SetSize(16, 16)
			frame.backdrop:ClearAllPoints()
			frame.backdrop:Point("LEFT", frame, "LEFT", 4, 0)
			frame.backdrop:SetBackdropColor(0, 0, 0, 0)
			frame.backdrop.SetBackdropColor = E.noop
			frame.backdrop:SetBackdropBorderColor(1, 1, 1)
			frame.backdrop.SetBackdropBorderColor = E.noop

			colorSwatch:SetTexture(E.media.blankTex)
			colorSwatch:ClearAllPoints()
			colorSwatch:SetParent(frame.backdrop)
			colorSwatch:SetInside(frame.backdrop)

			if frame.texture then
				frame.texture:SetTexture(0, 0, 0, 0)
			end

			if frame.checkers then
				frame.checkers:ClearAllPoints()
				frame.checkers:SetDrawLayer("ARTWORK")
				frame.checkers:SetParent(frame.backdrop)
				frame.checkers:SetInside(frame.backdrop)
			end
		end

		return oldRegisterAsWidget(self, widget)
	end
	AceGUI.RegisterAsWidget = RegisterAsWidget

	local oldRegisterAsContainer = AceGUI.RegisterAsContainer
	RegisterAsContainer = function(self, widget)
		if not E.private.skins.ace3.enable then
			return oldRegisterAsContainer(self, widget)
		end
		local TYPE = widget.type
		if TYPE == "ScrollFrame" then
			S:HandleScrollBar(widget.scrollbar)
		elseif TYPE == "InlineGroup" or TYPE == "TreeGroup" or TYPE == "TabGroup" or TYPE == "Frame" or TYPE == "DropdownGroup" or TYPE == "Window" then
			local frame = widget.content:GetParent()
			if TYPE == "Frame" then
				frame:StripTextures()
				if not E.GUIFrame then
					E.GUIFrame = frame
				end
				for i = 1, frame:GetNumChildren() do
					local child = select(i, frame:GetChildren())
					if child:GetObjectType() == "Button" and child:GetText() then
						S:HandleButton(child)
					else
						child:StripTextures()
					end
				end
			elseif TYPE == "Window" then
				frame:StripTextures()
				S:HandleCloseButton(frame.obj.closebutton)
			end
			frame:SetTemplate("Transparent")

			if widget.treeframe then
				widget.treeframe:SetTemplate("Transparent")
				frame:Point("TOPLEFT", widget.treeframe, "TOPRIGHT", 1, 0)

				local oldRefreshTree = widget.RefreshTree
				widget.RefreshTree = function(self, scrollToSelection)
					oldRefreshTree(self, scrollToSelection)
					if not self.tree then return end
					local status = self.status or self.localstatus
					local groupstatus = status.groups
					local lines = self.lines
					local buttons = self.buttons
					local offset = status.scrollvalue

					for i = offset + 1, #lines do
						local button = buttons[i - offset]
						if button then
							button.toggle:SetNormalTexture([[Interface\AddOns\ElvUI\media\textures\PlusMinusButton]])
							button.toggle:SetPushedTexture([[Interface\AddOns\ElvUI\media\textures\PlusMinusButton]])
							button.toggle:SetHighlightTexture("")

							if groupstatus[lines[i].uniquevalue] then
								button.toggle:GetNormalTexture():SetTexCoord(0.540, 0.965, 0.085, 0.920)
								button.toggle:GetPushedTexture():SetTexCoord(0.540, 0.965, 0.085, 0.920)
							else
								button.toggle:GetNormalTexture():SetTexCoord(0.040, 0.465, 0.085, 0.920)
								button.toggle:GetPushedTexture():SetTexCoord(0.040, 0.465, 0.085, 0.920)
							end
						end
					end
				end
			end

			if TYPE == "TabGroup" then
				local oldCreateTab = widget.CreateTab
				widget.CreateTab = function(self, id)
					local tab = oldCreateTab(self, id)
					tab:StripTextures()
					tab.backdrop = CreateFrame("Frame", nil, tab)
					tab.backdrop:SetTemplate("Transparent")
					tab.backdrop:SetFrameLevel(tab:GetFrameLevel() - 1)
					tab.backdrop:Point("TOPLEFT", 10, -3)
					tab.backdrop:Point("BOTTOMRIGHT", -10, 0)

					return tab
				end
			end

			if widget.scrollbar then
				S:HandleScrollBar(widget.scrollbar)
			end
		elseif TYPE == "SimpleGroup" then
			local frame = widget.content:GetParent()
			frame:SetTemplate("Transparent", nil, true) --ignore border updates
			frame:SetBackdropBorderColor(0, 0, 0, 0) --Make border completely transparent
		end

		return oldRegisterAsContainer(self, widget)
	end
	AceGUI.RegisterAsContainer = RegisterAsContainer
end

local function attemptSkin()
	local AceGUI = LibStub("AceGUI-3.0", true)
	if AceGUI and (AceGUI.RegisterAsContainer ~= RegisterAsContainer or AceGUI.RegisterAsWidget ~= RegisterAsWidget) then
		S:SkinAce3()
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", attemptSkin)

S:AddCallback("Ace3", attemptSkin)