-- UILibrary.lua: A modern UI library for Roblox exploits
-- Step 9: Integrate input fields in the Tools tab with placeholder text and focus animations
-- Fix: Ensure correct tab content naming to prevent "MainContent is not a valid member of Frame"

local UILibrary = {}
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Configuration
local config = {
    darkMode = true, -- Start in dark mode
    borderColorDark = Color3.fromRGB(255, 255, 255), -- White border for dark mode
    borderColorLight = Color3.fromRGB(0, 0, 0), -- Black border for light mode
    backgroundColorDark = Color3.fromRGB(30, 30, 30), -- Dark background
    backgroundColorLight = Color3.fromRGB(240, 240, 240), -- Light background
    tabColorDark = Color3.fromRGB(50, 50, 50), -- Tab background in dark mode
    tabColorLight = Color3.fromRGB(200, 200, 200), -- Tab background in light mode
    textColorDark = Color3.fromRGB(255, 255, 255), -- Text color in dark mode
    textColorLight = Color3.fromRGB(0, 0, 0), -- Text color in light mode
    cardColorDark = Color3.fromRGB(40, 40, 40), -- Card background in dark mode
    cardColorLight = Color3.fromRGB(220, 220, 220), -- Card background in light mode
    orbColorDark = Color3.fromRGB(100, 100, 150), -- Orb color in dark mode
    orbColorLight = Color3.fromRGB(100, 100, 100), -- Orb color in light mode
    buttonColorDark = Color3.fromRGB(60, 60, 60), -- Button background in dark mode
    buttonColorLight = Color3.fromRGB(180, 180, 180), -- Button background in light mode
    toggleColorDark = Color3.fromRGB(60, 60, 60), -- Toggle background in dark mode
    toggleColorLight = Color3.fromRGB(180, 180, 180), -- Toggle background in light mode
    toggleKnobColorDark = Color3.fromRGB(200, 200, 200), -- Toggle knob in dark mode
    toggleKnobColorLight = Color3.fromRGB(50, 50, 50), -- Toggle knob in light mode
    dropdownColorDark = Color3.fromRGB(50, 50, 50), -- Dropdown background in dark mode
    dropdownColorLight = Color3.fromRGB(200, 200, 200), -- Dropdown background in light mode
    sliderColorDark = Color3.fromRGB(60, 60, 60), -- Slider background in dark mode
    sliderColorLight = Color3.fromRGB(180, 180, 180), -- Slider background in light mode
    sliderHandleColorDark = Color3.fromRGB(200, 200, 200), -- Slider handle in dark mode
    sliderHandleColorLight = Color3.fromRGB(50, 50, 50), -- Slider handle in light mode
    inputColorDark = Color3.fromRGB(50, 50, 50), -- Input field background in dark mode
    inputColorLight = Color3.fromRGB(200, 200, 200), -- Input field background in light mode
}

-- Create the main UI
function UILibrary:Init()
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UILibraryGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- Create orb container (behind main frame)
    local orbContainer = Instance.new("Frame")
    orbContainer.Name = "OrbContainer"
    orbContainer.Size = UDim2.new(1, 0, 1, 0)
    orbContainer.BackgroundTransparency = 1
    orbContainer.ZIndex = 0
    orbContainer.Parent = screenGui
    
    -- Function to create an orb
    local function createOrb()
        local orb = Instance.new("Frame")
        orb.Name = "Orb"
        orb.Size = UDim2.new(0, 50, 0, 50)
        orb.BackgroundColor3 = config.darkMode and config.orbColorDark or config.orbColorLight
        orb.BackgroundTransparency = 0.7
        orb.BorderSizePixel = 0
        orb.ZIndex = 0
        orb.Parent = orbContainer
        
        local orbCorner = Instance.new("UICorner")
        orbCorner.CornerRadius = UDim.new(1, 0) -- Fully circular
        orbCorner.Parent = orb
        
        -- Random initial position
        local random = Random.new()
        orb.Position = UDim2.new(random:NextNumber(0, 1), 0, random:NextNumber(0, 1), 0)
        
        -- Animate orb movement
        local function animateOrb()
            local targetX = random:NextNumber(0, 1)
            local targetY = random:NextNumber(0, 1)
            local duration = random:NextNumber(5, 10)
            local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local goal = { Position = UDim2.new(targetX, 0, targetY, 0) }
            local tween = TweenService:Create(orb, tweenInfo, goal)
            tween:Play()
            tween.Completed:Connect(animateOrb) -- Loop animation
        end
        
        -- Animate orb transparency (fade in/out)
        local function animateTransparency()
            local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local goal = { BackgroundTransparency = random:NextNumber(0.5, 0.9) }
            local tween = TweenService:Create(orb, tweenInfo, goal)
            tween:Play()
            tween.Completed:Connect(animateTransparency) -- Loop animation
        end
        
        animateOrb()
        animateTransparency()
        
        return orb
    end
    
    -- Create multiple orbs
    local orbs = {}
    for i = 1, 5 do
        table.insert(orbs, createOrb())
    end
    
    -- Create main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0.5, 0, 0.6, 0)
    mainFrame.Position = UDim2.new(0.25, 0, 0.2, 0)
    mainFrame.BackgroundColor3 = config.darkMode and config.backgroundColorDark or config.backgroundColorLight
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = config.darkMode and config.borderColorDark or config.borderColorLight
    mainFrame.ZIndex = 1
    mainFrame.Parent = screenGui
    
    -- Add UI corner for rounded edges
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 8)
    uiCorner.Parent = mainFrame
    
    -- Create tab container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(1, 0, 0, 50)
    tabContainer.Position = UDim2.new(0, 0, 0, 0)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = mainFrame
    
    -- Create content area
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -20, 1, -70)
    contentArea.Position = UDim2.new(0, 10, 0, 60)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = mainFrame
    
    -- Tab management
    local tabs = {}
    local activeTab = nil
    
    -- Function to create a button
    local function createButton(parent, text, onClick)
        local button = Instance.new("TextButton")
        button.Name = text .. "Button"
        button.Size = UDim2.new(0, 100, 0, 30)
        button.BackgroundColor3 = config.darkMode and config.buttonColorDark or config.buttonColorLight
        button.Text = text
        button.TextColor3 = config.darkMode and config.textColorDark or config.textColorLight
        button.Font = Enum.Font.SourceSans
        button.TextSize = 16
        button.Parent = parent
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = button
        
        -- Hover effect (scale up)
        button.MouseEnter:Connect(function()
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local hoverGoal = { Size = UDim2.new(0, 105, 0, 32) }
            local hoverTween = TweenService:Create(button, tweenInfo, hoverGoal)
            hoverTween:Play()
        end)
        
        button.MouseLeave:Connect(function()
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local defaultGoal = { Size = UDim2.new(0, 100, 0, 30) }
            local defaultTween = TweenService:Create(button, tweenInfo, defaultGoal)
            defaultTween:Play()
        end)
        
        -- Click effect (ripple)
        button.MouseButton1Click:Connect(function()
            local ripple = Instance.new("Frame")
            ripple.Name = "Ripple"
            ripple.Size = UDim2.new(0, 0, 0, 0)
            ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
            ripple.BackgroundColor3 = config.darkMode and config.textColorDark or config.textColorLight
            ripple.BackgroundTransparency = 0.5
            ripple.ZIndex = button.ZIndex + 1
            ripple.Parent = button
            
            local rippleCorner = Instance.new("UICorner")
            rippleCorner.CornerRadius = UDim.new(1, 0)
            rippleCorner.Parent = ripple
            
            local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
            local rippleGoal = { Size = UDim2.new(0, 100, 0, 100), BackgroundTransparency = 1 }
            local rippleTween = TweenService:Create(ripple, tweenInfo, rippleGoal)
            rippleTween:Play()
            rippleTween.Completed:Connect(function()
                ripple:Destroy()
            end)
            
            if onClick then
                onClick()
            end
        end)
        
        return button
    end
    
    -- Function to create a toggle
    local function createToggle(parent, label, defaultState, onToggle)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Name = label .. "Toggle"
        toggleFrame.Size = UDim2.new(0, 200, 0, 40)
        toggleFrame.BackgroundTransparency = 1
        toggleFrame.Parent = parent
        
        -- Add label
        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Name = "Label"
        toggleLabel.Size = UDim2.new(0, 140, 0, 40)
        toggleLabel.Position = UDim2.new(0, 0, 0, 0)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Text = label
        toggleLabel.TextColor3 = config.darkMode and config.textColorDark or config.textColorLight
        toggleLabel.Font = Enum.Font.SourceSans
        toggleLabel.TextSize = 18
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.Parent = tdoggleFrame
        
        -- Create toggle button
        local toggleButton = Instance.new("TextButton")
        toggleButton.Name = "ToggleButton"
        toggleButton.Size = UDim2.new(0, 50, 0, 24)
        toggleButton.Position = UDim2.new(0, 150, 0, 8)
        toggleButton.BackgroundColor3 = config.darkMode and config.toggleColorDark or config.toggleColorLight
        toggleButton.Text = ""
        toggleButton.Parent = toggleFrame
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 12)
        toggleCorner.Parent = toggleButton
        
        -- Create knob
        local knob = Instance.new("Frame")
        knob.Name = "Knob"
        knob.Size = UDim2.new(0, 20, 0, 20)
        knob.Position = defaultState and UDim2.new(0, 28, 0, 2) or UDim2.new(0, 2, 0, 2)
        knob.BackgroundColor3 = config.darkMode and config.toggleKnobColorDark or config.toggleKnobColorLight
        knob.Parent = toggleButton
        
        local knobCorner = Instance.new("UICorner")
        knobCorner.CornerRadius = UDim.new(1, 0)
        knobCorner.Parent = knob
        
        local isToggled = defaultState
        
        -- Hover effect (scale up)
        toggleButton.MouseEnter:Connect(function()
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local hoverGoal = { Size = UDim2.new(0, 54, 0, 26) }
            local hoverTween = TweenService:Create(toggleButton, tweenInfo, hoverGoal)
            hoverTween:Play()
        end)
        
        toggleButton.MouseLeave:Connect(function()
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local defaultGoal = { Size = UDim2.new(0, 50, 0, 24) }
            local defaultTween = TweenService:Create(toggleButton, tweenInfo, defaultGoal)
            defaultTween:Play()
        end)
        
        -- Toggle functionality
        toggleButton.MouseButton1Click:Connect(function()
            isToggled = not isToggled
            local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local knobGoal = isToggled and { Position = UDim2.new(0, 28, 0, 2) } or { Position = UDim2.new(0, 2, 0, 2) }
            local knobTween = TweenService:Create(knob, tweenInfo, knobGoal)
            knobTween:Play()
            
            if onToggle then
                onToggle(isToggled)
            end
        end)
        
        return toggleFrame
    end
    
    -- Function to create a dropdown
    local function createDropdown(parent, label, options, defaultOption, onSelect)
        local dropdownFrame = Instance.new("Frame")
        dropdownFrame.Name = label .. "Dropdown"
        dropdownFrame.Size = UDim2.new(0, 200, 0, 40)
        dropdownFrame.BackgroundTransparency = 1
        dropdownFrame.Parent = parent
        
        -- Create dropdown button
        local dropdownButton = Instance.new("TextButton")
        dropdownButton.Name = "DropdownButton"
        dropdownButton.Size = UDim2.new(0, 200, 0, 40)
        dropdownButton.BackgroundColor3 = config.darkMode and config.dropdownColorDark or config.dropdownColorLight
        dropdownButton.Text = defaultOption or options[1]
        dropdownButton.TextColor3 = config.darkMode and config.textColorDark or config.textColorLight
        dropdownButton.Font = Enum.Font.SourceSans
        dropdownButton.TextSize = 18
        dropdownButton.Parent = dropdownFrame
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = dropdownButton
        
        -- Create dropdown menu
        local dropdownMenu = Instance.new("Frame")
        dropdownMenu.Name = "DropdownMenu"
        dropdownMenu.Size = UDim2.new(0, 200, 0, 0)
        dropdownMenu.Position = UDim2.new(0, 0, 0, 40)
        dropdownMenu.BackgroundColor3 = config.darkMode and config.dropdownColorDark or config.dropdownColorLight
        dropdownMenu.Visible = false
        dropdownMenu.ClipsDescendants = true
        dropdownMenu.Parent = dropdownFrame
        
        local menuCorner = Instance.new("UICorner")
        menuCorner.CornerRadius = UDim.new(0, 6)
        menuCorner.Parent = dropdownMenu
        
        local uiListLayout = Instance.new("UIListLayout")
        uiListLayout.FillDirection = Enum.FillDirection.Vertical
        uiListLayout.Padding = UDim.new(0, 2)
        uiListLayout.Parent = dropdownMenu
        
        -- Create dropdown options
        local optionButtons = {}
        for i, option in ipairs(options) do
            local optionButton = Instance.new("TextButton")
            optionButton.Name = option .. "Option"
            optionButton.Size = UDim2.new(1, 0, 0, 30)
            optionButton.BackgroundColor3 = config.darkMode and config.dropdownColorDark or config.dropdownColorLight
            optionButton.Text = option
            optionButton.TextColor3 = config.darkMode and config.textColorDark or config.textColorLight
            optionButton.Font = Enum.Font.SourceSans
            optionButton.TextSize = 16
            optionButton.Parent = dropdownMenu
            
            -- Hover highlight
            optionButton.MouseEnter:Connect(function()
                local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                local hoverGoal = { BackgroundColor3 = config.darkMode and Color3.fromRGB(70, 70, 70) or Color3.fromRGB(180, 180, 180) }
                local hoverTween = TweenService:Create(optionButton, tweenInfo, hoverGoal)
                hoverTween:Play()
            end)
            
            optionButton.MouseLeave:Connect(function()
                local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                local defaultGoal = { BackgroundColor3 = config.darkMode and config.dropdownColorDark or config.dropdownColorLight }
                local defaultTween = TweenService:Create(optionButton, tweenInfo, defaultGoal)
                defaultTween:Play()
            end)
            
            -- Option selection
            optionButton.MouseButton1Click:Connect(function()
                dropdownButton.Text = option
                dropdownMenu.Visible = false
                local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                local closeGoal = { Size = UDim2.new(0, 200, 0, 0) }
                local closeTween = TweenService:Create(dropdownMenu, tweenInfo, closeGoal)
                closeTween:Play()
                if onSelect then
                    onSelect(option)
                end
            end)
            
            table.insert(optionButtons, optionButton)
        end
        
        -- Calculate menu height
        local menuHeight = #options * 30 + (#options - 1) * 2
        
        -- Hover effect (scale up)
        dropdownButton.MouseEnter:Connect(function()
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local hoverGoal = { Size = UDim2.new(0, 205, 0, 42) }
            local hoverTween = TweenService:Create(dropdownButton, tweenInfo, hoverGoal)
            hoverTween:Play()
        end)
        
        dropdownButton.MouseLeave:Connect(function()
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local defaultGoal = { Size = UDim2.new(0, 200, 0, 40) }
            local defaultTween = TweenService:Create(dropdownButton, tweenInfo, defaultGoal)
            defaultTween:Play()
        end)
        
        -- Toggle dropdown menu
        dropdownButton.MouseButton1Click:Connect(function()
            dropdownMenu.Visible = not dropdownMenu.Visible
            local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local goal = dropdownMenu.Visible and { Size = UDim2.new(0, 200, 0, menuHeight) } or { Size = UDim2.new(0, 200, 0, 0) }
            local tween = TweenService:Create(dropdownMenu, tweenInfo, goal)
            tween:Play()
        end)
        
        return dropdownFrame
    end
    
    -- Function to create a slider
    local function createSlider(parent, label, minValue, maxValue, defaultValue, onValueChanged)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Name = label .. "Slider"
        sliderFrame.Size = UDim2.new(0, 200, 0, 50)
        sliderFrame.BackgroundTransparency = 1
        sliderFrame.Parent = parent
        
        -- Add label
        local sliderLabel = Instance.new("TextLabel")
        sliderLabel.Name = "Label"
        sliderLabel.Size = UDim2.new(0, 140, 0, 20)
        sliderLabel.Position = UDim2.new(0, 0, 0, 0)
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Text = label
        sliderLabel.TextColor3 = config.darkMode and config.textColorDark or config.textColorLight
        sliderLabel.Font = Enum.Font.SourceSans
        sliderLabel.TextSize = 18
        sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        sliderLabel.Parent = sliderFrame
        
        -- Create slider track
        local sliderTrack = Instance.new("Frame")
        sliderTrack.Name = "Track"
        sliderTrack.Size = UDim2.new(0, 180, 0, 8)
        sliderTrack.Position = UDim2.new(0, 10, 0, 30)
        sliderTrack.BackgroundColor3 = config.darkMode and config.sliderColorDark or config.sliderColorLight
        sliderTrack.Parent = sliderFrame
        
        local trackCorner = Instance.new("UICorner")
        trackCorner.CornerRadius = UDim.new(0, 4)
        trackCorner.Parent = sliderTrack
        
        -- Create slider handle
        local sliderHandle = Instance.new("TextButton")
        sliderHandle.Name = "Handle"
        sliderHandle.Size = UDim2.new(0, 16, 0, 16)
        sliderHandle.BackgroundColor3 = config.darkMode and config.sliderHandleColorDark or config.sliderHandleColorLight
        sliderHandle.Text = ""
        sliderHandle.Parent = sliderTrack
        
        local handleCorner = Instance.new("UICorner")
        handleCorner.CornerRadius = UDim.new(1, 0)
        handleCorner.Parent = sliderHandle
        
        -- Create tooltip
        local tooltip = Instance.new("TextLabel")
        tooltip.Name = "Tooltip"
        tooltip.Size = UDim2.new(0, 40, 0, 20)
        tooltip.BackgroundColor3 = config.darkMode and config.dropdownColorDark or config.dropdownColorLight
        tooltip.TextColor3 = config.darkMode and config.textColorDark or config.textColorLight
        tooltip.Font = Enum.Font.SourceSans
        tooltip.TextSize = 14
        tooltip.Visible = false
        tooltip.ZIndex = 2
        tooltip.Parent = sliderFrame
        
        local tooltipCorner = Instance.new("UICorner")
        tooltipCorner.CornerRadius = UDim.new(0, 4)
        tooltipCorner.Parent = tooltip
        
        local currentValue = defaultValue or minValue
        local function updateHandlePosition()
            local ratio = (currentValue - minValue) / (maxValue - minValue)
            sliderHandle.Position = UDim2.new(ratio, -8, 0, -4)
            tooltip.Text = tostring(math.floor(currentValue))
            tooltip.Position = UDim2.new(ratio, -20, 0, -25)
        end
        updateHandlePosition()
        
        -- Hover effect (scale up)
        sliderHandle.MouseEnter:Connect(function()
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local hoverGoal = { Size = UDim2.new(0, 20, 0, 20) }
            local hoverTween = TweenService:Create(sliderHandle, tweenInfo, hoverGoal)
            hoverTween:Play()
            tooltip.Visible = true
        end)
        
        sliderHandle.MouseLeave:Connect(function()
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local defaultGoal = { Size = UDim2.new(0, 16, 0, 16) }
            local defaultTween = TweenService:Create(sliderHandle, tweenInfo, defaultGoal)
            defaultTween:Play()
            tooltip.Visible = false
        end)
        
        -- Dragging functionality
        local dragging = false
        sliderHandle.MouseButton1Down:Connect(function()
            dragging = true
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        sliderTrack.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                local mouseX = input.Position.X
                local trackAbsPos = sliderTrack.AbsolutePosition.X
                local trackAbsSize = sliderTrack.AbsoluteSize.X
                local ratio = math.clamp((mouseX - trackAbsPos) / trackAbsSize, 0, 1)
                currentValue = minValue + ratio * (maxValue - minValue)
                updateHandlePosition()
                if onValueChanged then
                    onValueChanged(currentValue)
                end
            end
        end)
        
        RunService.RenderStepped:Connect(function()
            if dragging then
                local mousePos = UserInputService:GetMouseLocation()
                local trackAbsPos = sliderTrack.AbsolutePosition.X
                local trackAbsSize = sliderTrack.AbsoluteSize.X
                local ratio = math.clamp((mousePos.X - trackAbsPos) / trackAbsSize, 0, 1)
                currentValue = minValue + ratio * (maxValue - minValue)
                updateHandlePosition()
                if onValueChanged then
                    onValueChanged(currentValue)
                end
            end
        end)
        
        return sliderFrame
    end
    
    -- Function to create an input field
    local function createInput(parent, label, placeholder, onSubmit)
        local inputFrame = Instance.new("Frame")
        inputFrame.Name = label .. "Input"
        inputFrame.Size = UDim2.new(0, 200, 0, 40)
        inputFrame.BackgroundTransparency = 1
        inputFrame.Parent = parent
        
        -- Add label
        local inputLabel = Instance.new("TextLabel")
        inputLabel.Name = "Label"
        inputLabel.Size = UDim2.new(0, 140, 0, 20)
        inputLabel.Position = UDim2.new(0, 0, 0, 0)
        inputLabel.BackgroundTransparency = 1
        inputLabel.Text = label
        inputLabel.TextColor3 = config.darkMode and config.textColorDark or config.textColorLight
        inputLabel.Font = Enum.Font.SourceSans
        inputLabel.TextSize = 18
        inputLabel.TextXAlignment = Enum.TextXAlignment.Left
        inputLabel.Parent = inputFrame
        
        -- Create input box
        local inputBox = Instance.new("TextBox")
        inputBox.Name = "InputBox"
        inputBox.Size = UDim2.new(0, 180, 0, 30)
        inputBox.Position = UDim2.new(0, 10, 0, 20)
        inputBox.BackgroundColor3 = config.darkMode and config.inputColorDark or config.inputColorLight
        inputBox.TextColor3 = config.darkMode and config.textColorDark or config.textColorLight
        inputBox.PlaceholderText = placeholder
        inputBox.PlaceholderColor3 = config.darkMode and Color3.fromRGB(150, 150, 150) or Color3.fromRGB(100, 100, 100)
        inputBox.Font = Enum.Font.SourceSans
        inputBox.TextSize = 16
        inputBox.TextXAlignment = Enum.TextXAlignment.Left
        inputBox.ClearTextOnFocus = false
        inputBox.Parent = inputFrame
        
        local inputCorner = Instance.new("UICorner")
        inputCorner.CornerRadius = UDim.new(0, 6)
        inputCorner.Parent = inputBox
        
        -- Focus animation
        inputBox.Focused:Connect(function()
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local focusGoal = { Size = UDim2.new(0, 185, 0, 32) }
            local focusTween = TweenService:Create(inputBox, tweenInfo, focusGoal)
            focusTween:Play()
        end)
        
        inputBox.FocusLost:Connect(function(enterPressed)
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local defaultGoal = { Size = UDim2.new(0, 180, 0, 30) }
            local defaultTween = TweenService:Create(inputBox, tweenInfo, defaultGoal)
            defaultTween:Play()
            
            if enterPressed and onSubmit then
                local text = inputBox.Text
                if text ~= "" then
                    onSubmit(text)
                else
                    inputBox.Text = ""
                    inputBox.PlaceholderText = "Invalid input!"
                    task.wait(1)
                    inputBox.PlaceholderText = placeholder
                end
            end
        end)
        
        return inputFrame
    end
    
    -- Function to create a card
    local function createCard(parent, title, description)
        local card = Instance.new("Frame")
        card.Name = title .. "Card"
        card.Size = UDim2.new(0.45, 0, 0, 120)
        card.BackgroundColor3 = config.darkMode and config.cardColorDark or config.cardColorLight
        card.BorderSizePixel = 0
        card.Parent = parent
        
        -- Add UI corner for rounded edges
        local cardCorner = Instance.new("UICorner")
        cardCorner.CornerRadius = UDim.new(0, 6)
        cardCorner.Parent = card
        
        -- Add shadow effect
        local uiStroke = Instance.new("UIStroke")
        uiStroke.Thickness = 2
        uiStroke.Color = Color3.fromRGB(0, 0, 0)
        uiStroke.Transparency = 0.8
        uiStroke.Parent = card
        
        -- Add title
        local cardTitle = Instance.new("TextLabel")
        cardTitle.Name = "Title"
        cardTitle.Size = UDim2.new(1, -20, 0, 30)
        cardTitle.Position = UDim2.new(0, 10, 0, 10)
        cardTitle.BackgroundTransparency = 1
        cardTitle.Text = title
        cardTitle.TextColor3 = config.darkMode and config.textColorDark or config.textColorLight
        cardTitle.Font = Enum.Font.SourceSansBold
        cardTitle.TextSize = 20
        cardTitle.TextXAlignment = Enum.TextXAlignment.Left
        cardTitle.Parent = card
        
        -- Add description
        local cardDescription = Instance.new("TextLabel")
        cardDescription.Name = "Description"
        cardDescription.Size = UDim2.new(1, -20, 0, 40)
        cardDescription.Position = UDim2.new(0, 10, 0, 40)
        cardDescription.BackgroundTransparency = 1
        cardDescription.Text = description
        cardDescription.TextColor3 = config.darkMode and config.textColorDark or config.textColorLight
        cardDescription.Font = Enum.Font.SourceSans
        cardDescription.TextSize = 16
        cardDescription.TextXAlignment = Enum.TextXAlignment.Left
        cardDescription.TextWrapped = true
        cardDescription.Parent = card
        
        -- Add button
        local button = createButton(card, "Activate", function()
            print("Activated: " .. title)
        end)
        button.Position = UDim2.new(0, 10, 0, 80)
        
        -- Hover effect
        card.MouseEnter:Connect(function()
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local hoverGoal = { Size = UDim2.new(0.46, 0, 0, 125) }
            local hoverTween = TweenService:Create(card, tweenInfo, hoverGoal)
            hoverTween:Play()
        end)
        
        card.MouseLeave:Connect(function()
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local defaultGoal = { Size = UDim2.new(0.45, 0, 0, 120) }
            local defaultTween = TweenService:Create(card, tweenInfo, defaultGoal)
            defaultTween:Play()
        end)
        
        return card
    end
    
    -- Function to create a tab
    local function createTab(name)
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name .. "Tab"
        tabButton.Size = UDim2.new(0, 100, 0, 40)
        tabButton.Position = UDim2.new(0, #tabs * 110 + 10, 0, 5)
        tabButton.BackgroundColor3 = config.darkMode and config.tabColorDark or config.tabColorLight
        tabButton.Text = name
        tabButton.TextColor3 = config.darkMode and config.textColorDark or config.textColorLight
        tabButton.Font = Enum.Font.SourceSansBold
        tabButton.TextSize = 18
        tabButton.Parent = tabContainer
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 6)
        tabCorner.Parent = tabButton
        
        -- Create content frame for this tab
        local tabContent = Instance.new("Frame")
        tabContent.Name = name .. "Content"
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = false
        tabContent.Parent = contentArea
        
        -- Add separator
        local separator = Instance.new("Frame")
        separator.Name = "Separator"
        separator.Size = UDim2.new(1, -20, 0, 2)
        separator.Position = UDim2.new(0, 10, 0, 10)
        separator.BackgroundColor3 = config.darkMode and config.textColorDark or config.textColorLight
        separator.Parent = tabContent
        
        -- Add cards to Main tab
        if name == "Main" then
            local cardContainer = Instance.new("Frame")
            cardContainer.Name = "CardContainer"
            cardContainer.Size = UDim2.new(1, 0, 1, -20)
            cardContainer.Position = UDim2.new(0, 0, 0, 20)
            cardContainer.BackgroundTransparency = 1
            cardContainer.Parent = tabContent
            
            local uiListLayout = Instance.new("UIListLayout")
            uiListLayout.FillDirection = Enum.FillDirection.Horizontal
            uiListLayout.Wraps = true
            uiListLayout.Padding = UDim.new(0, 10)
            uiListLayout.Parent = cardContainer
            
            -- Create sample cards
            createCard(cardContainer, "Exploit Tool 1", "A powerful tool for in-game exploits.")
            createCard(cardContainer, "Exploit Tool 2", "Enhance your gameplay with this feature.")
        end
        
        -- Add toggles and sliders to Settings tab
        if name == "Settings" then
            local settingsContainer = Instance.new("Frame")
            settingsContainer.Name = "SettingsContainer"
            settingsContainer.Size = UDim2.new(1, 0, 1, -20)
            settingsContainer.Position = UDim2.new(0, 0, 0, 20)
            settingsContainer.BackgroundTransparency = 1
            settingsContainer.Parent = tabContent
            
            local uiListLayout = Instance.new("UIListLayout")
            uiListLayout.FillDirection = Enum.FillDirection.Vertical
            uiListLayout.Padding = UDim.new(0, 10)
            uiListLayout.Parent = settingsContainer
            
            -- Create sample toggles
            createToggle(settingsContainer, "Enable Exploits", true, function(state)
                print("Exploits Enabled: " .. tostring(state))
            end)
            createToggle(settingsContainer, "Auto-Update", false, function(state)
                print("Auto-Update Enabled: " .. tostring(state))
            end)
            
            -- Create sample sliders
            createSlider(settingsContainer, "Speed Boost", 0, 100, 50, function(value)
                print("Speed Boost: " .. tostring(value))
            end)
            createSlider(settingsContainer, "Opacity", 0, 1, 0.5, function(value)
                print("Opacity: " .. tostring(value))
            end)
        end
        
        -- Add dropdowns and input fields to Tools tab
        if name == "Tools" then
            local toolsContainer = Instance.new("Frame")
            toolsContainer.Name = "ToolsContainer"
            toolsContainer.Size = UDim2.new(1, 0, 1, -20)
            toolsContainer.Position = UDim2.new(0, 0, 0, 20)
            toolsContainer.BackgroundTransparency = 1
            toolsContainer.Parent = tabContent
            
            local uiListLayout = Instance.new("UIListLayout")
            uiListLayout.FillDirection = Enum.FillDirection.Vertical
            uiListLayout.Padding = UDim.new(0, 10)
            uiListLayout.Parent = toolsContainer
            
            -- Create sample dropdowns
            createDropdown(toolsContainer, "Tool Type", {"Speed Hack", "Fly Hack", "Noclip"}, "Speed Hack", function(option)
                print("Selected Tool: " .. option)
            end)
            createDropdown(toolsContainer, "Environment", {"Client", "Server", "Both"}, "Client", function(option)
                print("Selected Environment: " .. option)
            end)
            
            -- Create sample input fields
            createInput(toolsContainer, "Command", "Enter command...", function(text)
                print("Command Submitted: " .. text)
            end)
            createInput(toolsContainer, "Player ID", "Enter player ID...", function(text)
                print("Player ID Submitted: " .. text)
            end)
        end
        
        -- Tab switching
        tabButton.MouseButton1Click:Connect(function()
            if activeTab ~= tabButton then
                if activeTab then
                    activeTab.BackgroundTransparency = 0
                    local previousContent = contentArea[activeTab.Name:gsub("Tab", "Content")]
                    if previousContent then
                        previousContent.Visible = false
                    end
                end
                tabButton.BackgroundTransparency = 0.5
                tabContent.Visible = true
                activeTab = tabButton
                
                -- Animate tab switch
                local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                local contentGoal = { Position = UDim2.new(0, 10, 0, 60) }
                local contentTween = TweenService:Create(tabContent, tweenInfo, contentGoal)
                contentTween:Play()
            end
        end)
        
        table.insert(tabs, tabButton)
        return tabContent
    end
    
    -- Create default tabs
    createTab("Main")
    createTab("Settings")
    createTab("Tools")
    
    -- Set default active tab
    if tabs[1] then
        tabs[1].BackgroundTransparency = 0.5
        local defaultContent = contentArea[tabs[1].Name:gsub("Tab", "Content")]
        if defaultContent then
            defaultContent.Visible = true
        end
        activeTab = tabs[1]
    end
    
    -- Create theme toggle button
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ThemeToggle"
    toggleButton.Size = UDim2.new(0, 100, 0, 40)
    toggleButton.Position = UDim2.new(1, -120, 0, 10)
    toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    toggleButton.Text = config.darkMode and "Light Mode" or "Dark Mode"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Font = Enum.Font.SourceSans
    toggleButton.TextSize = 18
    toggleButton.Parent = tabContainer
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleButton
    
    -- Theme toggle functionality
    toggleButton.MouseButton1Click:Connect(function()
        config.darkMode = not config.darkMode
        
        -- Animate theme transition
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        local mainFrameGoals = {
            BackgroundColor3 = config.darkMode and config.backgroundColorDark or config.backgroundColorLight,
            BorderColor3 = config.darkMode and config.borderColorDark or config.borderColorLight
        }
        local tabGoals = {
            BackgroundColor3 = config.darkMode and config.tabColorDark or config.tabColorLight,
            TextColor3 = config.darkMode and config.textColorDark or config.textColorLight
        }
        local cardGoals = {
            BackgroundColor3 = config.darkMode and config.cardColorDark or config.cardColorLight,
            TextColor3 = config.darkMode and config.textColorDark or config.textColorLight
        }
        local separatorGoals = {
            BackgroundColor3 = config.darkMode and config.textColorDark or config.textColorLight
        }
        local orbGoals = {
            BackgroundColor3 = config.darkMode and config.orbColorDark or config.orbColorLight
        }
        local buttonGoals = {
            BackgroundColor3 = config.darkMode and config.buttonColorDark or config.buttonColorLight,
            TextColor3 = config.darkMode and config.textColorDark or config.textColorLight
        }
        local toggleGoals = {
            BackgroundColor3 = config.darkMode and config.toggleColorDark or config.toggleColorLight
        }
        local toggleKnobGoals = {
            BackgroundColor3 = config.darkMode and config.toggleKnobColorDark or config.toggleKnobColorLight
        }
        local dropdownGoals = {
            BackgroundColor3 = config.darkMode and config.dropdownColorDark or config.dropdownColorLight,
            TextColor3 = config.darkMode and config.textColorDark or config.textColorLight
        }
        local sliderGoals = {
            BackgroundColor3 = config.darkMode and config.sliderColorDark or config.sliderColorLight
        }
        local sliderHandleGoals = {
            BackgroundColor3 = config.darkMode and config.sliderHandleColorDark or config.sliderHandleColorLight
        }
        local inputGoals = {
            BackgroundColor3 = config.darkMode and config.inputColorDark or config.inputColorLight,
            TextColor3 = config.darkMode and config.textColorDark or config.textColorLight,
            PlaceholderColor3 = config.darkMode and Color3.fromRGB(150, 150, 150) or Color3.fromRGB(100, 100, 100)
        }
        
        local mainFrameTween = TweenService:Create(mainFrame, tweenInfo, mainFrameGoals)
        mainFrameTween:Play()
        
        for _, tab in ipairs(tabs) do
            local tabTween = TweenService:Create(tab, tweenInfo, tabGoals)
            tabTween:Play()
            local contentFrame = contentArea[tab.Name:gsub("Tab", "Content")]
            if contentFrame then
                local separator = contentFrame.Separator
                local separatorTween = TweenService:Create(separator, tweenInfo, separatorGoals)
                separatorTween:Play()
                
                -- Update cards in Main tab
                if tab.Name == "MainTab" then
                    local cardContainer = contentFrame.CardContainer
                    if cardContainer then
                        for _, card in ipairs(cardContainer:GetChildren()) do
                            if card:IsA("Frame") then
                                local cardTween = TweenService:Create(card, tweenInfo, { BackgroundColor3 = cardGoals.BackgroundColor3 })
                                cardTween:Play()
                                for _, child in ipairs(card:GetChildren()) do
                                    if child:IsA("TextLabel") or child:IsA("TextButton") then
                                        local textTween = TweenService:Create(child, tweenInfo, { TextColor3 = cardGoals.TextColor3 })
                                        textTween:Play()
                                        if child:IsA("TextButton") then
                                            local buttonTween = TweenService:Create(child, tweenInfo, { BackgroundColor3 = buttonGoals.BackgroundColor3 })
                                            buttonTween:Play()
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                
                -- Update toggles and sliders in Settings tab
                if tab.Name == "SettingsTab" then
                    local settingsContainer = contentFrame.SettingsContainer
                    if settingsContainer then
                        for _, settingsFrame in ipairs(settingsContainer:GetChildren()) do
                            if settingsFrame:IsA("Frame") then
                                for _, child in ipairs(settingsFrame:GetChildren()) do
                                    if child:IsA("TextLabel") then
                                        local labelTween = TweenService:Create(child, tweenInfo, { TextColor3 = cardGoals.TextColor3 })
                                        labelTween:Play()
                                    elseif child:IsA("TextButton") then
                                        local toggleTween = TweenService:Create(child, tweenInfo, { BackgroundColor3 = toggleGoals.BackgroundColor3 })
                                        toggleTween:Play()
                                        local knob = child.Knob
                                        if knob then
                                            local knobTween = TweenService:Create(knob, tweenInfo, { BackgroundColor3 = toggleKnobGoals.BackgroundColor3 })
                                            knobTween:Play()
                                        end
                                    elseif child:IsA("Frame") and child.Name:find("Slider") then
                                        local track = child.Track
                                        local handle = track and track.Handle
                                        local tooltip = child.Tooltip
                                        if track then
                                            local trackTween = TweenService:Create(track, tweenInfo, { BackgroundColor3 = sliderGoals.BackgroundColor3 })
                                            trackTween:Play()
                                        end
                                        if handle then
                                            local handleTween = TweenService:Create(handle, tweenInfo, { BackgroundColor3 = sliderHandleGoals.BackgroundColor3 })
                                            handleTween:Play()
                                        end
                                        if tooltip then
                                            local tooltipTween = TweenService:Create(tooltip, tweenInfo, { BackgroundColor3 = dropdownGoals.BackgroundColor3, TextColor3 = dropdownGoals.TextColor3 })
                                            tooltipTween:Play()
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                
                -- Update dropdowns and input fields in Tools tab
                if tab.Name == "ToolsTab" then
                    local toolsContainer = contentFrame.ToolsContainer
                    if toolsContainer then
                        for _, toolsFrame in ipairs(toolsContainer:GetChildren()) do
                            if toolsFrame:IsA("Frame") then
                                for _, child in ipairs(toolsFrame:GetChildren()) do
                                    if child:IsA("TextButton") then
                                        local buttonTween = TweenService:Create(child, tweenInfo, dropdownGoals)
                                        buttonTween:Play()
                                    elseif child:IsA("TextBox") then
                                        local inputTween = TweenService:Create(child, tweenInfo, inputGoals)
                                        inputTween:Play()
                                    elseif child:IsA("TextLabel") then
                                        local labelTween = TweenService:Create(child, tweenInfo, { TextColor3 = cardGoals.TextColor3 })
                                        labelTween:Play()
                                    elseif child:IsA("Frame") then
                                        local menuTween = TweenService:Create(child, tweenInfo, { BackgroundColor3 = dropdownGoals.BackgroundColor3 })
                                        menuTween:Play()
                                        for _, option in ipairs(child:GetChildren()) do
                                            if option:IsA("TextButton") then
                                                local optionTween = TweenService:Create(option, tweenInfo, dropdownGoals)
                                                optionTween:Play()
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        
        -- Update orbs
        for _, orb in ipairs(orbs) do
            local orbTween = TweenService:Create(orb, tweenInfo, orbGoals)
            orbTween:Play()
        end
        
        toggleButton.Text = config.darkMode and "Light Mode" or "Dark Mode"
    end)
    
    return self
end

-- Return the library
return UILibrary
