# Git 브랜치 확인 및 체크아웃
function gsb() {
    local branches=$(git branch -a --color=always | grep -v HEAD)
    local selected_branch=$(echo "$branches" | fzf --ansi \
                                                   --preview 'git show --color=always {1}' \
                                                   --height 40% \
                                                   )
    if [ -n "$selected_branch" ]; then
        local branch_name=$(echo "$selected_branch" | sed 's/^..//' | sed 's/^remotes\/origin\///')
        if [[ "$selected_branch" == *"remotes/origin/"* ]]; then
            # If it's a remote branch, create a new local branch tracking the remote
            git switch -c "$branch_name" --track "origin/$branch_name"
        else
            # If it's a local branch, just switch to it
            git switch "$branch_name"
        fi
    else
        echo "No branch selected. Operation cancelled."
    fi
}





# 이슈 목록 조회 및 브랜치 생성
function ghi() {
    # 이슈 목록을 임시 파일에 저장
    local temp_file=$(mktemp)
    gh issue list > "$temp_file"

    # fzf를 사용하여 이슈 선택
    local selected_issue=$(cat "$temp_file" | fzf --preview "gh issue view {1}" \
                                                  --header 'ESC: Exit without creating branch' \
                                                  --height 40% \
                                                  --ansi \
                                                  --cycle)

    # 임시 파일 삭제
    rm "$temp_file"

    # 선택된 이슈가 있으면 상세 정보 출력 및 브랜치 생성 여부 확인
    if [[ -n "$selected_issue" ]]; then
        local issue_number=$(echo "$selected_issue" | awk '{print $1}')
        gh issue view "$issue_number"
        
        read -p "Do you want to create a branch for this issue? (y/N) " create_branch
        if [[ "$create_branch" =~ ^[yY]$ ]]; then
            local branchTypes=("enhancement" "doc" "bug" "hotfix" "refactor" "test")
            local branchType=$(printf "%s\n" "${branchTypes[@]}" | fzf --header "Select branch type")

            if [ -n "$branchType" ]; then
                read -p "Enter branch name: " branchName

                if [ -n "$branchName" ]; then
                    # Convert branch name to lowercase
                    branchName=$(echo "$branchName" | tr '[:upper:]' '[:lower:]')

                    local fullBranchName="${branchType}/${branchName}-${issue_number}"

                    echo "Branch to be created: $fullBranchName"
                    read -p "Create and switch to this branch? (Y/n) " confirmation

                    if [[ -z "$confirmation" || "$confirmation" =~ ^[yY]$ ]]; then
                        git switch -c "$fullBranchName"
                        if [ $? -eq 0 ]; then
                            echo "Successfully created and switched to branch '$fullBranchName'"
                        else
                            echo "Failed to create branch '$fullBranchName'"
                        fi
                    else
                        echo "Branch creation cancelled"
                    fi
                else
                    echo "No branch name provided. Branch creation cancelled."
                fi
            else
                echo "No branch type selected. Branch creation cancelled."
            fi
        else
            echo "Branch creation cancelled."
        fi
    else
        echo "No issue selected. Operation cancelled."
    fi
}



# Git 브랜치 삭제 (로컬 및 리모트)
function gdb() {
    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    local branches=$(git branch | sed 's/^[ *]*//' | while read branch; do
        if [ "$branch" = "$current_branch" ]; then
            echo -e "\033[32m$branch\033[0m"
        else
            echo "$branch"
        fi
    done)
    local branchToDelete=$(echo "$branches" | fzf --multi \
                                                  --header="Select branches to delete (use TAB to select multiple)" \
                                                  --preview 'git log --oneline --graph --color=always {}' \
                                                  --height 40% \
                                                  --preview-window=right:60% \
                                                  --ansi)
    if [ -n "$branchToDelete" ]; then
        IFS=$'\n' # set the field separator to newline
        for branch in $branchToDelete; do
            branch=$(echo "$branch" | sed 's/\x1b\[[0-9;]*m//g')  # Remove ANSI color codes
            echo "Branch to delete: $branch"
            if [ "$branch" = "$current_branch" ]; then
                echo "Cannot delete the current branch. Switching to another branch first."
                local other_branch=$(git branch | grep -v "^\*" | sed 's/^[ ]*//' | head -n 1)
                if [ -n "$other_branch" ]; then
                    git switch "$other_branch"
                    echo "Switched to branch '$other_branch'"
                else
                    echo "No other branch to switch to. Cannot delete the only branch."
                    continue
                fi
            fi
            read -p "Are you sure you want to delete local branch '$branch'? (y/N) " confirmDelete
            if [[ "$confirmDelete" =~ ^[yY]$ ]]; then
                git branch -d "$branch" 2>/dev/null || {
                    echo "Branch '$branch' has unmerged changes. Use -D to force delete. Do you want to force delete? (y/N)"
                    read -r forceDelete
                    if [[ "$forceDelete" =~ ^[yY]$ ]]; then
                        git branch -D "$branch"
                    else
                        continue
                    fi
                }
                
                # Check if a remote branch with the same name exists
                if git ls-remote --exit-code --heads origin "$branch" &>/dev/null; then
                    read -p "A remote branch '$branch' exists. Do you want to delete it too? (y/N) " confirmRemoteDelete
                    if [[ "$confirmRemoteDelete" =~ ^[yY]$ ]]; then
                        git push origin --delete "$branch"
                        echo "Remote branch '$branch' deleted."
                    fi
                fi
            fi
            echo ""
        done
    else
        echo "No branch selected. Operation cancelled."
    fi
}

# Git stash 목록 확인 및 적용
function gst() {
    local stash=$(git stash list | fzf --preview 'git stash show -p {1}')
    if [ -n "$stash" ]; then
        local stashName=$(echo "$stash" | cut -d: -f1)
        local action=$(echo -e "apply\npop\ndrop" | fzf --header "Select action for $stashName")
        if [ -n "$action" ]; then
            git stash "$action" "$stashName"
        fi
    fi
}

# Git 브랜치 생성
function gscb() {
    local branchTypes=("enhancement" "doc" "bug" "hotfix" "refactor" "test")
    local branchType=$(printf "%s\n" "${branchTypes[@]}" | fzf --header "브랜치 타입 선택")

    if [ -n "$branchType" ]; then
        read -p "브랜치 이름을 입력하세요 (예: 'button-component'): " branchName

        if [ -n "$branchName" ]; then
            # 브랜치 이름을 소문자로 변환
            branchName=$(echo "$branchName" | tr '[:upper:]' '[:lower:]')

            # GitHub에서 열린 이슈 가져오기
            local issues=$(gh issue list --limit 100 --json number,title --jq '.[] | "\(.number): \(.title)"')
            local selectedIssue=$(echo "$issues" | fzf --header "관련 이슈 선택 (선택사항, ESC로 건너뛰기)")
            
            local issueNumber=""
            if [ -n "$selectedIssue" ]; then
                issueNumber=$(echo $selectedIssue | cut -d':' -f1)
            fi

            local fullBranchName="${branchType}/${branchName}"
            if [ -n "$issueNumber" ]; then
                fullBranchName="${fullBranchName}-${issueNumber}"
            fi

            echo "생성될 브랜치: $fullBranchName"
            read -p "이 브랜치를 생성하고 전환하시겠습니까? (Y/n) " confirmation

            if [[ -z "$confirmation" || "$confirmation" =~ ^[yY]$ ]]; then
                git switch -c "$fullBranchName"
                if [ $? -eq 0 ]; then
                    echo "브랜치 '$fullBranchName'를 성공적으로 생성하고 전환했습니다."
                else
                    echo "브랜치 '$fullBranchName' 생성에 실패했습니다."
                fi
            else
                echo "브랜치 생성이 취소되었습니다."
            fi
        else
            echo "브랜치 이름이 제공되지 않았습니다. 작업이 취소되었습니다."
        fi
    else
        echo "브랜치 타입이 선택되지 않았습니다. 작업이 취소되었습니다."
    fi
}

# Git 상태 확인 기능 개선
function gss() {
    export -f color_git_status  # 함수를 서브쉘에서 사용할 수 있도록 export

    color_git_status | 
    fzf --preview '
        if [[ {1} == "??" ]]; then
            git diff --no-index /dev/null {2}
        elif [[ {1} == *"D"* ]]; then
            git diff --color=always HEAD {2}
        elif [[ {1} == *"M"* ]]; then
            (git diff --color=always HEAD {2} && echo "\n--- Staged changes ---\n" && git diff --color=always --cached {2}) || git diff --color=always HEAD {2}
        else
            (git diff --color=always --cached {2} && echo "\n--- Unstaged changes ---\n" && git diff --color=always {2}) || git diff --color=always HEAD {2}
        fi
    ' \
    --bind 's:execute(git add {2})+reload(color_git_status)' \
    --bind 'u:execute(git restore --staged {2})+reload(color_git_status)' \
    --bind 'ctrl-r:reload(color_git_status)' \
    --header 's: Stage, u: Unstage, Ctrl-R: Refresh' \
    --height 100% \
    --ansi \
    --multi \
    --info inline \
    --border \
    --prompt "Git Status > "
}

function color_git_status() {
    git status -s | 
    sed -e 's/^M/\x1b[32mM\x1b[0m/' \
        -e 's/^A/\x1b[32mA\x1b[0m/' \
        -e 's/^D/\x1b[32mD\x1b[0m/' \
        -e 's/^R/\x1b[32mR\x1b[0m/' \
        -e 's/^C/\x1b[32mC\x1b[0m/' \
        -e 's/^ M/\x1b[31m M\x1b[0m/' \
        -e 's/^ D/\x1b[31m D\x1b[0m/' \
        -e 's/^ A/\x1b[31m A\x1b[0m/' \
        -e 's/??/\x1b[33m??\x1b[0m/'
}

# Gist 생성
function ghgist() {
    local file=$(fzf --header "Select file to create gist")
    if [ -n "$file" ]; then
        gh gist create "$file"
    else
        echo "No file selected. Operation cancelled."
    fi
}

 

# Git 로그 확인 기능 개선 및 체크 아웃 기능 추가
function glg() {
    git log --oneline --graph --color=always |
    fzf --ansi --no-sort --reverse --tiebreak=index \
        --preview 'git show --color=always {1}' \
        --bind 'ctrl-o:execute(git checkout {1})' \
        --header 'Ctrl-O: Checkout commit' \
        --height 100%

}

