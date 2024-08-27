# 🚀 Git Bash Enhancement Scripts

이 저장소는 Git 워크플로우를 개선하기 위한 Bash 스크립트 모음입니다. 이 스크립트들은 일상적인 Git 작업을 더 효율적이고 사용자 친화적으로 만들어줍니다.

## 📋 목차
- [기능](#-기능)
- [설치 가이드](#-설치-가이드)
  - [요구사항(필수 프로그램)](#요구사항필수-프로그램)
  - [Windows 11/10](#windows-1110)
  - [macOS](#macos)
  - [Linux](#linux)
- [Git Bash Enhancement Scripts 적용 방법](#-git-bash-enhancement-scripts-적용-방법)
- [사용법](#-사용법)
  - [gsb: Git 브랜치 확인 및 체크아웃](#gsb-git-브랜치-확인-및-체크아웃)
  - [ghpr: GitHub PR 목록 조회 및 체크아웃](#ghpr-github-pr-목록-조회-및-체크아웃)
  - [gdb: Git 브랜치 삭제](#gdb-git-브랜치-삭제)
  - [gst: Git stash 목록 확인 및 적용](#gst-git-stash-목록-확인-및-적용)
  - [gscb: Git 브랜치 생성](#gscb-git-브랜치-생성)
  - [gss: 개선된 Git staged, unstaged 확인 기능](#gss-개선된-git-staged-unstaged-확인-기능)
  - [ghgist: GitHub Gist 생성 (구현중)](#ghgist-github-gist-생성-구현중)
  - [glg: Git 로그 확인 및 체크아웃 (구현중)](#glg-git-로그-확인-및-체크아웃-구현중)

## 🛠 기능

1. `gsb`: Git 브랜치 확인 및 체크아웃
2. `ghpr`: GitHub PR 목록 조회 및 체크아웃
3. `ghi`: GitHub 이슈 목록 조회 및 브랜치 생성
4. `gdb`: Git 브랜치 삭제
5. `gst`: Git stash 목록 확인 및 적용
6. `gscb`: Git 브랜치 생성
7. `gss`: Git 상태 확인 기능 개선
8. `ghgist`: GitHub Gist 생성
9. `glg`: Git 로그 확인 기능 개선 및 체크아웃 기능 추가

## 📥 설치 가이드

이 가이드는 Windows 11, macOS 및 Linux에서의 설치 과정을 다룹니다.

### 요구사항(필수 프로그램)
모든 OS 플랫폼의 전제 조건

- Bash 셸 (Windows 사용자는 [Git Bash Shell](https://gitforwindows.org/)을 사용해야 함)
- Git
- [fzf](https://github.com/junegunn/fzf) (대화형 필터링 도구)
- [GitHub CLI](https://cli.github.com/) (`gh` 명령어)

### Windows 11/10

#### Git Bash 설치하기
1. https://gitforwindows.org/ 에서 Git for Windows 다운로드
2. 설치 프로그램 실행 후 안내에 따라 진행
3. 설치 중 "Use Git and optional Unix tools from the Command Prompt" 선택

#### fzf 설치하기
1. Git Bash 열기
2. 다음 명령어 실행:
   ```
   git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
   ~/.fzf/install
   ```

#### GitHub CLI 설치하기
1. https://cli.github.com/ 에서 설치 프로그램 다운로드
2. 설치 프로그램 실행 후 안내에 따라 진행

### macOS

#### Homebrew 설치하기 (아직 설치되지 않은 경우)
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### fzf 설치하기
```
brew install fzf
$(brew --prefix)/opt/fzf/install
```

#### GitHub CLI 설치하기
```
brew install gh
```

### Linux

#### fzf 설치하기
```
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

#### GitHub CLI 설치하기

##### 방법 1 (port 사용)
```
sudo port install gh
```

##### 방법 2 (webi 사용)
```
curl -sS https://webi.sh/gh | sh
```

참고: GitHub CLI 설치 방법은 Linux 배포판에 따라 다를 수 있습니다. 배포판별 구체적인 안내는 공식 GitHub CLI 문서를 참조하세요.

## 🔧 Git Bash Enhancement Scripts 적용 방법

0. **위에 요구사항에 정의한 프로그램들을 설치**

1. 이 저장소를 클론합니다:

2. 스크립트를 `.bashrc` 파일에 추가합니다:

아래 링크에 들어가서 파일 내용을 복사해서 `~/.bashrc`에 넣습니다.</br>
[.bashrc 스크립트 링크](./.bashrc)

```
vi ~/.bashrc
```

3. 변경사항을 적용하기 위해 새 터미널을 열거나 다음 명령어를 실행합니다:

```
source ~/.bashrc
```

## 📘 사용법

각 함수는 터미널에서 직접 호출할 수 있습니다. 예를 들어:

- `gsb`: Git 브랜치 목록을 보고 선택하여 체크아웃합니다.
- `ghpr`: GitHub PR 목록을 보고 선택하여 체크아웃합니다.
- `gdb`: 삭제할 Git 브랜치를 선택합니다.
- `gst`: Git stash 목록을 보고 선택하여 적용, 팝 또는 삭제합니다.
- `gscb`: 새 Git 브랜치를 생성합니다.
- `gss`: 개선된 Git 상태 확인 기능을 사용합니다.
- `ghgist`: 선택한 파일로 GitHub Gist를 생성합니다.
- `glg`: Git 로그를 확인하고 특정 커밋으로 체크아웃합니다.

### gsb: Git 브랜치 확인 및 체크아웃

Git 브랜치 목록을 보고 선택하여 체크아웃합니다.

![gsb 사용 예시](path/to/gsb.gif)

![wezterm-gui_20240827_15h13m_1609](https://github.com/user-attachments/assets/00ebcc1b-3335-4b94-a642-ca17bb622743)

### ghpr: GitHub PR 목록 조회 및 체크아웃

GitHub PR 목록을 보고 선택하여 체크아웃합니다.

![ghpr 사용 예시](path/to/ghpr.gif)

이 기능을 통해 현재 저장소의 PR 목록을 확인하고, 선택한 PR의 브랜치로 쉽게 전환할 수 있습니다.

### gdb: Git 브랜치 삭제

삭제할 Git 브랜치를 선택합니다.

![wezterm-gui_20240827_15h28m_1604](https://github.com/user-attachments/assets/af714f47-feca-4b5f-8ce7-3273b24587a7)

더 이상 필요하지 않은 브랜치를 쉽게 정리할 수 있습니다. 삭제 전 확인 과정을 거쳐 실수를 방지합니다.

### gst: Git stash 목록 확인 및 적용

Git stash 목록을 보고 선택하여 적용, 팝 또는 삭제합니다.

![gst 사용 예시](path/to/gst.gif)

stash된 변경사항을 쉽게 관리하고 적용할 수 있습니다.

### gscb: Git 브랜치 생성

새 Git 브랜치를 생성합니다. 
브랜치를 생성 할 때 타입명/이름-이슈번호 형식으로 만듭니다. github cli를 통해 이슈번호를 확인하고 이를 통해 브랜치를 생성 할 수 있습니다.


브랜치 타입을 선택하고 이름을 입력하여 일관된 형식의 새 브랜치를 빠르게 생성할 수 있습니다.

![wezterm-gui_20240827_15h32m_1608](https://github.com/user-attachments/assets/613d5da2-c4d2-47e4-aa56-7f9a9708d091)


### gss: 개선된 Git staged, unstaged 확인 기능

개선된 Git staged 확인 기능을 사용합니다.

![gss 사용 예시](path/to/gss.gif)

변경된 파일들을 보기 쉽게 표시하고, 각 파일의 diff를 즉시 확인할 수 있습니다.

### ghgist: GitHub Gist 생성 (구현중)

선택한 파일로 GitHub Gist를 생성합니다.

![ghgist 사용 예시](path/to/ghgist.gif)

로컬 파일을 선택하여 빠르게 Gist를 생성할 수 있습니다.

### glg: Git 로그 확인 및 체크아웃 (구현중)

Git 로그를 확인하고 특정 커밋으로 체크아웃합니다.

![glg 사용 예시](path/to/glg.gif)

커밋 히스토리를 그래프 형태로 확인하고, 원하는 커밋으로 쉽게 체크아웃할 수 있습니다.
