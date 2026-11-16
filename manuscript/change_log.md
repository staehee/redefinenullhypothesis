# Change log — MDPI Stats 투고본

- 작업일: 2026-11-16
- 기준 원고: `redefinenullhypothesis_arxiv.qmd` (commit `3686794`)
- 수정본: `redefinenullhypothesis_stats.qmd` → `redefinenullhypothesis_stats.pdf` (17쪽)
- 함께 수정: `NewHypoTest.bib` (arXiv·journal 원고도 같은 bib을 씀), 재현 코드 `code/` 신규

문장은 필요한 부분만 고쳤습니다. 6.2절은 공식 자체가 틀려서 문단을 교체했습니다.

---

## 1. [필수] 6.2절 표본수 공식 수정

### 무엇이 틀렸나
기존 공식 $n_{c\sigma} = 1/(1/n - c^2)$은 대립가설 하의 추정량 분산에도 $c^2$을 넣은 꼴입니다. 실제로는 대립가설 하에서 $\hat d \sim N(d, 1/n)$이고, $c$는 기각역 $z_{1-\alpha/2}\sqrt{1/n + c^2}$에만 들어갑니다.

### 바꾼 내용
| 위치 | 변경 |
|---|---|
| 6.2절 본문 | 검정력 조건 $d = z_{1-\alpha/2}\sqrt{1/n + c^2} + z_{1-\beta}\sqrt{1/n}$, 반대쪽 꼬리를 무시한 근사라는 점, $s = 1/\sqrt n$, $A = z_{1-\alpha/2}^2 - z_{1-\beta}^2$로 둔 2차식 유도와 근의 공식, $c = 0$이면 기존 공식으로 돌아간다는 점을 넣음. 섹션 라벨 `{#sec-samplesize}` 추가 |
| 6.2절 불가능 조건 | "$1/n \le c^2$" → "$d \le z_{1-\alpha/2}\,c$" (점근 MDE 이하) |
| 6.2절 가정 | $A > 0$, 즉 $z_{1-\alpha/2} > z_{1-\beta}$일 때 성립한다는 조건을 괄호로 명시 (α = 0.05, power 0.8이면 성립) |
| Contributions 2번 | "closed-form sample size formula" 뒤에 6.2절 참조 `(@sec-samplesize)`만 추가. 이제 6.2절이 실제로 closed form이라 문구는 그대로 둠 |
| Figure 6 | `SampleNew()`를 새 공식으로 교체 후 다시 그림. 수직 점근선이 $d = 1.96c$ (0.098, 0.196, 0.392)에 위치. 기존 그림은 $d = 2.80c$에서 끊겨 있었음 |

### 검증
**(a) c = 0 환원:** `all.equal(SampleNew(d, 0), ((z_{0.975}+z_{0.8})/d)^2)` = TRUE (`code/06_fig6_samplesize.R`의 `stopifnot`).

**(b) 검정력 시뮬레이션:** one-sample z-test (σ = 1), n = ceiling(공식값), 50,000회 반복, `set.seed(2024)`.

| d | c | 공식 n | 사용 n | 정확 검정력 (양쪽 꼬리) | 시뮬레이션 검정력 | MC SE | 기존 공식 n | 기존 n의 정확 검정력 |
|---|---|---|---|---|---|---|---|---|
| 0.30 | 0.10 | 198.7 | 199 | 0.8004 | 0.8005 | 0.0018 | 681.8 | 0.991 |
| 0.25 | 0.10 | 533.7 | 534 | 0.8001 | 0.8018 | 0.0018 | 불가능 (음수) | – |
| 0.20 | 0.05 | 292.5 | 293 | 0.8006 | 0.7969 | 0.0018 | 385.2 | 0.881 |
| 0.50 | 0.10 | 39.9 | 40 | 0.8004 | 0.8005 | 0.0018 | 45.8 | 0.845 |
| 0.10 | 0.02 | 998.7 | 999 | 0.8001 | 0.7978 | 0.0018 | 1144.1 | 0.845 |

- 공식 n이 기대값(199, 534, 293, 40, 999)과 일치합니다.
- 시뮬레이션 검정력은 모두 0.80 ± 2 MC SE 안에 있습니다.
- 반대쪽 꼬리를 무시한 근사 오차는 무시할 수준입니다(정확 검정력 0.8001–0.8006).
- 기존 공식은 n을 과대추정해서 검정력이 0.85–0.99로 나오고, (0.25, 0.1)은 실제로 가능한 설계인데도 불가능으로 판정합니다.

---

## 2. 6.1절 정리
- "…important difference (MCID):" 뒤가 비어 있던 문장을 마침표로 끝내고, Table 3을 본문에서 참조하는 문장 1개를 추가했습니다: "@tbl-guidelines lists suggested values of $c$ for several minimum important effect sizes, together with the corresponding asymptotic MDE."
- Table 3 caption 끝에 "The Example column gives illustrative examples only."를 추가했습니다.

---

## 3. 참고문헌

| 항목 | 변경 | 근거 |
|---|---|---|
| Ioannidis 2018 | volume 319, number 14, pages 1429–1430 추가 ("ahead of print" 제거) | Crossref 10.1001/jama.2018.1536: JAMA 319(14):1429 |
| Venables & Ripley 2002 | title을 `Modern Applied Statistics with {S}`로 보호 → PDF에 "S"로 표기 | – |
| Hosmer & Lemeshow 1989 (신규 `hosmer1989applied`) | *Applied Logistic Regression*, 1st ed., Wiley, New York, 1989. 4장 데이터 설명에 "originally described by Hosmer and Lemeshow (1989)" 인용 추가 | R `MASS::birthwt` 도움말의 Source 항목 |

### DOI 추가 (모두 Crossref API로 저자·제목·권호·쪽 확인)

| 항목 | DOI | 상태 |
|---|---|---|
| Lin, Lucas & Shmueli 2013 | 10.1287/isre.2013.0480 | 확인 |
| Sullivan & Feinn 2012 | 10.4300/JGME-D-12-00156.1 | 확인 |
| Box 1980 | 10.2307/2982063 | 확인 (JSTOR DOI; Crossref 등록) |
| Cohen 1994 | 10.1037/0003-066X.49.12.997 | 확인 |
| Hodges & Lehmann 1954 | 10.1111/j.2517-6161.1954.tb00169.x | 확인 |
| Lindley 1957 | 10.1093/biomet/44.1-2.187 | 확인 (출판사 DOI. JSTOR DOI 10.2307/2333251도 존재) |
| Meehl 1967 | 10.1086/288135 | 확인 |

확인하지 못한 DOI는 없습니다.

---

## 4. MDPI back matter (References 앞)
MDPI 템플릿 순서에 맞춰 굵은 글씨 제목의 단락으로 넣었습니다.

| 항목 | 내용 |
|---|---|
| Author Contributions | CRediT 항목 나열, 각 항목 TODO |
| Funding | "This research received no external funding." |
| Institutional Review Board Statement | "Not applicable." (요청 외 추가. MDPI research article 필수 항목이라 넣음. 공개 데이터와 시뮬레이션만 사용) |
| Informed Consent Statement | "Not applicable." (위와 같은 이유로 추가) |
| Data Availability Statement | birthwt는 MASS 패키지에 공개, 코드는 GitHub 저장소(URL TODO) |
| Acknowledgments | 생성형 AI 사용 공개 초안: 원고 구성 검토, 문장 교정, 코드 작성 보조. 저자가 모든 내용을 검증하고 책임진다는 문구. 도구명·버전 TODO. MDPI 정책상 Acknowledgments에 쓰는 형식을 따름 |
| Conflicts of Interest | TODO |

---

## 5. 재현성 (`code/`)
- `00_setup.R` ~ `07_fig7_multiple.R`, `run_all.R`, `README.md`를 만들었습니다. 실행 순서와 seed는 README에 정리했습니다.
- 원고 qmd의 각 시뮬레이션 chunk와 같은 위치에서 `set.seed(2024)`를 호출하므로, 원고와 같은 난수열이 나옵니다.

### 원고와의 일치 확인
원고 qmd를 `knitr::purl`로 실행해 얻은 객체와 `code/output/` CSV를 비교했습니다.

| 대상 | 결과 |
|---|---|
| Table 1 (point / distributional null, 40개 값) | 완전 일치 |
| Figure 4 검정력 (84개 값) | 완전 일치 |
| Table 2 p-value 5개, 4장 요약 통계 | 일치 (CSV 저장에 따른 차이 < 1e−12) |
| Figure 5 rate (156개 값)·5장 본문 수치 | 일치 (차이 < 1e−15) |
| Figure 6 곡선 | 완전 일치 |
| 7.3절 p_req (5.5 × 10⁻³) | 일치 |
| Figures 1–3, 7 | 결정론적 계산이라 같은 코드로 같은 그림이 나옴 |

불일치는 없습니다.

---

## 6. 참고 사항 (1차 작업 시점)
- Abstract 길이, arXiv 원고의 6.2절 오류, MDPI LaTeX 템플릿은 2차 작업에서 처리했습니다(아래 참고).
- 렌더링 시 남는 경고는 ggplot의 축 범위 밖 행 제거 메시지뿐이고, 의도된 동작입니다.

---

# 2차 작업 — MDPI Stats 투고 규정 반영 (2026-11-16)

## A. 단일 소스로 통일 (arXiv 포함)
- `redefinenullhypothesis_arxiv.qmd`/`.tex`/`.pdf`/`_files`를 삭제했습니다(git rm, 이력으로 복구 가능).
- 이제 원고 소스는 `redefinenullhypothesis_stats.qmd` 하나입니다.
- `manuscript/build.sh` 한 번으로 아래를 모두 만듭니다.
  - PDF, DOCX
  - `submission/`
  - arXiv 패키지(`manuscript/arxiv_submission/`, `redefinenullhypothesis_arxiv.zip`): 같은 소스의 LaTeX 출력에서 생성
- 검증: arXiv 패키지를 빈 폴더에서 pdfLaTeX로 두 번 컴파일했고, 오류·overfull·미정의 참조 없이 16쪽이 나왔습니다. tex에 새 표본수 공식이 들어 있고, 기존 공식(`1/n - c^2`, `1/n \leq c^2`)은 0건입니다.
- 참고: arXiv 판에도 MDPI back matter(Supplementary Materials의 저널 링크 TODO 포함)가 그대로 들어갑니다. arXiv 업로드 시점에 저널 링크를 GitHub 링크로 바꾸면 됩니다.

## B. Word 출력
- YAML에 `docx` 형식을 추가했습니다. `quarto render` 한 번으로 PDF와 DOCX가 같이 나옵니다.
- **표:** PDF는 기존 kable(LaTeX), DOCX는 flextable로 출력합니다(`is_pdf` 분기).
  - Table 1: point/distributional null을 spanning header로 표시
  - Table 2: 검정 종류 열을 세로 병합하고 footer에 주석
  - Table 3: 사람이 읽는 열 이름 사용
- **제목 영역:** PDF는 기존 authblk를 그대로 씁니다. DOCX는 MDPI 순서(제목 → 저자 → 소속·교신 → Abstract → Keywords)로 나오게 했습니다.
  - 초록은 YAML `abstract-text` 한 곳에만 쓰고, `{{< meta abstract-text >}}`로 PDF·DOCX가 같이 씁니다.
- **그림:** 본문에 한 번도 인용되지 않던 Figure 1–4, Figure 6, Table 1을 인용했습니다. 그림·표 바로 앞 문단 끝에 `(@fig-…)`, `(@tbl-…)`를 추가해서, 그림이 처음 인용된 문단 바로 뒤에 오게 했습니다.
  - Table 2는 앞 문단에서도 인용하도록 추가했습니다.
  - 6.2(현 4.2)절 끝에는 "@fig-samplesize shows the required sample size for several values of $c$." 한 문장을 추가했습니다.
  - PDF는 `fig-pos: H`, `tbl-pos: H`로 그림·표가 떠다니지 않게 했습니다.
- **DOCX 검증:** pandoc으로 다시 읽어 확인했습니다.
  - 수식은 Word 수식(OMML) 224개로 변환됐습니다.
  - 그림 7개가 모두 캡션과 함께, 처음 인용된 문단 바로 뒤에 있습니다.
  - 표 3개의 캡션·병합·footer가 정상입니다.
  - 상호참조(Figure/Table/Section 링크)와 참고문헌 링크가 정상입니다.
  - LibreOffice가 서버에 없어서 Word 화면 렌더링은 직접 보지 못했습니다. Word에서 한 번 열어 확인해 주십시오.

## C. 섹션 구조 (Stats free format)
| 이전 | 이후 |
|---|---|
| 2 Methods | 2 Materials and Methods (끝에 2.5 Use of Generative AI 추가) |
| 3 Simulation Study (3.1, 3.2) | 3 Results → 3.1 Simulation Study (3.1.1 Type I Error Control, 3.1.2 Power Analysis) |
| 4 Real Data Application | 3.2 Real Data Application |
| 5 Comparison with Equivalence Testing | 3.3 Comparison with Equivalence Testing |
| 6 Practical Guidelines | 4 Practical Guidelines (4.1, 4.2 Sample Size Calculation) |
| 7 Discussion | 5 Discussion (5.1–5.4) |
| 8 Conclusion | 6 Conclusions |
| References | References (번호 없음) |

- 상호참조는 모두 `@sec-` 라벨이라 자동으로 바뀝니다(예: Contributions 2번 → "Section 4.2", Bayesian 절 → "Section 4", TOST 절 → "Section 2.4.5").
- 논문 구성 안내 문단("The remainder of this paper is organized as follows")을 새 구조로 고쳤습니다. Results 장 안의 3.1–3.3을 괄호로 함께 참조합니다.
- PDF·DOCX 모두 미해결 참조(??) 0건입니다.

## D. 생성형 AI 공개
- 2.5절 "Use of Generative AI"를 추가했습니다. 사용한 작업 내용은 TODO로 비워 두었습니다.
- Acknowledgments 문구를 MDPI 권장 형식으로 교체했습니다: "During the preparation of this manuscript, the authors used [TODO: tool name, version] for the purposes of [TODO]. The authors have reviewed and edited the output and take full responsibility for the content of this publication."

## E. Back matter
- 순서: Supplementary Materials → Author Contributions → Funding → Data Availability Statement → Acknowledgments → Conflicts of Interest → References.
- **Supplementary Materials:** "Code S1: R scripts reproducing all simulations, tables, and figures." 다운로드 링크는 저널이 부여하므로 TODO로 두었습니다.
- **Author Contributions, Conflicts of Interest:** 주신 문구를 그대로 넣었습니다.
- **Data Availability:** 코드 링크를 <https://github.com/staehee/redefinenullhypothesis/tree/main/code>로 채웠습니다.
  - 저장소는 이미 공개 상태입니다(비로그인 접근 HTTP 200 확인).
  - 이번 커밋을 push하면 링크가 바로 열립니다.
- 1차 작업에서 넣었던 IRB Statement와 Informed Consent Statement는 주신 순서 목록에 없어서 뺐습니다.

## F. Abstract
| | 공백 기준 단어 수 | 하이픈 분리·수식 1단어 기준 |
|---|---|---|
| 수정 전 | 214 | 205 |
| 수정 후 | 179 | 183 |

- 직접 세신 226단어는 수식 기호를 여러 단어로 센 결과로 보입니다. 어느 방식으로 세도 수정 후는 200단어 아래입니다.
- 수식은 축소 계수 $1/\sqrt{1+nc^2}$와 $1.96c$만 남겼습니다. MDE 식, $H_0$ 식, $c = \tau/\sigma$는 문장으로 풀었습니다.
- 다음 핵심 내용은 그대로 두었습니다: 문제(대표본·point null), 방법(분포형 null), 축소 계수, 1종 오류 성질(분포형 null에서 exact size, point null에서 보수적), MDE 극한, 실제 데이터 예시, TOST 비교.
- 기존 초록의 "(2) sample-size-adaptive power" 항목은 MDE 문장에 합쳤습니다.

## G. 업로드 파일
`submission/` 폴더:
- `manuscript.docx`: 투고 본문
- `manuscript.pdf`: 같은 소스로 만든 PDF
- `supplementary_code.zip`: `code/` 폴더(스크립트 9개와 README, `output/` 제외)

## H. 재현성 재확인
- 섹션 번호 변경에 맞춰 `code/` 주석과 README의 절 번호를 고쳤습니다.
- 출력 파일 이름을 `birthwt_summary.csv`, `multiple_preq.csv`로 바꿨습니다.
- `run_all.R`을 다시 실행해 원고 객체와 대조했고, 1차와 같이 모두 일치합니다(Table 1, Figure 4, Figure 6은 완전 일치, 나머지는 차이 < 1e−12).

## I. 남은 TODO (저자 확인 필요)
- 2.5절 AI 사용 작업 내용
- Acknowledgments의 도구명·버전, 사용 목적
- Supplementary Materials의 저널 다운로드 링크 (게재 시 저널이 부여)
- `redefinenullhypothesis_journal.qmd`와 최초 원고 `redefinenullhypothesis.qmd`는 손대지 않았습니다. 둘 다 예전 표본수 공식을 담고 있으니, 더 쓰지 않을 거면 삭제하는 게 좋겠습니다.

---

# 3차 작업 — TODO 채우기 (2026-11-16)
- **2.5 Use of Generative AI:** 본문을 저자가 준 문구로 교체했습니다(Claude (Anthropic; Claude Opus 5.5) 사용 범위와 저자 검증·책임).
- **Acknowledgments:** 저자가 준 MDPI 형식 문구로 교체했습니다.
- **Supplementary Materials:** 남아 있던 세 번째 TODO("link assigned by the journal")를 MDPI 템플릿의 기본 자리표시자 `www.mdpi.com/xxx/s1`로 바꿨습니다. 실제 링크는 게재 시 편집부가 넣습니다.
- `build.sh`로 PDF, DOCX, `submission/`, arXiv 패키지를 다시 만들었습니다.
- **검증:** "TODO" 문자열이 qmd 소스, `submission/manuscript.pdf`, `submission/manuscript.docx`(word/*.xml 전체), arXiv tex, `supplementary_code.zip` 모두에서 0건입니다.
