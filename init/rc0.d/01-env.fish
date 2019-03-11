if not set -q FD_IDEA_HOME 
  set -U FD_IDEA_HOME "$HOME/.ideas"
end

if not test -d $FD_IDEA_HOME 
    mkdir -p $FD_IDEA_HOME
end

if not set -q FD_IDEA_CURRENT
    set -U FD_IDEA_CURRENT "unset"
end


