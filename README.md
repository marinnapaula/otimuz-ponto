# Ótimuz Ponto — DEMO 0.3

Protótipo navegável e responsivo para apresentação à Ótimuz Energia Solar. Este repositório usa um único `index.html` com CSS e JavaScript incorporados; não é necessário instalar dependências ou executar build.

## Publicação na Vercel
1. Acesse https://vercel.com/new.
2. Importe o repositório `marinnapaula/otimuz-ponto`.
3. Escolha **Other** (ou sem framework), **Root Directory** `./` e mantenha os comandos de build em branco.
4. Clique em **Deploy**.

O deploy publica o `index.html` na raiz, com os estilos embutidos. O link HTTPS pode ser compartilhado para avaliação visual.

## Funcionalidades da DEMO
- Perfis demonstrativos de administração, liderança e colaborador, sem autenticação.
- Painel, marcações simuladas, histórico exportável e diárias.
- Ocorrências: envio de justificativa e anexos PDF/JPG/PNG (até 3 arquivos de 1 MB), aprovação, rejeição e solicitação de complemento pelo perfil de administrador.
- Regra contextual demonstrativa: sede e obra dispensam foto; local externo solicita evidência; GPS impreciso exige conferência.
- Sugestões e exportação/compartilhamento manual de feedback.

## Limitações e segurança
**Apenas demonstração; não usar dados pessoais reais ou documentos médicos reais.** Todos os dados, anexos e decisões são guardados no `localStorage` do navegador. Não há sincronização entre dispositivos; trocar o perfil no mesmo navegador simula apenas a navegação. Os horários vêm do aparelho e as localizações são cenários fictícios. O sistema não é um REP validado para registros trabalhistas oficiais.

### Para virar MVP conectado
Implementar autenticação, permissões por perfil, PostgreSQL, upload privado dos anexos, registro de auditoria, persistência de feedback em servidor, comprovantes e validação jurídica/LGPD aplicáveis.
