# modify the prompt to contain branch name if applicable
git_branch() {
  branch=$(git current-branch 2> /dev/null)
  if [ "$branch" = "master" ]; then
    echo "±"
  else
    echo $branch
  fi
}

hg_bookmark() {
  repo=$($HOME/.zsh/tools/find_parent_dir .hg)
  if [[ -n $repo ]]; then
    bookmark=$(cat $repo/bookmarks.current 2> /dev/null)
    if [[ -n $bookmark ]]; then
      echo $bookmark
    else
      echo "☿"
    fi
  fi
}

get_branch_name() {
  # git
  branch=$(git_branch)
  [[ -n $branch ]] && echo "$branch" && return 0
  # hg
  branch=$(hg_bookmark)
  [[ -n $branch ]] && echo "$branch" && return 0
  return 1
}

branch_prompt_info() {
  branch=$(get_branch_name)
  # output the prompt
  if [[ -n $branch ]]; then
    echo " %{$fg_bold[green]%}$branch%{$reset_color%}"
  fi
}
setopt promptsubst

PS1='${SSH_CONNECTION+"%{$fg[cyan]%}%n@%m "}%{$fg_bold[yellow]%}λ %{$fg_bold[blue]%}%c%{$reset_color%}$(branch_prompt_info) '
