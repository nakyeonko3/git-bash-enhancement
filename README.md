# 🚀 git-bash-enhancement

이 저장소는 Git 워크플로우를 개선하기 위한 Bash 스크립트 모음입니다. 이 스크립트들은 일상적인 Git 작업을 더 효율적이고 사용자 친화적으로 만들어줍니다.
![wezterm-gui_20240827_15h13m_1609](https://github.com/user-attachments/assets/00ebcc1b-3335-4b94-a642-ca17bb622743)


## 📋 목차

- [🚀 git-bash-enhancement](#-git-bash-enhancement)
  - [📋 목차](#-목차)
  - [🛠 기능](#-기능)
  - [📥 설치 가이드](#-설치-가이드)
    - [요구사항(필수 프로그램)](#요구사항필수-프로그램)
  - [📘 사용법](#-사용법)
    - [gsb: Git 브랜치 확인 및 브랜치 변경](#gsb-git-브랜치-확인-및-브랜치-변경)
    - [gdb: Git 브랜치 삭제](#gdb-git-브랜치-삭제)
    - [gscb: Git 브랜치 생성](#gscb-git-브랜치-생성)
  - [삭제 방법](#삭제-방법)

## 🛠 기능

1. `gsb`: Git 브랜치 확인 및 브랜치 변경
2. `ghi`: GitHub 이슈 목록 조회 및 브랜치 생성
3. `gdb`: Git 브랜치 삭제
4. `gscb`: Git 브랜치 생성

## 📥 설치 가이드

아래의 명령어를 입력을 통해 설치 가능함.
아래 명령어 터미널에 입력시 [fzf](https://github.com/junegunn/fzf) (대화형 필터링 도구)와 [GitHub CLI](https://cli.github.com/)도 설치하게 됩니다.

```bash
curl -fsSL https://raw.githubusercontent.com/nakyeonko3/git-bash-enhancement/main/install-git-bash-enhancement.sh | bash
```

### 요구사항(필수 프로그램)

모든 OS 플랫폼의 전제 조건

- Bash 셸 (Windows 사용자는 [Git Bash Shell](https://gitforwindows.org/)을 사용해야 함)
- 또는 Zsh 쉘
- Git

## 📘 사용법

각 함수는 터미널에서 직접 호출할 수 있습니다.

### gsb: Git 브랜치 확인 및 브랜치 변경

Git 브랜치 목록을 보고 선택하여 변경합니다.

![gsb 사용 예시](path/to/gsb.gif)

![wezterm-gui_20240827_15h13m_1609](https://github.com/user-attachments/assets/00ebcc1b-3335-4b94-a642-ca17bb622743)

### gdb: Git 브랜치 삭제

깃 브랜치를 확인하고 삭제를 합니다.

![wezterm-gui_20240827_15h28m_1604](https://github.com/user-attachments/assets/af714f47-feca-4b5f-8ce7-3273b24587a7)

더 이상 필요하지 않은 브랜치를 쉽게 정리할 수 있습니다. 삭제 전 확인 과정을 거쳐 실수를 방지합니다.

### gscb: Git 브랜치 생성

새 Git 브랜치를 생성합니다.
브랜치를 생성 할 때 `타입명/이름-이슈번호` 형식으로 만듭니다.(예시 feature/login-23) github cli를 통해 이슈번호를 확인하고 이를 통해 브랜치를 생성 할 수 있습니다.

브랜치 타입을 선택하고 이름을 입력하여 일관된 형식의 새 브랜치를 빠르게 생성할 수 있습니다.


## 삭제 방법

.bashrc 파일을 열고 해당 내용을 삭제하기

```bash
# git-bash-enhancement.sh
source ~/.git-bash-enhancement.sh
```

그리고 루트 위치의 `~/.git-bash-enhancement.sh` 파일을 삭제하기

```bash
rm ~/.git-bash-enhancement.sh
```
