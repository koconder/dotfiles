#
# Load dotfiles pre-ENV
#
for file in ~/.{path,bash_prompt,aliases,functions,exports}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

#
# Mac Specific
#

if [[ $OSTYPE == 'darwin'* ]]; then
	# gpg
	export GPG_TTY=$(tty)

	# pyenv (python)
	export PYENV_ROOT="$(pyenv root)"
	export PATH="$PYENV_ROOT/shims:$PATH"
	eval "$(pyenv init - --no-rehash)"

	# nodenv (nodejs)
	export NODENV_ROOT="$(nodenv root)"
	export PATH="$NODENV_ROOT/shims:$PATH"
	eval "$(nodenv init -)"

	# rbenv (ruby)
	eval "$(rbenv init - zsh)"

	# java (jenv)
	eval "$(jenv init -)"

	# Shell History
	if [ -d /Applications/ShellHistory.app ]; then
		# adding shhist to PATH, so we can use it from Terminal
		PATH="${PATH}:/Applications/ShellHistory.app/Contents/Helpers"
		# creating an unique session id for each terminal session
		__shhist_session="${RANDOM}"
		# prompt function to record the history
		__shhist_prompt() {
		    local __exit_code="${?:-1}"
		    \history -D -t "%s" -1 | sudo --preserve-env --user ${SUDO_USER:-${LOGNAME}} shhist insert --session ${TERM_SESSION_ID:-${__shhist_session}} --username ${LOGNAME} --hostname $(hostname) --exit-code ${__exit_code} --shell zsh
		    return ${__exit_code}
		}
		# integrating prompt function in prompt
		precmd_functions=(__shhist_prompt $precmd_functions)
	fi
fi

#
# Load dotfiles post-ENV
#
for file in ~/.{extra,extra/user.sh}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

#
# Unix and Generic Configs
