# schema.rb
require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/development.sqlite3'
)

# Cria as tabelas
ActiveRecord::Schema.define do
  create_table :pessoas, force: true do |t|
    t.string :first_name
    t.string :last_name
    t.string :address
    t.string :city
  end

  create_table :documentos, force: true do |t|
    t.string :numero
    t.references :pessoa, foreign_key: true # 1-1 com pessoa
  end

  create_table :cursos, force: true do |t|
    t.string :nome
  end

  create_table :cursos_pessoas, force: true do |t|
    t.references :pessoa
    t.references :curso
  end
end
