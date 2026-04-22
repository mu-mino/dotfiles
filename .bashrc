# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
# See bash(4) for more details.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm* | rxvt*)
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
  ;;
*)
  ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alFh --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Git Shortcuts
alias gadd='git add .'
gcm() {
  git commit -m"$@"
}
gchm() {
  git commit --amend -m "$@"
}
alias gaddcm='git add . && git commit --amend --no-edit'
alias gpsh='git push'
alias gpl='git pull'
alias gst='git status'
alias gl='git log --oneline --graph --decorate'
alias gcheck='git checkout'
alias glog='git log -1'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ll='ls -alF --color=auto'

# System
alias cls='clear'
alias upd='sudo apt update && sudo apt upgrade -y'
alias exp='nautilus .'
alias src='source'
# =========================
# python3
# =========================
alias py='python3'
alias pip='pip3'

# Virtuelle Envs
alias venv='python3 -m venv .venv'
alias venva='source .venv/bin/activate'
alias venvd='deactivate'

# =========================
# PIPENV
# =========================
alias pe='pipenv'
alias pei='pipenv install'
alias ped='pipenv install --dev'
alias per='pipenv run'
alias pes='pipenv shell'
alias pelu='pipenv lock -u'
alias pecl='pipenv clean'

# Projekte schnell starten
alias penew='pipenv --python3 3.11'
alias petest='pipenv run pytest'
alias perp='pipenv run python'
# =========================
# DJANGO + PIPENV KOMBINIERT (sehr praktisch)
# =========================

alias dj='pipenv run python3 manage.py'
alias djrun='pipenv run python3 manage.py runserver'
alias djmm='pipenv run python3 manage.py makemigrations'
alias djm='pipenv run python3 manage.py migrate'
alias djshell='pipenv run python3 manage.py shell'
alias djtestall='pipenv run pytest -n 8'
alias djsuperuser='python3 manage.py createsuperuser'
alias afuzz='cd /home/muhammed-emin-eser/desk/p/PrintZ && pipenv run python3 /home/muhammed-emin-eser/desk/p/PrintZ/scripts/analyze_fuzz_log.py'
alias fuzz='cd /home/muhammed-emin-eser/desk/p/PrintZ/project && pipenv run python3 manage.py fuzz_endpoints > /home/muhammed-emin-eser/desk/p/PrintZ/project/logs/run_001.log'

djtest() {
  pipenv run pytest project/"$@"
}

shorts() {
  echo "alias $1=$2" >>~/.bashrc
}

# =========================
# Pipenv APPS
# =========================

alias scr='flameshot gui'
alias brc='nvim ~/.bashrc'
alias mic='pactl set-card-profile bluez_card.31_11_72_51_E1_F9 headset-head-unit-msbc'
alias hifi='pactl set-card-profile bluez_card.31_11_72_51_E1_F9 a2dp-sink'

sp() {
  WAV="mic.wav"
  TXT="mic.txt"
  CARD="bluez_card.31_11_72_51_E1_F9"
  SRC="bluez_input.31_11_72_51_E1_F9.0"
  cd /home/muhammed-emin-eser/desk/apps/whisper

  cleanup() {
    echo "Aufnahme gestoppt, schalte zurück auf HiFi..."
    pactl set-card-profile "$CARD" a2dp-sink
    trap - INT
    echo "Starte Whisper (nur TXT-Output)..."
    pipenv run whisper --model small --language de --task transcribe \
      --output_format txt --output_dir . "$WAV"
    echo "Warte auf $TXT..."
    for i in {1..100}; do
      [ -f "$TXT" ] && break
      sleep 0.1
    done
    if [ -f "$TXT" ]; then
      echo "Transkript gefunden."
      xclip -selection clipboard <"$TXT"
      echo "In Zwischenablage kopiert (xclip)."
      rm -f "$WAV" "$TXT"
      echo "Temporäre Dateien entfernt."
    else
      echo "Kein Transkript gefunden."
      rm -f "$WAV"
    fi
    return 0
  }

  trap cleanup INT

  echo "Aufnahme läuft... Strg+C zum Beenden"

  # AUF AIRPODS-MIKRO SCHALTEN
  pactl set-card-profile "$CARD" headset-head-unit-msbc

  # AUFNEHMEN
  ffmpeg -f pulse -i "$SRC" "$WAV"

  cleanup
}
alias sht='sudo systemctl poweroff'
alias printz='code ~/desk/p/PrintZ'
alias cdp='cd project'
alias off='systemctl suspend'
alias off_long='systemctl suspend-then-hibernate'
alias stripelistenprintz='stripe listen --forward-to http://localhost:8000/payments/stripe/webhook/'
alias offbg='xset dpms force off'
alias cdxwatcher='cd ~/desk/apps/Codex_watcher && pipenv run python3 codex_idle_alert_loud.py'
alias cdxstart="$HOME/desk/apps/Codex_watcher/start_cdxwatcher.sh"
alias cdxstop="$HOME/desk/apps/Codex_watcher/stop_cdxwatcher.sh"
alias gcheck='git checkout'
alias gdiff='git diff'
alias gdiff='git diff'
alias c='code .'
alias mark='~/Downloads/marktext-x86_64.AppImage --disable-gpu --no-sandbox'

alias app='pipenv run uvicorn app:app --reload'
alias greset='git reset --soft HEAD~1'
alias sqlb='sqlitebrowser'
alias pymo='cd /home/muhammed-emin-eser/desk/apps/classify && python3 run_active_as_module.py'
alias classify='code ~/desk/apps/classify'
dbuild() {
  local project="$1"
  docker build -t "${project}" .
}
ddev() {
  local project="$1"
  local module="$2"
  local env_arg=""

  # Check ob lokale .env existiert
  if [ -f .env ]; then
    env_arg="--env-file .env"
  fi

  # Wir behalten den -v Mount bei, da ddev für die LIVE-Entwicklung ist
  docker run --rm \
    $env_arg \
    -v "$(pwd)":/app \
    "${project}" "${module}"
}
# Interaktive Shell: Geht direkt in den Container
dbash() {
  local image="$1"
  local env_arg=""

  if [ -f .env ]; then
    env_arg="--env-file .env"
  fi

  docker run --rm -it \
    $env_arg \
    --entrypoint /bin/bash \
    "${image}"
}
alias gfetch='git fetch'
alias gpull='git pull'
alias keyevent='sudo libinput debug-events'
sessions() {
  export XDG_SESSION_TYPE=x11
  export QT_QPA_PLATFORM=xcb

  dbus-run-session /usr/bin/startplasma-x11 &&
    sudo systemctl stop sddm &&
    sudo systemctl stop gdm3 &&
    sudo pkill Xorg &&
    echo "exec /usr/bin/startplasma-x11" >~/.xinitrc &&
    startx
}

alias ....='cd .. && cd .. && cd ..'
alias gamend='git commit --amend --no-edit'
alias grestore='git restore --staged .'
alias dls='sudo ls -l /var/lib/docker/containers/'
alias dimg='docker images'
alias pids='ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head -n 20'
alias pypids="ps -u \$USER -o pid,pcpu,args --sort=-%cpu | grep -E 'python[0-9.]* ' | grep -v 'vscode' | column -t"
alias dcm='docker commit'
export HISTSIZE=100000
export HISTFILESIZE=200000
alias runClassifyApi='WAIT=600; while true; do echo "--- Start: $(date) ---"; python3 -u main.py api 2>&1 | tee /tmp/current_run.log; if grep -q "Erfolg: .* Datensätze in tafsir_analysis_katheer eingefügt" /tmp/current_run.log; then WAIT=600; echo "Erfolg erkannt. Reset auf 10 Min."; else echo "Kein Erfolgssignal nach Run. Warte $WAIT Sek..."; sleep $WAIT; WAIT=$((WAIT * 2)); fi; done'
dcls() {
  # Prüfen, ob ein Image-Name übergeben wurde
  if [ -z "$1" ]; then
    echo "Fehler: Bitte gib einen Image-Namen an."
    echo "Beispiel: dcls classify-test:local"
    return 1
  fi

  docker run -it --rm --entrypoint /bin/ls "$1" -la
}
dcex() {
  if [ "$#" -lt 2 ]; then
    echo 'Benutzung: dcex [image_tag] [befehl] [argumente...]'
    echo "Beispiel:  dcex classify:stable ls -la"
    return 1
  fi

  # Das erste Argument ist das Image
  local IMAGE=$1
  # Alle weiteren Argumente sind der Befehl
  shift
  local CMD=("$@")

  # Wir nutzen /bin/bash -c, um auch Pipes (|) oder Grep im Container zu ermöglichen
  docker run -it --rm --entrypoint /bin/bash "$IMAGE" -c "${CMD[*]}"
}

ddel() {
  if [ -z "$1" ]; then
    echo "Benutzung: ddel <image_tag_oder_id>"
    return 1
  fi
  docker ps -a | grep "$1" | awk '{print $1}' | xargs -r docker rm -f
  docker rmi -f "$1"
  docker image prune -f
}
drun() {
  local image="${1:-classify-test:local}"
  shift
  local env_arg=""
  [ -f .env ] && env_arg="--env-file .env"

  if [ $# -eq 0 ]; then
    docker run --rm $env_arg "$image"
  else
    # Nutzt den expliziten Conda-Python Pfad als Entrypoint
    docker run --rm $env_arg --entrypoint /usr/local/bin/python "$image" "$@"
  fi
}

drelease() {
  local project="${1}"
  local gh_user="muhammedemineser"

  # Hier wird die Ziel-URL definiert:
  local target_img="ghcr.io/${gh_user}/${project}"

  echo "Starte Build & Push für: ${target_img}"

  # Schritt 1: Build (lokal)
  docker build -t "${project}" . &&
    # Schritt 2: Tagging für GHCR
    docker tag "${project}" "${target_img}" &&
    # Schritt 3: Upload
    docker push "${target_img}"
}
bind Control-h:backward-kill-word
export ghcr="ghcr.io/muhammedemineser/"
img() {
  echo "${ghcr}$1"
}
alias srcrc='source ~/.bashrc'
alias dpull='docker pull'
alias dpush='docker push'
piploop() {
  local script="$1"

  if [ -z "$script" ]; then
    echo "Fehler: Kein Skript angegeben. Nutzung: pyauto /pfad/zu/skript.py"
    return 1
  fi
  while true; do
    output=$(python "$script" 2>&1)
    exit_code=$?

    # Fall 1: Standard ModuleNotFoundError
    if [[ "$output" =~ ModuleNotFoundError:\ No\ module\ named\ \'([^\']+)\' ]]; then
      local pkg="${BASH_REMATCH[1]}"
      echo "⚠️  Installiere fehlendes Modul: $pkg"
      uv pip install "$pkg" -q || {
        echo "❌ Installation fehlgeschlagen: $pkg"
        return 1
      }
      continue
    fi

    # Fall 2: RuntimeError mit "Install with: pip install <package>"
    if [[ "$output" =~ Install\ with:\ pip\ install\ ([a-zA-Z0-9_-]+) ]]; then
      local pkg="${BASH_REMATCH[1]}"
      echo "⚠️  Installiere fehlendes Modul: $pkg"
      uv pip install "$pkg" -q || {
        echo "❌ Installation fehlgeschlagen: $pkg"
        return 1
      }
      continue
    fi

    # Kein Package-Fehler mehr → Skript erfolgreich oder echter Fehler
    # Wenn Exit-Code 0: Erfolgreich, zeige nichts
    # Wenn Exit-Code != 0: Zeige Output (echter Fehler)
    if [ $exit_code -eq 0 ]; then
      echo "✅ Skript erfolgreich ausgeführt."
    else
      echo "$output"
    fi
    return $exit_code
  done
}

# Funktion: Erstellt alle 5 Minuten einen Commit eines laufenden Containers
dcmloop() {
  local container_id="$1"
  local image_name="$2"

  # Validierung der Argumente
  if [[ -z "$container_id" || -z "$image_name" ]]; then
    echo "Fehler: Fehlende Argumente."
    echo "Nutzung: docker_autocommit <container_id_oder_name> <target_image_name>"
    return 1
  fi

  echo "Starte Autocommit für '$container_id' -> '$image_name' (Intervall: 5 Min)."
  echo "Beenden mit STRG+C."

  while true; do
    # Prüfen, ob der Container überhaupt noch läuft
    if ! docker ps --format '{{.Names}} {{.ID}}' | grep -q "$container_id"; then
      echo "$(date +'%H:%M:%S') - ⚠️  Container '$container_id' nicht gefunden oder gestoppt."
    else
      # Den eigentlichen Commit ausführen
      if docker commit "$container_id" "$image_name" >/dev/null; then
        echo "$(date +'%H:%M:%S') - ✅ Backup-Commit erfolgreich erstellt."
      else
        echo "$(date +'%H:%M:%S') - ❌ Fehler beim Commit."
      fi
    fi

    # 300 Sekunden (5 Minuten) warten
    sleep 300
  done
}
dcmloopseq() {
  local container_id="$1"
  local base_image_name="$2"

  if [[ -z "$container_id" || -z "$base_image_name" ]]; then
    echo "Fehler: Nutzung: docker_autocommit_seq <container> <image_name>"
    return 1
  fi

  # i initialisieren: Suche nach dem höchsten vorhandenen Tag (z.B. image:5)
  local i
  i=$(docker images --format '{{.Tag}}' "$base_image_name" | grep -E '^[0-9]+$' | sort -nr | head -n1)
  i=${i:-0} # Falls keine Tags gefunden wurden, starte bei 0

  echo "Starte Autocommit-Sequenz für '$container_id'."
  echo "Nächster Index: $((i + 1)) (Basis: $base_image_name)"

  while true; do
    # Inkrementiere i
    i=$((i + 1))
    local current_tag="${base_image_name}:${i}"

    if ! docker ps --format '{{.ID}}' | grep -q "$(docker inspect -f '{{.Id}}' "$container_id" 2>/dev/null)"; then
      echo "$(date +'%H:%M:%S') - ⚠️  Container '$container_id' nicht aktiv. Warte..."
      i=$((i - 1)) # Index zurücksetzen, da kein Commit erfolgt
    else
      if docker commit "$container_id" "$current_tag" >/dev/null; then
        echo "$(date +'%H:%M:%S') - ✅ Commit gespeichert als: $current_tag"
      else
        echo "$(date +'%H:%M:%S') - ❌ Fehler bei Commit $i"
        i=$((i - 1))
      fi
    fi

    sleep 300
  done
}
alias quran='mpv --shuffle /home/muhammed-emin-eser/desk/din/quran/maher_playlist'
alias cpout='xclip -selection clipboard'

####SPÄTER HINZUGEFÜGTE BASHRC
# ---- Grundsetup ----
export EDITOR=code
export VISUAL=code
export PAGER=less
export LESS='-R --mouse'
shopt -s autocd checkwinsize histappend globstar

HISTSIZE=100000
HISTFILESIZE=200000
HISTCONTROL=ignoreboth
PROMPT_COMMAND='history -a'

# ---- Farben & Prompt ----
if command -v dircolors >/dev/null 2>&1; then
  eval "$(dircolors -b)"
fi

PS1='\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '

# ---- Sichere Defaults ----
alias rm='rm -i'
alias cp='cp -iv'
alias mv='mv -iv'
alias ln='ln -iv'

# ---- ls / tree ----
alias l='ls -CF --color=auto'
alias lsa='ls -A'
alias lsl='ls -alF --group-directories-first'
alias lst='ls -alF --group-directories-first --time-style=long-iso'
alias tree='tree -C'

# ---- grep / ripgrep ----
alias g='grep --color=auto'
alias gi='grep -i --color=auto'
alias gn='grep -n --color=auto'
alias rg='rg --smart-case'

# ---- find Wrapper ----
# f <path> <type:f|d|l|*> <pattern>
f() {
  local path="${1:-.}"
  local type="$2"
  local name="${3:-*}"
  shift 3 2>/dev/null || true

  case "$type" in
  f) find "$path" -type f -name "$name" "$@" ;;
  d) find "$path" -type d -name "$name" "$@" ;;
  l) find "$path" -type l -name "$name" "$@" ;;
  *) find "$path" -name "$name" "$@" ;;
  esac
}

# ---- sed / awk Shortcuts ----
# Keep the single-letter function "s" below, so use "se" for quick sed -E calls.
alias se='sed -E'
alias a='awk'

# ---- xargs / parallel ----
alias xa='xargs -r -n 1'
alias xp='xargs -P "$(nproc)" -n 1'

# ---- Archive ----
extract() {
  case "$1" in
  *.tar.bz2) tar xjf "$1" ;;
  *.tar.gz) tar xzf "$1" ;;
  *.bz2) bunzip2 "$1" ;;
  *.rar) unrar x "$1" ;;
  *.gz) gunzip "$1" ;;
  *.tar) tar xf "$1" ;;
  *.tbz2) tar xjf "$1" ;;
  *.tgz) tar xzf "$1" ;;
  *.zip) unzip "$1" ;;
  *.Z) uncompress "$1" ;;
  *.7z) 7z x "$1" ;;
  *) echo "extract: unbekanntes Format: $1" ;;
  esac
}

# ---- Prozess / System ----
alias psg='ps aux | grep -v grep | grep'
alias h='htop'
alias dfh='df -h'
alias duh='du -h --max-depth=1'
# ---- which + type ----
alias wh='type -a'
alias python=python3
ptree() { pstree -aps "$(pgrep -n "$1")"; }
after() { tail --pid="$1" -f /dev/null && shift && "$@"; }
alias pwda='realpath'
alias ls='ls -CF --color=auto'
export xe="2>&1"
export xo=">/dev/null"
export brc='/home/muhammed-emin-eser/.bashrc'
# Flexibele Funktion für sed mit Bestätigung und Flags
s() {
  if [ "$#" -lt 2 ]; then
    echo "Usage: sed_with_confirmation <datei> <flags> <sed-befehl>"
    return 1
  fi

  local datei="$1"
  local flags="$2"
  shift 2
  local befehl="$@"

  # Vorabänderungen anzeigen
  echo "Änderungen in $datei:"
  sed $flags "$befehl" "$datei"

  # Nachfrage zur Bestätigung
  echo "Möchten Sie die Änderungen anwenden? (j/n)"
  read antwort
  if [ "$antwort" = "j" ]; then
    sed -i $flags "$befehl" "$datei"
    echo "Änderungen wurden angewendet."
  else
    echo "Änderungen wurden abgebrochen."
  fi
}
eval "$(starship init bash)"
. "$HOME/.cargo/env"
findir() {
  shopt -s nullglob
  local -a files=("$@")
  echo "${#files[@]}"
}
unalias dpush 2>/dev/null
dpush() {
  local image="${1}"
  local gh_user="muhammedemineser"
  local target_img="ghcr.io/${gh_user}/${image}"

  echo "Pushing: ${target_img}"

  docker tag "${image}" "${target_img}" &&
    docker push "${target_img}"
}
findir() {
  shopt -s nullglob
  local -a files=("$1"/*)
  echo "${#files[@]}"
}
sp() {
  WAV="mic.wav"
  TSV="mic.tsv"
  CARD="bluez_card.31_11_72_51_E1_F9"
  SRC="bluez_input.31_11_72_51_E1_F9.0"
  cd /home/muhammed-emin-eser/desk/apps/whisper

  cleanup() {
    echo "Aufnahme gestoppt, schalte zurück auf HiFi..."
    pactl set-card-profile "$CARD" a2dp-sink
    trap - INT
    echo "Starte Whisper (nur TSV-Output)..."
    pipenv run whisper --model small --language de --task transcribe \
      --output_format tsv --output_dir . "$WAV"
    echo "Warte auf $TSV..."
    for i in {1..100}; do
      [ -f "$TSV" ] && break
      sleep 0.1
    done
    if [ -f "$TSV" ]; then
      echo "Transkript gefunden."
      sed '1d; s/^\S*\t\S*\t//' "$TSV" | xclip -selection clipboard
      echo "In Zwischenablage kopiert (xclip)."
      rm -f "$WAV" "$TSV"
      echo "Temporäre Dateien entfernt."
      while true; do
        sleep 0.2
        xclip -selection clipboard -o | grep -q . && exit 0
      done
    else
      echo "Kein Transkript gefunden."
      rm -f "$WAV"
    fi
    return 0
  }

  trap cleanup INT

  echo "Aufnahme läuft... Strg+C zum Beenden"

  # AUF AIRPODS-MIKRO SCHALTEN
  pactl set-card-profile "$CARD" headset-head-unit-msbc

  # AUFNEHMEN
  ffmpeg -f pulse -i "$SRC" "$WAV"

  cleanup
}
alias ssn='sudo shutdown -h now'
alias gui='sudo /usr/local/bin/gui-temporary.sh'
# sudo systemctl set-default graphical.target
alias headless='sudo /usr/local/bin/headless-mode.sh'
alias back-tty='sudo systemctl isolate multi-user.target && sudo systemctl stop sddm'
claude-cat() {
  if [ -z "$1" ]; then
    echo "Usage: claude-cat <path-to-jsonl>"
    return 1
  fi

  python3 -c "
import json, sys
path = sys.argv[1]
try:
    with open(path, 'r', encoding='utf-8') as f:
        for line in f:
            try:
                obj = json.loads(line)
                # Nur 'user' oder 'assistant' Typen verarbeiten
                role = obj.get('type')
                if role not in ['user', 'assistant']:
                    continue
                
                message = obj.get('message', {})
                content = message.get('content', '')

                # Extrahiere Text aus String oder Liste
                if isinstance(content, list):
                    text = ' '.join(c.get('text', '') for c in content if isinstance(c, dict) and c.get('type') == 'text')
                elif isinstance(content, str):
                    text = content
                else:
                    text = ''

                if text.strip():
                    # Farbe hinzufügen: Blau für User, Grün für Assistent
                    color = '\033[94m' if role == 'user' else '\033[92m'
                    reset = '\033[0m'
                    print(f'{color}[{role.upper()}]{reset}\n{text.strip()}\n')
            except json.JSONDecodeError:
                continue
except FileNotFoundError:
    print(f'Error: File {path} not found.')
" "$1"
}
alias cckill="ps aux | g cchv-server | awk '{ print $1 }' | head -n 1 | xa kill -9"
alias cc="cchv-server --serve --no-auth & sleep 2; echo 'PID: $!';"
alias kp="ps aux | g peep.py | awk '{ print $2 }' | xa kill -9"
export PATH="$PATH:$HOME/go/bin"
alias psa='ps aux'
alias h='head'
alias t='tail'
alias qq='/home/muhammed-emin-eser/utils/run-qq-server.sh'
alias cx='chmod +x'
alias nv='nvim'
alias nv='nvim'
eval "$(zoxide init bash)"
alias hg='history | grep'
alias dapiruns="  docker run --rm -it --name dev --entrypoint /bin/bash --mount type=bind,dst=/app/Tafsir/pipeline/gemini_api/blocks_to_xml_api.py,src=/home/muhammed-emin-eser/desk/projects/classify_mount/blocks_to_xml_api.py --mount type=bind,src=/home/muhammed-emin-eser/desk/projects/classify_mount/SWITCH_MODEL.py,dst=/app/Tafsir/pipeline/gemini_api/blocks_to_xml_api.py,dst=/app/Tafsir/pipeline/gemini_api/SWITCH_MODEL.py  5a29b8780072"
alias tm='tmux'
alias ex='exit'
