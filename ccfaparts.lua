local Workspace = game:GetService("Workspace")

-- Ignora qualquer coisa de player/NPC
local function isCharacter(part)
	local model = part:FindFirstAncestorOfClass("Model")
	return model and model:FindFirstChildOfClass("Humanoid")
end

-- Detecta tronco
local function isTrunk(part)
	local c = part.Color
	return part:IsA("BasePart")
		and part.Anchored
		and part.CanCollide
		and part.Size.Y > part.Size.X -- formato vertical
		and c.R > 0.3 and c.G > 0.15 and c.B < 0.15
end

-- Cache
local parts = Workspace:GetDescendants()
local trunks = {}

-- Coleta troncos
for _, part in ipairs(parts) do
	if isTrunk(part) then
		table.insert(trunks, part)
	end
end

-- Remove folhas
for _, part in ipairs(parts) do
	if part:IsA("BasePart") then
		
		-- Nunca mexe em personagem
		if isCharacter(part) then
			continue
		end
		
		-- Só mapa
		if part.Anchored then
			
			-- folhas são blocos "mais largos que altos"
			if part.Size.X >= part.Size.Y and part.Size.Z >= part.Size.Y then
				
				-- checa se está em cima de um tronco
				for _, trunk in ipairs(trunks) do
					if trunk and trunk.Parent then
						
						local dx = math.abs(part.Position.X - trunk.Position.X)
						local dz = math.abs(part.Position.Z - trunk.Position.Z)
						local dy = part.Position.Y - (trunk.Position.Y + trunk.Size.Y/2)

						if dx < trunk.Size.X
						and dz < trunk.Size.Z
						and dy > 0
						and dy < 20 then
							
							part:Destroy()
							break
						end
					end
				end
				
			end
			
		end
	end
end
