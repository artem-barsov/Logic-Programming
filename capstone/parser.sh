#!/usr/bin/env bash

declare -A reg

while read line; do
    IFS=' ' read -ra word <<< "$line"
    case ${word[2]} in INDI|FAM )
        case $tag in
        INDI )
            echo "sex(\"${name}_${surname}\", $sex)."
            reg[$id]="${name}_${surname}"
            unset name surname sex ;;
        FAM )
            for child in ${childs[@]}; do
                echo "parent(\"${reg[$husband]}\", \"${reg[$child]}\")."
                echo "parent(\"${reg[$wife]}\", \"${reg[$child]}\")."
            done
            unset husband wife childs ;;
        esac
        id=${word[1]}
        tag=${word[2]} ;;
    * ) case $tag in
        INDI )
            case ${word[1]} in
                GIVN )        name=${word[2]//[!a-zA-Z]} ;;
                SURN|_MARNM ) surname=${word[2]//[!a-zA-Z]} ;;
                SEX )         sex=${word[2],,} ;;
            esac ;;
        FAM )
            case ${word[1]} in
                HUSB ) husband=${word[2]} ;;
                WIFE ) wife=${word[2]} ;;
                CHIL ) childs+=(${word[2]}) ;;
            esac ;;
        esac ;;
    esac
done < $1 > $2
