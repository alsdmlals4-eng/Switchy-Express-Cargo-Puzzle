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
W,H=960,640
pdfmetrics.registerFont(TTFont('KR',r'C:/Windows/Fonts/malgun.ttf'))
pdfmetrics.registerFont(TTFont('KRB',r'C:/Windows/Fonts/malgunbd.ttf'))
STYLE=ParagraphStyle('body',fontName='KR',fontSize=14,leading=23,wordWrap='CJK',textColor=colors.HexColor('#233c45'))
SMALL=ParagraphStyle('small',parent=STYLE,fontSize=11,leading=17)
CELL=ParagraphStyle('cell',parent=STYLE,fontSize=12,leading=19)
OUT.parent.mkdir(parents=True,exist_ok=True)
EVIDENCE.mkdir(parents=True,exist_ok=True)
c=canvas.Canvas(str(OUT),pagesize=(W,H),pageCompression=1,invariant=1)
c.setTitle('Switchy Express 사람용 블루프린트 · 제작 준비 검토본')
page_no=0
records=[]
used={}
def digest(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def start(title,kind='기획 권장안 · 최종 승인 전'):
 global page_no
 page_no+=1
 c.setFillColor(colors.HexColor('#f6f1e6'));c.rect(0,0,W,H,fill=1,stroke=0)
 c.setFillColor(colors.HexColor('#19313b'));c.rect(0,H-104,W,104,fill=1,stroke=0)
 c.setFillColor(colors.HexColor('#ceac67'));c.setFont('KR',11);c.drawString(38,H-27,'SWITCHY EXPRESS / 사람용 블루프린트')
 c.setFillColor(colors.white);c.setFont('KRB',24);c.drawString(38,H-64,title)
 c.setFont('KR',10);c.drawString(38,H-87,kind)
 c.setFillColor(colors.HexColor('#647780'));c.setFont('KR',9)
 c.drawString(38,21,f'{page_no:02} · 2026.09.11 · 기획 / 후보 자산 / 실제 실행 증거를 구분')
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
start('화면 아틀라스 · 현재 구현과 다음 기준','실제 캡처 3장 + 승인 바탕 비교 1장 · 최종 목표 화면 아님')
atlas=[('건설 · 현재 구현','evidence/runtime/night-workshop-20260910/build.png'),('적재 · 현재 실행','evidence/runtime/night-workshop-20260910/pickup-2.png'),('결과 · 즉시 프레임','evidence/runtime/night-workshop-20260910/result.png'),('청회색 바탕 · 일시 비교','evidence/design/night-workshop-surfaces-20260910/board-preview.png')]
for i,(label,p) in enumerate(atlas):
 x=38+(i%2)*452;y=285-(i//2)*231
 picture(p,x,y,430,207);c.setFont('KRB',12);c.setFillColor(colors.HexColor('#233c45'));c.drawString(x,y-16,label)
finish()

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

assets=[('열차 · 승인된 새 가족','art/product_assets/night_workshop_v1/train.png','train slot / RIGHT 방향, 진행 방향 회전 / 원본 유지'),('파랑 역 · 승인된 새 가족','art/product_assets/night_workshop_v1/station_blue.png','station_blue slot / 지면 접지·off-track 서비스 / 재질 기준'),('적재 모션 아틀라스','art/product_assets/night_workshop_v1/cargo_lift.png','4 frames / 448×448 / stride 450 / 60ms / 총 240ms / 파랑 전용'),('선로 연결 마스터 · 준비 상태','evidence/design/night-workshop-assets-20260910/rail-master.png','straight / curve / crossing / switch 예정 / 타일 추출·포트 검증 미완료'),('새 역·화물 가족 · 제작 검사 탈락','evidence/design/blueprint-20260911/object-family.png','RGB 1536×1024 / 실제 알파 없음 / 체크무늬가 구워짐 / 게임용 사용 금지·재제작 필요')]
for title,path,caption in assets:
 start(title,'실제 인게임 소비 예정 자산 · 후보/승인 상태는 캡션 참조')
 picture(path,45,125,870,380);para(caption,38,103,884,SMALL);finish()

copy={}
for file in ['route_book_01_v1.json','route_book_02_v1.json']:
 copy.update(json.loads((ROOT/'data/localization'/file).read_text(encoding='utf-8'))['strings'])
for p in sorted((ROOT/'data/maps/route_book').glob('rb*.json')):
 m=json.loads(p.read_text(encoding='utf-8'));n=int(p.stem[2:4]);prefix=f'SX_RB{n:02}'
 y=start(f'스테이지 {n:02} · '+copy[prefix+'_TITLE']['ko'],'기존 실제 맵 데이터 · 전략 설명은 유일한 해법의 증명이 아님')
 y=para(copy[prefix+'_OBJECTIVE']['ko'],38,y)
 rows=[['데이터','현재 값'],['맵 ID',m['map_id']],['격자 / 제한 시간',f"{m['board_size']} / {m['time_limit_seconds']}초"],['시작 / 진입',str(m['start_cell'])+' / '+str(m['incoming_cell'])],['역', '; '.join(str(v['cell'])+' '+v['cargo_type'] for v in m['station_placements'])],['화물','; '.join(str(v['cell'])+' '+v['cargo_type'] for v in m['cargo_placements'])],['주의 칸 / 금지 칸',str(m.get('caution_track_cells',[]))+' / '+str(m.get('blocked_cells',[]))]]
 y=table(rows,y);para('검수: 실제 해법 성공 + 의도한 판단과 대안 행동의 차이. 새 수치·맵 변경 없음. 임의 최적해를 강제하지 않는다.',38,y,884,SMALL)
 used[str(p.relative_to(ROOT)).replace('\\','/')]=digest(p);finish()

y=start('제작 준비 잔여표 · 완료를 과장하지 않는다','검토본의 현재 경계 · 전체 구현 준비 완료 아님')
y=table([['준비 항목','현재 상태','필요한 후속'],['핵심·상세 규칙·SWOT','기획 검토본 있음','사용자 최종 검토'],['새 역·화물 시트','생성 후보','알파·개별 추출·피벗·크기 검증'],['선로 마스터','기존 연결 그림 있음','타일 추출·포트·회전·조립 검증'],['메인·상태 UI·전체 모션','기획과 기존 자산 참조','신규 가족과 상태군 제작/합성 검토'],['런타임','기존 실행 캡처 참조','승인 후 신규 자산 연결과 실행'],['완전한 구현 착수 패키지','아직 미완료','잔여 자산 및 exact handoff 완성']],y)
para('이 PDF는 읽을 수 있는 중간 검토본이다. 마지막 준비 부족이 닫히기 전 최종 승인 요청용 완성본으로 제시하지 않는다.',38,y)
finish();c.save()
receipt={'status':'INTERMEDIATE_REVIEW_NOT_IMPLEMENTATION_READY','pdf':str(OUT.relative_to(ROOT)),'sha256':digest(OUT),'page_count':page_no,'source':str(SOURCE.relative_to(ROOT)),'source_sha256':digest(SOURCE),'assets_and_maps':used,'pages':records}
(EVIDENCE/'publication.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps({'pdf':str(OUT),'pages':page_no,'sha256':receipt['sha256']}))
