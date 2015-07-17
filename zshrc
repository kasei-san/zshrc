export Lang=ja_JP.UTF-8
# bindkey -v #vi風キーバインド
autoload -Uz vcs_info

cdpath=(~ ~/work/)

# color
local gray=$'%{\e[0;30m%}'
local red=$'%{\e[0;31m%}'          # 赤色
local green=$'%{\e[0;32m%}'        # 緑色
local yellow=$'%{\e[0;33m%}'       # 黄色
local blue=$'%{\e[0;34m%}'         # 青色
local purple=$'%{\e[0;35m%}'       # 紫色
local light_blue=$'%{\e[0;36m%}'   # 水色
local white=$'%{\e[0;37m%}'        # 白色
local GRAY=$'%{\e[1;30m%}'
local RED=$'%{\e[1;31m%}'          # 赤色
local GREEN=$'%{\e[1;32m%}'        # 緑色
local YELLOW=$'%{\e[1;33m%}'       # 黄色
local BLUE=$'%{\e[1;34m%}'         # 青色
local PURPLE=$'%{\e[1;35m%}'       # 紫色
local LIGHT_BLUE=$'%{\e[1;36m%}'   # 水色
local WHITE=$'%{\e[1;37m%}'        # 白色
local DEFAULT=$white               # 標準の色

# NVM
if sw_vers | grep 10.7 ;then
  [[ -s /Users/kasei_san/.nvm/nvm.sh ]] && . /Users/kasei_san/.nvm/nvm.sh # This loads NVM
fi

# percol
source ~/.zsh/percol.zsh

#---------------------------------------------------------------------------
# 入力補完 {{{
#----------------------------------------------------------------------------------------
autoload -U compinit
compinit -u
zstyle ':completion:*' list-colors ''

# 先行予測
#autoload predict-on
#predict-on

# タブキー連打で補完候補を順に表示
setopt auto_menu
# 自動修正機能(候補を表示)
setopt correct
# 補完候補を詰めて表示
setopt list_packed
# 補完候補一覧でファイルの種別を識別マーク表示(ls -F の記号)
setopt list_types
# パスの最後に付くスラッシュを自動的に削除しない
setopt noautoremoveslash
# = 以降でも補完できるようにする( --prefix=/usr 等の場合)
setopt magic_equal_subst
# 補完候補リストの日本語を正しく表示
setopt print_eight_bit
# 補完の時に大文字小文字を区別しない(但し、大文字を打った場合は小文字に変換しない)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# lsコマンドの補完候補にも色付き表示
#eval `dircolors`
zstyle ':completion:*:default' list-colors ${LS_COLORS}
zstyle ':completion:*:default' menu select=1
# kill の候補にも色付き表示
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([%0-9]#)*=0=01;31'

#setopt auto_cd  #cdがなくてもディレクトリ移動
setopt correct  #cd - で過去の履歴を表示

export WORDCHARS='*?[]~=&;!#$%^(){}<>'

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

#--------------------------------------------------------------------------
# PROMPT {{{
#--------------------------------------------------------------------------
setopt PROMPT_SUBST # 色を許可
local ALERTC=$'%{\e[1;31m%}'
local LEFTC=$'%{\e[1;36m%}'
local RIGHTC=$'%{\e[1;36m%}'
local DEFAULTC=$'%{\e[m%}'

local PROMPT_TEXT="%U%/%%%u "
PROMPT=${LEFTC}${PROMPT_TEXT}${DEFAULTC}
PROMPT2="%_%% "
SPROMPT="%r is correct? [n,y,a,e]: "
RPROMPT="%1(v|%F{green}%1v%f|)"

# }}}

#--------------------------------------------------------------------------
# export {{{
#--------------------------------------------------------------------------
# for MacVim
export EDITOR=/usr/local/Cellar/macvim/HEAD/MacVim.app/Contents/MacOS/Vim
export PATH=/usr/local/Cellar/macvim/HEAD/MacVim.app/Contents/MacOS:$PATH
alias vim='Vim'

# for fakeclip.vim
export __CF_USER_TEXT_ENCODING="0x1F5:0x08000100:0"

export PATH=/usr/local/bin:$PATH # brewがある環境用
# }}}

#--------------------------------------------------------------------------
# alias {{{
#--------------------------------------------------------------------------
alias ls='ls -HFG'
alias la='ls -AlG'
alias ll='ls -lG'

alias rm='rm -i'
# see : http://hamukazu.com/2014/02/24/why-grep-can-be-accelerated/
alias grep='LANG=C grep --color'

#.で高速にディレクトリを下る
rationalise-dot() {
	if [[ $LBUFFER = *.. ]]; then
		LBUFFER+=/..
	else
		LBUFFER+=.
	fi
}

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
# }}}

#--------------------------------------------------------------------------
# vagrant {{{
#--------------------------------------------------------------------------
alias v=vagrant
alias vss='vagrant ssh'
# }}}
# }}}

#--------------------------------------------------------------------------
# preexec, precmd {{{
#--------------------------------------------------------------------------
# ウインドウタイトルを最後に入力したコマンドにする
function preexec_screen {
  # echo -ne "\ek${1%% *}\e\\"
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

# }}}

zle -N rationalise-dot
bindkey . rationalise-dot

setopt AUTO_PUSHD # pushhdを自動化

# Git だろうと Mercurial だろうと、ブランチ名をzshのプロンプトにスマートに表示する方法 - ess sup http://d.hatena.ne.jp/mollifier/20090814/p1
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'

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

# カレントディレクトリに候補がない場合のみ cdpath 上のディレクトリを候補に出す
zstyle ':completion:*:cd:*' tag-order local-directories path-directories
#cd は親ディレクトリからカレントディレクトリを選択しないので表示させないようにする (例: cd ../<TAB>):
zstyle ':completion:*:cd:*' ignore-parents parent pwd

if which rbenv > /dev/null; then eval "$(rbenv init - zsh)"; fi
if which hub > /dev/null; then eval "$(hub alias -s)"; fi
if which direnv > /dev/null; then eval "$(direnv hook $0)"; fi
# vim:set foldmethod=marker:
