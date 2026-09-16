"""Source-bound monthly work log, not a planning owner or financial certification."""
from __future__ import annotations
import argparse
from collections import Counter
from datetime import datetime, timezone
import hashlib
import json
from io import BytesIO
import os
from pathlib import Path
import subprocess
import tempfile
from xml.sax.saxutils import escape

from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, Image
from PIL import Image as PILImage
from pypdf import PdfReader, PdfWriter

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "docs/reporting/2026-09-worklog-records.json"
REPO_URL = "https://github.com/alsdmlals4-eng/Switchy-Express-Cargo-Puzzle"


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def append_daily(output: Path, summaries: list, hashes: dict, main: str):
    """Append only unseen dated summaries; preserve original pages and publication metadata."""
    sidecar = output.with_suffix('.sources.json')
    original_pdf = output.read_bytes()
    original_meta = sidecar.read_bytes()
    meta = json.loads(original_meta)
    previous_hash = hashlib.sha256(original_pdf).hexdigest()
    if meta['pdf_sha256'] != previous_hash:
        raise ValueError('Existing PDF hash differs from its source receipt')
    applied = dict(meta.get('applied_daily_summaries', {}))
    pending = []
    seen = set()
    for row in summaries:
        identifier = row['id']
        if identifier in seen:
            raise ValueError('Duplicate daily summary ID')
        seen.add(identifier)
        datetime.strptime(row['date'], '%Y-%m-%d')
        if not row['date'].startswith(meta['month'] + '-'):
            raise ValueError('Daily summary month differs from publication')
        digest = hashlib.sha256(json.dumps(row, ensure_ascii=False, sort_keys=True).encode()).hexdigest()
        if identifier in applied and applied[identifier] != digest:
            raise ValueError('Use a new correction ID rather than replacing an existing summary')
        if identifier not in applied:
            pending.append(row)
            applied[identifier] = digest
    if not pending:
        return {'status': 'UNCHANGED', 'pdf_sha256': previous_hash}
    pending.sort(key=lambda row: (row['date'], row['id']))
    korean_font = Path('C:/Windows/Fonts/malgun.ttf')
    font = 'Helvetica'
    if korean_font.is_file():
        pdfmetrics.registerFont(TTFont('WorkKRAppend', str(korean_font)))
        font = 'WorkKRAppend'
    elif any(not json.dumps(row, ensure_ascii=False).isascii() for row in pending):
        raise ValueError('Korean font unavailable; refusing unreadable publication')
    body = ParagraphStyle('daily', fontName=font, fontSize=10, leading=17, wordWrap='CJK', spaceAfter=12)
    title = ParagraphStyle('daily-title', parent=body, fontSize=18, leading=27)
    flow = []
    issued = datetime.now(timezone.utc).isoformat(timespec='seconds')
    for index, row in enumerate(pending):
        if index:
            flow.append(PageBreak())
        for value, style in [(row['date'] + ' / ' + row['id'], title),
                             (row['summary'], body), (row['evidence'], body),
                             (row['limits'], body),
                             ('Recorded / appended (UTC): ' + issued, body)]:
            flow.append(Paragraph(escape(value), style))
    addition = BytesIO()
    original = PdfReader(BytesIO(original_pdf))
    def footer(c, doc):
        c.setFont(font, 8)
        c.drawString(40, 24, 'Switchy Express | Monthly AI work log | Dated additions')
        c.drawRightString(A4[0] - 40, 24, str(len(original.pages) + doc.page))
    SimpleDocTemplate(addition, pagesize=A4, leftMargin=40, rightMargin=40,
                      topMargin=42, bottomMargin=44).build(flow, onFirstPage=footer, onLaterPages=footer)
    writer = PdfWriter()
    writer.append(original)
    writer.append(PdfReader(addition))
    combined = BytesIO(); writer.write(combined)
    pdf_bytes = combined.getvalue()
    if len(PdfReader(BytesIO(pdf_bytes)).pages) <= len(original.pages):
        raise ValueError('No daily pages produced')
    meta['pdf_sha256'] = hashlib.sha256(pdf_bytes).hexdigest()
    meta['updated_at_utc'] = issued
    meta['applied_daily_summaries'] = applied
    meta.setdefault('updates', []).append({
        'appended_at_utc': issued, 'record_ids': [row['id'] for row in pending],
        'previous_pdf_sha256': previous_hash, 'pdf_sha256': meta['pdf_sha256'],
        'source_main': main, 'source_file_sha256': hashes,
        'original_page_count': len(original.pages), 'page_count': len(PdfReader(BytesIO(pdf_bytes)).pages),
    })
    # Stage both complete files before replacing either. Restore the pair on handled failure.
    staged = []
    try:
        for path, content in [(output, pdf_bytes), (sidecar, (json.dumps(meta, ensure_ascii=False, indent=2) + '\n').encode())]:
            with tempfile.NamedTemporaryFile(dir=path.parent, delete=False, suffix='.tmp') as handle:
                handle.write(content)
                staged.append(Path(handle.name))
        os.replace(staged[0], output)
        os.replace(staged[1], sidecar)
    except Exception:
        output.write_bytes(original_pdf)
        sidecar.write_bytes(original_meta)
        raise
    finally:
        for path in staged:
            path.unlink(missing_ok=True)
    return {'status': 'APPENDED', 'pdf_sha256': meta['pdf_sha256'], 'records': len(pending)}


def collect():
    data = json.loads(SOURCE.read_text(encoding="utf-8"))
    main = subprocess.check_output(["git", "rev-parse", "origin/main"], cwd=ROOT, text=True).strip()
    raw = subprocess.check_output(
        ["git", "log", main, "--first-parent", "--since=2026-09-01T00:00:00+09:00",
         "--until=2026-09-30T23:59:59+09:00", "--format=%H%x09%cI%x09%s"],
        cwd=ROOT, text=True, encoding="utf-8")
    commits = []
    for line in raw.splitlines():
        commit, time, subject = line.split("\t", 2)
        commits.append({"commit": commit, "committer_time": time, "subject": subject})
    paths = list(dict.fromkeys([str(SOURCE.relative_to(ROOT))] + data["sources"] + [x["path"] for x in data["images"]]))
    hashes = {}
    for relative in paths:
        path = (ROOT / relative).resolve()
        if not path.is_relative_to(ROOT) or not path.is_file():
            raise ValueError("Missing/out-of-scope evidence: " + relative)
        hashes[relative] = sha(path)
    return data, main, commits, hashes


def build(output: Path):
    if output.exists() or output.with_suffix(".sources.json").exists():
        data, main, commits, hashes = collect()
        print(json.dumps(append_daily(output, data.get('daily_summaries', []), hashes, main)))
        return
    data, main, commits, hashes = collect()
    issued = datetime.now(timezone.utc).isoformat(timespec="seconds")
    pdfmetrics.registerFont(TTFont("WorkKR", "C:/Windows/Fonts/malgun.ttf"))
    pdfmetrics.registerFont(TTFont("WorkBold", "C:/Windows/Fonts/malgunbd.ttf"))
    body = ParagraphStyle("body", fontName="WorkKR", fontSize=10, leading=16, wordWrap="CJK", textColor=colors.HexColor("#223943"), spaceAfter=9)
    small = ParagraphStyle("small", parent=body, fontSize=8, leading=12)
    heading = ParagraphStyle("heading", parent=body, fontName="WorkBold", fontSize=19, leading=28, spaceAfter=16)
    sub = ParagraphStyle("sub", parent=body, fontName="WorkBold", fontSize=12, leading=19, spaceBefore=10)
    flow = []

    def p(text, style=body):
        return Paragraph(escape(str(text)), style)

    def section(title):
        flow.append(p(title, heading))

    def table(rows, widths):
        t = Table([[p(c, small) for c in row] for row in rows], colWidths=widths, repeatRows=1)
        t.setStyle(TableStyle([("BACKGROUND", (0,0), (-1,0), colors.HexColor("#dce8e7")),
            ("VALIGN", (0,0), (-1,-1), "TOP"), ("TOPPADDING", (0,0), (-1,-1), 7),
            ("BOTTOMPADDING", (0,0), (-1,-1), 7), ("LINEBELOW", (0,0), (-1,-1), .4, colors.HexColor("#bdccce"))]))
        flow.append(t)

    section("AI 활용 작업일지·증빙집")
    flow += [p(data["project"], sub), p("2026년 9월 / v" + data["version"], sub),
             p("블루프린트와 별도인 활용 증빙 첨부자료"), Spacer(1,18),
             p(data["coverage"]), p("문서 상태: 내부 대조용 초판 / 제출 완료 아님", sub),
             p("기록 작성·PDF 발행: " + issued + " (UTC)"),
             p("원본 기준 main: " + main, small),
             p("PDF 날짜는 작업 시점을 인증하지 않습니다. Git/CI/실행 기록의 날짜와 수행 내용을 찾아가기 위한 보고서입니다."),
             p("입력 원본 화면·청구 계정·결제 내역의 연결은 미완성입니다. 미확인 항목을 임의로 보완하거나 비용 인정/협약 체결을 주장하지 않습니다."),
             p(data["agreement"]), PageBreak()]
    section("01 / 날짜와 근거를 읽는 방법")
    table([["구분","이 문서의 처리"],["실제 작업일","원본 실행·대화 기록으로 확인한 날짜만 사용. 미확인 세부 시각은 추정하지 않음."],
           ["Git 변경 기록","committer 시각과 commit ID를 보존. AI 사용 시작/종료 시각이나 외부 공증이 아님."],
           ["기록 작성일","이번 발행 시점의 사후 요약. 과거 작업을 지금 수행한 것으로 옮겨 적지 않음."],
           ["증빙 캡처일","원본 timestamp가 없으면 미기재. 파일명/수정시각만으로 확정하지 않음."],
           ["PDF 발행일","보고서를 출력한 날짜. 과거 작업의 날짜를 소급 증명하지 않음."]], [105,410])
    flow += [p("범위와 개인정보", sub), p(data["ai_service"]), p(data["account"]), p(data["billing"]),
             p("협회 지정 양식이 제공되면 그 양식에 맞춰 별도 제출합니다. 본 문서는 지정 양식을 대체하거나 서명·회신·제출을 실행하지 않습니다."), PageBreak()]
    section("02 / 9월 변경 기록 색인")
    counts = Counter(x["committer_time"][:10] for x in commits)
    table([["변경 기록일","main 첫 부모 변경 수","판정"]]+[[d,str(n),"Git 기록. AI 사용·비용 인정 여부 별도"] for d,n in sorted(counts.items())], [95,115,305])
    flow += [Spacer(1,12), p("색인은 현재 origin/main에 도달하는 9월 first-parent 기록만 포함합니다. 일수·commit 수는 AI 사용시간·작업량·정산금액이 아닙니다. 원본 commit 목록은 동봉 sources.json에 수록합니다."),
             p("이번 상세 작업", sub)]
    table([["작업 ID","내용","현재 구분"]]+[[x["id"],x["title"],"본문 상세 및 원본 연결"] for x in data["records"]], [140,250,125])
    flow.append(PageBreak())
    for n, record in enumerate(data["records"], 3):
        section(f"{n:02} / " + record["title"])
        flow += [p(record["id"], sub),p("작업일/기간: " + record["work_date"]),p("기록 방식: 사후 정리 + 현재 관측. 발행일은 표지에 별도 표시."),
                 p("작업 전", sub),p(record["before"]),p("이번 변경", sub),p(record["change"]),
                 p("실제 반영과 검수", sub),p(record["status"]),p("원본 연결", sub),
                 p(record["source"], small),p(REPO_URL + "/pull/" + str(record["pr"]), small),
                 p("관련 commit: " + record["commit"], small),
                 p("AI 입력/계정 근거: 현재 요청 전사와 실행 파일은 보존하되, 과거 세션별 원문 화면 및 청구 계정 연결은 미확인."),
                 PageBreak()]
    section("06 / 실제 결과 화면")
    for entry in data["images"]:
        path = ROOT / entry["path"]
        with PILImage.open(path) as im:
            w,h = im.size
        height = min(230, 515*h/w)
        flow += [Image(str(path), width=height*w/h, height=height), p(entry["caption"], small),
                 p("캡처일: " + entry["capture_date"], small)]
    flow.append(PageBreak())
    section("07 / 입력·AI 서비스·검수 경계")
    flow += [p("사용자 요청 발췌 전사", sub),p(data["prompt_evidence"])]
    for text in data["prompt_transcription"]:
        flow.append(p(text))
    flow += [p("원본 화면을 재구성한 이미지가 아닙니다. 계정/솔루션별 실제 프롬프트 스크린샷 제출 요구를 이 전사만으로 충족했다고 표시하지 않습니다."),
             p("이번 확인 결과", sub),
             p("C1: 기존 main·정확 패키지 검증 기록. C2: 원본 맵과 작성 입력으로 실제 코드·창을 검사. 실패 원인과 남은 화물을 별도 확인. 최종 사용자·실기기·권리·출시는 서로 다른 미완료 경계."),
             p("기능/자산/검증 기록을 게임 전체 완료나 지원사업 인정으로 환산하지 않습니다."),
             p("사용 AI별 찾아보기", sub),p(data["ai_service"]),p(data["account"]),p(data["billing"]),PageBreak()]
    section("08 / 원본 대조와 보완 목록")
    flow += [p("동봉 .sources.json은 아래 파일들의 SHA-256, Git 기록 원문 목록, 발행 시각, PDF SHA-256을 포함합니다. 해시는 동일 바이트 대조 수단이며 작업일 공증은 아닙니다."),
             p("원본의 책임은 저장소에 있고, 이 PDF는 읽기용 파생본입니다. 같은 월에는 기존 파일에 날짜별 요약을 추가하고 기존 sources.json에 변경 이유와 해시를 누적합니다.")]
    table([["원본 파일","SHA-256 앞 16자"]]+[[path,value[:16]] for path,value in hashes.items()], [395,120])
    flow += [p("제출 전 필요한 보완", sub),
             p("실제 원본 프롬프트 화면/원본 세션, 계정별 AI 활용 연결, 프로젝트별 결제 증빙과 중복 없는 참조, 담당자 지정 정산 양식, 협약·지원 기간·크레딧 인정·AI 고지 방식 확인."),
             p("이 자료를 만들면서 이메일 회신·전자서명·대외 제출·공개 배포는 하지 않았습니다.")]
    output.parent.mkdir(parents=True, exist_ok=True)
    def footer(c, doc):
        c.setFont("WorkKR",8);c.setFillColor(colors.HexColor("#577079"))
        c.drawString(40,24,"Switchy Express | AI 활용 작업일지·증빙집 | 내부 대조용")
        c.drawRightString(A4[0]-40,24,str(doc.page))
    SimpleDocTemplate(str(output),pagesize=A4,leftMargin=40,rightMargin=40,topMargin=42,bottomMargin=44).build(flow,onFirstPage=footer,onLaterPages=footer)
    publication={"project":data["project"],"month":data["month"],"version":data["version"],
        "issued_at_utc":issued,"record_written_at_utc":issued,"source_main":main,
        "source_file_sha256":hashes,"git_first_parent_records":commits,
        "scope":data["coverage"],"pdf_sha256":sha(output),"pdf_filename":output.name,
        "legal_or_financial_acceptance":"NOT_VERIFIED","prompt_original_screenshot":"NOT_COLLECTED"}
    output.with_suffix(".sources.json").write_text(json.dumps(publication,ensure_ascii=False,indent=2)+"\n",encoding="utf-8")
    print(json.dumps({"pdf":str(output),"sha256":publication["pdf_sha256"],"git_records":len(commits)},ensure_ascii=False))


if __name__ == "__main__":
    parser=argparse.ArgumentParser()
    parser.add_argument("--output",type=Path,required=True)
    build(parser.parse_args().output)
