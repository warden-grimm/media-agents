const fs = require('fs');
const input = 'SEQUENCER_TATE_GPT.json';
const output = 'SEQUENCER_TATE_GPT.cleaned.json';
const s = fs.readFileSync(input, 'utf8');
let out = '';
let inString = false;
let stringQuote = '"';
let escaped = false;
let i = 0;
while (i < s.length) {
  const c = s[i];
  const next = s[i+1];
  if (inString) {
    out += c;
    if (escaped) {
      escaped = false;
    } else if (c === '\\') {
      escaped = true;
    } else if (c === stringQuote) {
      inString = false;
    }
    i++;
    continue;
  }
  // not in string
  if (c === '"' || c === '\'') {
    inString = true;
    stringQuote = c;
    out += c;
    i++;
    continue;
  }
  // detect block comment start
  if (c === '/' && next === '*') {
    // skip until closing */
    i += 2;
    while (i < s.length && !(s[i] === '*' && s[i+1] === '/')) i++;
    i += 2; // skip */
    continue;
  }
  // detect line comment start
  if (c === '/' && next === '/') {
    // skip until end of line
    i += 2;
    while (i < s.length && s[i] !== '\n' && s[i] !== '\r') i++;
    continue;
  }
  out += c;
  i++;
}
fs.writeFileSync(output, out, 'utf8');
// Validate
try {
  JSON.parse(out);
  console.log('CLEAN_OK');
} catch (e) {
  console.log('CLEAN_ERR', e.message);
}
