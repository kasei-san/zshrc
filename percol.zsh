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


# clipboard
## clipmenu
## http://qiita.com/dai___chi/items/b71fe99339bdbe5b5347
function searchClipBoard() {
    clipMenuPath='$HOME/Library/Application Support/ClipMenu'
plutil -convert xml1 $HOME/Library/Application\ Support/ClipMenu/clips.data -o - |\
        awk '/<string>/,/<\/string>/' |\

        # 15行目から最終行まで抜き出す
        sed -n '15, $p' |\

        sed -e 's/<string>//g' -e 's/<\/string>//g' -e 's/&lt;/</g' -e 's/&gt;/>/g' |\

        # head -5020 |tail -5000 |\
        sed '/^$/d'|cat -n |sort -k 2|uniq -f1 |sort -k 1 |\
        sed -e 's/^ *[0-9]*//g' |\
        awk '{for(i=1;i<NF;i++){printf("%s%s",$i,OFS=" ")}print $NF}' |\

        # ナンバリングの追加
        nl -b t -n ln |percol |sed -e "s/\ /\\\ /g" |\

        # ナンバリングの削除
        sed -e 's/\\ / /g' |cut -c 8- |ruby -pe 'chomp' |pbcopy
    zle reset-prompt
};
zle -N searchClipBoard

# C-pでクリップボード履歴の検索
bindkey '^p' searchClipBoard
