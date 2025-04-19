-- // Previous code remains the same until the addTab function...

-- // Create a new card in the current tab
function sleekui:addCard(title, description)
    if not self.selectedTab then return; end
    
    -- // Create card frame
    local cardframe = Instance.new("Frame");
    cardframe.Name = title .. "Card";
    cardframe.Size = UDim2.new(1, 0, 0, 0);
    cardframe.AutomaticSize = Enum.AutomaticSize.Y;
    cardframe.BackgroundColor3 = settings[self.theme].card;
    cardframe.BorderSizePixel = 0;
    cardframe.Parent = self.selectedTab.content;
    
    -- // Add corner radius
    local corner = Instance.new("UICorner");
    corner.CornerRadius = UDim.new(0, 8);
    corner.Parent = cardframe;
    
    -- // Add shadow
    local shadow = Instance.new("ImageLabel");
    shadow.Name = "Shadow";
    shadow.AnchorPoint = Vector2.new(0.5, 0.5);
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0);
    shadow.Size = UDim2.new(1, 24, 1, 24);
    shadow.BackgroundTransparency = 1;
    shadow.Image = "rbxassetid://6014261993";
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0);
    shadow.ImageTransparency = 0.5;
    shadow.ZIndex = cardframe.ZIndex - 1;
    shadow.Parent = cardframe;
    
    -- // Add padding
    local padding = Instance.new("UIPadding");
    padding.PaddingLeft = UDim.new(0, 15);
    padding.PaddingRight = UDim.new(0, 15);
    padding.PaddingTop = UDim.new(0, 15);
    padding.PaddingBottom = UDim.new(0, 15);
    padding.Parent = cardframe;
    
    -- // Add title
    local titlelbl = Instance.new("TextLabel");
    titlelbl.Name = "Title";
    titlelbl.Size = UDim2.new(1, 0, 0, 20);
    titlelbl.BackgroundTransparency = 1;
    titlelbl.Font = Enum.Font.GothamBold;
    titlelbl.Text = title;
    titlelbl.TextColor3 = settings[self.theme].text;
    titlelbl.TextSize = 16;
    titlelbl.TextXAlignment = Enum.TextXAlignment.Left;
    titlelbl.Parent = cardframe;
    
    -- // Add description if provided
    local contentContainer = Instance.new("Frame");
    contentContainer.Name = "Content";
    contentContainer.Size = UDim2.new(1, 0, 0, 0);
    contentContainer.AutomaticSize = Enum.AutomaticSize.Y;
    contentContainer.BackgroundTransparency = 1;
    contentContainer.Parent = cardframe;
    
    if description then
        local desclbl = Instance.new("TextLabel");
        desclbl.Name = "Description";
        desclbl.Size = UDim2.new(1, 0, 0, 0);
        desclbl.AutomaticSize = Enum.AutomaticSize.Y;
        desclbl.BackgroundTransparency = 1;
        desclbl.Position = UDim2.new(0, 0, 0, 25);
        desclbl.Font = Enum.Font.Gotham;
        desclbl.Text = description;
        desclbl.TextColor3 = settings[self.theme].subtext;
        desclbl.TextSize = 14;
        desclbl.TextWrapped = true;
        desclbl.TextXAlignment = Enum.TextXAlignment.Left;
        desclbl.Parent = cardframe;
        
        contentContainer.Position = UDim2.new(0, 0, 0, 55);
    else
        contentContainer.Position = UDim2.new(0, 0, 0, 30);
    end
    
    -- // Add list layout to content container
    local layout = Instance.new("UIListLayout");
    layout.SortOrder = Enum.SortOrder.LayoutOrder;
    layout.Padding = UDim.new(0, 10);
    layout.Parent = contentContainer;
    
    -- // Create card data
    local card = {
        frame = cardframe,
        title = titlelbl,
        content = contentContainer,
        components = {}
    };
    
    -- // Add to cards table
    table.insert(self.selectedTab.cards, card);
    
    -- // Add component functions
    function card:addButton(text, callback)
        local btn = Instance.new("TextButton");
        btn.Name = text .. "Button";
        btn.Size = UDim2.new(1, 0, 0, 32);
        btn.BackgroundColor3 = settings[sleekui.theme].accent;
        btn.BorderSizePixel = 0;
        btn.Font = Enum.Font.GothamSemibold;
        btn.Text = text;
        btn.TextColor3 = Color3.fromRGB(255, 255, 255);
        btn.TextSize = 14;
        btn.AutoButtonColor = false;
        btn.Parent = self.content;
        
        -- // Add corner radius
        local corner = Instance.new("UICorner");
        corner.CornerRadius = UDim.new(0, 6);
        corner.Parent = btn;
        
        -- // Click handler with ripple effect
        btn.MouseButton1Click:Connect(function()
            createRipple(btn, uis:GetMouseLocation());
            if callback then callback(); end
        end);
        
        -- // Hover effect
        btn.MouseEnter:Connect(function()
            tween(btn, {time = 0.2}, {
                BackgroundColor3 = settings[sleekui.theme].accent:Lerp(Color3.fromRGB(255, 255, 255), 0.2)
            });
        end);
        
        btn.MouseLeave:Connect(function()
            tween(btn, {time = 0.2}, {
                BackgroundColor3 = settings[sleekui.theme].accent
            });
        end);
        
        return btn;
    end
    
    function card:addToggle(text, default, callback)
        local container = Instance.new("Frame");
        container.Name = text .. "Toggle";
        container.Size = UDim2.new(1, 0, 0, 32);
        container.BackgroundTransparency = 1;
        container.Parent = self.content;
        
        local label = Instance.new("TextLabel");
        label.Name = "Label";
        label.Size = UDim2.new(1, -52, 1, 0);
        label.BackgroundTransparency = 1;
        label.Font = Enum.Font.Gotham;
        label.Text = text;
        label.TextColor3 = settings[sleekui.theme].text;
        label.TextSize = 14;
        label.TextXAlignment = Enum.TextXAlignment.Left;
        label.Parent = container;
        
        local toggleframe = Instance.new("Frame");
        toggleframe.Name = "ToggleFrame";
        toggleframe.AnchorPoint = Vector2.new(1, 0.5);
        toggleframe.Position = UDim2.new(1, 0, 0.5, 0);
        toggleframe.Size = UDim2.new(0, 44, 0, 24);
        toggleframe.BackgroundColor3 = default and settings[sleekui.theme].accent or settings[sleekui.theme].bg;
        toggleframe.BorderSizePixel = 0;
        toggleframe.Parent = container;
        
        local corner = Instance.new("UICorner");
        corner.CornerRadius = UDim.new(1, 0);
        corner.Parent = toggleframe;
        
        local knob = Instance.new("Frame");
        knob.Name = "Knob";
        knob.Size = UDim2.new(0, 20, 0, 20);
        knob.Position = default and UDim2.new(1, -22, 0.5, 0) or UDim2.new(0, 2, 0.5, 0);
        knob.AnchorPoint = Vector2.new(0, 0.5);
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        knob.BorderSizePixel = 0;
        knob.Parent = toggleframe;
        
        local knobcorner = Instance.new("UICorner");
        knobcorner.CornerRadius = UDim.new(1, 0);
        knobcorner.Parent = knob;
        
        local button = Instance.new("TextButton");
        button.Name = "Button";
        button.Size = UDim2.new(1, 0, 1, 0);
        button.BackgroundTransparency = 1;
        button.Text = "";
        button.Parent = container;
        
        local enabled = default or false;
        
        button.MouseButton1Click:Connect(function()
            enabled = not enabled;
            
            tween(toggleframe, {time = 0.2}, {
                BackgroundColor3 = enabled and settings[sleekui.theme].accent or settings[sleekui.theme].bg
            });
            
            tween(knob, {time = 0.2}, {
                Position = enabled and UDim2.new(1, -22, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
            });
            
            if callback then callback(enabled); end
        end);
        
        return container;
    end
    
    function card:addSlider(text, min, max, default, callback)
        local container = Instance.new("Frame");
        container.Name = text .. "Slider";
        container.Size = UDim2.new(1, 0, 0, 50);
        container.BackgroundTransparency = 1;
        container.Parent = self.content;
        
        local label = Instance.new("TextLabel");
        label.Name = "Label";
        label.Size = UDim2.new(1, -50, 0, 20);
        label.BackgroundTransparency = 1;
        label.Font = Enum.Font.Gotham;
        label.Text = text;
        label.TextColor3 = settings[sleekui.theme].text;
        label.TextSize = 14;
        label.TextXAlignment = Enum.TextXAlignment.Left;
        label.Parent = container;
        
        local value = Instance.new("TextLabel");
        value.Name = "Value";
        value.AnchorPoint = Vector2.new(1, 0);
        value.Position = UDim2.new(1, 0, 0, 0);
        value.Size = UDim2.new(0, 40, 0, 20);
        value.BackgroundTransparency = 1;
        value.Font = Enum.Font.GothamSemibold;
        value.Text = tostring(default or min);
        value.TextColor3 = settings[sleekui.theme].accent;
        value.TextSize = 14;
        value.Parent = container;
        
        local sliderframe = Instance.new("Frame");
        sliderframe.Name = "SliderFrame";
        sliderframe.Position = UDim2.new(0, 0, 0, 25);
        sliderframe.Size = UDim2.new(1, 0, 0, 4);
        sliderframe.BackgroundColor3 = settings[sleekui.theme].bg;
        sliderframe.BorderSizePixel = 0;
        sliderframe.Parent = container;
        
        local corner = Instance.new("UICorner");
        corner.CornerRadius = UDim.new(1, 0);
        corner.Parent = sliderframe;
        
        local fill = Instance.new("Frame");
        fill.Name = "Fill";
        fill.Size = UDim2.new((default or min - min) / (max - min), 0, 1, 0);
        fill.BackgroundColor3 = settings[sleekui.theme].accent;
        fill.BorderSizePixel = 0;
        fill.Parent = sliderframe;
        
        local fillcorner = Instance.new("UICorner");
        fillcorner.CornerRadius = UDim.new(1, 0);
        fillcorner.Parent = fill;
        
        local knob = Instance.new("Frame");
        knob.Name = "Knob";
        knob.AnchorPoint = Vector2.new(0.5, 0.5);
        knob.Position = UDim2.new((default or min - min) / (max - min), 0, 0.5, 0);
        knob.Size = UDim2.new(0, 16, 0, 16);
        knob.BackgroundColor3 = settings[sleekui.theme].accent;
        knob.BorderSizePixel = 0;
        knob.Parent = sliderframe;
        
        local knobcorner = Instance.new("UICorner");
        knobcorner.CornerRadius = UDim.new(1, 0);
        knobcorner.Parent = knob;
        
        local draggin = false;
        
        knob.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggin = true;
            end
        end);
        
        uis.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggin = false;
            end
        end);
        
        uis.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and draggin then
                local pos = math.clamp((input.Position.X - sliderframe.AbsolutePosition.X) / sliderframe.AbsoluteSize.X, 0, 1);
                local val = math.floor(min + ((max - min) * pos));
                
                tween(fill, {time = 0.1}, {
                    Size = UDim2.new(pos, 0, 1, 0)
                });
                
                tween(knob, {time = 0.1}, {
                    Position = UDim2.new(pos, 0, 0.5, 0)
                });
                
                value.Text = tostring(val);
                
                if callback then callback(val); end
            end
        end);
        
        return container;
    end
    
    function card:addDropdown(text, options, default, callback)
        local container = Instance.new("Frame");
        container.Name = text .. "Dropdown";
        container.Size = UDim2.new(1, 0, 0, 32);
        container.BackgroundTransparency = 1;
        container.ClipsDescendants = true;
        container.Parent = self.content;
        
        local button = Instance.new("TextButton");
        button.Name = "Button";
        button.Size = UDim2.new(1, 0, 0, 32);
        button.BackgroundColor3 = settings[sleekui.theme].bg;
        button.BorderSizePixel = 0;
        button.Font = Enum.Font.Gotham;
        button.Text = "";
        button.Parent = container;
        
        local corner = Instance.new("UICorner");
        corner.CornerRadius = UDim.new(0, 6);
        corner.Parent = button;
        
        local label = Instance.new("TextLabel");
        label.Name = "Label";
        label.Size = UDim2.new(1, -32, 1, 0);
        label.Position = UDim2.new(0, 10, 0, 0);
        label.BackgroundTransparency = 1;
        label.Font = Enum.Font.Gotham;
        label.Text = text;
        label.TextColor3 = settings[sleekui.theme].text;
        label.TextSize = 14;
        label.TextXAlignment = Enum.TextXAlignment.Left;
        label.Parent = button;
        
        local selected = Instance.new("TextLabel");
        selected.Name = "Selected";
        selected.AnchorPoint = Vector2.new(1, 0);
        selected.Position = UDim2.new(1, -32, 0, 0);
        selected.Size = UDim2.new(0, 100, 1, 0);
        selected.BackgroundTransparency = 1;
        selected.Font = Enum.Font.GothamSemibold;
        selected.Text = default or options[1];
        selected.TextColor3 = settings[sleekui.theme].accent;
        selected.TextSize = 14;
        selected.TextXAlignment = Enum.TextXAlignment.Right;
        selected.Parent = button;
        
        local arrow = Instance.new("ImageLabel");
        arrow.Name = "Arrow";
        arrow.AnchorPoint = Vector2.new(1, 0.5);
        arrow.Position = UDim2.new(1, -8, 0.5, 0);
        arrow.Size = UDim2.new(0, 16, 0, 16);
        arrow.BackgroundTransparency = 1;
        arrow.Image = "rbxassetid://6034818372";
        arrow.ImageColor3 = settings[sleekui.theme].accent;
        arrow.Parent = button;
        
        local optionsframe = Instance.new("Frame");
        optionsframe.Name = "Options";
        optionsframe.Position = UDim2.new(0, 0, 0, 32);
        optionsframe.Size = UDim2.new(1, 0, 0, #options * 32);
        optionsframe.BackgroundColor3 = settings[sleekui.theme].bg;
        optionsframe.BorderSizePixel = 0;
        optionsframe.Visible = false;
        optionsframe.Parent = container;
        
        local optionscorner = Instance.new("UICorner");
        optionscorner.CornerRadius = UDim.new(0, 6);
        optionscorner.Parent = optionsframe;
        
        local layout = Instance.new("UIListLayout");
        layout.SortOrder = Enum.SortOrder.LayoutOrder;
        layout.Parent = optionsframe;
        
        local open = false;
        
        -- // Create option buttons
        for i, option in ipairs(options) do
            local optionbtn = Instance.new("TextButton");
            optionbtn.Name = option;
            optionbtn.Size = UDim2.new(1, 0, 0, 32);
            optionbtn.BackgroundTransparency = 1;
            optionbtn.Font = Enum.Font.Gotham;
            optionbtn.Text = option;
            optionbtn.TextColor3 = settings[sleekui.theme].text;
            optionbtn.TextSize = 14;
            optionbtn.Parent = optionsframe;
            
            optionbtn.MouseButton1Click:Connect(function()
                selected.Text = option;
                if callback then callback(option); end
                
                open = false;
                optionsframe.Visible = false;
                tween(arrow, {time = 0.2}, {
                    Rotation = 0
                });
                tween(container, {time = 0.2}, {
                    Size = UDim2.new(1, 0, 0, 32)
                });
            end);
            
            optionbtn.MouseEnter:Connect(function()
                tween(optionbtn, {time = 0.2}, {
                    BackgroundTransparency = 0.9
                });
            end);
            
            optionbtn.MouseLeave:Connect(function()
                tween(optionbtn, {time = 0.2}, {
                    BackgroundTransparency = 1
                });
            end);
        end
        
        button.MouseButton1Click:Connect(function()
            open = not open;
            optionsframe.Visible = open;
            
            tween(arrow, {time = 0.2}, {
                Rotation = open and 180 or 0
            });
            
            tween(container, {time = 0.2}, {
                Size = UDim2.new(1, 0, 0, open and (32 + #options * 32) or 32)
            });
        end);
        
        return container;
    end
    
    return card;
end

[Previous code for setTheme(), updateCardTheme() and destroy() remains the same...]

return sleekui;
