local anims = {};
local checked = {};

local function scaninst(inst)
    if checked[inst] then return; end
    checked[inst] = true;
    
    if inst:IsA("Animation") then
        table.insert(anims, {name = inst.Name, id = inst.AnimationId});
    end
    
    for _, v in ipairs(inst:GetChildren()) do
        scaninst(v);
    end
end

local oldnamecall;
oldnamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod();
    local args = {...};
    
    if method == "LoadAnimation" and self:IsA("Animator") then
        local anim = args[1];
        if anim and anim:IsA("Animation") then
            table.insert(anims, {name = anim.Name, id = anim.AnimationId});
        end
    end
    
    return oldnamecall(self, ...);
end);

scaninst(game);

local function saveanimations()
    local output = "";
    for _, v in ipairs(anims) do
        if v.id and v.id ~= "" then
            output = output .. v.name .. " | " .. v.id .. "\n";
        end
    end
    
    writefile("animations.txt", output);
    print("Saved " .. #anims .. " animations to animations.txt");
end

local sg = Instance.new("ScreenGui");
sg.Parent = gethui();

local frame = Instance.new("Frame");
frame.Size = UDim2.new(0, 200, 0, 50);
frame.Position = UDim2.new(0.5, -100, 0, 20);
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
frame.BorderSizePixel = 0;
frame.Parent = sg;

local btn = Instance.new("TextButton");
btn.Size = UDim2.new(1, -10, 1, -10);
btn.Position = UDim2.new(0, 5, 0, 5);
btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60);
btn.Text = "Save Animations";
btn.TextColor3 = Color3.fromRGB(255, 255, 255);
btn.Parent = frame;
btn.MouseButton1Click:Connect(saveanimations);
