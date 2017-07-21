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
  set -l cyan (set_color -d cyan)
  set -l brcyan (set_color -d brcyan)
  set -l yellow (set_color yellow)
  set -l bryellow (set_color -o bryellow)
  set -l red (set_color red)
  set -l brred (set_color brred)
  set -l blue (set_color blue)
  set -l brblue (set_color -o brblue)
  set -l green (set_color green)
  set -l brgreen (set_color brgreen)
  set -l normal (set_color normal)
  set -l grey (set_color grey)
  set -l white (set_color white)
  set -l brwhite (set_color -o brwhite)

  if test $last_status = 0
      set arrow (set_color -o brwhite)"$CLOUD"
  else
      set arrow "$red$CLOUD"
  end

# Virtual Environment settings
  if not set -q VIRTUAL_ENV_DISABLE_PROMPT
        set -g VIRTUAL_ENV_DISABLE_PROMPT true
    end
  if test $VIRTUAL_ENV
        printf "$brwhite(%s$brwhite)" (set_color brblue)(basename $VIRTUAL_ENV)(set_color normal)
    end
  set -l cwd (basename (prompt_pwd))

  if [ (_git_branch_name) ]
    set -l git_branch (set_color -o brwhite)(_git_branch_name)
    set git_info "[$git_branch$bryellow]"

    if [ (_is_git_dirty) ]
      set -l dirty "$yellow ✗"
      set git_info "$git_info$dirty"
    else
      set -l clean "$green ✔"
      set git_info "$git_info$clean"
    end
  end

  echo -n -s ' ' $arrow '  ' $bryellow$cwd ' ' $git_info ' ' $brwhite
end

