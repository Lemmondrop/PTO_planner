# 월차 관리

월차 제도 전용 개인 휴가 관리 웹앱입니다. GitHub Pages(정적 호스팅)와 Supabase(DB·로그인)로 동작합니다.

- 입사일 기준 근속연도, 수습 기간 뒤 매달 1개 발생 (0년차 9개, 1년차부터 12개)
- 앞으로 생길 월차를 당겨 쓰기, 연도 말 소멸 또는 이월
- 하루, 반차, 여러 날(연휴) 등록. 연휴로 등록할 때 주말과 공휴일은 자동으로 제외
- 2026–2027년 공휴일 포함, 회사 휴일 추가와 제외
- 징검다리 연휴 추천, 백업 파일 저장과 가져오기

## 파일 구성

```
index.html            앱 본체
config.js             Supabase 연결 정보 (직접 입력)
vendor/               Supabase JS 클라이언트 (v2.49.4)
supabase/schema.sql   DB 테이블과 보안 정책
.nojekyll             GitHub Pages 설정용 빈 파일
```

---

## 1. Supabase 준비 (약 5분)

1. https://supabase.com 에 가입한 뒤 **New project**를 만듭니다. Region은 `Northeast Asia (Seoul)`을 추천합니다.
2. 왼쪽 메뉴 **SQL Editor**에 `supabase/schema.sql` 내용을 통째로 붙여 넣고 **Run**을 누릅니다.
3. **Authentication → Users → Add user → Create new user**에서 본인 이메일과 비밀번호를 입력하고 **Auto Confirm User**를 체크합니다.
4. **Authentication → Sign In / Providers**에서 **Allow new users to sign up**을 **끕니다**. 다른 사람이 가입하지 못하게 막는 설정입니다.
5. **Project Settings → API Keys**에서 다음 두 값을 복사합니다.
   - Project URL (`https://xxxx.supabase.co`)
   - **Publishable key** (`sb_publishable_...`). 화면에 없으면 Legacy 탭의 `anon` key를 쓰면 됩니다.
6. `config.js`를 열어 두 값을 바꿔 넣습니다.

```js
window.WOLCHA_CONFIG = {
  supabaseUrl: 'https://xxxx.supabase.co',
  supabaseKey: 'sb_publishable_xxxx'
};
```

> ⚠️ `secret` key나 `service_role` key는 절대 넣지 마세요. Publishable key는 공개되어도 괜찮은 키이고, 데이터는 로그인과 RLS(본인 데이터만 접근하게 하는 정책)로 보호됩니다.

## 2. GitHub에 올리고 Pages로 배포

1. GitHub에서 **New repository**를 만듭니다. 이름은 `PTO_planner`로 하고 (대소문자 그대로) **Public**으로 설정합니다. 무료 계정에서 Pages를 쓰려면 Public이어야 하지만, 공개되는 것은 코드뿐이고 기록은 Supabase에 있습니다.
2. 이 폴더의 파일을 전부 올립니다.
   - **웹에서 올리기:** 저장소 화면의 **Add file → Upload files**에 폴더 안 파일을 끌어다 놓고 Commit합니다. `.nojekyll`처럼 점으로 시작하는 파일이 보이지 않으면 없어도 동작합니다.
   - **git으로 올리기:**
     ```bash
     git init && git add . && git commit -m "월차 관리 첫 배포"
     git branch -M main
     git remote add origin https://github.com/<아이디>/PTO_planner.git
     git push -u origin main
     ```
3. 저장소의 **Settings → Pages → Build and deployment**에서 Source를 `Deploy from a branch`, Branch를 `main` / `/ (root)`로 정하고 **Save**를 누릅니다.
4. 1–2분 뒤 `https://<아이디>.github.io/PTO_planner/`로 접속합니다.
   - 저장소 이름을 `<아이디>.github.io`로 만들면 주소가 `https://<아이디>.github.io/`가 됩니다.
5. (선택) Supabase **Authentication → URL Configuration**의 Site URL에 위 주소를 넣어 둡니다.

## 3. 처음 사용

1. 위 주소로 들어가 1-3에서 만든 이메일과 비밀번호로 로그인합니다.
2. 기존 기록을 옮길 때는 **백업 파일에서 가져오기**(또는 설정 → 백업 가져오기)를 누르고 `wolcha-backup-2026-10-29.json`을 고릅니다. 이 파일은 저장소에 올리지 마세요.
3. 휴대폰에서는 브라우저 메뉴의 **홈 화면에 추가**를 쓰면 앱처럼 쓸 수 있습니다.

## 수정과 유지보수

- **기록 백업:** 설정 → **백업 파일 저장**으로 JSON 파일을 받아 둡니다.
- **공휴일 목록:** 공휴일은 `index.html`의 `BASE_HOL`에 들어 있습니다. 2028년 이후 공휴일은 여기에 추가하거나 앱 설정의 "회사 휴일 조정"으로 넣으면 됩니다.
- **Supabase 무료 플랜:** 7일 동안 접속이 없으면 프로젝트가 일시 정지됩니다. 대시보드에서 **Restore**를 누르면 데이터는 그대로 돌아옵니다.
