# Ótimuz Ponto — Plano de conformidade REP-P (rascunho técnico)

**Status:** planejamento; NÃO certificado, registrado ou autorizado para uso oficial. Revisar contra a Portaria MTP 671/2021 compilada, Anexos V, VI, VII, VIII e IX, atualizações e orientações oficiais antes de produção.

Fontes oficiais:
- https://www.gov.br/trabalho-e-emprego/pt-br/assuntos/legislacao/portarias-1/portarias-vigentes-3/PDFPortarian671de8denovembrode2021compilada07.01.2026.pdf
- https://www.gov.br/trabalho-e-emprego/pt-br/assuntos/inspecao-do-trabalho/fiscalizacao-do-trabalho/Perguntas%20e%20Respostas%20REP

## 1. Escopo legal
- O REP-P é o registrador, separado do Programa de Tratamento de Registro de Ponto (PTRP).
- Segundo FAQ do MTE, o REP-P exige certificado de registro do programa no INPI, não homologação ministerial como REP-C.
- O desenvolvedor deve fornecer Atestado Técnico e Termo de Responsabilidade conforme norma.
- As saídas fiscais devem obedecer leiautes e assinaturas ICP-Brasil aplicáveis.

## 2. Camadas de produto
1. **Coletor**: aplicativo mobile/web com relógio HH:MM:SS; registro online e contingência offline segura.
2. **REP-P**: autenticação, horário sincronizado com HLB (tolerância normativa), ARP com alta disponibilidade/redundância, NSR, integridade e emissão do comprovante.
3. **PTRP**: apuração, jornadas, ocorrências, ajustes como registros derivados, espelho, AEJ.
4. **Gestão**: cadastros, equipes, obras, diárias de prestadores, feedback, analytics.

## 3. Invariantes obrigatórias
- Registro original imutável; proibir UPDATE/DELETE sobre marcações fiscais; qualquer retificação é evento adicional no PTRP.
- NSR único e sequencial conforme especificação do REP-P; operações atômicas no servidor.
- Registrar horário oficial, identidade do trabalhador, empregador, coletor e evidências de sincronismo.
- Não bloquear marcação por geolocalização, câmera, atraso, ausência de escala ou pendência de aprovação.
- Localização e foto são evidências adicionais proporcionais, nunca substituem marcação.
- Comprovante eletrônico PDF com campos normativos, hash SHA-256 e assinatura PAdES ICP-Brasil; disponível imediatamente e recuperável.
- AFD gerado no leiaute oficial e assinado CAdES detached .p7s; AEJ gerado pelo PTRP e assinado conforme regra.
- Registro offline: coletor mantém fila protegida, identidade e timestamps; sincroniza assim que online; estratégia a validar juridicamente e em testes.
- Proteção de dados: RBAC, criptografia, retenção, trilha de acesso, política LGPD; anexos médicos em armazenamento restrito.
- Separar ponto de empregado de confirmação de diárias/prestação de serviço.

## 4. Entidades iniciais
Employer, Establishment, Worker, EmploymentContract, WorkSchedule, ShiftAssignment, Team, Worksite, Collector, PunchRecord, PunchReceipt, PunchEvidence, AuditEvent, Occurrence, Attachment, ReviewDecision, Adjustment, DailyService, CalculationRun, MonthlyClose, ExportJob.

## 5. Critérios de aceite antes de liberar marcação oficial
- [ ] Auditoria da norma e seus anexos por responsável técnico e jurídico trabalhista.
- [ ] Cadastro de empregador e trabalhador com dados exigidos.
- [ ] Fonte de horário HLB sincronizada, com monitoramento e testes de desvio.
- [ ] ARP redundante, confiável, recuperável, com backups e prova de integridade.
- [ ] NSR e hash implementados e testados sob concorrência.
- [ ] Comprovantes PDF PAdES ICP-Brasil validados por verificador independente.
- [ ] AFD + assinatura CAdES detached validados com casos de teste oficiais.
- [ ] AEJ + assinatura CAdES detached e Espelho validados com casos de teste.
- [ ] Contingência offline testada com sincronização, duplicatas e falhas.
- [ ] Permissões, LGPD, testes de invasão e restauração de backups.
- [ ] Registro do programa no INPI.
- [ ] Atestado Técnico e Termo de Responsabilidade devidamente assinado.
- [ ] Parecer de prontidão para uso real emitido após verificação integral.

## 6. Plano de implementação
- **Sprint 1:** projeto Next.js/TypeScript + PostgreSQL; autenticação, multiempresa, cadastros reais e RBAC.
- **Sprint 2:** serviço REP-P isolado, horário, NSR, registros imutáveis, ARP e testes.
- **Sprint 3:** comprovante, assinaturas, AFD e contingência offline.
- **Sprint 4:** PTRP, escalas, apuração, ocorrências, AEJ, espelho e fechamento.
- **Sprint 5:** segurança, testes de conformidade, documentação técnica e procedimentos para INPI/atestado.

**A DEMO atual em index.html não implementa esses controles. Não inserir dados trabalhistas reais.**
