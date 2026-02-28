--[[
╔══════════════════════════════════════════════════════════╗
║              KINETIX UI LIBRARY  v1.0.0                  ║
║         github.com/Shindo957-Official/kinetix            ║
║                                                          ║
║  Themes: macOS · Windows 7 · Linux (GNOME/KDE/Hyprland) ║
║  Switch themes live from Settings tab                    ║
╚══════════════════════════════════════════════════════════╝

  USAGE:
    local Kinetix = loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/Shindo957-Official/kinetix/main/KinetixLib.lua"
    ))()

    local Win = Kinetix:CreateWindow({
        Title      = "My Script",
        Subtitle   = "by Me",
        Theme      = "macOS",   -- "macOS" | "Windows7" | "Linux"
        LinuxStyle = "Hyprland",-- "GNOME" | "KDE" | "Hyprland" (only when Theme="Linux")
        ToggleKey  = Enum.KeyCode.RightControl,
    })

    local Tab = Win:CreateTab("Main", "🏠")
    Tab:CreateSection("Movement")
    Tab:CreateToggle({ Name="Fly", Default=false, Callback=function(v) end })
    Tab:CreateSlider({ Name="Speed", Min=5, Max=100, Increment=1, Default=20, Callback=function(v) end })
    Tab:CreateButton({ Name="Action", Label="Run", Style="default", Callback=function() end })
    Tab:CreateDropdown({ Name="Mode", Options={"A","B"}, Default="A", Callback=function(v) end })
    Tab:CreatePillGroup({ Name="Angle", Options={"90°","45°"}, Default="90°", Callback=function(v) end })
    Tab:CreateLabel("Info text here")

    Win:Notify({ Icon="🎉", Title="Loaded", Body="Ready!", Duration=3 })
    Win:SetStatus("Custom status text")
    Win:SetTheme("Windows7")   -- switch theme at runtime
    Win:Destroy()
]]

local Kinetix = {}
Kinetix.__index = Kinetix

-- ─── Services ────────────────────────────────────────────────────────────────
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local LocalPlayer      = Players.LocalPlayer

local function getGui()
    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    return (ok and cg) or LocalPlayer:WaitForChild("PlayerGui")
end

-- ─── Tween helpers ───────────────────────────────────────────────────────────
local function tw(obj, props, t, style, dir)
    TweenService:Create(obj,
        TweenInfo.new(t or 0.18,
            style or Enum.EasingStyle.Quart,
            dir   or Enum.EasingDirection.Out),
        props):Play()
end

local function spring(obj, props, t)
    TweenService:Create(obj,
        TweenInfo.new(t or 0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        props):Play()
end

local function rgb(r,g,b) return Color3.fromRGB(r,g,b) end
local function hex(h)
    h = h:gsub("#","")
    return rgb(
        tonumber(h:sub(1,2),16),
        tonumber(h:sub(3,4),16),
        tonumber(h:sub(5,6),16)
    )
end

-- ═════════════════════════════════════════════════════════════════════════════
-- THEME DEFINITIONS
-- ═════════════════════════════════════════════════════════════════════════════
local Themes = {}

-- ── macOS ────────────────────────────────────────────────────────────────────
Themes["macOS"] = {
    -- identity
    Name           = "macOS",
    WinRadius      = 14,
    RowRadius      = 10,
    SidebarWidth   = 155,
    TitleBarH      = 44,
    StatusBarH     = 28,
    TitleCentered  = true,
    TrafficLights  = "mac",   -- "mac" | "win7" | "linux_gnome" | "linux_kde"
    -- colors
    Window         = hex("1c1c1e"),
    WinBorder      = hex("3a3a3c"),
    TitleBar       = hex("2c2c2e"),
    TitleBarGrad   = nil,
    TitleText      = hex("e5e5ea"),
    TitleSub       = hex("8e8e93"),
    Sidebar        = hex("161618"),
    SidebarBorder  = hex("2c2c2e"),
    SidebarBg      = hex("161618"),
    Content        = hex("1c1c1e"),
    Row            = hex("242428"),
    RowHover       = hex("2e2e34"),
    RowBorder      = hex("3a3a3c"),
    Text           = hex("e5e5ea"),
    TextSec        = hex("8e8e93"),
    TextTert       = hex("48484a"),
    Accent         = hex("0a84ff"),
    AccentHover    = hex("409cff"),
    Green          = hex("30d158"),
    Red            = hex("ff453a"),
    Yellow         = hex("ffd60a"),
    StatusBar      = hex("161618"),
    Toast          = hex("2c2c2e"),
    SectionLbl     = hex("58585a"),
    ToggleOff      = hex("3a3a3c"),
    ToggleOn       = hex("0a84ff"),
    Knob           = hex("ffffff"),
    SliderTrack    = hex("3a3a3c"),
    SliderFill     = hex("0a84ff"),
    Pill           = hex("2c2c2e"),
    PillActive     = hex("0a84ff"),
    Select         = hex("2c2c2e"),
    Btn            = hex("3a3a3c"),
    BtnHover       = hex("48484a"),
    BtnDanger      = hex("3d1a1a"),
    BtnDangerHov   = hex("4d2020"),
    BtnTextDanger  = hex("ff453a"),
    SideItemActive = hex("0a3d8a"),
    SideItemText   = hex("8e8e93"),
    SideItemTxtOn  = hex("409cff"),
    TLRed          = hex("ff5f57"),
    TLYellow       = hex("febc2e"),
    TLGreen        = hex("28c840"),
    Font           = Enum.Font.GothamBold,
    FontMed        = Enum.Font.GothamMedium,
    FontReg        = Enum.Font.Gotham,
}

-- ── Windows 7 ────────────────────────────────────────────────────────────────
Themes["Windows7"] = {
    Name           = "Windows7",
    WinRadius      = 6,
    RowRadius      = 3,
    SidebarWidth   = 160,
    TitleBarH      = 40,
    StatusBarH     = 24,
    TitleCentered  = false,
    TrafficLights  = "win7",
    -- Aero glass palette
    Window         = hex("dce6f0"),
    WinBorder      = hex("4a7eb5"),
    TitleBar       = hex("4372a8"),  -- solid fallback; gradient applied in code
    TitleBarGrad   = { hex("6aa0d4"), hex("3060a0") },
    TitleText      = hex("ffffff"),
    TitleSub       = hex("b8d0f0"),
    Sidebar        = hex("eaf0f8"),
    SidebarBorder  = hex("b0c4de"),
    SidebarBg      = hex("dce6f2"),
    Content        = hex("f0f4f8"),
    Row            = hex("ffffff"),
    RowHover       = hex("e8f0fc"),
    RowBorder      = hex("c8d8e8"),
    Text           = hex("1a1a2e"),
    TextSec        = hex("4a5568"),
    TextTert       = hex("8a9ab0"),
    Accent         = hex("2a6dd9"),
    AccentHover    = hex("4080f0"),
    Green          = hex("1e8e3e"),
    Red            = hex("c62828"),
    Yellow         = hex("f9a825"),
    StatusBar      = hex("c8d8ec"),
    Toast          = hex("e8f0fc"),
    SectionLbl     = hex("5a7a9a"),
    ToggleOff      = hex("c0ccd8"),
    ToggleOn       = hex("2a6dd9"),
    Knob           = hex("ffffff"),
    SliderTrack    = hex("b0c0d0"),
    SliderFill     = hex("2a6dd9"),
    Pill           = hex("dce8f8"),
    PillActive     = hex("2a6dd9"),
    Select         = hex("f0f4fc"),
    Btn            = hex("dce8f8"),
    BtnHover       = hex("c8d8f0"),
    BtnDanger      = hex("fce8e8"),
    BtnDangerHov   = hex("f0c8c8"),
    BtnTextDanger  = hex("c62828"),
    SideItemActive = hex("c8daf8"),
    SideItemText   = hex("4a5a6a"),
    SideItemTxtOn  = hex("1a4a9a"),
    TLRed          = hex("e04040"),
    TLYellow       = hex("d0a020"),
    TLGreen        = hex("208040"),
    Font           = Enum.Font.GothamBold,
    FontMed        = Enum.Font.GothamMedium,
    FontReg        = Enum.Font.Gotham,
}

-- ── Linux GNOME (Ubuntu Yaru dark) ───────────────────────────────────────────
Themes["GNOME"] = {
    Name           = "Linux · GNOME",
    WinRadius      = 12,
    RowRadius      = 6,
    SidebarWidth   = 160,
    TitleBarH      = 46,
    StatusBarH     = 26,
    TitleCentered  = true,
    TrafficLights  = "linux_gnome",
    Window         = hex("2c2c2c"),
    WinBorder      = hex("1a1a1a"),
    TitleBar       = hex("383838"),
    TitleBarGrad   = nil,
    TitleText      = hex("eeeeee"),
    TitleSub       = hex("9a9a9a"),
    Sidebar        = hex("252525"),
    SidebarBorder  = hex("1a1a1a"),
    SidebarBg      = hex("252525"),
    Content        = hex("2c2c2c"),
    Row            = hex("343434"),
    RowHover       = hex("3e3e3e"),
    RowBorder      = hex("484848"),
    Text           = hex("eeeeee"),
    TextSec        = hex("9a9a9a"),
    TextTert       = hex("5a5a5a"),
    Accent         = hex("e95420"),
    AccentHover    = hex("ff6a35"),
    Green          = hex("26a269"),
    Red            = hex("e01b24"),
    Yellow         = hex("f6d32d"),
    StatusBar      = hex("1e1e1e"),
    Toast          = hex("3a3a3a"),
    SectionLbl     = hex("727272"),
    ToggleOff      = hex("4a4a4a"),
    ToggleOn       = hex("e95420"),
    Knob           = hex("ffffff"),
    SliderTrack    = hex("4a4a4a"),
    SliderFill     = hex("e95420"),
    Pill           = hex("3a3a3a"),
    PillActive     = hex("e95420"),
    Select         = hex("3a3a3a"),
    Btn            = hex("424242"),
    BtnHover       = hex("505050"),
    BtnDanger      = hex("3d1a1a"),
    BtnDangerHov   = hex("4d2020"),
    BtnTextDanger  = hex("e01b24"),
    SideItemActive = hex("5a1e0a"),
    SideItemText   = hex("9a9a9a"),
    SideItemTxtOn  = hex("ff7a4a"),
    TLRed          = hex("e01b24"),
    TLYellow       = hex("c4a000"),
    TLGreen        = hex("26a269"),
    Font           = Enum.Font.GothamBold,
    FontMed        = Enum.Font.GothamMedium,
    FontReg        = Enum.Font.Gotham,
}

-- ── Linux KDE (Breeze Dark) ───────────────────────────────────────────────────
Themes["KDE"] = {
    Name           = "Linux · KDE",
    WinRadius      = 8,
    RowRadius      = 4,
    SidebarWidth   = 165,
    TitleBarH      = 38,
    StatusBarH     = 24,
    TitleCentered  = false,
    TrafficLights  = "linux_kde",
    Window         = hex("31363b"),
    WinBorder      = hex("1d2023"),
    TitleBar       = hex("2d3238"),
    TitleBarGrad   = nil,
    TitleText      = hex("eff0f1"),
    TitleSub       = hex("7f8c8d"),
    Sidebar        = hex("232629"),
    SidebarBorder  = hex("1a1d20"),
    SidebarBg      = hex("232629"),
    Content        = hex("31363b"),
    Row            = hex("3b4045"),
    RowHover       = hex("454d54"),
    RowBorder      = hex("4a5260"),
    Text           = hex("eff0f1"),
    TextSec        = hex("7f8c8d"),
    TextTert       = hex("4d5461"),
    Accent         = hex("3daee9"),
    AccentHover    = hex("6ec6f0"),
    Green          = hex("27ae60"),
    Red            = hex("da4453"),
    Yellow         = hex("f67400"),
    StatusBar      = hex("1d2023"),
    Toast          = hex("2d3238"),
    SectionLbl     = hex("5a6475"),
    ToggleOff      = hex("4a5260"),
    ToggleOn       = hex("3daee9"),
    Knob           = hex("eff0f1"),
    SliderTrack    = hex("4a5260"),
    SliderFill     = hex("3daee9"),
    Pill           = hex("3b4045"),
    PillActive     = hex("3daee9"),
    Select         = hex("2d3238"),
    Btn            = hex("3b4045"),
    BtnHover       = hex("454d54"),
    BtnDanger      = hex("3d1520"),
    BtnDangerHov   = hex("4d1a28"),
    BtnTextDanger  = hex("da4453"),
    SideItemActive = hex("153050"),
    SideItemText   = hex("7f8c8d"),
    SideItemTxtOn  = hex("6ec6f0"),
    TLRed          = hex("da4453"),
    TLYellow       = hex("f67400"),
    TLGreen        = hex("27ae60"),
    Font           = Enum.Font.GothamBold,
    FontMed        = Enum.Font.GothamMedium,
    FontReg        = Enum.Font.Gotham,
}

-- ── Linux Hyprland (Catppuccin Mocha) ────────────────────────────────────────
Themes["Hyprland"] = {
    Name           = "Linux · Hyprland",
    WinRadius      = 16,
    RowRadius      = 12,
    SidebarWidth   = 155,
    TitleBarH      = 42,
    StatusBarH     = 26,
    TitleCentered  = true,
    TrafficLights  = "linux_gnome",
    Window         = hex("1e1e2e"),
    WinBorder      = hex("cba6f7"),   -- mauve border = signature Hyprland look
    TitleBar       = hex("181825"),
    TitleBarGrad   = nil,
    TitleText      = hex("cdd6f4"),
    TitleSub       = hex("6c7086"),
    Sidebar        = hex("11111b"),
    SidebarBorder  = hex("313244"),
    SidebarBg      = hex("11111b"),
    Content        = hex("1e1e2e"),
    Row            = hex("313244"),
    RowHover       = hex("3b3f5c"),
    RowBorder      = hex("45475a"),
    Text           = hex("cdd6f4"),
    TextSec        = hex("6c7086"),
    TextTert       = hex("45475a"),
    Accent         = hex("cba6f7"),   -- mauve
    AccentHover    = hex("d8b4fe"),
    Green          = hex("a6e3a1"),
    Red            = hex("f38ba8"),
    Yellow         = hex("f9e2af"),
    StatusBar      = hex("11111b"),
    Toast          = hex("313244"),
    SectionLbl     = hex("585b70"),
    ToggleOff      = hex("45475a"),
    ToggleOn       = hex("cba6f7"),
    Knob           = hex("cdd6f4"),
    SliderTrack    = hex("45475a"),
    SliderFill     = hex("cba6f7"),
    Pill           = hex("313244"),
    PillActive     = hex("cba6f7"),
    Select         = hex("313244"),
    Btn            = hex("313244"),
    BtnHover       = hex("3b3f5c"),
    BtnDanger      = hex("3d1a2a"),
    BtnDangerHov   = hex("4d2030"),
    BtnTextDanger  = hex("f38ba8"),
    SideItemActive = hex("3d2a55"),
    SideItemText   = hex("6c7086"),
    SideItemTxtOn  = hex("d8b4fe"),
    TLRed          = hex("f38ba8"),
    TLYellow       = hex("f9e2af"),
    TLGreen        = hex("a6e3a1"),
    Font           = Enum.Font.GothamBold,
    FontMed        = Enum.Font.GothamMedium,
    FontReg        = Enum.Font.Gotham,
}

-- Theme group mapping for user-facing names
local ThemeGroups = {
    macOS    = { "macOS" },
    Windows7 = { "Windows7" },
    Linux    = { "GNOME", "KDE", "Hyprland" },
}

local function resolveTheme(theme, linuxStyle)
    if theme == "macOS"    then return Themes["macOS"]    end
    if theme == "Windows7" then return Themes["Windows7"] end
    if theme == "Linux"    then return Themes[linuxStyle or "Hyprland"] or Themes["Hyprland"] end
    return Themes[theme] or Themes["macOS"]
end

-- ─── Dragging ────────────────────────────────────────────────────────────────
local function makeDraggable(frame, handle)
    local dragging, start, origin
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true; start = i.Position; origin = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if not dragging then return end
        if i.UserInputType == Enum.UserInputType.MouseMovement
        or i.UserInputType == Enum.UserInputType.Touch then
            local d = i.Position - start
            frame.Position = UDim2.new(
                origin.X.Scale, origin.X.Offset + d.X,
                origin.Y.Scale, origin.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- ═════════════════════════════════════════════════════════════════════════════
-- CREATE WINDOW
-- ═════════════════════════════════════════════════════════════════════════════
function Kinetix:CreateWindow(cfg)
    cfg = cfg or {}
    local Title      = cfg.Title      or "Kinetix"
    local Subtitle   = cfg.Subtitle   or "by Kinetix"
    local ToggleKey  = cfg.ToggleKey  or Enum.KeyCode.RightControl
    local WinSize    = cfg.Size       or UDim2.new(0, 700, 0, 510)
    local initTheme  = cfg.Theme      or "macOS"
    local initLinux  = cfg.LinuxStyle or "Hyprland"

    local currentThemeName  = initTheme
    local currentLinuxStyle = initLinux
    local T = resolveTheme(initTheme, initLinux)

    -- ── ScreenGui ─────────────────────────────────────────────────────────────
    local SG = Instance.new("ScreenGui")
    SG.Name           = "KinetixUI"
    SG.ResetOnSpawn   = false
    SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    SG.DisplayOrder   = 999
    SG.IgnoreGuiInset = true
    SG.Parent         = getGui()

    -- ── Window Frame ──────────────────────────────────────────────────────────
    local Win = Instance.new("Frame")
    Win.Name             = "KinetixWindow"
    Win.Size             = UDim2.new(0,0,0,0)
    Win.Position         = UDim2.new(0.5,0,0.5,0)
    Win.BackgroundColor3 = T.Window
    Win.BorderSizePixel  = 0
    Win.ClipsDescendants = true
    Win.Parent           = SG

    local WinCorner = Instance.new("UICorner", Win)
    WinCorner.CornerRadius = UDim.new(0, T.WinRadius)

    local WinStroke = Instance.new("UIStroke", Win)
    WinStroke.Color = T.WinBorder; WinStroke.Thickness = 1.5
    WinStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- open spring
    spring(Win, {
        Size     = WinSize,
        Position = UDim2.new(0.5, -WinSize.X.Offset/2, 0.5, -WinSize.Y.Offset/2)
    }, 0.5)

    local function closeAnim()
        spring(Win, {Size=UDim2.new(0,0,0,0), Position=UDim2.new(0.5,0,0.5,0)}, 0.28)
        task.delay(0.35, function() SG:Destroy() end)
    end

    -- ── Title Bar ─────────────────────────────────────────────────────────────
    local TBar = Instance.new("Frame", Win)
    TBar.Name             = "TitleBar"
    TBar.Size             = UDim2.new(1,0,0, T.TitleBarH)
    TBar.BackgroundColor3 = T.TitleBar
    TBar.BorderSizePixel  = 0
    TBar.ZIndex           = 3

    local TBarCorner = Instance.new("UICorner", TBar)
    TBarCorner.CornerRadius = UDim.new(0, T.WinRadius)

    -- square bottom of titlebar
    local TBarFix = Instance.new("Frame", TBar)
    TBarFix.Size             = UDim2.new(1,0,0,T.WinRadius)
    TBarFix.Position         = UDim2.new(0,0,1,-T.WinRadius)
    TBarFix.BackgroundColor3 = T.TitleBar
    TBarFix.BorderSizePixel  = 0
    TBarFix.ZIndex           = 3

    local TBarDiv = Instance.new("Frame", TBar)
    TBarDiv.Size             = UDim2.new(1,0,0,1)
    TBarDiv.Position         = UDim2.new(0,0,1,-1)
    TBarDiv.BackgroundColor3 = T.RowBorder
    TBarDiv.BorderSizePixel  = 0
    TBarDiv.ZIndex           = 4

    -- Title label
    local TitleLbl = Instance.new("TextLabel", TBar)
    TitleLbl.Size               = UDim2.new(1,0,1,0)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Font               = T.Font
    TitleLbl.TextSize           = 13
    TitleLbl.TextColor3         = T.TitleText
    TitleLbl.ZIndex             = 4
    TitleLbl.Text               = Title.."  —  "..Subtitle
    TitleLbl.TextXAlignment     = T.TitleCentered and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left

    if not T.TitleCentered then
        local tp = Instance.new("UIPadding", TitleLbl)
        tp.PaddingLeft = UDim.new(0, 12)
    end

    -- ── Traffic Light / Window Buttons ────────────────────────────────────────
    local function makeTrafficLights(style)
        -- remove existing
        for _, v in ipairs(TBar:GetChildren()) do
            if v.Name == "TrafficFrame" then v:Destroy() end
        end

        local tf = Instance.new("Frame", TBar)
        tf.Name                = "TrafficFrame"
        tf.BackgroundTransparency = 1
        tf.ZIndex              = 5

        if style == "mac" then
            -- macOS: left side, 3 colored circles
            tf.Size     = UDim2.new(0,80,0,20)
            tf.Position = UDim2.new(0,14, 0.5,-10)
            local ll = Instance.new("UIListLayout",tf)
            ll.FillDirection = Enum.FillDirection.Horizontal
            ll.Padding = UDim.new(0,8); ll.VerticalAlignment = Enum.VerticalAlignment.Center

            local function macDot(col, hover, fn)
                local d = Instance.new("TextButton",tf)
                d.Size=UDim2.new(0,13,0,13); d.BackgroundColor3=col
                d.Text=""; d.AutoButtonColor=false; d.ZIndex=5
                Instance.new("UICorner",d).CornerRadius=UDim.new(1,0)
                local sto = Instance.new("UIStroke",d); sto.Color=rgb(0,0,0); sto.Thickness=0.5; sto.Transparency=0.7
                d.MouseButton1Click:Connect(function()
                    tw(d,{BackgroundColor3=hover},0.08); task.wait(0.1)
                    tw(d,{BackgroundColor3=col},0.08); if fn then fn() end
                end)
                return d
            end
            macDot(T.TLRed,    rgb(200,40,30),  closeAnim)
            macDot(T.TLYellow, rgb(200,150,10), function() Win.Visible=not Win.Visible end)
            macDot(T.TLGreen,  rgb(20,160,40),  nil)

        elseif style == "win7" then
            -- Windows 7: right side, 3 rectangle buttons
            tf.Size     = UDim2.new(0,110,0,T.TitleBarH)
            tf.Position = UDim2.new(1,-110,0,0)
            local ll = Instance.new("UIListLayout",tf)
            ll.FillDirection = Enum.FillDirection.Horizontal
            ll.VerticalAlignment = Enum.VerticalAlignment.Center
            ll.HorizontalAlignment = Enum.HorizontalAlignment.Right

            local function winBtn(label, bg, hover, tc, fn, rad)
                local b = Instance.new("TextButton",tf)
                b.Size=UDim2.new(0,36,1,0); b.BackgroundColor3=bg
                b.Font=Enum.Font.GothamBold; b.TextSize=12; b.TextColor3=tc
                b.Text=label; b.AutoButtonColor=false; b.BorderSizePixel=0; b.ZIndex=5
                if rad then Instance.new("UICorner",b).CornerRadius=UDim.new(0,rad) end
                b.MouseEnter:Connect(function() tw(b,{BackgroundColor3=hover},0.1) end)
                b.MouseLeave:Connect(function() tw(b,{BackgroundColor3=bg},0.1) end)
                b.MouseButton1Click:Connect(function() if fn then fn() end end)
                return b
            end
            winBtn("─", hex("5080c0"), hex("6090d0"), hex("ffffff"), function() Win.Visible=not Win.Visible end, 0)
            winBtn("□", hex("5080c0"), hex("6090d0"), hex("ffffff"), nil, 0)
            winBtn("✕", hex("c02020"), hex("e03030"), hex("ffffff"), closeAnim, T.WinRadius)

        elseif style == "linux_gnome" then
            -- GNOME: right side, circles
            tf.Size     = UDim2.new(0,80,0,20)
            tf.Position = UDim2.new(1,-92,0.5,-10)
            local ll = Instance.new("UIListLayout",tf)
            ll.FillDirection = Enum.FillDirection.Horizontal
            ll.Padding = UDim.new(0,8); ll.VerticalAlignment = Enum.VerticalAlignment.Center
            ll.HorizontalAlignment = Enum.HorizontalAlignment.Right

            local function gnomeDot(col, hover, lbl, fn)
                local d = Instance.new("TextButton",tf)
                d.Size=UDim2.new(0,13,0,13); d.BackgroundColor3=col
                d.Font=Enum.Font.GothamBold; d.TextSize=9; d.TextColor3=rgb(255,255,255)
                d.Text=lbl; d.AutoButtonColor=false; d.ZIndex=5
                Instance.new("UICorner",d).CornerRadius=UDim.new(1,0)
                d.MouseButton1Click:Connect(function()
                    tw(d,{BackgroundColor3=hover},0.08); task.wait(0.1)
                    tw(d,{BackgroundColor3=col},0.08); if fn then fn() end
                end)
                return d
            end
            gnomeDot(T.TLGreen,  rgb(20,160,40),  "", nil)
            gnomeDot(T.TLYellow, rgb(200,150,10), "", function() Win.Visible=not Win.Visible end)
            gnomeDot(T.TLRed,    rgb(200,40,30),  "✕", closeAnim)

        elseif style == "linux_kde" then
            -- KDE: right side, flat square buttons
            tf.Size     = UDim2.new(0,90,0,T.TitleBarH)
            tf.Position = UDim2.new(1,-90,0,0)
            local ll = Instance.new("UIListLayout",tf)
            ll.FillDirection = Enum.FillDirection.Horizontal
            ll.VerticalAlignment = Enum.VerticalAlignment.Center
            ll.HorizontalAlignment = Enum.HorizontalAlignment.Right
            local pad = Instance.new("UIPadding",tf); pad.PaddingRight = UDim.new(0,6)
            ll.Padding = UDim.new(0,2)

            local function kdeBtn(icon, bg, hover, fn)
                local b = Instance.new("TextButton",tf)
                b.Size=UDim2.new(0,26,0,26); b.BackgroundColor3=bg; b.BackgroundTransparency=0.7
                b.Font=Enum.Font.GothamBold; b.TextSize=11; b.TextColor3=T.TitleText
                b.Text=icon; b.AutoButtonColor=false; b.BorderSizePixel=0; b.ZIndex=5
                Instance.new("UICorner",b).CornerRadius=UDim.new(0,4)
                b.MouseEnter:Connect(function() tw(b,{BackgroundTransparency=0, BackgroundColor3=hover},0.1) end)
                b.MouseLeave:Connect(function() tw(b,{BackgroundTransparency=0.7, BackgroundColor3=bg},0.1) end)
                b.MouseButton1Click:Connect(function() if fn then fn() end end)
                return b
            end
            kdeBtn("─", T.TLYellow, rgb(180,120,10), function() Win.Visible=not Win.Visible end)
            kdeBtn("□", T.TLGreen,  rgb(20,140,40),  nil)
            kdeBtn("✕", T.TLRed,    rgb(190,30,30),  closeAnim)
        end
        return tf
    end

    local trafficFrame = makeTrafficLights(T.TrafficLights)
    makeDraggable(Win, TBar)

    -- ── Body ──────────────────────────────────────────────────────────────────
    local Body = Instance.new("Frame", Win)
    Body.Name                = "Body"
    Body.Size                = UDim2.new(1,0,1,-T.TitleBarH-T.StatusBarH)
    Body.Position            = UDim2.new(0,0,0,T.TitleBarH)
    Body.BackgroundTransparency = 1

    -- ── Sidebar ───────────────────────────────────────────────────────────────
    local Sidebar = Instance.new("ScrollingFrame", Body)
    Sidebar.Name               = "Sidebar"
    Sidebar.Size               = UDim2.new(0, T.SidebarWidth, 1, 0)
    Sidebar.BackgroundColor3   = T.Sidebar
    Sidebar.BorderSizePixel    = 0
    Sidebar.ScrollBarThickness = 0
    Sidebar.CanvasSize         = UDim2.new(0,0,0,0)
    Sidebar.AutomaticCanvasSize= Enum.AutomaticSize.Y

    local SidebarDiv = Instance.new("Frame", Sidebar)
    SidebarDiv.Size             = UDim2.new(0,1,1,0)
    SidebarDiv.Position         = UDim2.new(1,-1,0,0)
    SidebarDiv.BackgroundColor3 = T.SidebarBorder
    SidebarDiv.BorderSizePixel  = 0
    SidebarDiv.ZIndex           = 2

    local SPad = Instance.new("UIPadding", Sidebar)
    SPad.PaddingLeft   = UDim.new(0,8)
    SPad.PaddingRight  = UDim.new(0,8)
    SPad.PaddingTop    = UDim.new(0,10)
    SPad.PaddingBottom = UDim.new(0,10)
    local SLayout = Instance.new("UIListLayout", Sidebar)
    SLayout.Padding    = UDim.new(0,2)
    SLayout.SortOrder  = Enum.SortOrder.LayoutOrder

    -- ── Content Holder ────────────────────────────────────────────────────────
    local ContentHolder = Instance.new("Frame", Body)
    ContentHolder.Name               = "ContentHolder"
    ContentHolder.Size               = UDim2.new(1,-T.SidebarWidth,1,0)
    ContentHolder.Position           = UDim2.new(0,T.SidebarWidth,0,0)
    ContentHolder.BackgroundTransparency = 1
    ContentHolder.ClipsDescendants   = true

    -- ── Status Bar ────────────────────────────────────────────────────────────
    local StatusBar = Instance.new("Frame", Win)
    StatusBar.Name             = "StatusBar"
    StatusBar.Size             = UDim2.new(1,0,0,T.StatusBarH)
    StatusBar.Position         = UDim2.new(0,0,1,-T.StatusBarH)
    StatusBar.BackgroundColor3 = T.StatusBar
    StatusBar.BorderSizePixel  = 0
    StatusBar.ZIndex           = 2

    local SBDiv = Instance.new("Frame", StatusBar)
    SBDiv.Size             = UDim2.new(1,0,0,1)
    SBDiv.BackgroundColor3 = T.RowBorder
    SBDiv.BorderSizePixel  = 0

    local SBPad = Instance.new("UIPadding", StatusBar)
    SBPad.PaddingLeft = UDim.new(0,12); SBPad.PaddingRight = UDim.new(0,12)

    local SBDot = Instance.new("Frame", StatusBar)
    SBDot.Size             = UDim2.new(0,6,0,6)
    SBDot.Position         = UDim2.new(0,0,0.5,-3)
    SBDot.BackgroundColor3 = T.Green
    SBDot.BorderSizePixel  = 0
    SBDot.ZIndex           = 3
    Instance.new("UICorner",SBDot).CornerRadius = UDim.new(1,0)

    local SBText = Instance.new("TextLabel", StatusBar)
    SBText.Size               = UDim2.new(1,-20,1,0)
    SBText.Position           = UDim2.new(0,16,0,0)
    SBText.BackgroundTransparency = 1
    SBText.Font               = Enum.Font.Gotham
    SBText.TextSize           = 11
    SBText.TextColor3         = T.TextSec
    SBText.TextXAlignment     = Enum.TextXAlignment.Left
    SBText.Text               = "Kinetix v1.0.0  ·  "..T.Name
    SBText.ZIndex             = 3

    local SBThemeLbl = Instance.new("TextLabel", StatusBar)
    SBThemeLbl.Size               = UDim2.new(0,160,1,0)
    SBThemeLbl.Position           = UDim2.new(1,-160,0,0)
    SBThemeLbl.BackgroundTransparency = 1
    SBThemeLbl.Font               = Enum.Font.Gotham
    SBThemeLbl.TextSize           = 11
    SBThemeLbl.TextColor3         = T.Accent
    SBThemeLbl.TextXAlignment     = Enum.TextXAlignment.Right
    SBThemeLbl.Text               = T.Name
    SBThemeLbl.ZIndex             = 3

    -- ── Toast ─────────────────────────────────────────────────────────────────
    local Toast = Instance.new("Frame", SG)
    Toast.Name             = "Toast"
    Toast.Size             = UDim2.new(0,295,0,68)
    Toast.Position         = UDim2.new(1,10,0,20)
    Toast.BackgroundColor3 = T.Toast
    Toast.BorderSizePixel  = 0
    Toast.ZIndex           = 100
    Instance.new("UICorner",Toast).CornerRadius = UDim.new(0,13)
    local ToastStroke = Instance.new("UIStroke",Toast)
    ToastStroke.Color = T.RowBorder; ToastStroke.Thickness = 1
    ToastStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local TPad = Instance.new("UIPadding",Toast)
    TPad.PaddingLeft=UDim.new(0,14); TPad.PaddingRight=UDim.new(0,14)
    TPad.PaddingTop=UDim.new(0,10); TPad.PaddingBottom=UDim.new(0,10)

    local TIcon = Instance.new("TextLabel",Toast)
    TIcon.Size=UDim2.new(0,28,0,28); TIcon.BackgroundTransparency=1
    TIcon.Font=Enum.Font.GothamBold; TIcon.TextSize=22; TIcon.Text="🔔"; TIcon.ZIndex=101

    local TTitle = Instance.new("TextLabel",Toast)
    TTitle.Size=UDim2.new(1,-38,0,20); TTitle.Position=UDim2.new(0,38,0,0)
    TTitle.BackgroundTransparency=1; TTitle.Font=T.Font; TTitle.TextSize=13
    TTitle.TextColor3=T.Text; TTitle.TextXAlignment=Enum.TextXAlignment.Left
    TTitle.Text=""; TTitle.ZIndex=101

    local TBody = Instance.new("TextLabel",Toast)
    TBody.Size=UDim2.new(1,-38,0,32); TBody.Position=UDim2.new(0,38,0,22)
    TBody.BackgroundTransparency=1; TBody.Font=T.FontReg; TBody.TextSize=12
    TBody.TextColor3=T.TextSec; TBody.TextXAlignment=Enum.TextXAlignment.Left
    TBody.TextWrapped=true; TBody.Text=""; TBody.ZIndex=101

    local toastThread
    local function showToast(icon, title, body, dur)
        TIcon.Text=icon or "🔔"; TTitle.Text=title or ""; TBody.Text=body or ""
        tw(Toast,{Position=UDim2.new(1,-310,0,20)},0.3,Enum.EasingStyle.Back)
        if toastThread then task.cancel(toastThread) end
        toastThread = task.delay(dur or 3, function()
            tw(Toast,{Position=UDim2.new(1,10,0,20)},0.22)
        end)
    end

    -- ── Toggle key ────────────────────────────────────────────────────────────
    UserInputService.InputBegan:Connect(function(i,gp)
        if gp then return end
        if i.KeyCode == ToggleKey then Win.Visible = not Win.Visible end
    end)

    -- ═════════════════════════════════════════════════════════════════════════
    -- THEME SWITCHER — applies colors to all live instances
    -- ═════════════════════════════════════════════════════════════════════════
    local themeListeners   = {}   -- {instance, propName, themeKey}
    local toggleInstances  = {}   -- {track, knob, state_ref}
    local sliderInstances  = {}   -- {fill, knob}
    local sidebarEntries   = {}   -- {btn, lbl, name}
    local activeTabName    = nil

    local function applyTheme(newT)
        T = newT
        -- Window
        tw(Win,{BackgroundColor3=T.Window},0.25)
        WinCorner.CornerRadius = UDim.new(0,T.WinRadius)
        WinStroke.Color = T.WinBorder
        -- TitleBar
        tw(TBar,{BackgroundColor3=T.TitleBar},0.25)
        TBarFix.BackgroundColor3 = T.TitleBar
        tw(TBarDiv,{BackgroundColor3=T.RowBorder},0.25)
        TitleLbl.TextColor3 = T.TitleText
        TitleLbl.TextXAlignment = T.TitleCentered and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left
        -- Traffic lights
        makeTrafficLights(T.TrafficLights)
        -- Sidebar
        tw(Sidebar,{BackgroundColor3=T.Sidebar},0.25)
        SidebarDiv.BackgroundColor3 = T.SidebarBorder
        -- Status bar
        tw(StatusBar,{BackgroundColor3=T.StatusBar},0.25)
        SBDot.BackgroundColor3  = T.Green
        SBText.TextColor3       = T.TextSec
        SBThemeLbl.TextColor3   = T.Accent
        SBThemeLbl.Text         = T.Name
        SBText.Text             = "Kinetix v1.0.0  ·  "..T.Name
        -- Toast
        tw(Toast,{BackgroundColor3=T.Toast},0.25)
        ToastStroke.Color = T.RowBorder
        TTitle.TextColor3 = T.Text; TBody.TextColor3 = T.TextSec
        -- Sidebar items
        for _, entry in ipairs(sidebarEntries) do
            local isActive = (entry.name == activeTabName)
            entry.btn.BackgroundColor3 = isActive and T.SideItemActive or T.Sidebar
            entry.btn.BackgroundTransparency = isActive and 0 or 1
            entry.lbl.TextColor3 = isActive and T.SideItemTxtOn or T.SideItemText
        end
        -- Theme listeners (rows, labels, etc.)
        for _, l in ipairs(themeListeners) do
            pcall(function() l.inst[l.prop] = T[l.key] end)
        end
        -- Toggles
        for _, ti in ipairs(toggleInstances) do
            pcall(function()
                local on = ti.stateRef[1]
                ti.track.BackgroundColor3 = on and T.ToggleOn or T.ToggleOff
                ti.knob.BackgroundColor3  = T.Knob
            end)
        end
        -- Sliders
        for _, si in ipairs(sliderInstances) do
            pcall(function()
                si.fill.BackgroundColor3  = T.SliderFill
                si.track.BackgroundColor3 = T.SliderTrack
                si.knob.BackgroundColor3  = T.Knob
            end)
        end
    end

    -- ═════════════════════════════════════════════════════════════════════════
    -- TAB SYSTEM
    -- ═════════════════════════════════════════════════════════════════════════
    local tabCount = 0
    local panels   = {}
    local sideItemMap = {}

    local function activateTab(name)
        activeTabName = name
        for k, p in pairs(panels) do
            p.Visible = (k==name)
        end
        for _, entry in ipairs(sidebarEntries) do
            local on = (entry.name == name)
            tw(entry.btn,{
                BackgroundTransparency = on and 0 or 1,
                BackgroundColor3       = on and T.SideItemActive or T.Sidebar
            },0.15)
            entry.lbl.TextColor3 = on and T.SideItemTxtOn or T.SideItemText
        end
    end

    -- ═════════════════════════════════════════════════════════════════════════
    -- WINDOW API
    -- ═════════════════════════════════════════════════════════════════════════
    local WinAPI = {}

    function WinAPI:Notify(c)
        showToast(c.Icon, c.Title, c.Body, c.Duration)
    end

    function WinAPI:SetStatus(txt)
        SBText.Text = "Kinetix  ·  "..txt
    end

    function WinAPI:Destroy()
        closeAnim()
    end

    function WinAPI:Toggle()
        Win.Visible = not Win.Visible
    end

    function WinAPI:SetTheme(theme, linuxStyle)
        currentThemeName  = theme
        currentLinuxStyle = linuxStyle or currentLinuxStyle
        local newT = resolveTheme(theme, currentLinuxStyle)
        applyTheme(newT)
    end

    function WinAPI:GetTheme()
        return currentThemeName, currentLinuxStyle
    end

    -- ─────────────────────────────────────────────────────────────────────────
    -- CREATE TAB
    -- ─────────────────────────────────────────────────────────────────────────
    function WinAPI:CreateTab(name, icon)
        icon = icon or "📄"
        tabCount += 1

        -- Sidebar button
        local SI = Instance.new("TextButton", Sidebar)
        SI.Name                  = "SI_"..name
        SI.Size                  = UDim2.new(1,0,0,34)
        SI.BackgroundColor3      = T.Sidebar
        SI.BackgroundTransparency= 1
        SI.AutoButtonColor       = false
        SI.Text                  = ""
        SI.LayoutOrder           = tabCount
        Instance.new("UICorner",SI).CornerRadius = UDim.new(0,8)

        local SIPad = Instance.new("UIPadding",SI)
        SIPad.PaddingLeft = UDim.new(0,8)
        local SIL = Instance.new("UIListLayout",SI)
        SIL.FillDirection = Enum.FillDirection.Horizontal
        SIL.Padding = UDim.new(0,8); SIL.VerticalAlignment = Enum.VerticalAlignment.Center

        local SIIcon = Instance.new("TextLabel",SI)
        SIIcon.Size=UDim2.new(0,18,1,0); SIIcon.BackgroundTransparency=1
        SIIcon.Font=T.Font; SIIcon.TextSize=14; SIIcon.Text=icon

        local SILbl = Instance.new("TextLabel",SI)
        SILbl.Name="Label"; SILbl.Size=UDim2.new(1,-30,1,0)
        SILbl.BackgroundTransparency=1; SILbl.Font=T.FontMed; SILbl.TextSize=13
        SILbl.TextColor3=T.SideItemText; SILbl.TextXAlignment=Enum.TextXAlignment.Left
        SILbl.Text=name

        SI.MouseEnter:Connect(function()
            if activeTabName ~= name then tw(SI,{BackgroundTransparency=0.82},0.1) end
        end)
        SI.MouseLeave:Connect(function()
            if activeTabName ~= name then tw(SI,{BackgroundTransparency=1},0.1) end
        end)
        SI.MouseButton1Click:Connect(function() activateTab(name) end)

        table.insert(sidebarEntries, {btn=SI, lbl=SILbl, name=name})

        -- Panel
        local Panel = Instance.new("ScrollingFrame", ContentHolder)
        Panel.Name               = "Panel_"..name
        Panel.Size               = UDim2.new(1,0,1,0)
        Panel.BackgroundTransparency = 1
        Panel.BorderSizePixel    = 0
        Panel.ScrollBarThickness = 3
        Panel.ScrollBarImageColor3 = rgb(80,80,90)
        Panel.CanvasSize         = UDim2.new(0,0,0,0)
        Panel.AutomaticCanvasSize= Enum.AutomaticSize.Y
        Panel.Visible            = false

        local PPad = Instance.new("UIPadding",Panel)
        PPad.PaddingLeft=UDim.new(0,16); PPad.PaddingRight=UDim.new(0,16)
        PPad.PaddingTop=UDim.new(0,14); PPad.PaddingBottom=UDim.new(0,14)
        local PLay = Instance.new("UIListLayout",Panel)
        PLay.Padding=UDim.new(0,2); PLay.SortOrder=Enum.SortOrder.LayoutOrder
        panels[name] = Panel

        if tabCount == 1 then activateTab(name) end

        -- ── Tab-local helpers ─────────────────────────────────────────────────
        local lo = 0
        local function nlo() lo+=1; return lo end

        local function makeRow(h)
            local r = Instance.new("Frame",Panel)
            r.Size=UDim2.new(1,0,0,h or 44)
            r.BackgroundColor3=T.Row; r.BorderSizePixel=0
            r.LayoutOrder=nlo(); r.ClipsDescendants=false
            Instance.new("UICorner",r).CornerRadius=UDim.new(0,T.RowRadius)
            local rs=Instance.new("UIStroke",r)
            rs.Color=T.RowBorder; rs.Thickness=1; rs.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
            local rp=Instance.new("UIPadding",r)
            rp.PaddingLeft=UDim.new(0,14); rp.PaddingRight=UDim.new(0,14)
            r.MouseEnter:Connect(function() tw(r,{BackgroundColor3=T.RowHover},0.1) end)
            r.MouseLeave:Connect(function() tw(r,{BackgroundColor3=T.Row},0.1) end)
            -- register for theme switching
            table.insert(themeListeners,{inst=r,  prop="BackgroundColor3", key="Row"})
            table.insert(themeListeners,{inst=rs, prop="Color",            key="RowBorder"})
            return r, rs
        end

        local function lbl(parent, text, font, size, col, xa)
            local l=Instance.new("TextLabel",parent)
            l.BackgroundTransparency=1; l.Font=font or T.FontMed
            l.TextSize=size or 13; l.TextColor3=col or T.Text
            l.TextXAlignment=xa or Enum.TextXAlignment.Left
            l.Text=text or ""; return l
        end

        -- ╔══════════════════════════════════════════╗
        -- ║            TAB ELEMENT API               ║
        -- ╚══════════════════════════════════════════╝
        local TabAPI = {}

        -- Section ─────────────────────────────────────────────
        function TabAPI:CreateSection(text)
            local sf=Instance.new("Frame",Panel)
            sf.Size=UDim2.new(1,0,0,30); sf.BackgroundTransparency=1; sf.LayoutOrder=nlo()
            local sl=lbl(sf,text:upper(),T.Font,10,T.SectionLbl)
            sl.Size=UDim2.new(1,0,1,0)
            local sp=Instance.new("UIPadding",sf)
            sp.PaddingLeft=UDim.new(0,4); sp.PaddingTop=UDim.new(0,8)
            table.insert(themeListeners,{inst=sl,prop="TextColor3",key="SectionLbl"})
        end

        -- Label ────────────────────────────────────────────────
        function TabAPI:CreateLabel(text)
            local lf=Instance.new("Frame",Panel)
            lf.Size=UDim2.new(1,0,0,34); lf.BackgroundColor3=T.Row
            lf.BorderSizePixel=0; lf.LayoutOrder=nlo()
            Instance.new("UICorner",lf).CornerRadius=UDim.new(0,T.RowRadius)
            local ls=Instance.new("UIStroke",lf); ls.Color=T.RowBorder; ls.Thickness=1
            ls.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
            local lp=Instance.new("UIPadding",lf); lp.PaddingLeft=UDim.new(0,12)
            local ll=lbl(lf,text,T.FontReg,12,T.TextSec); ll.Size=UDim2.new(1,0,1,0)
            table.insert(themeListeners,{inst=lf,prop="BackgroundColor3",key="Row"})
            table.insert(themeListeners,{inst=ls,prop="Color",key="RowBorder"})
            table.insert(themeListeners,{inst=ll,prop="TextColor3",key="TextSec"})
        end

        -- Toggle ───────────────────────────────────────────────
        function TabAPI:CreateToggle(cfg)
            local state = cfg.Default or false
            local stateRef = {state}
            local r,rs = makeRow(cfg.Desc and 56 or 44)

            local nl=lbl(r,cfg.Name,T.FontMed,13,T.Text)
            nl.Size=UDim2.new(1,-56,0,20)
            nl.Position=cfg.Desc and UDim2.new(0,0,0,8) or UDim2.new(0,0,0.5,-10)
            table.insert(themeListeners,{inst=nl,prop="TextColor3",key="Text"})

            if cfg.Desc then
                local dl=lbl(r,cfg.Desc,T.FontReg,11,T.TextSec)
                dl.Size=UDim2.new(1,-56,0,14); dl.Position=UDim2.new(0,0,1,-20)
                table.insert(themeListeners,{inst=dl,prop="TextColor3",key="TextSec"})
            end

            local track=Instance.new("Frame",r)
            track.Size=UDim2.new(0,40,0,24); track.Position=UDim2.new(1,-40,0.5,-12)
            track.BackgroundColor3=state and T.ToggleOn or T.ToggleOff; track.BorderSizePixel=0
            Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)

            local knob=Instance.new("Frame",track)
            knob.Size=UDim2.new(0,20,0,20)
            knob.Position=state and UDim2.new(0,18,0,2) or UDim2.new(0,2,0,2)
            knob.BackgroundColor3=T.Knob; knob.BorderSizePixel=0
            Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)
            local ks=Instance.new("UIStroke",knob); ks.Color=rgb(0,0,0); ks.Thickness=0.5; ks.Transparency=0.65

            table.insert(toggleInstances,{track=track,knob=knob,stateRef=stateRef})

            local cb=Instance.new("TextButton",r)
            cb.Size=UDim2.new(1,0,1,0); cb.BackgroundTransparency=1; cb.Text=""; cb.ZIndex=2
            cb.MouseButton1Click:Connect(function()
                state=not state; stateRef[1]=state
                tw(track,{BackgroundColor3=state and T.ToggleOn or T.ToggleOff},0.18)
                spring(knob,{Position=state and UDim2.new(0,18,0,2) or UDim2.new(0,2,0,2)},0.28)
                if cfg.Callback then cfg.Callback(state) end
            end)

            local API={}
            function API:Set(v)
                state=v; stateRef[1]=v
                tw(track,{BackgroundColor3=v and T.ToggleOn or T.ToggleOff},0.18)
                spring(knob,{Position=v and UDim2.new(0,18,0,2) or UDim2.new(0,2,0,2)},0.28)
                if cfg.Callback then cfg.Callback(v) end
            end
            function API:Get() return state end
            return API
        end

        -- Slider ───────────────────────────────────────────────
        function TabAPI:CreateSlider(cfg)
            local mn=cfg.Min or 0; local mx=cfg.Max or 100
            local inc=cfg.Increment or 1; local val=cfg.Default or mn
            local r,rs=makeRow(54)

            local nl=lbl(r,cfg.Name,T.FontMed,13,T.Text)
            nl.Size=UDim2.new(0.6,0,0,20); nl.Position=UDim2.new(0,0,0,7)
            table.insert(themeListeners,{inst=nl,prop="TextColor3",key="Text"})

            local vl=lbl(r,tostring(val),T.FontReg,12,T.TextSec,Enum.TextXAlignment.Right)
            vl.Size=UDim2.new(0.4,0,0,20); vl.Position=UDim2.new(0.6,0,0,7)
            table.insert(themeListeners,{inst=vl,prop="TextColor3",key="TextSec"})

            local trackBg=Instance.new("Frame",r)
            trackBg.Size=UDim2.new(1,0,0,4); trackBg.Position=UDim2.new(0,0,1,-13)
            trackBg.BackgroundColor3=T.SliderTrack; trackBg.BorderSizePixel=0
            Instance.new("UICorner",trackBg).CornerRadius=UDim.new(1,0)

            local pct=(val-mn)/(mx-mn)
            local fill=Instance.new("Frame",trackBg)
            fill.Size=UDim2.new(pct,0,1,0); fill.BackgroundColor3=T.SliderFill; fill.BorderSizePixel=0
            Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)

            local knobBtn=Instance.new("TextButton",trackBg)
            knobBtn.Size=UDim2.new(0,16,0,16); knobBtn.Position=UDim2.new(pct,-8,0.5,-8)
            knobBtn.BackgroundColor3=T.Knob; knobBtn.Text=""; knobBtn.AutoButtonColor=false
            knobBtn.BorderSizePixel=0; knobBtn.ZIndex=3
            Instance.new("UICorner",knobBtn).CornerRadius=UDim.new(1,0)
            local ks2=Instance.new("UIStroke",knobBtn); ks2.Color=rgb(0,0,0); ks2.Thickness=0.5; ks2.Transparency=0.65

            table.insert(sliderInstances,{track=trackBg,fill=fill,knob=knobBtn})

            knobBtn.MouseEnter:Connect(function()
                spring(knobBtn,{Size=UDim2.new(0,18,0,18),Position=UDim2.new(pct,-9,0.5,-9)},0.2)
            end)
            knobBtn.MouseLeave:Connect(function()
                spring(knobBtn,{Size=UDim2.new(0,16,0,16),Position=UDim2.new(pct,-8,0.5,-8)},0.2)
            end)

            local dragging=false
            knobBtn.MouseButton1Down:Connect(function() dragging=true end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
            end)

            local function update(pos)
                local ap=trackBg.AbsolutePosition; local as=trackBg.AbsoluteSize
                local rel=math.clamp((pos.X-ap.X)/as.X,0,1)
                val=math.round((mn+(mx-mn)*rel)/inc)*inc; val=math.clamp(val,mn,mx)
                pct=(val-mn)/(mx-mn)
                vl.Text=(inc%1==0) and tostring(math.round(val)) or string.format("%.2f",val)
                tw(fill,{Size=UDim2.new(pct,0,1,0)},0.05)
                tw(knobBtn,{Position=UDim2.new(pct,-8,0.5,-8)},0.05)
                if cfg.Callback then cfg.Callback(val) end
            end

            UserInputService.InputChanged:Connect(function(i)
                if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
                    update(i.Position)
                end
            end)
            trackBg.InputBegan:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                    dragging=true; update(i.Position)
                end
            end)

            local API={}
            function API:Set(v)
                val=math.clamp(v,mn,mx); pct=(val-mn)/(mx-mn)
                vl.Text=tostring(val)
                tw(fill,{Size=UDim2.new(pct,0,1,0)},0.1)
                tw(knobBtn,{Position=UDim2.new(pct,-8,0.5,-8)},0.1)
                if cfg.Callback then cfg.Callback(val) end
            end
            function API:Get() return val end
            return API
        end

        -- Button ───────────────────────────────────────────────
        function TabAPI:CreateButton(cfg)
            local r,rs=makeRow(cfg.Desc and 56 or 44)

            local nl=lbl(r,cfg.Name,T.FontMed,13,T.Text)
            nl.Size=UDim2.new(1,-88,0,20)
            nl.Position=cfg.Desc and UDim2.new(0,0,0,8) or UDim2.new(0,0,0.5,-10)
            table.insert(themeListeners,{inst=nl,prop="TextColor3",key="Text"})

            if cfg.Desc then
                local dl=lbl(r,cfg.Desc,T.FontReg,11,T.TextSec)
                dl.Size=UDim2.new(1,-88,0,14); dl.Position=UDim2.new(0,0,1,-20)
                table.insert(themeListeners,{inst=dl,prop="TextColor3",key="TextSec"})
            end

            local style=cfg.Style or "default"
            local bc  = (style=="accent") and T.Accent    or (style=="danger") and T.BtnDanger    or T.Btn
            local bch = (style=="accent") and T.AccentHover or (style=="danger") and T.BtnDangerHov or T.BtnHover
            local btc = (style=="danger") and T.BtnTextDanger or T.Text

            local btn=Instance.new("TextButton",r)
            btn.Size=UDim2.new(0,74,0,28); btn.Position=UDim2.new(1,-74,0.5,-14)
            btn.BackgroundColor3=bc; btn.Font=T.FontMed; btn.TextSize=12
            btn.TextColor3=btc; btn.Text=cfg.Label or "Run"
            btn.AutoButtonColor=false; btn.BorderSizePixel=0; btn.ZIndex=2
            Instance.new("UICorner",btn).CornerRadius=UDim.new(0,T.RowRadius)
            local bs=Instance.new("UIStroke",btn); bs.Color=T.RowBorder; bs.Thickness=1
            bs.ApplyStrokeMode=Enum.ApplyStrokeMode.Border

            btn.MouseEnter:Connect(function() tw(btn,{BackgroundColor3=bch},0.1) end)
            btn.MouseLeave:Connect(function() tw(btn,{BackgroundColor3=bc},0.1) end)
            btn.MouseButton1Down:Connect(function()
                spring(btn,{Size=UDim2.new(0,70,0,26),Position=UDim2.new(1,-72,0.5,-13)},0.12)
            end)
            btn.MouseButton1Up:Connect(function()
                spring(btn,{Size=UDim2.new(0,74,0,28),Position=UDim2.new(1,-74,0.5,-14)},0.18)
            end)
            btn.MouseButton1Click:Connect(function()
                if cfg.Callback then cfg.Callback() end
            end)
        end

        -- Dropdown ─────────────────────────────────────────────
        function TabAPI:CreateDropdown(cfg)
            local opts=cfg.Options or {}; local sel=cfg.Default or (opts[1] or "")
            local open=false
            local r,rs=makeRow(44); r.ClipsDescendants=false

            local nl=lbl(r,cfg.Name,T.FontMed,13,T.Text); nl.Size=UDim2.new(0.5,0,1,0)
            table.insert(themeListeners,{inst=nl,prop="TextColor3",key="Text"})

            local dBtn=Instance.new("TextButton",r)
            dBtn.Size=UDim2.new(0,130,0,28); dBtn.Position=UDim2.new(1,-130,0.5,-14)
            dBtn.BackgroundColor3=T.Select; dBtn.Font=T.FontMed; dBtn.TextSize=12
            dBtn.TextColor3=T.Text; dBtn.Text=sel.."  ▾"
            dBtn.AutoButtonColor=false; dBtn.BorderSizePixel=0; dBtn.ZIndex=5
            Instance.new("UICorner",dBtn).CornerRadius=UDim.new(0,T.RowRadius)
            local dbs=Instance.new("UIStroke",dBtn); dbs.Color=T.RowBorder; dbs.Thickness=1
            dbs.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
            table.insert(themeListeners,{inst=dBtn,prop="BackgroundColor3",key="Select"})
            table.insert(themeListeners,{inst=dBtn,prop="TextColor3",key="Text"})

            local dList=Instance.new("Frame",r)
            dList.Size=UDim2.new(0,130,0,0); dList.Position=UDim2.new(1,-130,1,4)
            dList.BackgroundColor3=T.Select; dList.BorderSizePixel=0
            dList.ZIndex=10; dList.ClipsDescendants=true; dList.Visible=false
            Instance.new("UICorner",dList).CornerRadius=UDim.new(0,T.RowRadius)
            local dls=Instance.new("UIStroke",dList); dls.Color=T.RowBorder; dls.Thickness=1
            dls.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
            local dll=Instance.new("UIListLayout",dList); dll.SortOrder=Enum.SortOrder.LayoutOrder
            table.insert(themeListeners,{inst=dList,prop="BackgroundColor3",key="Select"})

            for i,opt in ipairs(opts) do
                local ob=Instance.new("TextButton",dList)
                ob.Size=UDim2.new(1,0,0,30); ob.BackgroundTransparency=1
                ob.Font=T.FontReg; ob.TextSize=12; ob.TextColor3=T.TextSec
                ob.Text=opt; ob.AutoButtonColor=false; ob.ZIndex=11; ob.LayoutOrder=i
                table.insert(themeListeners,{inst=ob,prop="TextColor3",key="TextSec"})
                ob.MouseEnter:Connect(function()
                    tw(ob,{BackgroundTransparency=0,BackgroundColor3=T.RowHover},0.1)
                    ob.TextColor3=T.Text
                end)
                ob.MouseLeave:Connect(function()
                    tw(ob,{BackgroundTransparency=1},0.1); ob.TextColor3=T.TextSec
                end)
                ob.MouseButton1Click:Connect(function()
                    sel=opt; dBtn.Text=sel.."  ▾"; open=false
                    tw(dList,{Size=UDim2.new(0,130,0,0)},0.18)
                    task.delay(0.2,function() dList.Visible=false end)
                    if cfg.Callback then cfg.Callback(sel) end
                end)
            end

            dBtn.MouseButton1Click:Connect(function()
                open=not open
                if open then
                    dList.Visible=true
                    spring(dList,{Size=UDim2.new(0,130,0,#opts*30)},0.22)
                else
                    tw(dList,{Size=UDim2.new(0,130,0,0)},0.18)
                    task.delay(0.2,function() dList.Visible=false end)
                end
            end)
            UserInputService.InputBegan:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 and open then
                    local p=i.Position; local ap=dList.AbsolutePosition; local as=dList.AbsoluteSize
                    if p.X<ap.X or p.X>ap.X+as.X or p.Y<ap.Y or p.Y>ap.Y+as.Y then
                        open=false; tw(dList,{Size=UDim2.new(0,130,0,0)},0.18)
                        task.delay(0.2,function() dList.Visible=false end)
                    end
                end
            end)

            local API={}
            function API:Set(v) sel=v; dBtn.Text=v.."  ▾"; if cfg.Callback then cfg.Callback(v) end end
            function API:Get() return sel end
            return API
        end

        -- PillGroup ────────────────────────────────────────────
        function TabAPI:CreatePillGroup(cfg)
            local opts=cfg.Options or {}; local sel=cfg.Default or (opts[1] or "")
            local r,rs=makeRow(44)

            local nl=lbl(r,cfg.Name,T.FontMed,13,T.Text); nl.Size=UDim2.new(0.4,0,1,0)
            table.insert(themeListeners,{inst=nl,prop="TextColor3",key="Text"})

            local pf=Instance.new("Frame",r)
            pf.Size=UDim2.new(0,#opts*60+4,0,30)
            pf.Position=UDim2.new(1,-#opts*60-4,0.5,-15)
            pf.BackgroundTransparency=1; pf.BorderSizePixel=0
            local pl=Instance.new("UIListLayout",pf)
            pl.FillDirection=Enum.FillDirection.Horizontal
            pl.Padding=UDim.new(0,4); pl.VerticalAlignment=Enum.VerticalAlignment.Center

            local pillBtns={}
            for _,opt in ipairs(opts) do
                local pb=Instance.new("TextButton",pf)
                pb.Size=UDim2.new(0,56,0,28)
                pb.BackgroundColor3=(opt==sel) and T.PillActive or T.Pill
                pb.Font=T.FontMed; pb.TextSize=12
                pb.TextColor3=(opt==sel) and rgb(255,255,255) or T.TextSec
                pb.Text=opt; pb.AutoButtonColor=false; pb.BorderSizePixel=0; pb.ZIndex=2
                Instance.new("UICorner",pb).CornerRadius=UDim.new(0,T.RowRadius)
                pillBtns[opt]=pb
                pb.MouseButton1Click:Connect(function()
                    sel=opt
                    for k,b in pairs(pillBtns) do
                        tw(b,{BackgroundColor3=(k==opt) and T.PillActive or T.Pill},0.15)
                        b.TextColor3=(k==opt) and rgb(255,255,255) or T.TextSec
                    end
                    if cfg.Callback then cfg.Callback(sel) end
                end)
            end

            local API={}
            function API:Get() return sel end
            return API
        end

        return TabAPI
    end

    -- ═════════════════════════════════════════════════════════════════════════
    -- BUILT-IN SETTINGS TAB (always last)
    -- ═════════════════════════════════════════════════════════════════════════
    function WinAPI:_buildSettingsTab()
        local SetTab = self:CreateTab("Settings", "⚙️")
        SetTab:CreateSection("Theme")

        local themeDropEl = SetTab:CreateDropdown({
            Name     = "Theme",
            Options  = {"macOS","Windows7","Linux"},
            Default  = currentThemeName == "macOS" and "macOS"
                    or currentThemeName == "Windows7" and "Windows7"
                    or "Linux",
            Callback = function(v)
                currentThemeName = v
                self:SetTheme(v, currentLinuxStyle)
                if v ~= "Linux" then linuxSubEl:Set("—") end
                showToast("🎨","Theme","Switched to "..v,2)
            end
        })

        local linuxOpts = {"—","GNOME","KDE","Hyprland"}
        local linuxSubEl = SetTab:CreateDropdown({
            Name     = "Linux Style",
            Options  = linuxOpts,
            Default  = (currentThemeName=="Linux") and currentLinuxStyle or "—",
            Callback = function(v)
                if v == "—" then return end
                currentLinuxStyle = v
                if currentThemeName == "Linux" then
                    self:SetTheme("Linux", v)
                    showToast("🐧","Linux","Style: "..v,2)
                end
            end
        })

        SetTab:CreateLabel("Linux Style only applies when Theme = Linux")
        return SetTab
    end

    -- call it immediately to wire settings tab
    WinAPI:_buildSettingsTab()

    return WinAPI
end

return Kinetix
