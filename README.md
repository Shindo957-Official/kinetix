# Kinetix UI Library 🎨
> A multi-theme Roblox UI library. Switch macOS · Windows 7 · Linux live at runtime.

## Load
```lua
local Kinetix = loadstring(game:HttpGet("https://raw.githubusercontent.com/Shindo957-Official/kinetix/main/KinetixLib.lua"))()
```

## Quick Start
```lua
local Win = Kinetix:CreateWindow({
    Title="My Script", Subtitle="by Me",
    Theme="macOS",       -- "macOS" | "Windows7" | "Linux"
    LinuxStyle="Hyprland", -- "GNOME" | "KDE" | "Hyprland"
    ToggleKey=Enum.KeyCode.RightControl,
})
local Tab = Win:CreateTab("Main","🏠")
Tab:CreateSection("Movement")
Tab:CreateToggle({ Name="Fly", Default=false, Callback=function(v) end })
Tab:CreateSlider({ Name="Speed", Min=5, Max=100, Increment=1, Default=20, Callback=function(v) end })
Tab:CreateButton({ Name="Action", Label="Run", Style="default", Callback=function() end })
Tab:CreateDropdown({ Name="Mode", Options={"A","B"}, Default="A", Callback=function(v) end })
Tab:CreatePillGroup({ Name="Angle", Options={"90°","45°"}, Default="90°", Callback=function(v) end })
Tab:CreateLabel("Info text")
Win:Notify({ Icon="🎉", Title="Loaded", Body="Ready!", Duration=3 })
```
> A **Settings tab is always auto-created** at the end with a live theme switcher dropdown.

## Themes
| Theme | Style | Look |
|-------|-------|------|
| `macOS` | — | Dark charcoal · traffic lights · Apple blue |
| `Windows7` | — | Aero glass · blue gradient titlebar · Win7 buttons |
| `Linux` | `GNOME` | Yaru Dark · flat · Ubuntu orange |
| `Linux` | `KDE` | Breeze Dark · steel · cyan |
| `Linux` | `Hyprland` | Catppuccin Mocha · deep purple · mauve |

Switch live: `Win:SetTheme("Windows7")` or use the Settings tab.

## Window API
| Method | Description |
|--------|-------------|
| `Win:CreateTab(name, icon)` | Add sidebar tab |
| `Win:Notify({Icon,Title,Body,Duration})` | Toast |
| `Win:SetStatus(text)` | Status bar |
| `Win:SetTheme(theme, linuxStyle?)` | Live theme switch |
| `Win:GetTheme()` | Returns theme, linuxStyle |
| `Win:Toggle()` | Show/hide |
| `Win:Destroy()` | Close |

## Tab API
| Method | Returns | Description |
|--------|---------|-------------|
| `Tab:CreateSection(text)` | — | Section header |
| `Tab:CreateLabel(text)` | — | Info row |
| `Tab:CreateToggle({...})` | Set/Get | Animated toggle |
| `Tab:CreateSlider({...})` | Set/Get | Draggable slider |
| `Tab:CreateButton({...})` | — | Button (Style: default/accent/danger) |
| `Tab:CreateDropdown({...})` | Set/Get | Dropdown |
| `Tab:CreatePillGroup({...})` | Get | Pill selector |

## Repo
```
kinetix/
├── KinetixLib.lua          ← UI library
├── potatoware_kinetix.lua  ← Example script
└── README.md
```

## Features
- 🎨 5 distinct themes, all colors animate on switch
- 🍎 macOS traffic lights / Win7 Aero / GNOME + KDE + Hyprland decorations
- 🔄 Live theme switching — no reload
- 🪟 Spring window open/close
- 🔔 Toast notifications
- ⚙️ Built-in Settings tab always included

Built by **Shindo / Potatoware**
