#!/usr/bin/env python3
"""Notion에 올릴 본문(.md 또는 problem JSON의 content)의 표기 오류를 게시 전에 잡는다.
사용: tools/lint-notion-content.py <파일 또는 폴더>...   (종료 코드 1 = 문제 있음)
규칙 원본: .claude/rules/content-style.md 「Notion 본문 표기」"""
import sys, re, json, pathlib

BAD = [
    (r'&(?:amp|gt|lt|quot|nbsp|#\d+);', 'HTML 엔티티(&gt; 등) 금지: 비교 기호·&는 백틱 코드 스팬에 그대로 쓴다'),
    (r'\\operatorname|\\mathbin|\\widehat|\\widetilde|\\text\b|\\pmod|\\left|\\right|\\begin|\\end|\\\\\[|\\substack|\\overset|\\underset|\\xrightarrow',
     '렌더링이 불확실한 수식 명령 금지(\\operatorname \\mathbin \\widehat \\text \\pmod \\left \\right \\begin cases 등)'),
    (r'\\\\[A-Za-z]', '이중 이스케이프된 수식(\\\\frac 등)'),
    (r'(?<!\\)\$(?!`)[^$`\n]+\$(?!`)', '$x$ 형식 수식 금지: 인라인 수식은 $`x`$ 형식'),
    (r'\$\$[^\n]+\$\$', '줄 안의 $$…$$ 금지: 블록 수식은 $$ 만 있는 줄 사이에, 줄 안은 $`…`$'),
    (r'[​�]', '깨진/보이지 않는 글자'),
    # 토글 형식(재발 사례): 한 줄 <details><summary>는 Notion에서 \<details\> 글자로 깨진다
    (r'<details[^>\n]*>[ \t]*<summary', '<details>와 <summary>를 같은 줄에 붙임: <details …> 다음 줄에 <summary>…</summary>, 자식은 탭 들여쓰기'),
    (r'\\</?(?:details|summary)\b', '이스케이프된 \\<details/\\<summary 글자(게시 후 fetch에 보이면 토글이 깨진 것)'),
]

def texts(path):
    if path.suffix == '.json':
        j = json.load(open(path, encoding='utf-8'))
        yield path.name, j['content'] if isinstance(j, dict) and 'content' in j else json.dumps(j, ensure_ascii=False)
    elif path.suffix == '.md':
        yield path.name, path.read_text(encoding='utf-8')

def strip_code(t):
    """코드 블록·코드 스팬·$`수식`$ 를 같은 길이의 공백으로 지워 엔티티·$x$ 검사에서 제외한다."""
    blank = lambda m: re.sub(r'[^\n]', ' ', m.group(0))
    t = re.sub(r'```.*?```', blank, t, flags=re.S)
    t = re.sub(r'\$`[^`\n]*`\$', blank, t)
    return re.sub(r'`[^`\n]*`', blank, t)

def tone(name, t):
    """해라체 ~다 종결 비율(서술 줄 기준). 코드·표·캡션·불릿 목표 제외."""
    body = re.sub(r'```.*?```', '', t, flags=re.S)
    body = re.sub(r'<callout icon="🎯".*?</callout>', '', body, flags=re.S)
    body = re.sub(r'## 문제\n.*?(?=## 내 풀이)', '', body, flags=re.S)  # 문제 원문 번역은 예외
    lines = [l.strip() for l in body.split('\n')]
    sents = []
    for l in lines:
        if not l or l.startswith(('<', '#', '|', '*SP', '*교재', '>', '- [', '→', '**문제 해석:**', '**지시 해석:**')): continue
        for x in re.split(r'(?<=[.!?])\s+|\n', l):
            x = x.strip()
            if len(x) > 8: sents.append(x)
    da = [x for x in sents if re.search(r'(?:다|한다|된다|이다|있다|없다|쓴다|본다|나온다)[.]?\s*(?:\(slides? [^)]*\))?\s*$', re.sub(r'[`*\]\)]+$', '', x))]
    ratio = len(da) / max(1, len(sents))
    run = 0; worst = 0
    for x in sents:
        run = run + 1 if x in da else 0; worst = max(worst, run)
    errs = []
    if ratio > 0.30: errs.append(f'{name}: ~다 종결 비율 {ratio:.0%} (30% 이하여야 함, 문장 {len(sents)}개 중 {len(da)}개)')
    if worst > 2: errs.append(f'{name}: ~다 종결이 연속 {worst}문장')
    return errs

def lint(name, t):
    errs = []
    body = t
    for pat, msg in BAD:
        src = strip_code(body) if '엔티티' in msg or '$x$' in msg else body
        # 수식 안의 $`…`$ 는 수식 규칙 검사 대상이므로 원문에서, 엔티티·$x$ 는 코드 제거본에서 검사
        for m in re.finditer(pat, src):
            ln = src[:m.start()].count('\n') + 1
            errs.append(f'{name}:{ln}: {msg}  «{m.group(0)[:40]}»')
    if t.count('```') % 2: errs.append(f'{name}: 코드 펜스(```) 개수가 홀수')
    if len(re.findall(r'(?m)^\s*\$\$\s*$', t)) % 2: errs.append(f'{name}: 블록 수식 $$ 개수가 홀수')
    # NumPy·Pandas 코드의 a[[0, 2]]·df[['열']]은 자리표시가 아니므로 코드 제거본에서 검사
    if re.search(r'\[\[(?!CAPTURE|PROBLEMS|PAGE|VIEW)', strip_code(t)): errs.append(f'{name}: 알 수 없는 [[자리표시]]')
    # 토글 구조: 여닫는 수가 같고, 각 <details …> 줄 바로 다음 줄이 <summary>…</summary>, 그다음 자식은 탭 들여쓰기
    plain = re.sub(r'```.*?```', '', t, flags=re.S)
    opens = re.findall(r'<details\b', plain); closes = re.findall(r'</details>', plain)
    if len(opens) != len(closes): errs.append(f'{name}: <details> {len(opens)}개 / </details> {len(closes)}개 불일치')
    lines = plain.split('\n')
    for i, l in enumerate(lines):
        if re.match(r'\s*<details\b[^>]*>\s*$', l):
            nxt = lines[i + 1] if i + 1 < len(lines) else ''
            if not re.match(r'\s*<summary>.*</summary>\s*$', nxt):
                errs.append(f'{name}:{i + 2}: <details> 다음 줄이 <summary>…</summary> 한 줄이 아님')
            elif i + 2 < len(lines) and lines[i + 2].strip() not in ('', '</details>') and not lines[i + 2].startswith('\t'):
                errs.append(f'{name}:{i + 3}: 토글 자식이 탭으로 들여쓰기되지 않음')
    return errs

bad = 0
TONE = '--tone' in sys.argv
args = [a for a in sys.argv[1:] if a != '--tone']
for a in args:
    p = pathlib.Path(a)
    # 폴더는 하위 폴더까지 본다(problems/w4/*.json). 예전 glob('*.json')은 하위 폴더를 건너뛰어 0건으로 보였음.
    files = [p] if p.is_file() else sorted(f for f in p.rglob('*') if f.suffix in ('.json', '.md') and not f.name.startswith(('created', 'uploads')))
    if not files: print(f'{a}: 검사할 파일 없음'); bad += 1
    for f in files:
        for name, t in texts(f):
            e = lint(name, t) + (tone(name, t) if TONE else [])
            if e: bad += 1; print('\n'.join(e))
print('lint 문제 파일:', bad)
sys.exit(1 if bad else 0)
