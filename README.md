# Trabalho 2 - ActiveRecord

## ✅ Como rodar

### 1. Instale as dependências:
Certifique-se de ter o Ruby instalado. Em seguida, instale as gems necessárias:

gem install bundler activerecord sqlite3


2. Este comando executa o schema automaticamente, limpa o banco e insere 10 personagens de Star Wars com seus respectivos dados:
   ruby seeds.rb

3. Execute os comandos:
   ruby main.rb insere pessoas first_name="Maria" last_name="Silva" address="Rua X" city="Curitiba"
   ruby main.rb lista pessoas
   ruby main.rb exclui pessoas id=3
   ruby main.rb associa_curso pessoa_id=2 curso_nome="Programação Web"
   ruby main.rb mostra_cursos pessoa_id=2


