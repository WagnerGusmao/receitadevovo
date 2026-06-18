import { apiFetch } from "@/services/api";

export interface ViaCEPResponse {
  cep: string;
  logradouro: string;
  complemento: string;
  bairro: string;
  localidade: string;
  uf: string;
  erro?: boolean;
}

export const fetchCEP = async (cep: string): Promise<ViaCEPResponse | null> => {
  const cleanedCep = cep.replace(/\D/g, '');
  
  if (cleanedCep.length !== 8) {
    return null;
  }

  try {
    const response = await apiFetch(`/ecommerce/addresses/zipcode/${cleanedCep}`);
    
    if (response && response.status === 'success' && response.data) {
      return response.data;
    }
    
    return null;
  } catch (error) {
    console.error("Erro ao buscar CEP via backend:", error);
    return null;
  }
};
