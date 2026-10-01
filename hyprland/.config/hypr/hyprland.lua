-- ============================================================
--  hyprland.lua — michka
--  Hyprland 0.56+ (format Lua, remplace hyprland.conf)
-- ============================================================

-- ---------- Détection de la machine ----------
local function read_hostname()
    local f = io.open("/etc/hostname", "r")
    if not f then return "" end
    local h = f:read("*l") or ""
    f:close()
    return h
end

local HOST = read_hostname()

-- ---------- Couleurs (générées par ~/dotfiles/theme/apply.sh) ----------
-- dofile plutôt que require : pas de cache, `hyprctl reload` relit bien le fichier
local c = dofile(os.getenv("HOME") .. "/.config/hypr/colors.lua")

-- ---------- Moniteurs ----------
if HOST == "michkasarchlinux" then
    -- Fixe principal : vérifier les positions avec `hyprctl monitors`
    hl.monitor({ output = "DP-2",     mode = "1920x1080@144", position = "0x0",    scale = "1" })
    hl.monitor({ output = "HDMI-A-2", mode = "1920x1080@144", position = "1920x0", scale = "1" })
else
    -- Portable (eDP-1) et autres machines : réglage automatique
    hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
end

-- ---------- Programmes ----------
local terminal    = "kitty"
local fileManager = "nemo"
local menu        = "wofi --show drun"
local scripts     = "~/.config/hypr/script/"

-- ---------- Variables d'environnement ----------
hl.env("BROWSER", "firefox")

-- ---------- Autostart (ex-exec-once) ----------
hl.on("hyprland.start", function()
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets,pkcs11")
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd([[sleep 1 && hyprctl hyprpaper wallpaper ",/home/michka/perso/wallpaper/montagne_geo.png"]])
    hl.exec_cmd("dunst")      -- notifications
    hl.exec_cmd("nextcloud")
    hl.exec_cmd("hypridle")   -- mise en veille automatique
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)

-- Ignorer les demandes de maximisation des applis (kitty notamment)
hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

-- ---------- Apparence ----------
hl.config({
    general = {
        gaps_in     = 2,
        gaps_out    = 0,
        border_size = 1,
        col = {
            active_border   = "rgba(" .. c.accent .. "ff)",
            inactive_border = "rgba(" .. c.border .. "ff)",
        },
        layout = "dwindle", -- dwindle ou master
    },

    decoration = {
        rounding = 8,
        blur = {
            enabled = false,
            size    = 3,
            passes  = 1,
        },
    },

    animations = {
        enabled = true,
    },

    xwayland = {
        force_zero_scaling = true,
    },

    input = {
        kb_layout = "fr",
    },
})

hl.animation({ leaf = "windows",    enabled = true,  speed = 3, bezier = "default", style = "slide" })
hl.animation({ leaf = "fade",       enabled = false })
hl.animation({ leaf = "workspaces", enabled = true,  speed = 5, bezier = "default" })

-- ---------- Raccourcis ----------
local mainMod = "SUPER"
local function key(k) return mainMod .. " + " .. k end

hl.bind(key("Q"),         hl.dsp.exec_cmd(terminal))
hl.bind(key("C"),         hl.dsp.window.close())
hl.bind(key("SHIFT + P"), hl.dsp.exec_cmd(scripts .. "poweroff.sh"))
hl.bind(key("SHIFT + O"), hl.dsp.exec_cmd(scripts .. "reboot.sh"))
hl.bind(key("SHIFT + M"), hl.dsp.exit())
hl.bind(key("E"),         hl.dsp.exec_cmd(fileManager))
hl.bind(key("V"),         hl.dsp.window.float({ action = "toggle" }))
hl.bind(key("D"),         hl.dsp.exec_cmd(menu))
hl.bind(key("R"),         hl.dsp.exec_cmd("firefox"))
hl.bind(key("F"),         hl.dsp.window.fullscreen())

-- Déplacés pour supprimer des conflits (voir notes) :
hl.bind(key("Escape"),    hl.dsp.exec_cmd("hyprlock"))                       -- était SUPER+SHIFT+L
hl.bind(key("P"),         hl.dsp.exec_cmd(scripts .. "switching-monitor.sh")) -- était SUPER+J

-- Workspaces : touches 1 à 0 du clavier AZERTY (keycodes 10 à 19)
for i = 1, 10 do
    local code = "code:" .. (9 + i)
    hl.bind(key(code),             hl.dsp.focus({ workspace = i }))
    hl.bind(key("SHIFT + " .. code), hl.dsp.window.move({ workspace = i }))
end
hl.bind(key("mouse_down"), hl.dsp.focus({ workspace = "e+1" }))
hl.bind(key("mouse_up"),   hl.dsp.focus({ workspace = "e-1" }))

-- Navigation, redimensionnement et déplacement (flèches + h/j/k/l)
local dirs = {
    { "left",  "H", "left",  -50,   0 },
    { "right", "L", "right",  50,   0 },
    { "up",    "K", "up",      0, -50 },
    { "down",  "J", "down",    0,  50 },
}
for _, d in ipairs(dirs) do
    local arrow, vim, dir, dx, dy = d[1], d[2], d[3], d[4], d[5]
    for _, k in ipairs({ arrow, vim }) do
        hl.bind(key(k),             hl.dsp.focus({ direction = dir }))
        hl.bind(key("CTRL + " .. k),  hl.dsp.window.resize({ x = dx, y = dy, relative = true }))
        hl.bind(key("SHIFT + " .. k), hl.dsp.window.move({ direction = dir }))
    end
end

-- Multimédia (ex-bindel / bindl)
local rep = { locked = true, repeating = true }
local lck = { locked = true }
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), rep)
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), rep)
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), lck)
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl s 10%+"), rep)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), rep)
hl.bind("XF86AudioPlay",         hl.dsp.exec_cmd("playerctl play-pause"), lck)
hl.bind("XF86AudioNext",         hl.dsp.exec_cmd("playerctl next"), lck)
hl.bind("XF86AudioPrev",         hl.dsp.exec_cmd("playerctl previous"), lck)

-- Capture d'écran
hl.bind(key("SHIFT + S"), hl.dsp.exec_cmd(
    [[grim -g "$(slurp)" - | tee ~/screenshots/screenshot-$(date +%s).png | wl-copy]]))

-- Presse-papier
hl.bind(key("SHIFT + V"), hl.dsp.exec_cmd(
    [[cliphist list | wofi --dmenu | cliphist decode | wl-copy]]))

-- ---------- Règles de fenêtres ----------
require("rules")
