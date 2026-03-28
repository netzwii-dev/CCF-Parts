local Workspace = game:GetService("Workspace")

-- Função para ignorar players
local function isCharacter(part)
	local model = part:FindFirstAncestorOfClass("Model")
	return model and model:FindFirstChildOfClass("Humanoid")
end

-- Função para checar se a cor é verde aproximada
local function isGreen(part)
	local color = part.Color
	return color.G > color.R and color.G > color.B
end

-- Função para checar se é um tronco marrom
local function isBrownTrunk(part)
	local color = part.Color
	return color.R > 0.3 and color.G > 0.15 and color.B < 0.1
		and part.Size.Y > 2
end

-- Loop por todas as partes do mapa
for _, part in pairs(Workspace:GetDescendants()) do
	if part:IsA("BasePart") and not isCharacter(part) then
		
		if not part.CanCollide then
			
			if isGreen(part) then
				part:Destroy()
			else
				local aboveTrunk = false
				
				for _, checkPart in pairs(Workspace:GetDescendants()) do
					if checkPart:IsA("BasePart") and isBrownTrunk(checkPart) then
						
						local dx = math.abs(part.Position.X - checkPart.Position.X)
						local dz = math.abs(part.Position.Z - checkPart.Position.Z)
						local dy = part.Position.Y - (checkPart.Position.Y + checkPart.Size.Y/2)

						if dx < checkPart.Size.X/2 and dz < checkPart.Size.Z/2 and dy > 0 and dy < 10 then
							aboveTrunk = true
							break
						end
					end
				end
				
				if aboveTrunk then
					part:Destroy()
				end
			end
		end
	end
end
