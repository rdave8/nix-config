local hyper = {"cmd", "ctrl", "option", "shift"}

-- b -> browser
hs.hotkey.bind(hyper, "b", function()
    hs.application.launchOrFocus("Brave Browser")
end)

-- t -> terminal
hs.hotkey.bind(hyper, "t", function()
    hs.application.launchOrFocus("Rex")
end)

-- c -> communications
hs.hotkey.bind(hyper, "c", function()
    hs.application.launchOrFocus("Discord")
end)

-- s -> spotify
hs.hotkey.bind(hyper, "s", function()
    hs.application.launchOrFocus("Spotify")
end)

-- e -> editor
hs.hotkey.bind(hyper, "e", function()
    hs.application.launchOrFocus("Visual Studio Code")
end)

-- f -> finder
hs.hotkey.bind(hyper, "f", function()
    hs.application.launchOrFocus("Finder")
end)

-- w -> writing
hs.hotkey.bind(hyper, "w", function()
    hs.application.launchOrFocus("Obsidian")
end)
