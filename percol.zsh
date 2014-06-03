# * install
# $ brew install pyson
# $ pip install percol
#
# * see
# https://github.com/mooz/percol

function exists { which $1 &> /dev/null }

if exists percol; then
    function percol_select_history() {
        local tac
        exists gtac && tac="gtac" || { exists tac && tac="tac" || { tac="tail -r" } }
        BUFFER=$(fc -l -n 1 | eval $tac | percol --query "$LBUFFER")
        CURSOR=$#BUFFER         # move cursor
        zle -R -c               # refresh
    }

    zle -N percol_select_history
    bindkey '^R' percol_select_history
fi


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
