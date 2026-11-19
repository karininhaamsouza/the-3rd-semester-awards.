-- THE 3RD SEMESTER AWARDS — permissões administrativas
-- Execute no Supabase SQL Editor. Não contém chaves secretas.

-- Garante que administradores possam consultar o próprio registro.
DROP POLICY IF EXISTS "admins can read own admin record" ON public.admin_users;
CREATE POLICY "admins can read own admin record"
ON public.admin_users FOR SELECT TO authenticated
USING (user_id = auth.uid());

-- Participantes: público pode ler apenas os ativos; admins podem gerenciar.
DROP POLICY IF EXISTS "admins manage participants" ON public.participants;
CREATE POLICY "admins manage participants"
ON public.participants FOR ALL TO authenticated
USING (EXISTS (SELECT 1 FROM public.admin_users a WHERE a.user_id = auth.uid()))
WITH CHECK (EXISTS (SELECT 1 FROM public.admin_users a WHERE a.user_id = auth.uid()));

-- Categorias: leitura pública já existe; admins podem criar/editar/excluir.
DROP POLICY IF EXISTS "admins manage categories" ON public.categories;
CREATE POLICY "admins manage categories"
ON public.categories FOR ALL TO authenticated
USING (EXISTS (SELECT 1 FROM public.admin_users a WHERE a.user_id = auth.uid()))
WITH CHECK (EXISTS (SELECT 1 FROM public.admin_users a WHERE a.user_id = auth.uid()));

-- Resultados: apenas administradores podem ler os votos.
DROP POLICY IF EXISTS "admins read votes" ON public.votes;
CREATE POLICY "admins read votes"
ON public.votes FOR SELECT TO authenticated
USING (EXISTS (SELECT 1 FROM public.admin_users a WHERE a.user_id = auth.uid()));

-- O site não deve ler nem gravar diretamente os códigos de votação.
-- A Edge Function awards-api usa a chave de serviço no servidor.

-- Categorias iniciais da edição (só insere se ainda não existirem pelo título).
INSERT INTO public.categories (title, description, sort_order, is_open)
SELECT v.title, v.description, v.sort_order, false
FROM (VALUES
 ('O Microfone Humano','Quem mais fala alto na sala?',0),
 ('Google Maps Humano','Quem sempre sabe onde fica tudo?',1),
 ('Cadê Meu Material?','Quem vive procurando alguma coisa?',2),
 ('CEO do Atraso','Quem chega depois de todo mundo?',3),
 ('Fiscal de Presença','Quem sabe quem faltou, chegou ou saiu?',4),
 ('Doutor(a) do Improviso','Quem sempre dá um jeito, mesmo sem estudar?',5),
 ('Riso Incontrolável','Quem começa a rir na pior hora possível?',6),
 ('Modo Avião','Quem parece estar sempre em outro planeta?',7),
 ('Sobrevivente do Semestre','Quem passou por tudo e ainda está de pé?',8)
) AS v(title, description, sort_order)
WHERE NOT EXISTS (SELECT 1 FROM public.categories c WHERE c.title = v.title);
