local Workspace = game:GetService("Workspace")

-- Detecta se é parte de player/NPC
local function isCharacter(part)
	local model = part:FindFirstAncestorOfClass("Model")
	if model and model:FindFirstChildOfClass("Humanoid") then
		return true
	end
	return false
end

-- Verde (folhas)
local function isLeaf(part)
	local color = part.Color
	return color.G > 0.4 and color.G > color.R and color.G > color.B
end

-- Tronco marrom
local function isTrunk(part)
	local color = part.Color
	return color.R > 0.3 and color.G > 0.15 and color.B < 0.15
		and part.Size.Y > part.Size.X -- mais alto que largo
end

-- Guarda troncos primeiro (otimização)
local trunks = {}

for _, part in pairs(Workspace:GetDescendants()) do
	if part:IsA("BasePart") and isTrunk(part) then
		table.insert(trunks, part)
	end
end

-- Agora remove folhas
for _, part in pairs(Workspace:GetDescendants()) do
	if part:IsA("BasePart") then
		
		-- NÃO mexe em player
		if isCharacter(part) then
			continue
		end
		
		-- só partes do mapa
		if part.Anchored and not part.CanCollide then
			
			-- folhas verdes
			if isLeaf(part) then
				part:Destroy()
				continue
			end
			
			-- folhas em cima de tronco
			for _, trunk in pairs(trunks) do
				local dx = math.abs(part.Position.X - trunk.Position.X)
				local dz = math.abs(part.Position.Z - trunk.Position.Z)
				local dy = part.Position.Y - (trunk.Position.Y + trunk.Size.Y/2)

				if dx < trunk.Size.X/2 and dz < trunk.Size.Z/2 and dy > 0 and dy < 15 then
					part:Destroy()
					break
				end
			end
		end
	end
end
