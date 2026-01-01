# yes, you're very smart - shut up.
mkd() {
    mkdir -p "$@"
}

tre() {
    tree -aC -I '.git' "$@" | less -FRNX
}

k() {
    kubectl "$@"
}

v() {
    vim "$@"
}

z() {
    zellij "$@"
}
