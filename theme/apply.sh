#!/usr/bin/env bash
# Génère les fichiers de couleurs à partir de palette.sh
# Usage : ./apply.sh [--dry-run]
#
# Chaque template  theme/templates/<paquet>/<chemin>.tmpl
# est rendu vers   ~/dotfiles/<paquet>/<chemin>
#
# Variables disponibles dans les templates, pour chaque couleur de palette.sh :
#   {{accent}}    → ff0000
#   {{accent_r}}  → 255   (idem _g, _b : utile pour ANSI ou rgba() CSS)
set -euo pipefail

THEME_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
DOTFILES="$(dirname "$THEME_DIR")"
TEMPLATES="$THEME_DIR/templates"
DRY_RUN=false
[[ ${1:-} == --dry-run ]] && DRY_RUN=true

# 1. Substitutions construites depuis palette.sh
sed_args=()
while IFS='=' read -r name value; do
  value="${value%%#*}"             # retire le commentaire
  value="${value//[[:space:]]/}"   # retire les espaces
  if [[ ! $value =~ ^[0-9a-fA-F]{6}$ ]]; then
    echo "✗ palette.sh : '$name' a une valeur invalide ('$value')" >&2
    exit 1
  fi
  sed_args+=(
    -e "s/{{${name}}}/${value}/g"
    -e "s/{{${name}_r}}/$((16#${value:0:2}))/g"
    -e "s/{{${name}_g}}/$((16#${value:2:2}))/g"
    -e "s/{{${name}_b}}/$((16#${value:4:2}))/g"
  )
done < <(grep -E '^[a-z_]+=' "$THEME_DIR/palette.sh")

# 2. Rendu des templates
mapfile -t tmpls < <(find "$TEMPLATES" -type f -name '*.tmpl' | sort)
for tmpl in "${tmpls[@]}"; do
  rel="${tmpl#"$TEMPLATES"/}"
  rel="${rel%.tmpl}"
  out="$DOTFILES/$rel"

  if $DRY_RUN; then
    echo "→ $rel"
    continue
  fi

  mkdir -p "$(dirname "$out")"
  sed "${sed_args[@]}" "$tmpl" > "$out"

  if unknown=$(grep -o '{{[a-z_]*}}' "$out" | sort -u | tr '\n' ' ') && [[ -n $unknown ]]; then
    echo "⚠ $rel : variable(s) inconnue(s) : $unknown" >&2
  else
    echo "✓ $rel"
  fi
done

$DRY_RUN && exit 0

# 3. Rechargement à chaud (ignoré si l'app ne tourne pas)
echo "Rechargement…"
hyprctl reload >/dev/null 2>&1 || true
pkill -SIGUSR2 waybar 2>/dev/null || true   # recharge config + CSS
pkill -SIGUSR1 kitty  2>/dev/null || true   # recharge kitty.conf
pkill dunst           2>/dev/null || true   # relancé par D-Bus à la prochaine notif
echo "Firefox et SDDM : relance nécessaire. Hyprlock : pris en compte au prochain verrouillage."
