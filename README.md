# Git Workflow Enhancement Scripts

이 저장소는 Git 워크플로우를 개선하기 위한 Bash 스크립트 모음입니다. 이 스크립트들은 일상적인 Git 작업을 더 효율적이고 사용자 친화적으로 만들어줍니다.

## 기능

1. `gsb`: Git 브랜치 확인 및 체크아웃
2. `ghpr`: GitHub PR 목록 조회 및 체크아웃
3. `ghi`: GitHub 이슈 목록 조회 및 브랜치 생성
4. `gdb`: Git 브랜치 삭제
5. `gst`: Git stash 목록 확인 및 적용
6. `gscb`: Git 브랜치 생성
7. `gss`: Git 상태 확인 기능 개선
8. `ghgist`: GitHub Gist 생성
9. `glg`: Git 로그 확인 기능 개선 및 체크아웃 기능 추가

## 요구 사항

- Bash 쉘
- Git
- [fzf](https://github.com/junegunn/fzf) (대화형 필터링 도구)
- [GitHub CLI](https://cli.github.com/) (`gh` 명령어)
- [Starship](https://starship.rs/) or [Oh My Zsh](https://ohmyz.sh/) (선택사항, 프롬프트 커스터마이징)


### fzf 설치 방법
```
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```
### gh 설치 방법
리눅스에서 gh 설치 방법1
```
sudo port install gh
```
리눅스에서 gh 설치 방법2
```
curl -sS https://webi.sh/gh | sh
```
맥에서 설치 방법
```
brew install gh
```

## 설치

0. **위에 요구사항에 정의한 프로그램들을 설치**

1. 이 저장소를 클론합니다:

2. 스크립트를 `.bashrc` 파일에 추가합니다:

현재 리포에 있는 `.bashrc`를 사용하시면 됩니다.
[.bashrc 스크립트 링크](./.bashrc)

3. 변경사항을 적용하기 위해 새 터미널을 열거나 다음 명령어를 실행합니다:

```
source ~/.bashrc
```

## 사용법

각 함수는 터미널에서 직접 호출할 수 있습니다. 예를 들어:

- `gsb`: Git 브랜치 목록을 보고 선택하여 체크아웃합니다.
- `ghpr`: GitHub PR 목록을 보고 선택하여 체크아웃합니다.
- `ghi`: GitHub 이슈 목록을 보고 선택하여 관련 브랜치를 생성합니다.
- `gdb`: 삭제할 Git 브랜치를 선택합니다.
- `gst`: Git stash 목록을 보고 선택하여 적용, 팝 또는 삭제합니다.
- `gscb`: 새 Git 브랜치를 생성합니다.
- `gss`: 개선된 Git 상태 확인 기능을 사용합니다.
- `ghgist`: 선택한 파일로 GitHub Gist를 생성합니다.
- `glg`: Git 로그를 확인하고 특정 커밋으로 체크아웃합니다.

### gsb: Git 브랜치 확인 및 체크아웃

Git 브랜치 목록을 보고 선택하여 체크아웃합니다.

![gsb 사용 예시](path/to/gsb.gif)

이 기능을 사용하면 로컬 및 원격 브랜치 목록을 쉽게 탐색하고 선택할 수 있습니다. 선택한 브랜치로 즉시 체크아웃됩니다.

### ghpr: GitHub PR 목록 조회 및 체크아웃

GitHub PR 목록을 보고 선택하여 체크아웃합니다.

![ghpr 사용 예시](path/to/ghpr.gif)

이 기능을 통해 현재 저장소의 PR 목록을 확인하고, 선택한 PR의 브랜치로 쉽게 전환할 수 있습니다.

### ghi: GitHub 이슈 목록 조회 및 브랜치 생성

GitHub 이슈 목록을 보고 선택하여 관련 브랜치를 생성합니다.

![ghi 사용 예시](path/to/ghi.gif)

선택한 이슈에 대한 새 브랜치를 빠르게 생성할 수 있어, 이슈 트래킹과 개발 작업을 연결하는 데 유용합니다.

### gdb: Git 브랜치 삭제

삭제할 Git 브랜치를 선택합니다.

![gdb 사용 예시](path/to/gdb.gif)

더 이상 필요하지 않은 브랜치를 쉽게 정리할 수 있습니다. 삭제 전 확인 과정을 거쳐 실수를 방지합니다.

### gst: Git stash 목록 확인 및 적용

Git stash 목록을 보고 선택하여 적용, 팝 또는 삭제합니다.

![gst 사용 예시](path/to/gst.gif)

stash된 변경사항을 쉽게 관리하고 적용할 수 있습니다.

### gscb: Git 브랜치 생성

새 Git 브랜치를 생성합니다.

![gscb 사용 예시](path/to/gscb.gif)

브랜치 타입을 선택하고 이름을 입력하여 일관된 형식의 새 브랜치를 빠르게 생성할 수 있습니다.

### gss: 개선된 Git 상태 확인 기능

개선된 Git 상태 확인 기능을 사용합니다.

![gss 사용 예시](path/to/gss.gif)

변경된 파일들을 보기 쉽게 표시하고, 각 파일의 diff를 즉시 확인할 수 있습니다.

### ghgist: GitHub Gist 생성

선택한 파일로 GitHub Gist를 생성합니다.

![ghgist 사용 예시](path/to/ghgist.gif)

로컬 파일을 선택하여 빠르게 Gist를 생성할 수 있습니다.

### glg: Git 로그 확인 및 체크아웃

Git 로그를 확인하고 특정 커밋으로 체크아웃합니다.

![glg 사용 예시](path/to/glg.gif)

커밋 히스토리를 그래프 형태로 확인하고, 원하는 커밋으로 쉽게 체크아웃할 수 있습니다.
