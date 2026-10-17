import test from 'node:test';
import assert from 'node:assert/strict';
// Source-level safety checks are kept dependency-free and run in any Node environment.
const fs = await import('node:fs');
const workflow = fs.readFileSync(new URL('../lib/workflow.ts', import.meta.url),'utf8');
test('final report release is guarded by QC 2 and both practitioner signatures',()=>{
 assert.match(workflow,/if\(c\.qc2!=='Passed'\|\|c\.applicants\.some\(a=>!a\.psychiatristSigned\|\|!a\.gpSigned\)\)/);
});
test('partner cases are modeled with per-applicant report and consent states',()=>{
 const types=fs.readFileSync(new URL('../lib/types.ts',import.meta.url),'utf8');
 assert.match(types,/applicants: Applicant\[\]/); assert.match(types,/consent:/); assert.match(types,/psychiatristSigned/); assert.match(types,/gpSigned/); assert.match(types,/reportExpiry/);
});
test('integration adapters explicitly mark actions as simulated',()=>{
 const integrations=fs.readFileSync(new URL('../lib/integrations.ts',import.meta.url),'utf8');
 assert.match(integrations,/simulated:true/); assert.match(integrations,/No external service was contacted/);
});
