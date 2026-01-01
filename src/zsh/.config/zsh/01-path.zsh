# `register_path()` accepts a single, non-duplicating, path to register within 
# the current session's `$PATH`.
register_path() {
    [ -d "${1}" ] && [[ ":{PATH}:" != *":${1}:"* ]] && PATH="${1}:${PATH}"
}

# lang: rust
register_path "${HOME}/.cargo/bin"

# lang: go
register_path "${GOPATH}/bin"
register_path "${GOROOT}/bin"

# runtime: podman
register_path "${HOME}/.rd/bin"

# tool: bun
register_path "${HOME}/.cargo/bin"
