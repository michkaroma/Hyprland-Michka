-- ============================================================
--  rules.lua — michka
--  Chargé par hyprland.lua via require("rules")
-- ============================================================

-- Workspaces automatiques au lancement
hl.window_rule({ match = { class = "firefox" }, workspace = "2" })
hl.window_rule({ match = { class = "code" },    workspace = "3" })
hl.window_rule({ match = { class = "discord" }, workspace = "4" })
hl.window_rule({ match = { class = "Beeper" },  workspace = "4" })
