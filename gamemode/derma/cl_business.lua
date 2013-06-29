local PANEL = {}
	function PANEL:Init()
		self:SetPos(ScrW() * 0.375, ScrH() * 0.125)
		self:SetSize(ScrW() * nut.config.menuWidth, ScrH() * nut.config.menuHeight)
		self:MakePopup()
		self:SetTitle(nut.lang.Get("business"))

		self.list = self:Add("DScrollPanel")
		self.list:Dock(FILL)
		self.list:SetDrawBackground(true)

		self.categories = {}

		for class, itemTable in SortedPairs(nut.item.GetAll()) do
			if (!itemTable.noBusiness) then
				local category = itemTable.category
				local category2 = string.lower(category)

				if (!self.categories[category2]) then
					local category3 = self.list:Add("DCollapsibleCategory")
					category3:Dock(TOP)
					category3:SetLabel(category)
					category3:DockMargin(5, 5, 5, 5)
					category3:SetPadding(5)

					local list = vgui.Create("DIconLayout")
						list.Paint = function(list, w, h)
							surface.SetDrawColor(0, 0, 0, 25)
							surface.DrawRect(0, 0, w, h)
						end
					category3:SetContents(list)
						local icon = list:Add("SpawnIcon")
						icon:SetModel(itemTable.model or "models/error.mdl")

						local cost = "Price: Free"

						if (itemTable.price and itemTable.price > 0) then
							cost = "Price: "..nut.currency.GetName(itemTable.price or 0)
						end

						icon:SetToolTip("Description: "..itemTable:GetDesc().."\n"..cost)
					category3:InvalidateLayout(true)

					self.categories[category2] = {category = category3, panel = panel}
				end
			end
		end
	end

	function PANEL:Think()
		if (!self:IsActive()) then
			self:MakePopup()
		end
	end
vgui.Register("nut_Business", PANEL, "DFrame")