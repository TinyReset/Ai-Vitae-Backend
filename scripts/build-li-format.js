// Build LinkedIn Format Requests
// Similar to CV but with LinkedIn-specific title (16pt) and section structure
const documentId = $json.documentId;
let text = '';
try { text = $('Format LinkedIn Text').first().json.formattedLinkedinText; } catch(e) {}
if (!text) try { text = $('Capture LinkedIn').first().json.linkedinProfileText; } catch(e) {}
if (!documentId || !text) {
  return [{ json: { documentId: documentId || '', batchUpdateBody: { requests: [] } } }];
}

const lines = text.split('\n');
const requests = [];
const docEnd = text.length + 1;

function ls(n) { let i = 1; for (let j = 0; j < n; j++) i += lines[j].length + 1; return i; }
function le(n) { return ls(n) + lines[n].length; }
function rgb(h) { return { red: parseInt(h.slice(1,3),16)/255, green: parseInt(h.slice(3,5),16)/255, blue: parseInt(h.slice(5,7),16)/255 }; }

function st(s, e, o) {
  if (s >= e) return;
  const ts = {}, f = [];
  if (o.b !== undefined) { ts.bold = o.b; f.push('bold'); }
  if (o.i !== undefined) { ts.italic = o.i; f.push('italic'); }
  if (o.sz) { ts.fontSize = { magnitude: o.sz, unit: 'PT' }; f.push('fontSize'); }
  if (o.fn) { ts.weightedFontFamily = { fontFamily: o.fn }; f.push('weightedFontFamily'); }
  if (o.c) { ts.foregroundColor = { color: { rgbColor: rgb(o.c) } }; f.push('foregroundColor'); }
  requests.push({ updateTextStyle: { range: { startIndex: s, endIndex: e }, textStyle: ts, fields: f.join(',') } });
}

function sp(s, e, o) {
  if (s >= e) return;
  const ps = {}, f = [];
  if (o.al) { ps.alignment = o.al; f.push('alignment'); }
  if (o.sa !== undefined) { ps.spaceAbove = { magnitude: o.sa, unit: 'PT' }; f.push('spaceAbove'); }
  if (o.sb !== undefined) { ps.spaceBelow = { magnitude: o.sb, unit: 'PT' }; f.push('spaceBelow'); }
  if (o.ls) { ps.lineSpacing = o.ls; f.push('lineSpacing'); }
  if (o.is !== undefined) { ps.indentStart = { magnitude: o.is, unit: 'PT' }; f.push('indentStart'); }
  if (o.ifl !== undefined) { ps.indentFirstLine = { magnitude: o.ifl, unit: 'PT' }; f.push('indentFirstLine'); }
  if (o.bb) { ps.borderBottom = o.bb; f.push('borderBottom'); }
  requests.push({ updateParagraphStyle: { range: { startIndex: s, endIndex: e }, paragraphStyle: ps, fields: f.join(',') } });
}

const isHdr = (s) => /^[A-Z][A-Z &\/\-,]+$/.test(s) && s.length > 2;
const isBul = (s) => s.startsWith('- ') || s.charCodeAt(0) === 8226;
const hasDt = (s) => /\b(20\d{2}|19\d{2}|Present|Current|Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)/i.test(s);

const entrySec = new Set([
  'EXPERIENCE','WORK EXPERIENCE','PROFESSIONAL EXPERIENCE',
  'EDUCATION','CERTIFICATIONS','VOLUNTEER EXPERIENCE'
]);

// Base styles: Arial 11pt dark, 1.15 line spacing
st(1, docEnd, { fn: 'Arial', sz: 11, c: '#1a1a1a', b: false, i: false });
sp(1, docEnd, { ls: 115 });

let sec = '', lt = null, titleDone = false;
for (let i = 0; i < lines.length; i++) {
  const t = lines[i].trim();
  if (!t) { lt = 'gap'; continue; }
  const s = ls(i), e = le(i), pe = Math.min(e + 1, docEnd);

  // First non-empty line or "LINKEDIN PROFILE OPTIMIZATION" = title (16pt bold)
  if (!titleDone && (i === 0 || t === 'LINKEDIN PROFILE OPTIMIZATION')) {
    st(s, e, { sz: 16, b: true, c: '#1a1a1a' });
    sp(s, pe, { sb: 6 });
    titleDone = true;
    lt = 'title'; continue;
  }

  // Section header (13pt bold navy + bottom border)
  if (isHdr(t)) {
    st(s, e, { sz: 13, b: true, c: '#1b3a5c' });
    sp(s, pe, {
      sa: 10, sb: 4,
      bb: {
        color: { color: { rgbColor: { red: 0.8, green: 0.8, blue: 0.8 } } },
        width: { magnitude: 0.5, unit: 'PT' },
        padding: { magnitude: 2, unit: 'PT' },
        dashStyle: 'SOLID'
      }
    });
    sec = t; lt = 'header'; continue;
  }

  // Bullet points
  if (isBul(t)) {
    sp(s, pe, { is: 18, ifl: 4 });
    lt = 'bullet'; continue;
  }

  // Entry-based sections: job title / company detection
  if (entrySec.has(sec)) {
    if (lt === 'header' || lt === 'gap') {
      st(s, e, { b: true });
      sp(s, pe, { sa: 6 });
      lt = 'jobTitle'; continue;
    }
    if (lt === 'jobTitle' && (t.includes('|') || hasDt(t))) {
      st(s, e, { sz: 10.5, i: true, c: '#444444' });
      sp(s, pe, { sa: 0 });
      lt = 'company'; continue;
    }
  }

  lt = 'body';
}

return [{ json: { documentId, batchUpdateBody: { requests } } }];
