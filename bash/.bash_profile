#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc
export $(gnome-keyring-daemon --start --components=secrets,pkcs11 2>/dev/null)
