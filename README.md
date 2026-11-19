# The 3rd Semester Awards — versão 2

## Prévia
Abra `index.html` em um navegador moderno. A página inclui:
- identidade visual comedy / black, gold & wine;
- categorias iniciais;
- cadastro local de participantes e categorias;
- cabine de votação ilustrativa;
- modo telão com cortinas, envelope, revelação animada, flash e confetes.

## Atenção
Esta ainda é uma prévia local. O `localStorage` só guarda dados no navegador atual. Não serve como votação oficial entre 30–50 celulares. Não compartilhe códigos reais nem use dados oficiais até conectar o backend.

## Produção
A arquitetura recomendada é Vercel (site) + Supabase (PostgreSQL, autenticação e storage opcional).
1. Criar projeto no Supabase.
2. Executar `supabase-schema.sql`.
3. Implementar Edge Function para validação de códigos e inserção segura de votos.
4. Proteger painel administrativo com autenticação.
5. Ligar frontend às tabelas e publicar na Vercel.
6. Testar votos simultâneos, duplicidade, empate e encerramento antes do evento.

O banco não deve permitir escrita pública direta na tabela `votes`. Os códigos devem ser armazenados como hashes, e os resultados devem permanecer ocultos até a cerimônia.
