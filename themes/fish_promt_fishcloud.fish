# name: fishcloud
# This theme is based off of the robyrussel fish theme
# You can override some default options in your config.fish:
#   set -g theme_display_git_untracked no

set CLOUD '☁'
set ARROW '➜'

function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  set -l show_untracked (git config --bool bash.showUntrackedFiles)
  set untracked ''
  if [ "$theme_display_git_untracked" = 'no' -o "$show_untracked" = 'false' ]
    set untracked '--untracked-files=no'
  end
  echo (command git status -s --ignore-submodules=dirty $untracked ^/dev/null)
end

function fish_prompt
  set -l last_status $status
  set -l cyan (set_color -o cyan)
  set -l yellow (set_color -o yellow)
  set -l red (set_color -o red)
  set -l blue (set_color -o blue)
  set -l green (set_color -o green)
  set -l normal (set_color normal)
  set -l grey (set_color grey)
  set -l white (set_color white)

  if test $last_status = 0
      set arrow "$cyan$CLOUD"
  else
      set arrow "$red$CLOUD"
  end

# Virtual Environment settings
  if not set -q VIRTUAL_ENV_DISABLE_PROMPT
        set -g VIRTUAL_ENV_DISABLE_PROMPT true
    end
  if test $VIRTUAL_ENV
        printf "(%s)" (set_color blue)(basename $VIRTUAL_ENV)(set_color normal)
    end
  set -l cwd (basename (prompt_pwd))

  if [ (_git_branch_name) ]
    set -l git_branch $cyan(_git_branch_name)
    set git_info "[$git_branch$green]"

    if [ (_is_git_dirty) ]
      set -l dirty "$yellow ✗"
      set git_info "$git_info$dirty"
    else
      set -l clean "$green ✔"
      set git_info "$git_info$clean"
    end
  end

  echo -n -s ' ' $arrow '  ' $green$cwd ' ' $git_info $normal ' '
end

