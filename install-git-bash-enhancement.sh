#!/bin/bash

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

install_debian() {
    sudo apt-get update
    sudo apt-get install -y git curl
    if ! command_exists fzf; then
        sudo apt-get install -y fzf
    fi
    if ! command_exists gh; then
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt-get update
        sudo apt-get install -y gh
    fi
}

install_mac() {
    if ! command_exists brew; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install git fzf gh
}

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    install_debian
elif [[ "$OSTYPE" == "darwin"* ]]; then
    install_mac
else
    echo "Unsupported operating system"
    exit 1
fi

cat << 'EOF' > ~/.git-bash-enhancement.sh
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
        IFS=$'\n'
        for branch in $branchToDelete; do
            branch=$(echo "$branch" | sed 's/\x1b\[[0-9;]*m//g')  
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

function gscb() {
    local branchTypes=("enhancement" "doc" "bug" "hotfix" "refactor" "test")
    local branchType=$(printf "%s\n" "${branchTypes[@]}" | fzf --header "Select branch type")

    if [ -n "$branchType" ]; then
        read -p "Enter branch name (e.g., 'button-component'): " branchName

        if [ -n "$branchName" ]; then
            branchName=$(echo "$branchName" | tr '[:upper:]' '[:lower:]')

            local issues=$(gh issue list --limit 100 --json number,title --jq '.[] | "\(.number): \(.title)"')
            local selectedIssue=$(echo "$issues" | fzf --header "Select related issue (optional, ESC to skip)")
            
            local issueNumber=""
            if [ -n "$selectedIssue" ]; then
                issueNumber=$(echo $selectedIssue | cut -d':' -f1)
            fi

            local fullBranchName="${branchType}/${branchName}"
            if [ -n "$issueNumber" ]; then
                fullBranchName="${fullBranchName}-${issueNumber}"
            fi

            echo "Branch to be created: $fullBranchName"
            read -p "Create and switch to this branch? (Y/n) " confirmation

            if [[ -z "$confirmation" || "$confirmation" =~ ^[yY]$ ]]; then
                git switch -c "$fullBranchName"
                if [ $? -eq 0 ]; then
                    echo "Successfully created and switched to branch '$fullBranchName'."
                else
                    echo "Failed to create branch '$fullBranchName'."
                fi
            else
                echo "Branch creation cancelled."
            fi
        else
            echo "No branch name provided. Operation cancelled."
        fi
    else
        echo "No branch type selected. Operation cancelled."
    fi
}
EOF

shell_config="$HOME/.bashrc"
if [[ "$SHELL" == *"zsh"* ]]; then
    shell_config="$HOME/.zshrc"
fi

echo "# git-bash-enhancement.sh" >> "$shell_config"
echo "source ~/.git-bash-enhancement.sh" >> "$shell_config"

echo "Installation complete. Please restart your terminal or run 'source $shell_config' to use the new Git helper functions."
