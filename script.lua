local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")

-- Helper function to create UICorner
local function createUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
end

-- Helper function to create Frame
local function createFrame(parent, size, position, color, transparency)
    local frame = Instance.new("Frame")
    frame.Size = size
    frame.Position = position
    frame.BackgroundColor3 = color
    frame.BackgroundTransparency = transparency or 0
    frame.BorderSizePixel = 0
    frame.Parent = parent
    return frame
end

-- Main Screen UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomUI"
screenGui.Parent = playerGui

-- White Border
local borderFrame = createFrame(screenGui, UDim2.new(0, 802, 0, 602), UDim2.new(0.5, -401, 0.5, -301), Color3.fromRGB(75, 75, 95))
createUICorner(borderFrame, 8)

-- Main Frame
local mainFrame = createFrame(borderFrame, UDim2.new(0, 800, 0, 600), UDim2.new(0.5, -400, 0.5, -300), Color3.fromRGB(20, 20, 30))
mainFrame.ClipsDescendants = true
createUICorner(mainFrame, 8)

-- Top Bar
local topBar = createFrame(mainFrame, UDim2.new(1, -150, 0, 50), UDim2.new(0, 150, 0, 0), Color3.fromRGB(25, 25, 35), 0.1)
createUICorner(topBar, 8)

-- Dragging functionality
local dragging, dragInput, dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    borderFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = borderFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

topBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- Home Icon and Text
local homeIcon = Instance.new("ImageLabel")
homeIcon.Size = UDim2.new(0, 24, 0, 24)
homeIcon.Position = UDim2.new(0, 10, 0.5, -12)
homeIcon.BackgroundTransparency = 1
homeIcon.Image = "rbxassetid://137214348651815"
homeIcon.Parent = topBar

local homeText = Instance.new("TextLabel")
homeText.Size = UDim2.new(0, 100, 1, 0)
homeText.Position = UDim2.new(0, 30, 0, 0)
homeText.BackgroundTransparency = 1
homeText.Text = "Home"
homeText.TextColor3 = Color3.fromRGB(255, 255, 255)
homeText.Font = Enum.Font.GothamSemibold
homeText.TextSize = 22
homeText.Parent = topBar

-- Sidebar
local sidebar = createFrame(mainFrame, UDim2.new(0, 150, 1, 0), UDim2.new(0, 0, 0, 0), Color3.fromRGB(20, 20, 30))
createUICorner(sidebar, 8)

-- Content Panel
local contentPanel = createFrame(mainFrame, UDim2.new(1, -151, 1, -51), UDim2.new(0, 151, 0, 51), Color3.fromRGB(30, 30, 40), 0.2)
createUICorner(contentPanel, 8)

-- Inner Panel inside Content Panel
local innerPanel = createFrame(contentPanel, UDim2.new(0.98, 0, 0.91, 0), UDim2.new(0.01, 0, 0.073, 0), Color3.fromRGB(35, 35, 45))
createUICorner(innerPanel, 8)

-- Tab Extension on Inner Panel
local tabExtension = createFrame(innerPanel, UDim2.new(0, 70, 0, 41), UDim2.new(0, 16, 0, -35), innerPanel.BackgroundColor3)
createUICorner(tabExtension, 8)

local tabExtensionText = Instance.new("TextLabel")
tabExtensionText.Size = UDim2.new(1, -20, 1, 0)
tabExtensionText.Position = UDim2.new(0, 20, 0, -3)
tabExtensionText.BackgroundTransparency = 1
tabExtensionText.TextColor3 = Color3.fromRGB(255, 255, 255)
tabExtensionText.Font = Enum.Font.GothamSemibold
tabExtensionText.TextSize = 12
tabExtensionText.Parent = tabExtension

local tabExtensionImage = Instance.new("ImageLabel")
tabExtensionImage.Size = UDim2.new(0, 14, 0, 14)
tabExtensionImage.Position = UDim2.new(0, 8, 0.5, -10)
tabExtensionImage.BackgroundTransparency = 1
tabExtensionImage.Parent = tabExtension

-- Sidebar Buttons
local sections = {"Home", "Combat", "Visual", "Utility"}
local buttons = {}
local selectedButton = nil

for i, section in ipairs(sections) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 50)
    button.Position = UDim2.new(0, 0, 0, (i - 1) * 60 + 10)
    button.BackgroundTransparency = 1
    button.Text = section
    button.TextColor3 = Color3.fromRGB(200, 200, 220)
    button.Font = Enum.Font.Gotham
    button.TextSize = 18
    button.Parent = sidebar
    table.insert(buttons, button)

    local highlightBox = createFrame(button, UDim2.new(0.9, 0, 0.9, 0), UDim2.new(0.05, 0, 0.05, 0), Color3.fromRGB(50, 50, 70), 1)
    createUICorner(highlightBox, 8)

    button.MouseEnter:Connect(function()
        if button ~= selectedButton then
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        local tween = TweenService:Create(highlightBox, TweenInfo.new(0.3), {BackgroundTransparency = 0.5})
        tween:Play()
    end)

    button.MouseLeave:Connect(function()
        if button ~= selectedButton then
            button.TextColor3 = Color3.fromRGB(200, 200, 220)
        end
        local tween = TweenService:Create(highlightBox, TweenInfo.new(0.3), {BackgroundTransparency = 1})
        tween:Play()
    end)

    button.MouseButton1Click:Connect(function()
        if selectedButton then
            selectedButton.TextColor3 = Color3.fromRGB(200, 200, 220)
        end
        selectedButton = button
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        homeText.Text = section

        if section == "Combat" then
            homeText.Position = UDim2.new(0, 30, 0, 0)
            homeIcon.Image = "rbxassetid://111502832608614"
            tabExtension.Size = UDim2.new(0, 80, 0, 41)
            tabExtensionText.Text = "Combat"
            tabExtensionImage.Image = "rbxassetid://111502832608614"
        elseif section == "Visual" then
            homeText.Position = UDim2.new(0, 20, 0, 0)
            homeIcon.Image = "rbxassetid://138701471245949"
            tabExtension.Size = UDim2.new(0, 70, 0, 41)
            tabExtensionText.Text = "Visual"
            tabExtensionImage.Image = "rbxassetid://138701471245949"
        elseif section == "Utility" then
            homeText.Position = UDim2.new(0, 20, 0, 0)
            homeIcon.Image = "rbxassetid://125189009266061"
            tabExtension.Size = UDim2.new(0, 70, 0, 41)
            tabExtensionText.Text = "Utility"
            tabExtensionImage.Image = "rbxassetid://125189009266061"
        else
            homeText.Position = UDim2.new(0, 20, 0, 0)
            homeIcon.Image = "rbxassetid://137214348651815"
            tabExtension.Size = UDim2.new(0, 70, 0, 41)
            tabExtensionText.Text = "Home"
            tabExtensionImage.Image = "rbxassetid://137214348651815"
        end

        for _, child in ipairs(contentPanel:GetChildren()) do
            if child ~= innerPanel then
                child:Destroy()
            end
        end
    end)
end

-- Borders
createFrame(mainFrame, UDim2.new(0, 1, 1, 0), UDim2.new(0, 150, 0, 0), Color3.fromRGB(35, 35, 55))
createFrame(mainFrame, UDim2.new(1, -150, 0, 1), UDim2.new(0, 150, 0, 50), Color3.fromRGB(35, 35, 55))

-- End of script