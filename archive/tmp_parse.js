const fs = require('fs');
const p = 'SEQUENCER_TATE_GPT.cleaned.json';
const s = fs.readFileSync(p, 'utf8');
try {
  JSON.parse(s);
  console.log('OK');
} catch (e) {
  const msg = e.message;
  const m = msg.match(/position (\d+)/i) || msg.match(/at position (\d+)/i);
  let pos = m ? parseInt(m[1], 10) : null;
  let line = 1, col = 1;
  if (pos != null) {
    for (let i = 0; i < pos; i++) {
      if (s[i] === '\n') { line++; col = 1; } else { col++; }
    }
  }
  console.log('ERR', msg);
  if (pos != null) {
    console.log('LINE', line, 'COL', col);
    const start = Math.max(0, pos - 80);
    const end = Math.min(s.length, pos + 80);
    console.log('NEAR>>', s.slice(start, end).replace(/\n/g, '\\n'));
  }
}
