#!/bin/bash

### DECLARE ###

# CONSTANTS #
defaultdir="${HOME}/scripts"
execdir="${HOME}/.local/share/myutils/scripts"
bold=$(tput bold)
normal=$(tput sgr0)

# VARIABLES #
command="$1"


# ARRAYS #
scriptdirs=("${HOME}/scripts" "${HOME}/.local/share/myutils/scripts")

# FUNCTIONS #

##################################

### MAIN ###

case "$command" in
    list)
        for dir in ${!scriptdirs[@]}
        do
            echo "${bold}${scriptdirs[$dir]}:${normal}"
            ls -p ${scriptdirs[$dir]} | grep -v /
        done

        #echo "${bold}~/scripts:${normal}"
        #find ~/scripts/ -type f -name "*.sh" -printf "%P\n"

        #echo "${bold}~/.local/share/myutils/scripts:${normal}"
        #ls -p ${HOME}/.local/share/myutils/scripts | grep -v /
    ;;

    create)
        if [[ -n "$2" ]]
        then
            scriptname="$2"

            if [[ -n "$3" ]]
            then
                finaldir="3"
            else
                finaldir="$defaultdir"
            fi

            if [[ ! -f "$finaldir"/"$scriptname".sh ]]
            then
                touch "$finaldir"/"$scriptname".sh
                chmod +x "$finaldir"/"$scriptname".sh
                cat ${HOME}/.local/share/myutils/newscript_template.txt > "$finaldir"/"$scriptname".sh
                printf '%s\n' "'"$scriptname".sh' created in '"$finaldir"'"
            else
                echo "${bold}ERROR${normal}: create: A script with this name already exists."
            fi
        else
            echo "${bold}ERROR${normal}: create: Please provide a name for new script."
        fi
    ;;

    move)
        if [[ -n $2 ]]
        then
            scriptname="$2"

            if [[ ! "$scriptname" == *.sh ]]
            then
                scriptname+=.sh
            fi

            if [[ -f "$defaultdir"/"$scriptname" ]]
            then
                mv "$defaultdir"/"$scriptname" "$execdir"/"${scriptname:0:-3}"
                printf '%s\n' "'"$scriptname"' moved into '"$execdir"'"
            else
                printf '%s\n' "'"$defaultdir"/"$scriptname"' does not exist."
            fi
        else
            echo "${bold}ERROR${normal}: move: Please provide a name of script that should be moved."
        fi
    ;;

    exec)
        # for executing scripts in the scriptsfolders from anywhere
        if [[ -n $2 ]]
        then
            scriptname="$2"

            if [[ ! "$scriptname" == *.sh ]]
            then
                scriptname+=.sh
            fi

            if [[ -f "$defaultdir"/"$scriptname" ]]
            then
                echo "Executing '$scriptname'..."
                echo
                bash "$defaultdir"/"$scriptname"
            else
                echo "${bold}ERROR${normal}: exec: Script '"$scriptname"' does not exist in '"$defaultdir"'"
            fi
        else
            echo "${bold}ERROR${normal}: exec: Please provide a name of script that should be executed."
        fi
    ;;

    remove)
        if [[ -n $2 ]]
        then
            scriptname="$2"

            if [[ ! "$scriptname" == *.sh ]]
            then
                scriptname+=.sh
            fi

            if [[ -f "$defaultdir"/"$scriptname" ]]
            then
                read -p "Are you sure you want to remove '"$scriptname"' from '"~/scripts/"'? (Y/n) " confirmremove
                
                if [[ "$confirmremove" == "Y" ]]
                then
                    rm "$defaultdir"/"$scriptname"
                    echo "'"$scriptname"' removed from '"~/scripts/"'!"
                else
                    echo "Aborted!"
                fi
            else
                echo "${bold}ERROR${normal}: exec: Script '"$scriptname"' does not exist in '"$defaultdir"'"
            fi
        else
            echo "${bold}ERROR${normal}: exec: Please provide a name of script that should be removed."
        fi
    ;;

    ""|-h|--help)
        echo "Usage: scriptctl [COMMAND] [OPTIONS]..."
        echo "Controller to manage scripts."
        echo
        echo "Commands:"
        echo "  create          Create new script with template"
        echo "  list            List all scripts in all script folders"
        echo "  move            Move selected scripts into global executable directory"
	    echo "  exec            Execute scripts from anywhere (script must be in script directories)"
        echo "  remove          Remove scripts"
        echo
        echo "Specific usage:"
        echo "  create:         scriptctl create [SCRIPT]"
        echo "  move:           scriptctl move [SCRIPT]"
	    echo "  exec:           scriptctl exec [SCRIPT]"
        echo "  remove:         scriptctl remove [SCRIPT]"
    ;;

    *)
        echo "${bold}ERROR${normal}: invalid command '$command'"
        echo "Try 'scriptctl --help' for more information."
    ;;
esac
