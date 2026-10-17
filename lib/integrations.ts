/** Integration boundary: demo adapters must never imply that an external service was called. */
export type IntegrationName = 'payments'|'ai-report-polish'|'scheduling'|'telehealth'|'sms'|'email'|'xero'|'freshsales'|'signing';
export type IntegrationResult<T> = { mode:'demo'; simulated:true; message:string; data:T };
export interface IntegrationAdapter { readonly name:IntegrationName; run<T>(operation:string,input:unknown):Promise<IntegrationResult<T>> }
export class DemoAdapter implements IntegrationAdapter {
 constructor(readonly name:IntegrationName){}
 async run<T>(operation:string,input:unknown):Promise<IntegrationResult<T>> { return {mode:'demo',simulated:true,message:`${this.name} / ${operation} simulated. No external service was contacted.`,data:{operation,input,simulated:true} as T}; }
}
export const integrations:Record<IntegrationName,IntegrationAdapter> = Object.fromEntries((['payments','ai-report-polish','scheduling','telehealth','sms','email','xero','freshsales','signing'] as IntegrationName[]).map(name=>[name,new DemoAdapter(name)])) as Record<IntegrationName,IntegrationAdapter>;
