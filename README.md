# MacOSLib 🍎
> A macOS-style Roblox UI library. Smooth animations, frosted glass aesthetic, traffic lights — built for executors.

## Installation
```lua
local MacOS = loadstring(game:HttpGet("https://raw.githubusercontent.com/Shindo957-Official/MacUI/refs/heads/main/MacOSLib.lua"))()
```

## Quick Start
```lua
local Win = MacOS:CreateWindow({ Title = "My Script", Subtitle = "by Me", ToggleKey = Enum.KeyCode.RightControl })
local Tab = Win:CreateTab("Main", "🏠")
Tab:CreateSection("Movement")
Tab:CreateToggle({ Name = "Fly", Default = false, Callback = function(v) end })
Tab:CreateSlider({ Name = "Speed", Min = 5, Max = 100, Increment = 1, Default = 20, Callback = function(v) end })
Tab:CreateButton({ Name = "Do Thing", Label = "Run", Style = "default", Callback = function() end })
Tab:CreateDropdown({ Name = "Mode", Options = {"A","B","C"}, Default = "A", Callback = function(v) end })
Tab:CreatePillGroup({ Name = "Angle", Options = {"90°","45°"}, Default = "90°", Callback = function(v) end })
Tab:CreateLabel("Info text")
Win:Notify({ Icon = "🎉", Title = "Loaded", Body = "Ready!", Duration = 3 })
```

## Window API
| Method | Description |
|--------|-------------|
| `Win:CreateTab(name, icon)` | Sidebar tab |
| `Win:Notify({Icon,Title,Body,Duration})` | Toast |
| `Win:SetStatus(text)` | Status bar |
| `Win:Toggle()` | Show/hide |
| `Win:Destroy()` | Close |

## Tab API
| Method | Description |
|--------|-------------|
| `Tab:CreateSection(text)` | Section header |
| `Tab:CreateLabel(text)` | Info row |
| `Tab:CreateToggle({...})` | Toggle (returns :Set/:Get) |
| `Tab:CreateSlider({...})` | Slider (returns :Set/:Get) |
| `Tab:CreateButton({...})` | Button |
| `Tab:CreateDropdown({...})` | Dropdown (returns :Set/:Get) |
| `Tab:CreatePillGroup({...})` | Pills (returns :Get) |

## Repo Structure
```
YOUR_REPO/
├── MacOSLib.lua          ← UI library
├── potatoware_macos.lua  ← Example (Potatoware)
└── README.md
```

## Features
- 🍎 Traffic light buttons, draggable window
- 🪟 Spring open/close animation
- 🔔 Slide-in toast notifications
- 🎛 Spring-animated toggles & sliders
- 💊 Pill groups, dropdowns, buttons
- 📋 Multi-tab sidebar, scrollable panels
- ⌨ Keybind to toggle visibility

Built by **Shindo / Potatoware**
