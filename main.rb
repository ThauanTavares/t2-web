require 'active_record'
require 'logger'
require_relative 'modelos/pessoa'
require_relative 'modelos/curso'
require_relative 'modelos/curso_pessoa'
require_relative 'modelos/documento'

# Configuração da conexão com o banco de dados
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/development.sqlite3'
)

ActiveRecord::Base.logger = Logger.new(STDOUT)

# Lê o comando e os parâmetros
comando = ARGV.shift
entidade = nil

# Se o próximo argumento não contiver '=', é entidade. Senão, já são atributos.
entidade = ARGV.shift unless ARGV[0]&.include?('=')

# Agora processa os atributos
atributos = ARGV.map { |arg| arg.split('=') }.to_h


# puts "ARGV: #{ARGV.inspect}"
# atributos = ARGV.map { |arg| arg.split('=') }.to_h
# puts "Atributos: #{atributos.inspect}"

# Comando de inserção
case comando
when "insere"
  case entidade
  when "pessoas"
    pessoa = Pessoa.create(atributos)
    puts "Pessoa criada com ID #{pessoa.id}: #{pessoa.inspect}"
  when "documentos"
    pessoa = Pessoa.find_by(id: atributos["pessoa_id"])
    if pessoa
      documento = Documento.create(atributos.merge(pessoa_id: pessoa.id))
      puts "Documento criado com ID #{documento.id}: #{documento.inspect}"
    else
      puts "Pessoa não encontrada para o documento."
    end
  else
    puts "Entidade '#{entidade}' não reconhecida para inserção."
  end

# Comando de listagem
when "lista"
  case entidade
  when "pessoas"
    pessoas = Pessoa.all
    if pessoas.any?
      puts "Lista de Pessoas:"
      pessoas.each do |p|
        puts "ID: #{p.id}, Nome: #{p.first_name} #{p.last_name}, Endereço: #{p.address}, Cidade: #{p.city}"
      end
    else
      puts "Nenhuma pessoa encontrada."
    end
  when "documentos"
    documentos = Documento.all
    if documentos.any?
      puts "Lista de Documentos:"
      documentos.each do |d|
        puts "ID: #{d.id}, Número: #{d.numero}, Pessoa ID: #{d.pessoa_id}"
      end
    else
      puts "Nenhum documento encontrado."
    end
  when "cursos"
    cursos = Curso.all
    if cursos.any?
      puts "Lista de Cursos:"
      cursos.each do |c|
        puts "ID: #{c.id}, Nome: #{c.nome}"
      end
    else
      puts "Nenhum curso encontrado."
    end
  else
    puts "Entidade '#{entidade}' não reconhecida para listagem."
  end

# Comando de remoção
when "remove"
  case entidade
  when "pessoas"
    id = atributos["id"]
    pessoa = Pessoa.find_by(id: id)
    if pessoa
      pessoa.destroy
      puts "Pessoa com ID #{id} removida."
    else
      puts "Pessoa com ID #{id} não encontrada."
    end
  when "documentos"
    id = atributos["id"]
    documento = Documento.find_by(id: id)
    if documento
      documento.destroy
      puts "Documento com ID #{id} removido."
    else
      puts "Documento com ID #{id} não encontrado."
    end
  when "cursos"
    id = atributos["id"]
    curso = Curso.find_by(id: id)
    if curso
      curso.destroy
      puts "Curso com ID #{id} removido."
    else
      puts "Curso com ID #{id} não encontrado."
    end
  else
    puts "Entidade '#{entidade}' não reconhecida para remoção."
  end

# Comando de associação de curso à pessoa
when "associa_curso"
  pessoa_id = atributos["pessoa_id"]
  curso_nome = atributos["curso_nome"]  # Mudamos para nome, pois você associará pelo nome do curso
  
  puts "pessoa_id: #{pessoa_id}, curso_nome: #{curso_nome}"
  # Verifica se a pessoa existe
  pessoa = Pessoa.find_by(id: pessoa_id)
  if pessoa
    # Verifica se o curso já existe pelo nome
    curso = Curso.find_by(nome: curso_nome)

    # Se o curso não existir, cria um novo
    unless curso
      curso = Curso.create(nome: curso_nome)
      puts "Curso '#{curso_nome}' criado com ID #{curso.id}."
    end

    # Cria a associação na tabela cursos_pessoas
    CursosPessoa.create(pessoa_id: pessoa.id, curso_id: curso.id)
    puts "Curso '#{curso.nome}' associado à pessoa '#{pessoa.first_name} #{pessoa.last_name}'."
  else
    puts "Pessoa com ID #{pessoa_id} não encontrada."
  end


when "lista_cursos"
  id = atributos["pessoa_id"]
  pessoa = Pessoa.find_by(id: id)

  if pessoa
    puts "Cursos da pessoa #{pessoa.first_name} #{pessoa.last_name}:"
    pessoa.cursos.each do |curso|
      puts "- #{curso.nome}"
    end
  else
    puts "Pessoa com ID #{id} não encontrada."
  end

  else
    puts "Comando '#{comando}' não reconhecido."
  end 