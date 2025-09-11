PROFILE_WORK_DOMAIN := ngrok
PROFILE_HOME_DOMAIN := morethq

switch-profile:
	@echo $(log) "changing to $(PROFILE_NEXT) system profile"
	@if [ "${PROFILE_NEXT}" = "work" ]; then \
		echo $(log) "updating gitconfig"; \
		perl -pi -e 's/$(PROFILE_HOME_DOMAIN)/$(PROFILE_WORK_DOMAIN)/g' ~/.gitconfig; \
		echo $(log) "updating ssh profile"; \
		sudo cp ~/.ssh/id_$(PROFILE_WORK_DOMAIN) ~/.ssh/id_ed25519; \
		sudo cp ~/.ssh/id_$(PROFILE_WORK_DOMAIN).pub ~/.ssh/id_ed25519.pub; \
		ssh-add --apple-use-keychain ~/.ssh/id_$(PROFILE_WORK_DOMAIN); \
	else \
		echo $(log) "updating gitconfig"; \
		perl -pi -e 's/$(PROFILE_WORK_DOMAIN)/$(PROFILE_HOME_DOMAIN)/g' ~/.gitconfig; \
		echo $(log) "updating ssh profile"; \
		sudo cp ~/.ssh/id_$(PROFILE_HOME_DOMAIN) ~/.ssh/id_ed25519; \
		sudo cp ~/.ssh/id_$(PROFILE_HOME_DOMAIN).pub ~/.ssh/id_ed25519.pub; \
		ssh-add ~/.ssh/id_$(PROFILE_HOME_DOMAIN); \
	fi

.PHONY: work
work:
work: PROFILE_NEXT=work
work: switch-profile
work: ## profile: work

.PHONY: home
home: PROFILE_NEXT=home
home: switch-profile
home: ## profile: home
