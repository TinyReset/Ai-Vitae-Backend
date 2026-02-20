// Build Cover Letter Format Requests
// Simple formatting: Arial 11pt, 1.15 spacing, 8pt paragraph gaps, bold sign-off name
const documentId = $json.documentId;
let text = '';
try { text = $('Capture Cover Letter').first().json.coverLetterText; } catch(e) {}
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
  requests.push({ updateParagraphStyle: { range: { startIndex: s, endIndex: e }, paragraphStyle: ps, fields: f.join(',') } });
}

// Base styles: Arial 11pt, 1.15 line spacing
st(1, docEnd, { fn: 'Arial', sz: 11, c: '#1a1a1a', b: false, i: false });
sp(1, docEnd, { ls: 115 });

// 8pt paragraph spacing for non-empty paragraphs
for (let i = 0; i < lines.length; i++) {
  if (!lines[i].trim()) continue;
  const s = ls(i), e = le(i), pe = Math.min(e + 1, docEnd);
  sp(s, pe, { sb: 8 });
}

// Bold the last non-empty line (candidate name sign-off)
for (let i = lines.length - 1; i >= 0; i--) {
  if (lines[i].trim()) {
    st(ls(i), le(i), { b: true });
    break;
  }
}

return [{ json: { documentId, batchUpdateBody: { requests } } }];
