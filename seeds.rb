require './schema'
require './modelos/pessoa'
require './modelos/documento'
require './modelos/curso'
require './modelos/curso_pessoa'

# ⚠️ Desativa restrições temporariamente pra evitar erros de chave estrangeira
ActiveRecord::Base.connection.execute("PRAGMA foreign_keys = OFF")

CursosPessoa.delete_all
Documento.delete_all
Curso.delete_all
Pessoa.delete_all

ActiveRecord::Base.connection.execute("PRAGMA foreign_keys = ON")

personagens = [
  { first_name: "Luke", last_name: "Skywalker", city: "Tatooine" },
  { first_name: "Leia", last_name: "Organa", city: "Alderaan" },
  { first_name: "Anakin", last_name: "Skywalker", city: "Tatooine" },
  { first_name: "Obi-Wan", last_name: "Kenobi", city: "Stewjon" },
  { first_name: "Padmé", last_name: "Amidala", city: "Naboo" },
  { first_name: "Yoda", last_name: "", city: "Dagobah" },
  { first_name: "Darth", last_name: "Maul", city: "Dathomir" },
  { first_name: "Rey", last_name: "", city: "Jakku" },
  { first_name: "Finn", last_name: "", city: "Unknown" },
  { first_name: "Poe", last_name: "Dameron", city: "Yavin IV" }
]

# 🎓 Cursos padrão para associar
nomes_dos_cursos = ["Jedi", "Sith", "Piloto"]
cursos = nomes_dos_cursos.map { |nome| Curso.find_or_create_by(nome: nome) }

# 🧪 Popula as pessoas, documentos e associa a cursos
personagens.each_with_index do |personagem, i|
  p = Pessoa.create(
    first_name: personagem[:first_name],
    last_name: personagem[:last_name],
    address: "Rua X",
    city: personagem[:city]
  )

  if p.persisted?
    Documento.create(numero: "000#{i}", pessoa: p)
    curso = cursos[i % cursos.length]
    CursosPessoa.create(pessoa: p, curso: curso)
    puts "Pessoa #{p.first_name} criada com curso #{curso.nome}"
  else
    puts "Erro ao criar #{personagem[:first_name]}: #{p.errors.full_messages.join(', ')}"
  end
end
