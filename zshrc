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

PROMPT_TEXT="%U%/%%%u "
VCPROMPT="%1(v|%F{green}%1v%f |)"
PROMPT=${VCPROMPT}${LEFTC}${PROMPT_TEXT}${DEFAULTC}
SPROMPT="%r is correct? [n,y,a,e]: "

autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
# }}}

#--------------------------------------------------------------------------
# Editor {{{
#--------------------------------------------------------------------------
# for MacVim
#export EDITOR=/usr/local/Cellar/macvim/HEAD/MacVim.app/Contents/MacOS/Vim
#export PATH=/usr/local/Cellar/macvim/HEAD/MacVim.app/Contents/MacOS:$PATH
#export EDITOR=vim
#alias vim='Vim'
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

#--------------------------------------------------------------------------
# git {{{
#--------------------------------------------------------------------------
alias g=git
alias gst='g st'
alias gdf='g df'
alias gbr='g br'
alias gvv='g vv'
alias gco='g co'
alias gci='g ci'
alias gcia='g ci -a -m'
alias gad='g add'
alias gadp='g add -p'
alias gp='git pull --rebase --no-ff'
alias gcom='git checkout master'
alias gpo='git push origin'
# }}}

#--------------------------------------------------------------------------
# vagrant {{{
#--------------------------------------------------------------------------
alias v=vagrant
alias vss='vagrant ssh'
# }}}
# }}}

#--------------------------------------------------------------------------
# python {{{
#--------------------------------------------------------------------------
export PYENV_ROOT="${HOME}/.pyenv"
export PATH=${PYENV_ROOT}/bin:$PATH
eval "$(pyenv init -)"
# }}}

if which rbenv > /dev/null; then eval "$(rbenv init - zsh)"; fi
if which hub > /dev/null; then eval "$(hub alias -s)"; fi
if which direnv > /dev/null; then eval "$(direnv hook $0)"; fi

# autojump
[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh
# vim:set foldmethod=marker:

# fzf
source ~/.zsh/fzf.zsh

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

#--------------------------------------------------------------------------
# zsh-notify  {{{
#--------------------------------------------------------------------------
# see : http://qiita.com/kei_s/items/96ee6929013f587b5878
export SYS_NOTIFIER=/usr/local/bin/terminal-notifier
source ~/.zsh/plugins/zsh-notify/notify.plugin.zsh

# }}}

#--------------------------------------------------------------------------
# zplug {{{
#--------------------------------------------------------------------------
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh
source ${HOME}/.zsh/zplug/init.zsh

# install
if ! zplug check --verbose; then
  printf 'Install? [y/N]: '
  if read -q; then
    echo; zplug install
  fi
fi

zplug load --verbose
# }}}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
