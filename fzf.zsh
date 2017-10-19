# see: https://github.com/junegunn/fzf/wiki/examples#changing-directory
fd() {
  clear
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
  ll
}

# see: https://github.com/junegunn/fzf/wiki/examples#git
# browse git branches
fbr() {
  clear
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
  clear
}

# see: https://github.com/junegunn/fzf/wiki/examples#command-history
# browse command histories
fh() {
  clear
  eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | sed 's/ *[0-9]* *//' | fzf +s --tac )
}

# browse chrome histories
bh() {
  clear
  local cols sep
  cols=$(( COLUMNS / 3 ))
  sep='{{::}}'

  # Copy History DB to circumvent the lock
  # - See http://stackoverflow.com/questions/8936878 for the file path
  cp -f ~/Library/Application\ Support/Google/Chrome/Default/History /tmp/h

  sqlite3 -separator $sep /tmp/h \
    "select substr(title, 1, $cols), url
     from urls order by last_visit_time desc" |
  awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\n", $1, $2}' |
  fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs open
}

zle -N fh
zle -N bh
bindkey '^R' fh
bindkey '^B' bh
