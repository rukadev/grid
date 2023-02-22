--[[

Constraints:
	* tileSize must be divisible by the plotsize

]]


local Grid = {}
Grid.__index = Grid

function Grid.new(plotSize, tileSize, plotPos)
	return setmetatable({
		grid = {},
		tileSize = tileSize,
		plotSize = plotSize,
		plotPos = plotPos,
		n = plotSize/tileSize,
		lineFolder = Instance.new("Folder"),
		tileFolder = Instance.new("Folder")
	}, Grid)
end

function Grid:changeSize(newSize)
	self:destroyLines()
	self:destroyTiles()
	
	self.tileSize = newSize
	self.n = self.plotSize/self.tileSize
	
	self:drawLines()
	self:drawTiles()
end

function Grid:destroyLines()
	self.lineFolder.Parent = nil
	for _, item in pairs(self.lineFolder:GetChildren()) do
		item:Destroy()
	end
end

function Grid:destroyTiles()
	self.tileFolder.Parent = nil
	for _, item in pairs(self.tileFolder:GetChildren()) do
		item:Destroy()
	end
end

function Grid:drawTiles()
	local half = (self.tileSize*self.n)/2
	local start = Vector3.new(self.plotPos.X - half, self.plotPos.Y, self.plotPos.Z - half)
	local finish = Vector3.new(self.plotPos.X + half, self.plotPos.Y, self.plotPos.Z + half)
	
	for x = 1, self.n do
		self.grid[x] = {}
		for z = 1, self.n do	
			local xp = self.tileSize * x - self.tileSize/2
			local zp = self.tileSize * z - self.tileSize/2
			local pos = Vector3.new(start.X + xp, 0.5, start.Z + zp)
			local size = Vector3.new(self.tileSize, 0.2, self.tileSize)
			self.grid[x][z] = self:createTile(size, pos)
		end
	end
	
	self.tileFolder.Parent = game.Workspace
end

function Grid:drawLines()
	local half = (self.tileSize*self.n)/2
	local start = Vector3.new(self.plotPos.X - half, self.plotPos.Y, self.plotPos.Z - half)
	local finish = Vector3.new(self.plotPos.X + half, self.plotPos.Y, self.plotPos.Z + half)
	
	for i = 1, self.n - 1 do
		local line = self.tileSize * i
		
		local p1 = Vector3.new(start.X + line, 0.5, self.plotPos.Z)
		local s1 = Vector3.new(0.5, 0.5, self.plotSize)
		self:createLines(s1, p1)
		
		local p2 = Vector3.new(self.plotPos.X, 0.5, start.Z + line)
		local s2 = Vector3.new(self.plotSize, 0.5, 0.5)
		self:createLines(s2, p2)
	end
	
	self.lineFolder.Parent = game.Workspace
end

function Grid:createLines(size, pos)
	local line = Instance.new("Part")
	line.BrickColor = BrickColor.new("Institutional white")
	line.Material = Enum.Material.SmoothPlastic
	line.Position = pos
	line.Size = size
	line.Anchored = true
	line.CanCollide = false
	line.Parent = self.lineFolder
end

function Grid:createTile(size, pos)
	local tile = Instance.new("Part")
	tile.BrickColor = BrickColor.new("Lime green")
	tile.Material = Enum.Material.SmoothPlastic
	tile.Size = size
	tile.Position = pos
	tile.Anchored = true
	tile.CanCollide = false
	tile.Parent = self.tileFolder
end

return Grid
