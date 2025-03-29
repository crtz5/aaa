local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel") -- Ajout du titre
local CashLabel = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")

UICorner.Parent = Frame
UICorner.CornerRadius = UDim.new(0, 40)

ScreenGui.Parent = game:GetService("CoreGui")

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Size = UDim2.new(0, 500, 0, 100)
Frame.Position = UDim2.new(0.5, -250, 0.1, 0) -- Centré
Frame.Active = true
Frame.Draggable = true

-- Ajout du titre AMS CASHCOUNTER
Title.Parent = Frame
Title.Text = "AMS CASHCOUNTER"
Title.Size = UDim2.new(1, 0, 0, 25) -- Taille ajustée
Title.Position = UDim2.new(0, 0, 0, 5) -- Positionné en haut
Title.TextColor3 = Color3.fromRGB(0, 255, 0) -- Texte vert flashy
Title.TextSize = 30
Title.Font = Enum.Font.SourceSansBold
Title.BackgroundTransparency = 1
Title.TextStrokeTransparency = 0.5 -- Effet contour léger

CashLabel.Parent = Frame
CashLabel.Text = "💵 Dropped: 0$"
CashLabel.Size = UDim2.new(1, 0, 0, 75)
CashLabel.Position = UDim2.new(0, 0, 0.25, 0) -- Déplacé pour éviter le chevauchement
CashLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CashLabel.TextSize = 28
CashLabel.BackgroundTransparency = 1

-- Mettre "Dropped:" en gras et aussi le nombre, les virgules et le symbole $
CashLabel.RichText = true -- Active le texte riche pour utiliser le balisage HTML
CashLabel.Text = "<b>💵 Dropped: </b><b>%s</b>"

-- Fonction pour formater le nombre avec des virgules
local function formatNumber(number)
return tostring(number):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

local function GetDroppedCash()
local TotalCash = 0
local Ignored = game:GetService("Workspace"):FindFirstChild("Ignored")

if Ignored and Ignored:FindFirstChild("Drop") then
for _, v in pairs(Ignored.Drop:GetChildren()) do
if v:IsA("Part") and v:FindFirstChild("BillboardGui") then
local CashText = v.BillboardGui.TextLabel.Text:gsub("%D+", "")
local CashAmount = tonumber(CashText)
if CashAmount then
TotalCash = TotalCash + CashAmount
end
end
end
end

return TotalCash
end

local function TrackAllWalletDrops()
local Players = game:GetService("Players")

for _, player in pairs(Players:GetPlayers()) do
if player:FindFirstChild("DataFolder") and player.DataFolder:FindFirstChild("Currency") then
local LastCash = player.DataFolder.Currency.Value

player.DataFolder.Currency:GetPropertyChangedSignal("Value"):Connect(function()
local NewCash = player.DataFolder.Currency.Value
if NewCash < LastCash then
wait(0.3)
UpdateCashDisplay()
end
LastCash = NewCash
end)
end
end

Players.PlayerAdded:Connect(function(player)
wait(2)
if player:FindFirstChild("DataFolder") and player.DataFolder:FindFirstChild("Currency") then
local LastCash = player.DataFolder.Currency.Value

player.DataFolder.Currency:GetPropertyChangedSignal("Value"):Connect(function()
local NewCash = player.DataFolder.Currency.Value
if NewCash < LastCash then
wait(0.3)
UpdateCashDisplay()
end
LastCash = NewCash
end)
end
end)
end

function UpdateCashDisplay()
local formattedCash = formatNumber(GetDroppedCash()) -- Formater le cash avec des virgules
CashLabel.Text = string.format("<b>💵 Dropped: </b><b>%s</b>", formattedCash .. "$")
end

task.spawn(function()
while true do
UpdateCashDisplay()
wait(0.5)
end
end)

local function SetupCashListener()
local Ignored = game:GetService("Workspace"):FindFirstChild("Ignored")
if Ignored and Ignored:FindFirstChild("Drop") then
Ignored.Drop.ChildAdded:Connect(function()
wait(0.2)
UpdateCashDisplay()
end)
end
end

SetupCashListener()
TrackAllWalletDrops()

-- Fonction pour ouvrir/fermer le GUI avec la touche K
local UserInputService = game:GetService("UserInputService")

-- Utilisation de l'événement InputBegan pour la touche K
UserInputService.InputBegan:Connect(function(input, gameProcessed)
if gameProcessed then return end -- Si le jeu a déjà traité l'entrée, ignorer
if input.KeyCode == Enum.KeyCode.K then
-- Lorsque "K" est appuyé, alterner l'état de l'interface
ScreenGui.Enabled = not ScreenGui.Enabled
end
end)
