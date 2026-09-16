import hashlib
import importlib.util
import json
from pathlib import Path

import pytest
from pypdf import PdfReader
from reportlab.pdfgen import canvas

spec = importlib.util.spec_from_file_location('worklog', Path(__file__).resolve().parents[2] / 'tools/build_monthly_ai_worklog.py')
worklog = importlib.util.module_from_spec(spec)
spec.loader.exec_module(worklog)


def original(tmp_path):
    path = tmp_path / 'monthly.pdf'
    doc = canvas.Canvas(str(path)); doc.drawString(40, 700, 'ORIGINAL EVIDENCE'); doc.save()
    meta = {'pdf_sha256': worklog.sha(path), 'month': '2026-09', 'issued_at_utc': '2026-09-14T13:20:36+00:00'}
    path.with_suffix('.sources.json').write_text(json.dumps(meta), encoding='utf-8')
    return path


def rows():
    return [{'id': 'd16', 'date': '2026-09-16', 'summary': 'Daily summary', 'evidence': 'PR314', 'limits': 'Not release acceptance'}]


def test_append_preserves_original_and_repeat_is_byte_identical(tmp_path):
    path = original(tmp_path)
    old = PdfReader(path).pages[0].get_contents().get_data()
    worklog.append_daily(path, rows(), {'fixture': 'source-hash'}, 'main-sha')
    pdf = PdfReader(path)
    assert len(pdf.pages) == 2
    assert pdf.pages[0].get_contents().get_data() == old
    assert '2026-09-16' in pdf.pages[1].extract_text()
    first = path.read_bytes(), path.with_suffix('.sources.json').read_bytes()
    worklog.append_daily(path, rows(), {'fixture': 'source-hash'}, 'main-sha')
    assert first == (path.read_bytes(), path.with_suffix('.sources.json').read_bytes())
    meta = json.loads(first[1])
    assert meta['pdf_sha256'] == hashlib.sha256(first[0]).hexdigest()
    assert meta['issued_at_utc'] == '2026-09-14T13:20:36+00:00'
    assert len(meta['updates']) == 1


def test_modified_pdf_is_rejected_without_writing(tmp_path):
    path = original(tmp_path)
    path.write_bytes(path.read_bytes() + b'changed')
    before = path.read_bytes()
    with pytest.raises(ValueError, match='hash'):
        worklog.append_daily(path, rows(), {}, 'main')
    assert path.read_bytes() == before


def test_changed_existing_summary_is_not_silently_replaced(tmp_path):
    path = original(tmp_path)
    worklog.append_daily(path, rows(), {}, 'main')
    changed = rows(); changed[0]['summary'] = 'Changed past claim'
    before = path.read_bytes()
    with pytest.raises(ValueError, match='correction'):
        worklog.append_daily(path, changed, {}, 'main')
    assert path.read_bytes() == before


def test_second_replace_failure_restores_pdf_and_sidecar(tmp_path, monkeypatch):
    path = original(tmp_path)
    sidecar = path.with_suffix('.sources.json')
    before = path.read_bytes(), sidecar.read_bytes()
    real_replace = worklog.os.replace
    def fail_sidecar(source, target):
        if target == sidecar:
            raise OSError('simulated sidecar replace failure')
        real_replace(source, target)
    monkeypatch.setattr(worklog.os, 'replace', fail_sidecar)
    with pytest.raises(OSError, match='simulated'):
        worklog.append_daily(path, rows(), {}, 'main')
    assert before == (path.read_bytes(), sidecar.read_bytes())
    assert not list(tmp_path.glob('*.tmp'))


def test_duplicate_or_wrong_month_rejected_without_touching_pdf(tmp_path):
    path = original(tmp_path)
    before = path.read_bytes()
    with pytest.raises(ValueError, match='Duplicate'):
        worklog.append_daily(path, rows() + rows(), {}, 'main')
    wrong_month = rows(); wrong_month[0]['date'] = '2026-10-01'
    with pytest.raises(ValueError, match='month'):
        worklog.append_daily(path, wrong_month, {}, 'main')
    assert path.read_bytes() == before
