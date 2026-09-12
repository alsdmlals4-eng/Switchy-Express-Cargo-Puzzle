"""Source-bound review PDF; no gameplay writes or synthetic runtime screenshots."""
from pathlib import Path
import json, hashlib, re
from xml.sax.saxutils import escape
from reportlab.pdfgen import canvas
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.lib import colors
from reportlab.lib.styles import ParagraphStyle
from reportlab.platypus import Paragraph, Table, TableStyle
from PIL import Image

ROOT=Path(__file__).resolve().parents[1]
SOURCE=ROOT/'docs/design/SWITCHY_BLUEPRINT_REVIEW_20260911.md'
OUT=ROOT/'output/pdf/SWITCHY_EXPRESS_HUMAN_BLUEPRINT_20260911_REVIEW.pdf'
EVIDENCE=ROOT/'evidence/design/blueprint-20260911'
RUNTIME='evidence/runtime/topdown-family-20260912/'
FAMILY=ROOT/'art/product_assets/topdown_v1/manifest.json'
W,H=960,640
pdfmetrics.registerFont(TTFont('KR',r'C:/Windows/Fonts/malgun.ttf'))
pdfmetrics.registerFont(TTFont('KRB',r'C:/Windows/Fonts/malgunbd.ttf'))
STYLE=ParagraphStyle('body',fontName='KR',fontSize=14,leading=23,wordWrap='CJK',textColor=colors.HexColor('#233c45'))
SMALL=ParagraphStyle('small',parent=STYLE,fontSize=11,leading=17)
CELL=ParagraphStyle('cell',parent=STYLE,fontSize=12,leading=19)
OUT.parent.mkdir(parents=True,exist_ok=True)
EVIDENCE.mkdir(parents=True,exist_ok=True)
c=canvas.Canvas(str(OUT),pagesize=(W,H),pageCompression=1,invariant=1)
c.setTitle('Switchy Express 사람용 블루프린트 · 탑뷰 구현 검토본')
page_no=0
records=[]
used={}
def digest(p):
 data=p.read_bytes()
 # Git may check text out as CRLF on Windows; binary asset identity stays exact.
 if p.suffix in {'.md','.py','.json'}:data=data.replace(b'\r\n',b'\n')
 return hashlib.sha256(data).hexdigest()
def start(title,kind='기획 방향·구현 진행 승인 / 미채택 이미지와 최종 사용자 검수 별도'):
 global page_no
 page_no+=1
 c.setFillColor(colors.HexColor('#f6f1e6'));c.rect(0,0,W,H,fill=1,stroke=0)
 c.setFillColor(colors.HexColor('#19313b'));c.rect(0,H-104,W,104,fill=1,stroke=0)
 c.setFillColor(colors.HexColor('#ceac67'));c.setFont('KR',11);c.drawString(38,H-27,'SWITCHY EXPRESS / 사람용 블루프린트')
 c.setFillColor(colors.white);c.setFont('KRB',24);c.drawString(38,H-64,title)
 c.setFont('KR',10);c.drawString(38,H-87,kind)
 c.setFillColor(colors.HexColor('#647780'));c.setFont('KR',9)
 c.drawString(38,21,f'{page_no:02} · 2026.09.13 · 승인 자산 / 자동 검증 / 최종 사용자 검수를 구분')
 records.append({'page':page_no,'title':title,'kind':kind})
 return H-127
def para(txt,x,y,width=884,style=STYLE):
 p=Paragraph(escape(txt),style);_,h=p.wrap(width,1000)
 if y-h<45:raise ValueError(f'Overflow page {page_no}: {txt[:30]}')
 p.drawOn(c,x,y-h);return y-h-16
def picture(rel,x,y,w,h):
 p=ROOT/rel
 if not p.is_file(): raise FileNotFoundError(p)
 used[rel]=digest(p)
 with Image.open(p) as im: iw,ih=im.size
 scale=min(w/iw,h/ih)
 c.drawImage(str(p),x+(w-iw*scale)/2,y+(h-ih*scale)/2,iw*scale,ih*scale,mask='auto')
def table(rows,y):
 cols=len(rows[0]);data=[[Paragraph(escape(v),CELL) for v in row] for row in rows]
 t=Table(data,colWidths=[884/cols]*cols,hAlign='LEFT')
 t.setStyle(TableStyle([('BACKGROUND',(0,0),(-1,0),colors.HexColor('#dce4e3')),('VALIGN',(0,0),(-1,-1),'TOP'),('TOPPADDING',(0,0),(-1,-1),9),('BOTTOMPADDING',(0,0),(-1,-1),9),('LINEBELOW',(0,0),(-1,-1),.5,colors.HexColor('#c2cbc6'))]))
 _,h=t.wrap(884,1000)
 if y-h<45:raise ValueError(f'Table overflow page {page_no}')
 t.drawOn(c,38,y-h);return y-h-18
def finish():c.showPage()

# Evidence atlas: photographs of current runtime, not invented final screens.
start('화면 아틀라스 · 탑뷰로 연결한 현재 구현','실제 Godot 화면 · 프로그램 입력과 기존 해법으로 검사 / 최종 사용자 검수 별도')
atlas=[('건설 · 승인 탑뷰 가족',RUNTIME+'build.png'),('적재 · 같은 화물의 윗면',RUNTIME+'pickup-2.png'),('결과 · 실제 성공',RUNTIME+'result.png'),('RB12 · 폐기물·노랑·장식',RUNTIME+'board-rb12.png')]
for i,(label,p) in enumerate(atlas):
 x=38+(i%2)*452;y=285-(i//2)*231
 picture(p,x,y,430,207);c.setFont('KRB',12);c.setFillColor(colors.HexColor('#233c45'));c.drawString(x,y-16,label)
finish()

# Actual title and long-list evidence retain their explicit maturity labels.
for title,path,caption in [
 ('RB08 브리핑 · 실제 감속 칸을 보고 판단','evidence/runtime/stage-preview-20260913/rb08.png','실제 선택 맵의 초기 상태. 화물·역·감속 칸을 표시하며 플레이어 선로나 테스트 해법은 공개하지 않는다. 시작하면 동일한 맵을 연다.'),
 ('RB10 브리핑 · 재방문과 폐기물 계획','evidence/runtime/stage-preview-20260913/rb10-postmerge.png','실제 Godot 1280×720 창 캡처. 선택적 적재 질문과 해당 지형을 함께 보여준다. 화면은 판단을 돕고 행동 순서를 강제하지 않는다.'),
 ('RB12 브리핑 · 복합 규칙의 공간 관계','evidence/runtime/stage-preview-20260913/rb12-postmerge.png','실제 맵 데이터와 기존 승인 renderer를 읽기 전용으로 재사용한다. 미리보기는 운행하지 않으며 정사각 칸의 비율을 유지한다.'),
 ('선로 편집 복구 · 전체 철거를 한 번에 취소','evidence/runtime/build-history-20260912/restored.png','현재 Godot에서 실제 마우스 입력으로 복원한 화면. Ctrl+Z / Ctrl+Y / Ctrl+Shift+Z도 같은 경로로 검사. 운행 중에는 사용하지 않는다.'),
 ('메인 화면 · 승인 탑뷰 자산으로 조립',RUNTIME+'title.png','실제 Godot 캡처. 승인된 바탕·열차·선로·오브젝트를 조립한다. 미채택 야간 공방 메인 배경은 사용하지 않는다.'),
 ('T2 브리핑 · 선로 옆의 역',RUNTIME+'lesson-t2.png','실제 T1 연결 검사를 통과한 뒤 열린 T2 화면. 설명 그림은 규칙 안내이며 해당 플레이어의 정답 노선을 뜻하지 않는다.'),
 ('실패 화면 · 같은 시점, 다른 상태',RUNTIME+'failure.png','실제 운행 실패 뒤의 결과 화면. 장식 구성과 실제 결과 판정은 별개이며 결과 문구가 현재 시도를 설명한다.'),
 ('긴 적재 목록 · 이전 UI 표시 검사','evidence/runtime/ui-feedback-20260911/manifest-64.png','2026-09-11의 64개 표시 fixture. TOP 3개 고정 요약 + 전체 목록·스크롤. 현재 탑뷰 자산 또는 실제 64개 적재 운행의 증거는 아니다.')]:
 start(title,'이전 UI 표시 증거 / 새 자산 검증 아님' if 'manifest-64' in path else '현재 브랜치 실제 렌더 / 사용자 최종 검수 아님')
 picture(path,38,125,884,380);para(caption,38,102,884,SMALL);finish()

# Every section is authored in the editable Korean source.
text=SOURCE.read_text(encoding='utf-8')
for part in text.split('\n## ')[1:]:
 lines=part.strip().splitlines();title=lines[0];y=start(title)
 rows=[]
 for line in lines[1:]+['']:
  if line.startswith('|'):
   rows.append(line.strip('|').split('|'));continue
  if rows:y=table(rows,y);rows=[]
  if line.strip():y=para(line,38,y)
 finish()

# Text-native spatial wireframes preserve editable structure, not bitmap replacements.
for name,boxes in [('BUILD 공간 와이어프레임',[('목표 / 현재 비용 / 권장 기준',38,455,884,50),('보드: 연결 포트 · 화물 · 역 서비스 칸',38,135,640,300),('도구 / 회전 / 철거\n선택 상태\n오류 이유',698,135,224,300),('선택 취소 / 출발 가능 상태 / 출발',38,65,884,50)]),('RUN 공간 와이어프레임',[('남은 시간 / 실제 배송 진행',38,455,884,50),('보드: 열차 · 경로 · 현장 적재/하역 · 점유 잠금',38,135,640,300),('TOP 묶음\n나머지 적재물\n정확한 초과 개수',698,135,224,300),('누르는 동안 적재 / 자동 켬·끔 / 일시정지',38,65,884,50)])]:
 start(name,'text-native 정보 구조 · 실제 게임 화면 아님')
 for label,x,y,w,h in boxes:
  c.setStrokeColor(colors.HexColor('#879da5'));c.setFillColor(colors.HexColor('#e5e9e4'));c.rect(x,y,w,h,fill=1)
  para(label.replace('\n',' · '),x+12,y+h-12,w-24,SMALL)
 finish()

assets=[('열차 · 승인된 탑뷰 기준','art/product_assets/night_workshop_v1/train.png','train slot / RIGHT 방향, 진행 방향 회전 / 승인 원본 유지')]
for title,path,caption in assets:
 start(title,'실제 인게임 소비 예정 자산 · 후보/승인 상태는 캡션 참조')
 picture(path,45,125,870,380);para(caption,38,103,884,SMALL);finish()

# A visual asset atlas indexes independent runtime textures; it is not a packed sprite sheet.
family=json.loads(FAMILY.read_text(encoding='utf-8'))
if len(family['assets']) != 13: raise ValueError('Expected the thirteen approved runtime assets')
used[str(FAMILY.relative_to(ROOT)).replace('\\','/')]=digest(FAMILY)
for prefix,label in [('station_','역 · 선로 옆 서비스 오브젝트'),('cargo_','화물 · 정지와 적재가 같은 윗면'),('decoration_','장식 · 비상호작용 탑뷰 가족')]:
 group=[a for a in family['assets'] if a['key'].startswith(prefix)]
 for offset in range(0,len(group),4):
  start('자산 아틀라스 · '+label,'13개 승인 자산의 색인 / 개별 RGBA PNG / 패킹 시트·새 모션 프레임 아님')
  batch=group[offset:offset+4]
  for i,a in enumerate(batch):
   rel='art/product_assets/topdown_v1/'+a['path']
   if digest(ROOT/rel) != a['sha256']: raise ValueError('Manifest mismatch: '+rel)
   if len(batch)==1:
    picture(rel,38,160,884,330)
    para(a['key']+' · '+str(a['dimensions'][0])+'×'+str(a['dimensions'][1])+' · RGBA · 승인 원본 유지',38,130,884,SMALL)
    para('비상호작용 장식. 게임 규칙이나 통행 가능 여부를 그림이 결정하지 않는다. SHA '+a['sha256'][:16],38,100,884,SMALL)
    continue
   x=38+(i%2)*452;y=286-(i//2)*224
   picture(rel,x,y+36,430,157)
   para(a['key']+' · '+str(a['dimensions'][0])+'×'+str(a['dimensions'][1]),x,y+28,430,SMALL)
   para('RGBA · 승인 원본 유지 · SHA '+a['sha256'][:16],x,y+8,430,SMALL)
  finish()

# Screen contracts complement the spatial BUILD/RUN diagrams with actual navigation.
for title,rows in [
 ('메인 → 노선집 → 브리핑 · 화면 계약',[
  ['화면 / 위치','입력과 표시','다음 상태'],
  ['메인 / 제목 영역','승인 로고·배경. UI 문구는 Control 텍스트','시작 또는 노선집'],
  ['노선집 / 스크롤 본문','책 선택 → 스테이지 카드. 잠금·선택·목표 구분','선택한 기존 map_id의 브리핑'],
  ['브리핑 / 실제 맵·목표·핵심 판단','초기 화물·역·지형과 질문; 정답 노선 없음','시작 → 동일 맵 BUILD'],
  ['뒤로 / 고정 내비게이션','현재 상위 화면으로 복귀','해금·진행을 임의 변경하지 않음']]),
 ('정지 → 결과 → 재시도 · 화면 계약',[
  ['현재 상태','플레이어 입력','효과와 보존'],
  ['RUN / UNLOADING','Pause / 메뉴','게임과 연출 정지, 입력 차단'],
  ['PAUSED','계속 운행','동일 상태·연출 프레임에서 재개'],
  ['SUCCESS / FAILURE','Retry','같은 배치 + 새 런타임; 잔류 효과 취소'],
  ['SUCCESS / FAILURE','Edit','같은 배치를 BUILD에서 수정'],
  ['결과 / 종료','상위 화면','결과 문구·원인과 종료 흐름 분리']]),
 ('실행 플로우맵 · 판정과 표시 책임',[
  ['입력','책임 처리','출력 / 다음 흐름'],
  ['선로 편집·실행 취소·다시 실행','BuildSession / Controller / preflight','전체 상태·비용 복원 → 출발 가능 여부'],
  ['출발','start-reachable 네트워크 검사','실패 이유 또는 RUN'],
  ['열차 이동·적재 입력','정확한 화물 칸 pickup → cardinal unload','실제 도메인 변경 → 표시 이벤트'],
  ['배송·시간·경로 끝','FiniteDeliveryLoop','SUCCESS / TIME_EXPIRED / ROUTE_END'],
  ['화면 이벤트','읽기 전용 HUD / renderer / local effects','시각 표시; 규칙·보상 역수정 금지']])]:
 y=start(title,'text-native 플로우·와이어프레임 보조표 / 기존 씬·consumer 기반')
 table(rows,y);finish()

copy={}
for file in ['route_book_01_v1.json','route_book_02_v1.json']:
 local_path=ROOT/'data/localization'/file
 copy.update(json.loads(local_path.read_text(encoding='utf-8'))['strings'])
 used[local_path.relative_to(ROOT).as_posix()]=digest(local_path)
preview_receipt='evidence/runtime/stage-preview-20260913/README.md'
used[preview_receipt]=digest(ROOT/preview_receipt)
for p in sorted((ROOT/'data/maps/route_book').glob('rb*.json')):
 m=json.loads(p.read_text(encoding='utf-8'));n=int(p.stem[2:4]);prefix=f'SX_RB{n:02}'
 y=start(f'스테이지 {n:02} · '+copy[prefix+'_TITLE']['ko'],'기존 실제 맵 데이터 · 전략 설명은 유일한 해법의 증명이 아님')
 y=para(copy[prefix+'_OBJECTIVE']['ko'],38,y)
 rows=[['데이터','현재 값'],['맵 ID',m['map_id']],['격자 / 제한 시간',f"{m['board_size']} / {m['time_limit_seconds']}초"],['시작 / 진입',str(m['start_cell'])+' / '+str(m['incoming_cell'])],['역', '; '.join(str(v['cell'])+' '+v['cargo_type'] for v in m['station_placements'])],['화물','; '.join(str(v['cell'])+' '+v['cargo_type'] for v in m['cargo_placements'])],['주의 칸 / 금지 칸',str(m.get('caution_track_cells',[]))+' / '+str(m.get('blocked_cells',[]))]]
 y=table(rows,y);para('검수: 실제 해법 성공 + 의도한 판단과 대안 행동의 차이. 새 수치·맵 변경 없음. 임의 최적해를 강제하지 않는다.',38,y,884,SMALL)
 used[str(p.relative_to(ROOT)).replace('\\','/')]=digest(p);finish()
 y=start(f'스테이지 {n:02} · 출발 전 판단','실제 게임의 한국어 브리핑 문구 / 정답·최적해 안내가 아님')
 y=para(copy[prefix+'_TITLE']['ko'],38,y)
 y=para(copy[prefix+'_CONTEXT']['ko'],38,y)
 y=para('미리보기 → 화물과 역·지형 관계 확인 → 노선 건설 → 운행 → 결과에서 같은 노선 재시도 또는 수정.',38,y)
 y=para('위 질문은 현재 게임과 같은 문구다. 규칙을 바꾸거나 특정 해법만 허용하는 추가 성공 조건이 아니다.',38,y)
 if n==8:
  y=table([['내부 비교 사례','건설비','자동 입력 시 경과 시간'],['주의 칸 직진','1,100','약 6.52초'],['선택 가능한 주의 칸 우회','1,300','약 7.11초']],y)
  para('두 사례 모두 실제 기본 속도 2.0에서 배송 성공. 이 우회는 더 비싸고 느리므로 균형 잡힌 교환 관계라고 주장하지 않는다. 사람의 플레이 시간·최적해 증명은 아니다.',38,y,884,SMALL)
 finish()

y=start('검증 경계 · 승인과 실행을 구분한다','현재 탑뷰 통일 범위 / 전체 게임·출시 완료 선언 아님')
y=table([['항목','현재 증거','분리되는 판단'],['핵심·상세 규칙·SWOT','기존 승인 방향·규칙 유지','새 코어 의미 변경 권한 없음'],['역·화물·장식 13개','픽셀 승인·정본 등록·실제 소비','조립된 화면의 최종 사용자 판단'],['선로·열차·바탕','승인된 기존 연결 자산 유지','미채택 마스터를 신규 타일로 취급하지 않음'],['적재·정지·복구','네 화물 종류·취소·모션 감소 검사','재미·가독성 자동 승인 아님'],['화면·데이터','현재 실행 캡처·기존 12개 맵','그림은 개별 시도 판정의 근거가 아님'],['출시·권리·실기기','이번 범위 외','별도 증거와 승인 필요']],y)
para('검증 수치와 exact source는 연결된 실행 영수증을 따른다. 최종 사용자 검수와 출시 승인을 PDF 생성 성공으로 대체하지 않는다.',38,y)
finish();c.save()
runtime_receipt=ROOT/RUNTIME/'receipt.json'
receipt={'status':'TOPDOWN_IMPLEMENTATION_REVIEW_FINAL_USER_REVIEW_SEPARATE','pdf':str(OUT.relative_to(ROOT)),'sha256':digest(OUT),'page_count':page_no,'source':str(SOURCE.relative_to(ROOT)),'source_sha256':digest(SOURCE),'generator_sha256':digest(Path(__file__)),'runtime_receipt':str(runtime_receipt.relative_to(ROOT)).replace('\\','/'),'runtime_receipt_sha256':digest(runtime_receipt),'assets_and_maps':used,'pages':records}
receipt['hash_policy']='SHA256_TEXT_MD_PY_JSON_CRLF_TO_LF_BINARY_RAW'
(EVIDENCE/'publication.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps({'pdf':str(OUT),'pages':page_no,'sha256':receipt['sha256']}))
