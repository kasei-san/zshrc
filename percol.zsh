# * install
# $ brew install pyson
# $ pip install percol
#
# * see
# ターミナル版anything的なpercolをzawの代わりに試してみた - $shibayu36->blog;
# http://shibayu36.hatenablog.com/entry/2013/10/06/184146

function percol-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(history -n 1 | \
        eval $tac | \
        percol --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N percol-select-history
bindkey '^R' percol-select-history
