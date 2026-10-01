# ~/dotfiles/theme/palette.sh
# ─────────────────────────────────────────────────────────────
#  SOURCE UNIQUE DES COULEURS : hex sur 6 caractères, SANS '#'
#  Nommer par RÔLE, pas par teinte ("accent", pas "red").
#  Après modification :  ~/dotfiles/theme/apply.sh
# ─────────────────────────────────────────────────────────────

# Neutres
bg=000000            # fond principal
surface=1a1a1a       # fonds secondaires (menus Vim…)
border=333333        # bordures inactives, séparateurs
muted=5c5c5c         # texte très discret (versions Starship, numéros de ligne Vim)
fg_dim=bfbfbf        # texte secondaire (entrées Wofi, chaînes Vim…)
fg=ffffff            # texte principal

# Accent (c'est ici qu'on passe du rouge au bleu)
accent=ff0000        # bordure Hyprland, workspace actif, Wofi, Starship, Fastfetch, Vim…
accent_light=ff5555  # variante claire (constantes/nombres Vim)
accent_dark=5f0000   # variante sombre (recherche/sélection Vim)

# Sémantique (reste rouge même si l'accent change)
error=ff0000         # erreurs, root, notifications critiques, mot de passe faux
