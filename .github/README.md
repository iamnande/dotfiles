<p align="center">
  <a href="https://github.com/iamnande">
    <img src="https://avatars.githubusercontent.com/u/7806510?v=4&s=125" 
width="125px" alt="iamnande"/>
  </a>
</p>

<h3 align="center">iamnande - dotfiles</h3>

<br />

<p align="center">
  <b>dotfiles</b> is <i>the</i> ultimate environment setup, at least for me. simple but 
effective.
</p>

## ✨ Features

- **Shell Management:** Installs and configures a stellar `zsh` configuration.
- **Common Software:** Common necessities, building blocks if you will, are 
installed for a quick jumping off point.
- **Non-Intrusive:** All the configurations are symlinked into your home
directory rather than managing files in different locations.

## ⚡️ QuickStart

```shell
$ make install
```

## ⚙️ Add-Ons

The `Makefile` actually has a bit of a helper screen baked into it. There are a
number of additional helpful targets included, but not required, that do
everything from install an opinionated `brew` setup, install a kick-ass `zsh`
shell and configuration, and (obviously) a fresh installation of `go`.

To check out the help screen, either run a bare `make` or you can run 
`make help`.

```shell
$ make help
help                 help: display available targets
clean                core: clean home of installed configurations
install              core: install configurations into the home directory
install-brew         env: install brew and core software
install-zsh          env: install preferred shell
install-vimfiles     env: install vim setup
install-go           env: install go
```

Any of the individual items can be called as normal `make` targets.

```shell
$ make install-go
2021-11-06 21:21:57 -0700 [dotfiles] installing go 1.17.3
```

_note: each of the targets are written to be idempotent_

## 💡 Contributing

Did you find a bug? 

Have you solved similar problems in a different way? 

Feel free to toss up a draft pull-request. I am happy to learn or update 
what's here 🙂.