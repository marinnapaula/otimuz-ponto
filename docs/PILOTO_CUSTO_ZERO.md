# Ótimuz Ponto — piloto sem cobrança e sem custo de infraestrutura

## Objetivo
Paulinho é o primeiro cliente-piloto. Cobrança = R$ 0 durante a fase de testes. A meta de infraestrutura é R$ 0 dentro das cotas gratuitas, sem garantia de permanência do plano.

## Arquitetura inicial
- Vercel Hobby: front e API de desenvolvimento; validar termos de uso e elegibilidade para uso comercial antes de operar cliente real.
- PostgreSQL gerenciado remoto (Neon Free, sujeito a disponibilidade e limites vigentes).
- Repositório GitHub e migrações versionadas.
- Documentos e comprovantes: não guardar anexos reais nem dados sensíveis em armazenamento gratuito não validado.
- Sem domínio pago, SMS, e-mail transacional pago, IA paga ou serviços com cobrança por consumo.
- Não ativar recursos que gerem faturas automaticamente; criar alertas de consumo e limites conservadores.

## Política de piloto
- Ambiente de demonstração e testes; sem uso como registrador oficial de jornada até aprovação de conformidade REP-P.
- Dados fictícios e testes de ponta a ponta.
- Sem cobrança de mensalidade, instalação ou suporte ao piloto.
- Uma organização piloto, estrutura preparada para múltiplos tenants.
- Evitar coleta de CPF, biometria, documentos médicos ou informações trabalhistas reais durante a fase não validada.
- Informar expressamente ao piloto que o sistema não substitui controle legal vigente.

## Limites iniciais (configuráveis)
- 1 empresa piloto, até 30 usuários fictícios, até 5 estabelecimentos e 20 locais de trabalho.
- Retenção de dados fictícios sob revisão; exportação e reset do ambiente de teste.
- Sem SLA contratual ou garantia de disponibilidade.

## Critérios de transição para operação real
1. Revisão técnica e jurídica da Portaria 671/2021 e requisitos REP-P.
2. Arquitetura de disponibilidade, integridade, backups, recuperação e comprovantes assinados.
3. Arquivos fiscais e atestados aplicáveis; registro INPI.
4. Avaliação de LGPD, contrato de tratamento e responsabilidades.
5. Custos reais de infraestrutura medidos e plano comercial sustentável.

## Alertas
- A Vercel Hobby tem limitações de uso comercial: verificar termos atuais e migrar a plano elegível antes de uso comercial, inclusive piloto operacional.
- Serviços gratuitos podem suspender projetos, alterar cotas ou sofrer indisponibilidade.
- Custo zero não equivale a disponibilidade garantida nem conformidade legal.
