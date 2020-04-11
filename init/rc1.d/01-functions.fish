define_command idea "fishdots plugin for working through ideas"
define_subcommand idea consolidate on_idea_consolidate "Consolidate all of the components of the current idea in a single file"
define_subcommand_nonevented idea create idea_create "<title> <summary> Create a new idea to solve"
define_subcommand_nonevented idea home idea_home "switch to the home folder of the current idea"
define_subcommand idea thought on_idea_thought "Record a thought relating to the current idea"
\define_subcommand_nonevented idea ls idea_ls "List all of the ideas"
define_subcommand_nonevented idea open idea_open "choose an existing idea to work on"
define_subcommand idea question on_idea_question "Record a question to be answered"
define_subcommand_nonevented idea summarise idea_summarise "Summarise everything recorded for the current idea"
define_subcommand idea save on_idea_save "Save all edits locally"
define_subcommand idea sync on_idea_sync "save all edits then Sync to origin"
define_subcommand idea test on_idea_test "Record a Test to perform"
define_subcommand idea task on_idea_task "Record a Task to perform"

function ideaold
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

function idea_create
    input_set title "what is the title"
    input_set summary "what is the summary"

    set -U FD_IDEA_CURRENT (idea_create_path $title)
    mkdir -p "$FD_IDEA_CURRENT"
    echo -e "# IDEA: "$title"\n\n- "$summary > $FD_IDEA_CURRENT/idea.md
    echo -e "# THOUGHTS\n\n" > $FD_IDEA_CURRENT/thoughts.md
    echo -e "# QUESTIONS\n\n" > $FD_IDEA_CURRENT/questions.md
    echo -e "# TESTS\n\n" > $FD_IDEA_CURRENT/tests.md
    echo -e "# TASKS\n\n" > $FD_IDEA_CURRENT/tasks.md
end

function idea_open -d "select from existing ideas"
    fd_item_selector (find $FD_IDEA_HOME/ -maxdepth 1 -mindepth 1 -type d ! -name ".git")
    if set -q fd_selected_item
        set -U FD_IDEA_CURRENT $fd_selected_item
    end
end

function idea_thought -a the_fact -e on_idea_thought
    echo -e "- $the_fact" >> $FD_IDEA_CURRENT/thoughts.md
end

function idea_question -a the_question -e on_idea_question
    echo -e "- $the_question" >> $FD_IDEA_CURRENT/questions.md
end

function idea_test -e on_idea_test -a the_test
    echo -e "- $the_test" >> $FD_IDEA_CURRENT/tests.md
end

function idea_task -e on_idea_task -a the_task
    echo -e "- $the_task" >> $FD_IDEA_CURRENT/tasks.md
end

function idea_summarise
    cat $FD_IDEA_CURRENT/idea.md
    echo ""
    cat $FD_IDEA_CURRENT/thoughts.md
    echo ""
    cat $FD_IDEA_CURRENT/questions.md
    echo ""
    cat $FD_IDEA_CURRENT/tests.md
    echo ""
    cat $FD_IDEA_CURRENT/tasks.md
end

function idea_consolidate -e on_idea_consolidate
    set -l target "$FD_IDEA_HOME"/(basename $FD_IDEA_CURRENT).md
    summarise > $target
end

function idea_save -e on_idea_save -d "save all new or modified notes locally"
  fishdots_git_save $FD_IDEA_HOME  "prob updates and additions"
end

function idea_sync -e on_idea_sync -d "save all notes to origin repo"
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

function idea_create_path -a title -d "USAGE: idea_create_path 'blah' => ~/.ideas/2018-02-21.mojo.md"
    set -l title_slug (to_slug $title)
    set -l d (date --iso-8601)
    echo "$FD_IDEA_HOME/$d-$title_slug"
end

function idea_ls -d 'list all recorded ideas'
    find $FD_IDEA_HOME/ -maxdepth 1 -mindepth 1 -type d ! -name '.git'
end

function idea_home -d 'cd to idea root folder'
  cd $FD_IDEA_HOME
end
