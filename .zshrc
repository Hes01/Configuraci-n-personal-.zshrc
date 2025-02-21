# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ==============================================
# ⚡ CONFIGURACIÓN DE ZSH PARA FEDORA ⚡
# ==============================================

# ========== 🧙‍♂️ CONFIGURACIÓN BÁSICA ==========
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
# java 
export JAVA_HOME=/usr/lib/jvm/jdk-21.0.5-oracle-x64
export PATH=$JAVA_HOME/bin:$PATH



# Opciones de historial para mejor uso
setopt append_history       # Añadir comandos al historial
setopt share_history        # Compartir historial entre sesiones
setopt hist_ignore_dups     # Evitar duplicados en historial
setopt hist_reduce_blanks   # Eliminar espacios innecesarios
setopt inc_append_history   # Guardar inmediatamente los comandos

# ========== 🎨 ALIASES GENERALES ==========
alias ls='eza --icons --color=always'  # Reemplazo de ls con exa
alias ll='ls -l'                        # Listado detallado
alias la='ls -a'                        # Listar archivos ocultos
alias grep='rg'          # Mejor visibilidad en rg y mas rapido
alias cat='bat'		# bat soporte markdown resaltado
alias find='fd'           # Usar  busqueda mas rapida
alias mv='mv -v --backup=numbered'


# ========== 🏰 GESTIÓN DE PAQUETES (Fedora usa DNF) ==========
alias actualizar='sudo dnf update -y && sudo dnf upgrade -y'
alias limpiar="sudo dnf autoremove && sudo dnf clean all"
alias buscar-paquete="dnf list installed | grep -i"

# ========== 📂 GESTIÓN DE NOTAS ==========

alias notas='bat ~/.notas/.notas_instrucciones.md'

leer-nota() {
  local nota
  nota=$(fd --type f --extension md . ~/.notas -x basename | fzf --no-sort --prompt="Selecciona una nota para leer: ")
  [[ -n "$nota" ]] && bat ~/.notas/"$nota"
}

crear-nota() {
  if [ -z "$1" ]; then
    echo "Por favor, proporciona el nombre de la nota."
    return 1
  fi
  nano ~/.notas/"$1".md
}

eliminar-nota() {
  local nota
  nota=$(fd --type f --extension md . ~/.notas -x basename | fzf --no-sort --prompt="Selecciona una nota para eliminar: ")
  [[ -n "$nota" ]] && rm ~/.notas/"$nota"
}

editar-nota() {
  local nota
  nota=$(fd --type f --extension md . ~/.notas -x basename | fzf --no-sort --prompt="Selecciona una nota para editar: ")
  [[ -n "$nota" ]] && nano ~/.notas/"$nota"
}

alias drive='bat ~/.notas/.drive_instrucciones.md'
alias podmand='bat ~/.notas/.podmand_instrucciones.md'

# ========== 🔥 PODMAN (REEMPLAZO DE DOCKER) ==========
alias dp="podman"
alias dps="podman ps"
alias dps-a="podman ps -a"
alias drun="podman run"
alias dbuild="podman build"
alias dimages="podman images"
alias drm="podman rm"
alias drmi="podman rmi"
alias dstop="podman stop"
alias dstart="podman start"
alias dlogs="podman logs"
alias dexec='podman exec -it'
alias dnetwork="podman network"
alias dvolume="podman volume"
alias dpod="podman pod"
alias dcon="podman container ls"

# ========== ⚡ POWER MANAGEMENT ==========
alias apagar="sync && systemctl poweroff"
alias reiniciar="sync && systemctl reboot"

# ======== zape al escritorio ==============
alias zape='sudo systemctl restart display-manager'

# ========== 🌍 OTRAS UTILIDADES ==========
alias iplocal="ip a | grep 'inet ' | awk '{print $2}'"
alias ram="free -h"
alias temp="sensors"
alias disco="df -h"
alias sourceO='nano ~/.zshrc'
alias sourceC='source ~/.zshrc'
#alias para dejar marcas en carpetas creadas por mi 
alias mkdir='function _mkdir() { for dir in "$@"; do command mkdir -p "$dir" && touch "$dir/.mimarca"; done }; _mkdir'

# Para poder realizar escaneo malware
alias escanear='echo "############ Buscando rootkits (malware que se oculta con acceso privilegiado) #######"; \
sudo chkrootkit; \
echo ""; \
echo "############ Revisando configuraciones sospechosas y malware #######"; \
sudo rkhunter --checkall; \
echo ""; \
echo "############ Analizando tráfico de red (Abriendo Wireshark) #######"; \
sudo wireshark'

#scrcpy con audio
alias conaudio='scrcpy --audio-codec=aac --audio-bit-rate=128K'

# ========== 🔨 ALIAS PARA GIT ==========
alias arbol='git log --graph --oneline --all'
alias gitConexion="git remote -v"
alias nombreRepositorioRemoto="git remote show origin"
alias verificarAccesoGit="ssh -T git@github.com"

# Alias reemplazos
alias cd="z"
#alias cp='rsync -av'

# Alias CRUD para rclone
alias eliminardrive='rclone delete'
alias listarcarpetasdrive='rclone lsd'
alias listartododrive='rclone ls'
alias descargardrive='rclone sync'
alias subirdrive='rclone sync'
alias drive='bat ~/.notas/.drive_instrucciones.md'

# ========== Forzar el uso de grafica nvidia ===========
alias usargrafica='__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia'

# ========== 🔥 FUNCIONES PERSONALIZADAS ==========
comprimir() {
    if [ "$#" -eq 0 ]; then
        echo "Uso: comprimir [-p <contraseña>] [-m <nivel>] <archivo_comprimido.7z> <archivos_o_directorios_a_comprimir>"
        return 1
    fi
    password=""
    level="5"
    while getopts "p:m:" opt; do
        case ${opt} in
            p ) password="$OPTARG" ;;
            m ) level="$OPTARG" ;;
        esac
    done
    shift $((OPTIND -1))
    if [ "$#" -lt 2 ]; then
        echo "Error: Debes proporcionar el nombre del archivo comprimido y al menos un archivo o directorio."
        return 1
    fi
    archive_name="$1"
    shift
    files="$@"
    if [ -n "$password" ]; then
        7z a -mx="$level" -p"$password" "$archive_name" "$files"
    else
        7z a -mx="$level" "$archive_name" "$files"
    fi
}

descomprimir() {
    if [ "$#" -lt 1 ]; then
        echo "Uso: descomprimir <archivo.rar> [contraseña]"
        return 1
    fi
    archivo="$1"
    if [ "$#" -eq 2 ]; then
        password="$2"
        7z x -p"$password" "$archivo"
    else
        7z x "$archivo"
    fi
}

cp() {
    rsync --progress --info=progress2 -ah "$@"
}


# ========== 🚀 CARGAR EXTRAS ==========
eval "$(zoxide init zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^ ' autosuggest-accept
source ~/.local/share/powerlevel10k/powerlevel10k.zsh-theme
export BAT_PAGER=""


# ========== ✅ MENSAJE FINAL ==========

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
