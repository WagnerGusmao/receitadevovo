/**
 * Máscaras de formatação para formulários
 */

/**
 * Formata número de WhatsApp
 * @param value - Valor a ser formatado
 * @returns Valor formatado (00) 00000-0000 ou (00) 0000-0000
 */
export function formatWhatsApp(value: string): string {
  const cleaned = value.replace(/\D/g, '');
  
  if (cleaned.length <= 10) {
    // Formato: (00) 0000-0000
    return cleaned.replace(/^(\d{2})(\d{0,4})(\d{0,4}).*/, (_, p1, p2, p3) => {
      let formatted = '';
      if (p1) formatted += `(${p1}`;
      if (p2) formatted += `) ${p2}`;
      if (p3) formatted += `-${p3}`;
      return formatted;
    });
  }
  
  // Formato: (00) 00000-0000
  return cleaned.replace(/^(\d{2})(\d{0,5})(\d{0,4}).*/, (_, p1, p2, p3) => {
    let formatted = '';
    if (p1) formatted += `(${p1}`;
    if (p2) formatted += `) ${p2}`;
    if (p3) formatted += `-${p3}`;
    return formatted;
  });
}

/**
 * Formata CPF
 * @param value - Valor a ser formatado
 * @returns Valor formatado 000.000.000-00
 */
export function formatCPF(value: string): string {
  const cleaned = value.replace(/\D/g, '');
  
  return cleaned.replace(/^(\d{0,3})(\d{0,3})(\d{0,3})(\d{0,2}).*/, (_, p1, p2, p3, p4) => {
    let formatted = p1;
    if (p2) formatted += `.${p2}`;
    if (p3) formatted += `.${p3}`;
    if (p4) formatted += `-${p4}`;
    return formatted;
  });
}

/**
 * Formata telefone fixo
 * @param value - Valor a ser formatado
 * @returns Valor formatado (00) 0000-0000
 */
export function formatPhone(value: string): string {
  const cleaned = value.replace(/\D/g, '');
  
  return cleaned.replace(/^(\d{2})(\d{0,4})(\d{0,4}).*/, (_, p1, p2, p3) => {
    let formatted = '';
    if (p1) formatted += `(${p1}`;
    if (p2) formatted += `) ${p2}`;
    if (p3) formatted += `-${p3}`;
    return formatted;
  });
}

/**
 * Formata CEP
 * @param value - Valor a ser formatado
 * @returns Valor formatado 00000-000
 */
export function formatCEP(value: string): string {
  const cleaned = value.replace(/\D/g, '');
  
  return cleaned.replace(/^(\d{0,5})(\d{0,3}).*/, (_, p1, p2) => {
    let formatted = p1;
    if (p2) formatted += `-${p2}`;
    return formatted;
  });
}

/**
 * Remove formatação de string (apenas números)
 * @param value - Valor com formatação
 * @returns Apenas dígitos
 */
export function removeFormat(value: string): string {
  return value.replace(/\D/g, '');
}

/**
 * Valida CPF
 * @param cpf - CPF a ser validado (com ou sem formatação)
 * @returns true se válido
 */
export function validateCPF(cpf: string): boolean {
  const cleaned = removeFormat(cpf);
  
  if (cleaned.length !== 11) return false;
  
  // Verifica se todos os dígitos são iguais
  if (/^(\d)\1+$/.test(cleaned)) return false;
  
  // Validação dos dígitos verificadores
  let sum = 0;
  let remainder;
  
  for (let i = 1; i <= 9; i++) {
    sum += parseInt(cleaned.substring(i - 1, i)) * (11 - i);
  }
  
  remainder = (sum * 10) % 11;
  if (remainder === 10 || remainder === 11) remainder = 0;
  if (remainder !== parseInt(cleaned.substring(9, 10))) return false;
  
  sum = 0;
  for (let i = 1; i <= 10; i++) {
    sum += parseInt(cleaned.substring(i - 1, i)) * (12 - i);
  }
  
  remainder = (sum * 10) % 11;
  if (remainder === 10 || remainder === 11) remainder = 0;
  if (remainder !== parseInt(cleaned.substring(10, 11))) return false;
  
  return true;
}

/**
 * Valida WhatsApp/Telefone
 * @param phone - Número a ser validado (com ou sem formatação)
 * @returns true se válido
 */
export function validatePhone(phone: string): boolean {
  const cleaned = removeFormat(phone);
  return cleaned.length === 10 || cleaned.length === 11;
}
