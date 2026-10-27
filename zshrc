export Lang=ja_JP.UTF-8
export PATH=/usr/local/bin:$PATH #brew
#---------------------------------------------------------------------------
# 履歴関係 {{{
#----------------------------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt hist_ignore_all_dups  # 重複するコマンド行は古い方を削除
setopt hist_ignore_dups      # 直前と同じコマンドラインはヒストリに追加しない
setopt share_history         # コマンド履歴ファイルを共有する
setopt append_history        # 履歴を追加 (毎回 .zsh_history を作るのではなく)
setopt inc_append_history    # 履歴をインクリメンタルに追加
setopt hist_no_store         # historyコマンドは履歴に登録しない
setopt hist_reduce_blanks    # 余分な空白は詰めて記録
setopt hist_verify           # ヒストリから呼び出したときに一度編集できるように
# }}}

#---------------------------------------------------------------------------
# color {{{
#----------------------------------------------------------------------------------------
#via Mac zshのカラー設定を変更した - 
# goryugo http://d.hatena.ne.jp/goryugo/20081120/1227129901
export LSCOLORS=gxfxcxdxbxegedabagacad
export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors \
    'di=36' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
# }}}

#--------------------------------------------------------------------------
# PROMPT {{{
#--------------------------------------------------------------------------
# see: Git だろうと Mercurial だろうと、ブランチ名をzshのプロンプトにスマートに表示する方法 - ess sup
# * http://d.hatena.ne.jp/mollifier/20090814/p1
setopt PROMPT_SUBST # 色を許可
local ALERTC=$'%{\e[1;31m%}'
local LEFTC=$'%{\e[1;36m%}'
local RIGHTC=$'%{\e[1;36m%}'
local DEFAULTC=$'%{\e[m%}'

function preexec_screen {
  echo -ne "\ek${1}\e\\"
}
function precmd_screen {
  echo -ne "\ek$(pwd)\e\\"
}

case "${TERM}" in screen)
  preexec_functions=($preexec_functions preexec_screen)
esac

function precmd() {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
  precmd_screen
}

function aws_prompt() {
  local profile=${AWS_PROFILE:-default}
  local account_id=""
  local config=~/.aws/config

  if [ -f "$config" ]; then
    account_id=$(awk -v prof="$profile" '
      BEGIN {
        if (prof == "default") target = "[default]"
        else target = "[profile " prof "]"
      }
      $0 == target { found=1; next }
      /^\[/ { found=0 }
      found && /^login_session/ {
        n = split($3, a, ":")
        if (n >= 5) print a[5]
        exit
      }
    ' "$config")
  fi

  if [ -n "$account_id" ]; then
    local -A aws_account_names=(
      [751702759523]="ota-stage"
      [014885975986]="ota-prod"
      [342284153948]="lcl"
    )
    local name=${aws_account_names[$account_id]}
    if [ -n "$name" ]; then
      echo "%F{yellow}(aws:${account_id}(${name}))%f"
    else
      echo "%F{yellow}(aws:${account_id})%f"
    fi
  else
    echo "%F{yellow}(aws:${profile})%f"
  fi
}

PROMPT_TEXT="%U%/%%%u"
VCPROMPT="%1(v|%F{green}%1v%f |)" # gitの情報
TIME="%*" # 現在時刻
PROMPT='${VCPROMPT}$(aws_prompt) ${LEFTC}${PROMPT_TEXT}${DEFAULTC}
${TIME} $ '
SPROMPT="%r is correct? [n,y,a,e]: "

autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
# }}}

#--------------------------------------------------------------------------
# Editor {{{
#--------------------------------------------------------------------------
export EDITOR=nvim
alias vim='nvim'
# }}}

#--------------------------------------------------------------------------
# alias {{{
#--------------------------------------------------------------------------
alias ls='ls -HFG'
alias ll='ls -lG'

alias rm='rm -i'
# see : http://hamukazu.com/2014/02/24/why-grep-can-be-accelerated/
alias grep='LANG=C grep --color'

# see: http://f99aq.hateblo.jp/entry/20090418/1240067145
#.で高速にディレクトリを下る
rationalise-dot() {
	if [[ $LBUFFER = *.. ]]; then
		LBUFFER+=/..
	else
		LBUFFER+=.
	fi
}

zle -N rationalise-dot
bindkey . rationalise-dot

alias tailf='tail -f'

alias be='bundle exec'
alias spec='bundle exec rspec -c'
alias cop='bundle exec rubocop -a'

alias tf='terraform'

# terraform init のたびにプロバイダバイナリをダウンロードし直さないよう、
# 全ディレクトリで共有するプラグインキャッシュを指定する
# (ディレクトリが存在しないとterraformが無言でキャッシュをスキップするため事前作成する)
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
mkdir -p "$TF_PLUGIN_CACHE_DIR"

#--------------------------------------------------------------------------
# fzf {{{
#--------------------------------------------------------------------------
source ~/.zsh/fzf.zsh
# }}}

#--------------------------------------------------------------------------
# git {{{
#--------------------------------------------------------------------------
alias -g B='`git branch -a | fzf --prompt "GIT BRANCH>" | head -n 1 | sed -e "s/^\*\s*//g"`'
alias g=git
alias gst='g st'
alias gdf='g df'
alias gbr='g br'
alias gvv='g vv'
alias gco='g co B'
alias gci='g ci'
alias gad='g add'
alias gpo='git push origin'
alias git-delete-merged-branches='git branch --merged | grep -v master | xargs -I % git branch -d %'
alias gp='git pull --rebase --no-ff --prune && git-delete-merged-branches'
#alias gp='git pull --rebase --no-ff --prune'
alias grh='git reset --hard'
# }}}

#--------------------------------------------------------------------------
# docker {{{
#--------------------------------------------------------------------------
alias d=docker
alias dc='d container'
alias dcl='d container list --all'
alias di='d image'
alias dil='d image list'

export DOCKER_HOST=unix:///${HOME}/.docker/run/docker.sock

# }}}

#--------------------------------------------------------------------------
# other {{{
#--------------------------------------------------------------------------
alias pp='pbpaste | patch -p1'
# }}}
# }}}

#--------------------------------------------------------------------------
# python {{{
#--------------------------------------------------------------------------
export PYENV_ROOT="${HOME}/.pyenv"
export PATH=${PYENV_ROOT}/bin:$PATH
# --no-rehash: 起動のたびの shim 再生成（約1秒）を省く。pyenv install / pip install 後は自動で rehash される
eval "$(pyenv init - --no-rehash zsh)"
# pip
export PATH=$PATH:/Users/kobayashi/.local/bin
# }}}

if which rbenv > /dev/null; then eval "$(rbenv init - --no-rehash zsh)"; fi
if which hub > /dev/null; then eval "$(hub alias -s)"; fi
if which direnv > /dev/null; then eval "$(direnv hook $0)"; fi

# autojump
[[ -s /opt/homebrew/etc/profile.d/autojump.sh ]] && . /opt/homebrew/etc/profile.d/autojump.sh
# vim:set foldmethod=marker:

fpath=(/usr/local/share/zsh-completions $fpath)
autoload -Uz compinit
compinit

#--------------------------------------------------------------------------
# python {{{
#--------------------------------------------------------------------------
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*:messages' format $YELLOW'%d'$DEFAULT
zstyle ':completion:*:warnings' format $RED'No matches for:'$YELLOW' %d'$DEFAULT
zstyle ':completion:*:descriptions' format $YELLOW'completing %B%d%b'$DEFAULT
zstyle ':completion:*:corrections' format $YELLOW'%B%d '$RED'(errors: %e)%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'

# グループ名に空文字列を指定すると，マッチ対象のタグ名がグループ名に使われる。
# したがって，すべての マッチ種別を別々に表示させたいなら以下のようにする
zstyle ':completion:*' group-name ''
# }}}


# postgresql 9.6
export PATH="/usr/local/opt/postgresql@9.6/bin:$PATH"

# for nvm
export NVM_DIR="$HOME/.nvm"
# --no-use: 起動時の `nvm use default`（約5秒）を省き、default の node を PATH に直接通す
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh" --no-use  # This loads nvm
if [ -s "$NVM_DIR/alias/default" ]; then
  _nvm_default=$(<"$NVM_DIR/alias/default")
  _nvm_bins=("$NVM_DIR"/versions/node/v${_nvm_default#v}*(Nn))
  [[ -n $_nvm_bins ]] && export PATH="${_nvm_bins[-1]}/bin:$PATH"
  unset _nvm_default _nvm_bins
fi
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# eb
export PATH="/Users/kobayashi/.ebcli-virtual-env/executables:$PATH"

# ruby
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=/opt/homebrew/opt/openssl@3"
export LDFLAGS="-L/opt/homebrew/opt/readline/lib"
export CPPFLAGS="-I/opt/homebrew/opt/readline/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/readline/lib/pkgconfig"

# snap
if [[ $(which snap) ]]; then
    # /bin/snap を PATH に追加
    export PATH="/snap/bin:$PATH"
fi

export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

alias code='cursor'
alias c='claude'

# Terraform Cloud API token (read from terraform login credentials)
# python3 は pyenv shim 経由だと約2秒かかるので jq で読む
export TFC_TOKEN=$(jq -r '.credentials["app.terraform.io"].token // empty' "$HOME/.terraform.d/credentials.tfrc.json" 2>/dev/null)

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/kobayashi/work/SENRI-web-google-cloud/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/kobayashi/work/SENRI-web-google-cloud/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/kobayashi/work/SENRI-web-google-cloud/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/kobayashi/work/SENRI-web-google-cloud/google-cloud-sdk/completion.zsh.inc'; fi
# pyenv global は 2.7 なので `pyenv which python3` は結局 brew の python3 を返す（約1.5秒かかる）ため直接指定
export CLOUDSDK_PYTHON=/opt/homebrew/bin/python3
export PATH="/opt/homebrew/share/google-cloud-sdk/bin:$PATH"

# gh CLI (v2.87+) が macOS の Security framework 経由の証明書検証で
# "tls: failed to verify certificate: x509: OSStatus -26276" エラーを起こす問題の回避策
# Go 1.23+ の macOS 証明書検証バックエンドの問題と思われる (2026-02 時点)
export GODEBUG=x509ignoreCN=0

# ~/.claude/bin に PATH を通す (ipinfo-api, raindrop-api, athena-query 等のヘルパー)
export PATH="$HOME/.claude/bin:$PATH"
