// Build CV Format Requests
// Parses CV text and builds Google Docs batchUpdate requests for professional formatting
const documentId = $json.documentId;
let text = '';
try { text = $('Stash Context').first().json.cvRewriteText; } catch(e) {}
if (!text) try { text = $('cvRewriteText (final)').first().json.cvRewriteText; } catch(e) {}
if (!documentId || !text) {
  return [{ json: { documentId: documentId || '', batchUpdateBody: { requests: [] } } }];
}

const lines = text.split('\n');
const requests = [];
const docEnd = text.length + 1;

// Index helpers (Google Docs body starts at index 1)
function ls(n) { let i = 1; for (let j = 0; j < n; j++) i += lines[j].length + 1; return i; }
function le(n) { return ls(n) + lines[n].length; }
function rgb(h) { return { red: parseInt(h.slice(1,3),16)/255, green: parseInt(h.slice(3,5),16)/255, blue: parseInt(h.slice(5,7),16)/255 }; }

// Text style helper
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

// Paragraph style helper
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
  if (o.kwn !== undefined) { ps.keepWithNext = o.kwn; f.push('keepWithNext'); }
  requests.push({ updateParagraphStyle: { range: { startIndex: s, endIndex: e }, paragraphStyle: ps, fields: f.join(',') } });
}

// Pattern detection
const isHdr = (s) => /^[A-Z][A-Z &\/\-,]+$/.test(s) && s.length > 2;
const isBul = (s) => s.startsWith('- ') || s.charCodeAt(0) === 8226;
const isCont = (s) => s.includes('@') || s.split('|').length >= 2;
const hasDt = (s) => /\b(20\d{2}|19\d{2}|Present|Current|Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)/i.test(s);

const entrySec = new Set([
  'PROFESSIONAL EXPERIENCE','EXPERIENCE','WORK EXPERIENCE','EMPLOYMENT HISTORY','CAREER HISTORY',
  'EDUCATION','EDUCATION & CERTIFICATIONS','EDUCATION AND CERTIFICATIONS',
  'QUALIFICATIONS','ACADEMIC QUALIFICATIONS',
  'CERTIFICATIONS','CERTIFICATIONS & LICENSES',
  'VOLUNTEER EXPERIENCE','VOLUNTEERING','PROJECTS','KEY PROJECTS'
]);

// Base styles: Arial 11pt dark, 1.15 line spacing
st(1, docEnd, { fn: 'Arial', sz: 11, c: '#1a1a1a', b: false, i: false });
sp(1, docEnd, { ls: 115 });

let sec = '', lt = null;
for (let i = 0; i < lines.length; i++) {
  const t = lines[i].trim();
  if (!t) { lt = 'gap'; continue; }
  const s = ls(i), e = le(i), pe = Math.min(e + 1, docEnd);

  // Line 0: Candidate name (20pt bold)
  if (i === 0) {
    st(s, e, { sz: 20, b: true, c: '#1a1a1a' });
    sp(s, pe, { sb: 2 });
    lt = 'name'; continue;
  }

  // Contact line (10pt grey centered)
  if (i <= 2 && lt === 'name' && isCont(t)) {
    st(s, e, { sz: 10, c: '#666666' });
    sp(s, pe, { al: 'CENTER', sb: 8 });
    lt = 'contact'; continue;
  }

  // Section header (13pt bold navy + bottom border)
  if (isHdr(t)) {
    st(s, e, { sz: 13, b: true, c: '#1b3a5c' });
    sp(s, pe, {
      sa: 10, sb: 4, kwn: true,
      bb: {
        color: { color: { rgbColor: { red: 0.8, green: 0.8, blue: 0.8 } } },
        width: { magnitude: 0.5, unit: 'PT' },
        padding: { magnitude: 2, unit: 'PT' },
        dashStyle: 'SOLID'
      }
    });
    sec = t; lt = 'header'; continue;
  }

  // Bullet points (indented)
  if (isBul(t)) {
    sp(s, pe, { is: 18, ifl: 4 });
    lt = 'bullet'; continue;
  }

  // Entry-based sections: job title / company detection
  if (entrySec.has(sec)) {
    // Job title: first non-empty line after header or gap
    if (lt === 'header' || lt === 'gap') {
      st(s, e, { b: true });
      sp(s, pe, { sa: 6, kwn: true });
      lt = 'jobTitle'; continue;
    }
    // Company/dates: after job title, contains | or date patterns
    if (lt === 'jobTitle' && (t.includes('|') || hasDt(t))) {
      st(s, e, { sz: 10.5, i: true, c: '#444444' });
      sp(s, pe, { sa: 0, kwn: true });
      lt = 'company'; continue;
    }
  }

  lt = 'body';
}

return [{ json: { documentId, batchUpdateBody: { requests } } }];
