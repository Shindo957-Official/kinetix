--[[
    MacOSLib — macOS-style UI Library for Roblox
    Author: Shindo / Potatoware
    Version: 1.0.0
    GitHub: https://github.com/YOU/REPO

    ═══════════════════════════════════════
    QUICK START:
        local MacOS = loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/YOU/REPO/main/MacOSLib.lua"
        ))()

        local Win = MacOS:CreateWindow({
            Title      = "My Script",
            Subtitle   = "by Me",
            ToggleKey  = Enum.KeyCode.RightControl,
        })

        local Tab = Win:CreateTab("Main", "🏠")
        Tab:CreateSection("Movement")
        Tab:CreateToggle({ Name = "Fly", Default = false, Callback = function(v) print(v) end })
        Tab:CreateSlider({ Name = "Speed", Min = 5, Max = 100, Increment = 1, Default = 20, Callback = function(v) end })
        Tab:CreateButton({ Name = "Frontflip", Callback = function() end })
        Tab:CreateDropdown({ Name = "Mode", Options = {"Normal","Fast","Slow"}, Default = "Normal", Callback = function(v) end })
        Tab:CreatePillGroup({ Name = "Angle", Options = {"90°","45°"}, Default = "90°", Callback = function(v) end })
        Tab:CreateLabel("Some info text")

        Win:Notify({ Icon = "🎉", Title = "Loaded", Body = "Script ready!", Duration = 3 })
    ═══════════════════════════════════════
]]

local MacOSLib = {}
MacOSLib.__index = MacOSLib

-- ─── Services ────────────────────────────────────────────────────────────────
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local LocalPlayer      = Players.LocalPlayer

local function getGui()
    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    return (ok and cg) or LocalPlayer:WaitForChild("PlayerGui")
end

-- ─── Helpers ─────────────────────────────────────────────────────────────────
local function tw(obj, props, t, style, dir)
    TweenService:Create(obj,
        TweenInfo.new(t or 0.18, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
        props):Play()
end

local function spring(obj, props, t)
    TweenService:Create(obj,
        TweenInfo.new(t or 0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        props):Play()
end

local function rgb(r,g,b) return Color3.fromRGB(r,g,b) end

-- ─── Theme ───────────────────────────────────────────────────────────────────
local T = {
    Window       = rgb(26,26,28),
    WinBorder    = rgb(55,55,62),
    TitleBar     = rgb(34,34,38),
    Sidebar      = rgb(20,20,23),
    SidebarBorder= rgb(44,44,50),
    Row          = rgb(36,36,40),
    RowHover     = rgb(46,46,52),
    RowBorder    = rgb(52,52,58),
    Text         = rgb(228,228,232),
    TextSec      = rgb(130,130,142),
    TextTert     = rgb(72,72,82),
    Accent       = rgb(10,132,255),
    AccentHover  = rgb(60,150,255),
    Green        = rgb(48,209,88),
    Red          = rgb(255,69,58),
    Yellow       = rgb(255,214,10),
    TLRed        = rgb(255,95,87),
    TLYellow     = rgb(254,188,46),
    TLGreen      = rgb(40,200,64),
    StatusBar    = rgb(20,20,23),
    Toast        = rgb(46,46,50),
    SectionLbl   = rgb(85,85,95),
    ToggleOff    = rgb(65,65,75),
    ToggleOn     = rgb(10,132,255),
    Knob         = rgb(255,255,255),
    SliderTrack  = rgb(55,55,65),
    SliderFill   = rgb(10,132,255),
    Pill         = rgb(46,46,54),
    PillActive   = rgb(10,132,255),
    Select       = rgb(40,40,46),
    Btn          = rgb(50,50,58),
    BtnHover     = rgb(62,62,72),
    BtnDanger    = rgb(55,18,18),
    BtnDangerHov = rgb(75,22,22),
}

-- ─── Dragging ────────────────────────────────────────────────────────────────
local function makeDraggable(frame, handle)
    local dragging, start, origin
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            start  = i.Position
            origin = frame.Position
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

-- ═══════════════════════════════════════════════════════════════════════════════
-- CreateWindow
-- ═══════════════════════════════════════════════════════════════════════════════
function MacOSLib:CreateWindow(cfg)
    cfg = cfg or {}
    local Title     = cfg.Title     or "MacOS UI"
    local Subtitle  = cfg.Subtitle  or "by MacOSLib"
    local ToggleKey = cfg.ToggleKey or Enum.KeyCode.RightControl
    local WinSize   = cfg.Size      or UDim2.new(0, 680, 0, 500)

    -- ── ScreenGui ────────────────────────────────────────────────────────────
    local SG = Instance.new("ScreenGui")
    SG.Name             = "MacOSLib"
    SG.ResetOnSpawn     = false
    SG.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
    SG.DisplayOrder     = 999
    SG.IgnoreGuiInset   = true
    SG.Parent           = getGui()

    -- ── Window Frame ─────────────────────────────────────────────────────────
    local Win = Instance.new("Frame")
    Win.Name               = "Window"
    Win.Size               = UDim2.new(0,0,0,0)
    Win.Position           = UDim2.new(0.5,0,0.5,0)
    Win.BackgroundColor3   = T.Window
    Win.BorderSizePixel    = 0
    Win.ClipsDescendants   = true
    Win.Parent             = SG

    Instance.new("UICorner", Win).CornerRadius = UDim.new(0,14)
    local winStroke = Instance.new("UIStroke", Win)
    winStroke.Color = T.WinBorder; winStroke.Thickness = 1
    winStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- open animation
    spring(Win, {Size=WinSize, Position=UDim2.new(0.5,-WinSize.X.Offset/2, 0.5,-WinSize.Y.Offset/2)}, 0.5)

    local function closeAnim()
        spring(Win, {Size=UDim2.new(0,0,0,0), Position=UDim2.new(0.5,0,0.5,0)}, 0.3)
        task.delay(0.35, function() SG:Destroy() end)
    end

    -- ── Title Bar ────────────────────────────────────────────────────────────
    local TBar = Instance.new("Frame")
    TBar.Name            = "TitleBar"
    TBar.Size            = UDim2.new(1,0,0,44)
    TBar.BackgroundColor3 = T.TitleBar
    TBar.BorderSizePixel  = 0
    TBar.ZIndex           = 2
    TBar.Parent           = Win
    Instance.new("UICorner",TBar).CornerRadius = UDim.new(0,14)

    -- square off bottom of titlebar
    local fix = Instance.new("Frame",TBar)
    fix.Size = UDim2.new(1,0,0,14); fix.Position = UDim2.new(0,0,1,-14)
    fix.BackgroundColor3 = T.TitleBar; fix.BorderSizePixel = 0; fix.ZIndex = 2

    local div = Instance.new("Frame",TBar)
    div.Size = UDim2.new(1,0,0,1); div.Position = UDim2.new(0,0,1,-1)
    div.BackgroundColor3 = T.RowBorder; div.BorderSizePixel = 0; div.ZIndex = 3

    -- Traffic lights
    local TLFrame = Instance.new("Frame",TBar)
    TLFrame.Size = UDim2.new(0,76,0,20)
    TLFrame.Position = UDim2.new(0,14,0.5,-10)
    TLFrame.BackgroundTransparency = 1; TLFrame.ZIndex = 3
    local tll = Instance.new("UIListLayout",TLFrame)
    tll.FillDirection = Enum.FillDirection.Horizontal
    tll.Padding = UDim.new(0,8)
    tll.VerticalAlignment = Enum.VerticalAlignment.Center

    local function dot(col, hover, fn)
        local d = Instance.new("TextButton",TLFrame)
        d.Size = UDim2.new(0,12,0,12); d.BackgroundColor3 = col
        d.Text = ""; d.AutoButtonColor = false; d.ZIndex = 4
        Instance.new("UICorner",d).CornerRadius = UDim.new(1,0)
        d.MouseButton1Click:Connect(function()
            tw(d,{BackgroundColor3=hover},0.08)
            task.wait(0.08); tw(d,{BackgroundColor3=col},0.08)
            if fn then fn() end
        end)
        return d
    end

    dot(T.TLRed,    rgb(200,40,30),  closeAnim)
    dot(T.TLYellow, rgb(200,150,10), function() Win.Visible = not Win.Visible end)
    dot(T.TLGreen,  rgb(20,160,40),  nil)

    local titleLbl = Instance.new("TextLabel",TBar)
    titleLbl.Size = UDim2.new(1,0,1,0); titleLbl.BackgroundTransparency = 1
    titleLbl.Font = Enum.Font.GothamBold; titleLbl.TextSize = 13
    titleLbl.TextColor3 = T.Text; titleLbl.ZIndex = 3
    titleLbl.Text = Title .. "  —  " .. Subtitle

    makeDraggable(Win, TBar)

    -- ── Body ─────────────────────────────────────────────────────────────────
    local Body = Instance.new("Frame",Win)
    Body.Name = "Body"
    Body.Size = UDim2.new(1,0,1,-44-28)
    Body.Position = UDim2.new(0,0,0,44)
    Body.BackgroundTransparency = 1

    -- ── Sidebar ──────────────────────────────────────────────────────────────
    local Sidebar = Instance.new("ScrollingFrame",Body)
    Sidebar.Size = UDim2.new(0,155,1,0)
    Sidebar.BackgroundColor3 = T.Sidebar; Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 0; Sidebar.CanvasSize = UDim2.new(0,0,0,0)
    Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local sDiv = Instance.new("Frame",Sidebar)
    sDiv.Size = UDim2.new(0,1,1,0); sDiv.Position = UDim2.new(1,-1,0,0)
    sDiv.BackgroundColor3 = T.SidebarBorder; sDiv.BorderSizePixel = 0; sDiv.ZIndex = 2

    local sPad = Instance.new("UIPadding",Sidebar)
    sPad.PaddingLeft = UDim.new(0,8); sPad.PaddingRight = UDim.new(0,8)
    sPad.PaddingTop = UDim.new(0,10); sPad.PaddingBottom = UDim.new(0,10)
    local sLayout = Instance.new("UIListLayout",Sidebar)
    sLayout.Padding = UDim.new(0,2); sLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- ── Content Holder ───────────────────────────────────────────────────────
    local ContentHolder = Instance.new("Frame",Body)
    ContentHolder.Size = UDim2.new(1,-155,1,0)
    ContentHolder.Position = UDim2.new(0,155,0,0)
    ContentHolder.BackgroundTransparency = 1; ContentHolder.ClipsDescendants = true

    -- ── Status Bar ───────────────────────────────────────────────────────────
    local StatusBar = Instance.new("Frame",Win)
    StatusBar.Size = UDim2.new(1,0,0,28)
    StatusBar.Position = UDim2.new(0,0,1,-28)
    StatusBar.BackgroundColor3 = T.StatusBar; StatusBar.BorderSizePixel = 0; StatusBar.ZIndex = 2
    local sbDiv = Instance.new("Frame",StatusBar)
    sbDiv.Size = UDim2.new(1,0,0,1); sbDiv.BackgroundColor3 = T.RowBorder; sbDiv.BorderSizePixel = 0

    local sbPad = Instance.new("UIPadding",StatusBar)
    sbPad.PaddingLeft = UDim.new(0,12); sbPad.PaddingRight = UDim.new(0,12)

    local sbDot = Instance.new("Frame",StatusBar)
    sbDot.Size = UDim2.new(0,6,0,6); sbDot.Position = UDim2.new(0,0,0.5,-3)
    sbDot.BackgroundColor3 = T.Green; sbDot.BorderSizePixel = 0; sbDot.ZIndex = 3
    Instance.new("UICorner",sbDot).CornerRadius = UDim.new(1,0)

    local sbText = Instance.new("TextLabel",StatusBar)
    sbText.Size = UDim2.new(1,-20,1,0); sbText.Position = UDim2.new(0,16,0,0)
    sbText.BackgroundTransparency = 1; sbText.Font = Enum.Font.Gotham; sbText.TextSize = 11
    sbText.TextColor3 = T.TextSec; sbText.TextXAlignment = Enum.TextXAlignment.Left
    sbText.Text = "Loaded  ·  MacOSLib v1.0"; sbText.ZIndex = 3

    -- ── Toast ────────────────────────────────────────────────────────────────
    local Toast = Instance.new("Frame",SG)
    Toast.Size = UDim2.new(0,290,0,66); Toast.Position = UDim2.new(1,10,0,20)
    Toast.BackgroundColor3 = T.Toast; Toast.BorderSizePixel = 0; Toast.ZIndex = 100
    Instance.new("UICorner",Toast).CornerRadius = UDim.new(0,13)
    local ts = Instance.new("UIStroke",Toast)
    ts.Color = T.RowBorder; ts.Thickness = 1; ts.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local tPad = Instance.new("UIPadding",Toast)
    tPad.PaddingLeft = UDim.new(0,14); tPad.PaddingRight = UDim.new(0,14)
    tPad.PaddingTop = UDim.new(0,10); tPad.PaddingBottom = UDim.new(0,10)

    local tIcon = Instance.new("TextLabel",Toast)
    tIcon.Size = UDim2.new(0,28,0,28); tIcon.BackgroundTransparency = 1
    tIcon.Font = Enum.Font.GothamBold; tIcon.TextSize = 22; tIcon.Text = "🔔"; tIcon.ZIndex = 101

    local tTitle = Instance.new("TextLabel",Toast)
    tTitle.Size = UDim2.new(1,-38,0,20); tTitle.Position = UDim2.new(0,38,0,0)
    tTitle.BackgroundTransparency = 1; tTitle.Font = Enum.Font.GothamBold; tTitle.TextSize = 13
    tTitle.TextColor3 = T.Text; tTitle.TextXAlignment = Enum.TextXAlignment.Left
    tTitle.Text = ""; tTitle.ZIndex = 101

    local tBody = Instance.new("TextLabel",Toast)
    tBody.Size = UDim2.new(1,-38,0,30); tBody.Position = UDim2.new(0,38,0,22)
    tBody.BackgroundTransparency = 1; tBody.Font = Enum.Font.Gotham; tBody.TextSize = 12
    tBody.TextColor3 = T.TextSec; tBody.TextXAlignment = Enum.TextXAlignment.Left
    tBody.TextWrapped = true; tBody.Text = ""; tBody.ZIndex = 101

    local toastThread
    local function showToast(icon, title, body, dur)
        tIcon.Text = icon or "🔔"; tTitle.Text = title or ""; tBody.Text = body or ""
        tw(Toast, {Position = UDim2.new(1,-306,0,20)}, 0.3, Enum.EasingStyle.Back)
        if toastThread then task.cancel(toastThread) end
        toastThread = task.delay(dur or 3, function()
            tw(Toast, {Position = UDim2.new(1,10,0,20)}, 0.22)
        end)
    end

    -- ── Toggle key ───────────────────────────────────────────────────────────
    UserInputService.InputBegan:Connect(function(i,gp)
        if gp then return end
        if i.KeyCode == ToggleKey then Win.Visible = not Win.Visible end
    end)

    -- ═════════════════════════════════════════════════════════════════════════
    -- Tab system
    -- ═════════════════════════════════════════════════════════════════════════
    local tabCount   = 0
    local activeTab  = nil
    local panels     = {}
    local sideItems  = {}

    local function activateTab(name)
        for k, p in pairs(panels) do p.Visible = (k == name) end
        for k, si in pairs(sideItems) do
            local on = (k == name)
            tw(si, {BackgroundTransparency = on and 0 or 1, BackgroundColor3 = on and rgb(10,80,195) or T.Sidebar}, 0.15)
            si:FindFirstChild("Label", true).TextColor3 = on and T.AccentHover or T.TextSec
        end
        activeTab = name
    end

    -- ── Window API ───────────────────────────────────────────────────────────
    local WinAPI = {}

    function WinAPI:Notify(c)
        showToast(c.Icon, c.Title, c.Body, c.Duration)
    end
    function WinAPI:SetStatus(txt)
        sbText.Text = txt
    end
    function WinAPI:Destroy()
        closeAnim()
    end
    function WinAPI:Toggle()
        Win.Visible = not Win.Visible
    end

    -- ─────────────────────────────────────────────────────────────────────────
    -- CreateTab
    -- ─────────────────────────────────────────────────────────────────────────
    function WinAPI:CreateTab(name, icon)
        icon = icon or "📄"
        tabCount += 1

        -- Sidebar button
        local SI = Instance.new("TextButton",Sidebar)
        SI.Name = "SI_"..name; SI.Size = UDim2.new(1,0,0,34)
        SI.BackgroundColor3 = T.Sidebar; SI.BackgroundTransparency = 1
        SI.AutoButtonColor = false; SI.Text = ""; SI.LayoutOrder = tabCount

        Instance.new("UICorner",SI).CornerRadius = UDim.new(0,8)
        local siPad = Instance.new("UIPadding",SI)
        siPad.PaddingLeft = UDim.new(0,8)
        local siLayout = Instance.new("UIListLayout",SI)
        siLayout.FillDirection = Enum.FillDirection.Horizontal
        siLayout.Padding = UDim.new(0,8); siLayout.VerticalAlignment = Enum.VerticalAlignment.Center

        local siIcon = Instance.new("TextLabel",SI)
        siIcon.Size = UDim2.new(0,18,1,0); siIcon.BackgroundTransparency = 1
        siIcon.Font = Enum.Font.GothamBold; siIcon.TextSize = 14; siIcon.Text = icon

        local siLbl = Instance.new("TextLabel",SI)
        siLbl.Name = "Label"; siLbl.Size = UDim2.new(1,-30,1,0)
        siLbl.BackgroundTransparency = 1; siLbl.Font = Enum.Font.GothamMedium; siLbl.TextSize = 13
        siLbl.TextColor3 = T.TextSec; siLbl.TextXAlignment = Enum.TextXAlignment.Left; siLbl.Text = name

        SI.MouseEnter:Connect(function()
            if activeTab ~= name then tw(SI,{BackgroundTransparency=0.82},0.1) end
        end)
        SI.MouseLeave:Connect(function()
            if activeTab ~= name then tw(SI,{BackgroundTransparency=1},0.1) end
        end)
        SI.MouseButton1Click:Connect(function() activateTab(name) end)
        sideItems[name] = SI

        -- Content panel
        local Panel = Instance.new("ScrollingFrame",ContentHolder)
        Panel.Name = "Panel_"..name; Panel.Size = UDim2.new(1,0,1,0)
        Panel.BackgroundTransparency = 1; Panel.BorderSizePixel = 0
        Panel.ScrollBarThickness = 3; Panel.ScrollBarImageColor3 = rgb(70,70,80)
        Panel.CanvasSize = UDim2.new(0,0,0,0); Panel.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Panel.Visible = false
        local panelPad = Instance.new("UIPadding",Panel)
        panelPad.PaddingLeft = UDim.new(0,16); panelPad.PaddingRight = UDim.new(0,16)
        panelPad.PaddingTop = UDim.new(0,14); panelPad.PaddingBottom = UDim.new(0,14)
        local panelLayout = Instance.new("UIListLayout",Panel)
        panelLayout.Padding = UDim.new(0,2); panelLayout.SortOrder = Enum.SortOrder.LayoutOrder
        panels[name] = Panel

        if tabCount == 1 then activateTab(name) end

        -- ── Shared row builder ───────────────────────────────────────────────
        local lo = 0
        local function nextLO() lo += 1; return lo end

        local function makeRow(h)
            local r = Instance.new("Frame",Panel)
            r.Size = UDim2.new(1,0,0,h or 44)
            r.BackgroundColor3 = T.Row; r.BorderSizePixel = 0
            r.LayoutOrder = nextLO(); r.ClipsDescendants = false
            Instance.new("UICorner",r).CornerRadius = UDim.new(0,10)
            local rs = Instance.new("UIStroke",r)
            rs.Color = T.RowBorder; rs.Thickness = 1; rs.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            local rp = Instance.new("UIPadding",r)
            rp.PaddingLeft = UDim.new(0,14); rp.PaddingRight = UDim.new(0,14)
            r.MouseEnter:Connect(function() tw(r,{BackgroundColor3=T.RowHover},0.1) end)
            r.MouseLeave:Connect(function() tw(r,{BackgroundColor3=T.Row},0.1) end)
            return r
        end

        local function lbl(parent, text, font, size, col, xa)
            local l = Instance.new("TextLabel",parent)
            l.BackgroundTransparency = 1; l.Font = font or Enum.Font.GothamMedium
            l.TextSize = size or 13; l.TextColor3 = col or T.Text
            l.TextXAlignment = xa or Enum.TextXAlignment.Left
            l.Text = text or ""; return l
        end

        -- ╔════════════════════════════════════════════════════╗
        -- ║                   Tab API                         ║
        -- ╚════════════════════════════════════════════════════╝
        local TabAPI = {}

        -- Section ─────────────────────────────────────────────
        function TabAPI:CreateSection(text)
            local sf = Instance.new("Frame",Panel)
            sf.Size = UDim2.new(1,0,0,30); sf.BackgroundTransparency = 1; sf.LayoutOrder = nextLO()
            local sl = lbl(sf, text:upper(), Enum.Font.GothamBold, 10, T.SectionLbl)
            sl.Size = UDim2.new(1,0,1,0)
            local sp = Instance.new("UIPadding",sf)
            sp.PaddingLeft = UDim.new(0,4); sp.PaddingTop = UDim.new(0,8)
        end

        -- Label ───────────────────────────────────────────────
        function TabAPI:CreateLabel(text)
            local lf = Instance.new("Frame",Panel)
            lf.Size = UDim2.new(1,0,0,34); lf.BackgroundColor3 = rgb(38,38,44)
            lf.BorderSizePixel = 0; lf.LayoutOrder = nextLO()
            Instance.new("UICorner",lf).CornerRadius = UDim.new(0,8)
            local ls = Instance.new("UIStroke",lf); ls.Color = T.RowBorder; ls.Thickness = 1
            ls.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            local lp = Instance.new("UIPadding",lf); lp.PaddingLeft = UDim.new(0,12)
            local ll = lbl(lf, text, Enum.Font.Gotham, 12, T.TextSec)
            ll.Size = UDim2.new(1,0,1,0)
        end

        -- Toggle ──────────────────────────────────────────────
        function TabAPI:CreateToggle(cfg)
            local state = cfg.Default or false
            local r = makeRow(cfg.Desc and 56 or 44)

            local nl = lbl(r, cfg.Name); nl.Size = UDim2.new(1,-56,0,20)
            nl.Position = cfg.Desc and UDim2.new(0,0,0,8) or UDim2.new(0,0,0.5,-10)

            if cfg.Desc then
                local dl = lbl(r, cfg.Desc, Enum.Font.Gotham, 11, T.TextSec)
                dl.Size = UDim2.new(1,-56,0,14); dl.Position = UDim2.new(0,0,1,-20)
            end

            local track = Instance.new("Frame",r)
            track.Size = UDim2.new(0,40,0,24); track.Position = UDim2.new(1,-40,0.5,-12)
            track.BackgroundColor3 = state and T.ToggleOn or T.ToggleOff; track.BorderSizePixel = 0
            Instance.new("UICorner",track).CornerRadius = UDim.new(1,0)

            local knob = Instance.new("Frame",track)
            knob.Size = UDim2.new(0,20,0,20)
            knob.Position = state and UDim2.new(0,18,0,2) or UDim2.new(0,2,0,2)
            knob.BackgroundColor3 = T.Knob; knob.BorderSizePixel = 0
            Instance.new("UICorner",knob).CornerRadius = UDim.new(1,0)
            local ks = Instance.new("UIStroke",knob); ks.Color = rgb(0,0,0); ks.Thickness = 0.5; ks.Transparency = 0.65

            local cb = Instance.new("TextButton",r)
            cb.Size = UDim2.new(1,0,1,0); cb.BackgroundTransparency = 1; cb.Text = ""; cb.ZIndex = 2
            cb.MouseButton1Click:Connect(function()
                state = not state
                tw(track, {BackgroundColor3 = state and T.ToggleOn or T.ToggleOff}, 0.18)
                spring(knob, {Position = state and UDim2.new(0,18,0,2) or UDim2.new(0,2,0,2)}, 0.28)
                if cfg.Callback then cfg.Callback(state) end
            end)

            local API = {}
            function API:Set(v)
                state = v
                tw(track, {BackgroundColor3 = state and T.ToggleOn or T.ToggleOff}, 0.18)
                spring(knob, {Position = state and UDim2.new(0,18,0,2) or UDim2.new(0,2,0,2)}, 0.28)
                if cfg.Callback then cfg.Callback(state) end
            end
            function API:Get() return state end
            return API
        end

        -- Slider ──────────────────────────────────────────────
        function TabAPI:CreateSlider(cfg)
            local mn = cfg.Min or 0; local mx = cfg.Max or 100
            local inc = cfg.Increment or 1; local val = cfg.Default or mn
            local r = makeRow(54)

            local nl = lbl(r, cfg.Name); nl.Size = UDim2.new(0.6,0,0,20); nl.Position = UDim2.new(0,0,0,7)
            local vl = lbl(r, tostring(val), Enum.Font.Gotham, 12, T.TextSec, Enum.TextXAlignment.Right)
            vl.Size = UDim2.new(0.4,0,0,20); vl.Position = UDim2.new(0.6,0,0,7)

            local trackBg = Instance.new("Frame",r)
            trackBg.Size = UDim2.new(1,0,0,4); trackBg.Position = UDim2.new(0,0,1,-13)
            trackBg.BackgroundColor3 = T.SliderTrack; trackBg.BorderSizePixel = 0
            Instance.new("UICorner",trackBg).CornerRadius = UDim.new(1,0)

            local pct = (val-mn)/(mx-mn)
            local fill = Instance.new("Frame",trackBg)
            fill.Size = UDim2.new(pct,0,1,0); fill.BackgroundColor3 = T.SliderFill; fill.BorderSizePixel = 0
            Instance.new("UICorner",fill).CornerRadius = UDim.new(1,0)

            local knobBtn = Instance.new("TextButton",trackBg)
            knobBtn.Size = UDim2.new(0,16,0,16); knobBtn.Position = UDim2.new(pct,-8,0.5,-8)
            knobBtn.BackgroundColor3 = T.Knob; knobBtn.Text = ""; knobBtn.AutoButtonColor = false
            knobBtn.BorderSizePixel = 0; knobBtn.ZIndex = 3
            Instance.new("UICorner",knobBtn).CornerRadius = UDim.new(1,0)
            local ks = Instance.new("UIStroke",knobBtn); ks.Color=rgb(0,0,0); ks.Thickness=0.5; ks.Transparency=0.65

            knobBtn.MouseEnter:Connect(function()
                spring(knobBtn,{Size=UDim2.new(0,18,0,18),Position=UDim2.new(pct,-9,0.5,-9)},0.2)
            end)
            knobBtn.MouseLeave:Connect(function()
                spring(knobBtn,{Size=UDim2.new(0,16,0,16),Position=UDim2.new(pct,-8,0.5,-8)},0.2)
            end)

            local dragging = false
            knobBtn.MouseButton1Down:Connect(function() dragging = true end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)

            local function update(pos)
                local ap = trackBg.AbsolutePosition; local as = trackBg.AbsoluteSize
                local rel = math.clamp((pos.X - ap.X)/as.X, 0, 1)
                val = math.round((mn+(mx-mn)*rel)/inc)*inc
                val = math.clamp(val, mn, mx)
                pct = (val-mn)/(mx-mn)
                local dv = (inc%1==0) and tostring(math.round(val)) or string.format("%.2f",val)
                vl.Text = dv
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
                    dragging = true; update(i.Position)
                end
            end)

            local API = {}
            function API:Set(v)
                val = math.clamp(v,mn,mx); pct = (val-mn)/(mx-mn)
                vl.Text = tostring(val)
                tw(fill,{Size=UDim2.new(pct,0,1,0)},0.1)
                tw(knobBtn,{Position=UDim2.new(pct,-8,0.5,-8)},0.1)
                if cfg.Callback then cfg.Callback(val) end
            end
            function API:Get() return val end
            return API
        end

        -- Button ──────────────────────────────────────────────
        function TabAPI:CreateButton(cfg)
            local r = makeRow(cfg.Desc and 56 or 44)

            local nl = lbl(r, cfg.Name); nl.Size = UDim2.new(1,-86,0,20)
            nl.Position = cfg.Desc and UDim2.new(0,0,0,8) or UDim2.new(0,0,0.5,-10)

            if cfg.Desc then
                local dl = lbl(r, cfg.Desc, Enum.Font.Gotham, 11, T.TextSec)
                dl.Size = UDim2.new(1,-86,0,14); dl.Position = UDim2.new(0,0,1,-20)
            end

            local style = cfg.Style or "default"
            local bc = (style=="accent") and T.Accent or (style=="danger") and T.BtnDanger or T.Btn
            local bch = (style=="accent") and T.AccentHover or (style=="danger") and T.BtnDangerHov or T.BtnHover
            local btc = (style=="danger") and T.Red or T.Text

            local btn = Instance.new("TextButton",r)
            btn.Size = UDim2.new(0,72,0,28); btn.Position = UDim2.new(1,-72,0.5,-14)
            btn.BackgroundColor3 = bc; btn.Font = Enum.Font.GothamMedium; btn.TextSize = 12
            btn.TextColor3 = btc; btn.Text = cfg.Label or "Run"
            btn.AutoButtonColor = false; btn.BorderSizePixel = 0; btn.ZIndex = 2
            Instance.new("UICorner",btn).CornerRadius = UDim.new(0,8)
            local bs = Instance.new("UIStroke",btn); bs.Color = T.RowBorder; bs.Thickness = 1
            bs.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            btn.MouseEnter:Connect(function() tw(btn,{BackgroundColor3=bch},0.1) end)
            btn.MouseLeave:Connect(function() tw(btn,{BackgroundColor3=bc},0.1) end)
            btn.MouseButton1Down:Connect(function()
                spring(btn,{Size=UDim2.new(0,68,0,26),Position=UDim2.new(1,-70,0.5,-13)},0.12)
            end)
            btn.MouseButton1Up:Connect(function()
                spring(btn,{Size=UDim2.new(0,72,0,28),Position=UDim2.new(1,-72,0.5,-14)},0.18)
            end)
            btn.MouseButton1Click:Connect(function()
                if cfg.Callback then cfg.Callback() end
            end)
        end

        -- Dropdown ────────────────────────────────────────────
        function TabAPI:CreateDropdown(cfg)
            local opts = cfg.Options or {}
            local sel  = cfg.Default or (opts[1] or "")
            local open = false
            local r = makeRow(44); r.ClipsDescendants = false

            local nl = lbl(r, cfg.Name); nl.Size = UDim2.new(0.5,0,1,0)

            local dropBtn = Instance.new("TextButton",r)
            dropBtn.Size = UDim2.new(0,128,0,28); dropBtn.Position = UDim2.new(1,-128,0.5,-14)
            dropBtn.BackgroundColor3 = T.Select; dropBtn.Font = Enum.Font.GothamMedium; dropBtn.TextSize = 12
            dropBtn.TextColor3 = T.Text; dropBtn.Text = sel.."  ▾"
            dropBtn.AutoButtonColor = false; dropBtn.BorderSizePixel = 0; dropBtn.ZIndex = 5
            Instance.new("UICorner",dropBtn).CornerRadius = UDim.new(0,8)
            local ds = Instance.new("UIStroke",dropBtn); ds.Color = T.RowBorder; ds.Thickness = 1
            ds.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            local dList = Instance.new("Frame",r)
            dList.Size = UDim2.new(0,128,0,0); dList.Position = UDim2.new(1,-128,1,4)
            dList.BackgroundColor3 = T.Select; dList.BorderSizePixel = 0
            dList.ZIndex = 10; dList.ClipsDescendants = true; dList.Visible = false
            Instance.new("UICorner",dList).CornerRadius = UDim.new(0,8)
            local dls = Instance.new("UIStroke",dList); dls.Color = T.RowBorder; dls.Thickness = 1
            dls.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            local dll = Instance.new("UIListLayout",dList); dll.SortOrder = Enum.SortOrder.LayoutOrder

            for i,opt in ipairs(opts) do
                local ob = Instance.new("TextButton",dList)
                ob.Size = UDim2.new(1,0,0,30); ob.BackgroundTransparency = 1
                ob.Font = Enum.Font.Gotham; ob.TextSize = 12; ob.TextColor3 = T.TextSec
                ob.Text = opt; ob.AutoButtonColor = false; ob.ZIndex = 11; ob.LayoutOrder = i
                ob.MouseEnter:Connect(function()
                    tw(ob,{BackgroundTransparency=0, BackgroundColor3=T.RowHover},0.1)
                    ob.TextColor3 = T.Text
                end)
                ob.MouseLeave:Connect(function()
                    tw(ob,{BackgroundTransparency=1},0.1); ob.TextColor3 = T.TextSec
                end)
                ob.MouseButton1Click:Connect(function()
                    sel = opt; dropBtn.Text = sel.."  ▾"
                    open = false
                    tw(dList,{Size=UDim2.new(0,128,0,0)},0.18)
                    task.delay(0.2, function() dList.Visible = false end)
                    if cfg.Callback then cfg.Callback(sel) end
                end)
            end

            local function toggle()
                open = not open
                if open then
                    dList.Visible = true
                    spring(dList,{Size=UDim2.new(0,128,0,#opts*30)},0.22)
                else
                    tw(dList,{Size=UDim2.new(0,128,0,0)},0.18)
                    task.delay(0.2,function() dList.Visible=false end)
                end
            end
            dropBtn.MouseButton1Click:Connect(toggle)

            UserInputService.InputBegan:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 and open then
                    local p = i.Position; local ap = dList.AbsolutePosition; local as = dList.AbsoluteSize
                    if p.X<ap.X or p.X>ap.X+as.X or p.Y<ap.Y or p.Y>ap.Y+as.Y then
                        open = false
                        tw(dList,{Size=UDim2.new(0,128,0,0)},0.18)
                        task.delay(0.2,function() dList.Visible=false end)
                    end
                end
            end)

            local API = {}
            function API:Set(v) sel=v; dropBtn.Text=v.."  ▾"; if cfg.Callback then cfg.Callback(v) end end
            function API:Get() return sel end
            return API
        end

        -- PillGroup ───────────────────────────────────────────
        function TabAPI:CreatePillGroup(cfg)
            local opts = cfg.Options or {}
            local sel  = cfg.Default or (opts[1] or "")
            local r = makeRow(44)

            local nl = lbl(r, cfg.Name); nl.Size = UDim2.new(0.4,0,1,0)

            local pf = Instance.new("Frame",r)
            pf.Size = UDim2.new(0,#opts*60+4,0,30); pf.Position = UDim2.new(1,-#opts*60-4,0.5,-15)
            pf.BackgroundTransparency = 1; pf.BorderSizePixel = 0
            local pl = Instance.new("UIListLayout",pf)
            pl.FillDirection = Enum.FillDirection.Horizontal
            pl.Padding = UDim.new(0,4); pl.VerticalAlignment = Enum.VerticalAlignment.Center

            local pillBtns = {}
            for _,opt in ipairs(opts) do
                local pb = Instance.new("TextButton",pf)
                pb.Size = UDim2.new(0,56,0,28)
                pb.BackgroundColor3 = (opt==sel) and T.PillActive or T.Pill
                pb.Font = Enum.Font.GothamMedium; pb.TextSize = 12
                pb.TextColor3 = (opt==sel) and rgb(255,255,255) or T.TextSec
                pb.Text = opt; pb.AutoButtonColor = false; pb.BorderSizePixel = 0; pb.ZIndex = 2
                Instance.new("UICorner",pb).CornerRadius = UDim.new(0,7)
                pillBtns[opt] = pb

                pb.MouseButton1Click:Connect(function()
                    sel = opt
                    for k,b in pairs(pillBtns) do
                        tw(b,{BackgroundColor3=(k==opt) and T.PillActive or T.Pill},0.15)
                        b.TextColor3 = (k==opt) and rgb(255,255,255) or T.TextSec
                    end
                    if cfg.Callback then cfg.Callback(sel) end
                end)
            end

            local API = {}
            function API:Get() return sel end
            return API
        end

        return TabAPI
    end

    return WinAPI
end

return MacOSLib
