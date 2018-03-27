function idea
  if test 0 -eq (count $argv)
    idea_help
    return
  end
  switch $argv[1]
    case home
      cd $FD_IDEA_HOME
    case ls
      find $FD_IDEA_HOME/ -maxdepth 1 -mindepth 1 -type d ! -name '.git'
    case open
      idea_open #$argv[2]
    case create
      idea_create $argv[2] $argv[3]
    case thought
      idea_thought $argv[2]
    case question
      idea_question $argv[2]
    case test
      idea_test $argv[2]
    case subidea
      idea_subidea $argv[2]
    case task
      idea_task $argv[2]
    case summarise
      idea_summarise
    case save
      idea_save
    case sync
      idea_sync
    case consolidate
      idea_consolidate
    case '*'
      idea_help
  end
end

function idea_create -a title summary
    set -U FD_IDEA_CURRENT (idea_create_path $title)
    mkdir -p $FD_IDEA_CURRENT
    echo -e "# IDEA: $title\n\n- $summary" > $FD_IDEA_CURRENT/idea.md
    echo -e "# KNOWN\n\n" > $FD_IDEA_CURRENT/thought.md
    echo -e "# QUESTIONS\n\n" > $FD_IDEA_CURRENT/questions.md
    echo -e "# TESTS\n\n" > $FD_IDEA_CURRENT/tests.md
    echo -e "# SUB-IDEAS\n\n" > $FD_IDEA_CURRENT/subideas.md
    echo -e "# TASKS\n\n" > $FD_IDEA_CURRENT/tasks.md
end

function idea_open -d "select from existing ideas"
  set matches (find $FD_IDEA_HOME/ -maxdepth 1 -mindepth 1 -type d ! -name ".git")
  if test 1 -eq (count $matches) and test -d $matches
    set -U FD_IDEA_CURRENT $matches[1]
    echo "chose option 1"
    return
  end
  set -g dcmd "dialog --stdout --no-tags --menu 'select the file to edit' 20 60 20 " 
  set c 1
  for option in $matches
    set l (get_file_relative_path $option)
    set -g dcmd "$dcmd $c '$l'"
    set c (math $c + 1)
  end
  set choice (eval "$dcmd")
  clear
  if test $status -eq 0
  echo "edit option $choice"
    set -U FD_IDEA_CURRENT $matches[$choice]
  end
end

function idea_thought -a the_fact
    echo -e "- $the_fact" >> $FD_IDEA_CURRENT/thought.md
end

function idea_question -a the_question
    echo -e "- $the_question" >> $FD_IDEA_CURRENT/questions.md
end

function idea_test -a the_test
    echo -e "- $the_test" >> $FD_IDEA_CURRENT/tests.md
end

function idea_subidea -a the_idea
    echo -e "- $the_idea" >> $FD_IDEA_CURRENT/subideas.md
end

function idea_task -a the_task
    echo -e "- $the_task" >> $FD_IDEA_CURRENT/tasks.md
end

function idea_summarise
    cat $FD_IDEA_CURRENT/idea.md
    echo ""
    cat $FD_IDEA_CURRENT/thought.md
    echo ""
    cat $FD_IDEA_CURRENT/questions.md
    echo ""
    cat $FD_IDEA_CURRENT/tests.md
    echo ""
    cat $FD_IDEA_CURRENT/subideas.md
    echo ""
    cat $FD_IDEA_CURRENT/tasks.md
end

function idea_consolidate
    set -l target "$FD_IDEA_HOME"/(basename $FD_IDEA_CURRENT).md
    summarise > $target
end

function idea_save -d "save all new or modified notes locally"
  fishdots_git_save $FD_IDEA_HOME  "prob updates and additions"
end

function idea_sync -d "save all notes to origin repo"
  fishdots_git_sync $FD_IDEA_HOME  "prob updates and additions"
end

function _enter_idea_home
  pushd .
  cd $FD_IDEA_HOME  
end

function _leave_idea_home
  popd
end


function idea_help -d "display usage info"
  echo "Fishdots ideas Usage"
  echo "===================="
  echo "idea <command> [options] [args]"
  echo ""

    echo "idea home"
    echo "  "
    echo""

    echo "idea create"
    echo "  "
    echo""

    echo "idea thought"
    echo "  "
    echo""

    echo "idea question"
    echo "  "
    echo""

    echo "idea test"
    echo "  "
    echo""

    echo "idea subidea"
    echo "  "
    echo""

    echo "idea task"
    echo "  "
    echo""

    echo "idea summarise"
    echo "  "
    echo""

    echo "idea sync"
    echo "  "
    echo""

    echo "idea sync"
    echo "  "
    echo""

    echo "idea consolidate"
    echo "  "
    echo""
end

function idea_create_path -d "USAGE: idea_create_path 'blah' => ~/.ideas/2018-02-21.mojo.md"
    set -l title_slug (string sub -l 32 (string replace " " "_" $argv[1]))
    set -l d (date --iso-8601)
    echo "$FD_IDEA_HOME/$d-$title_slug"
end

