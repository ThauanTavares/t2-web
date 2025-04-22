class Curso < ActiveRecord::Base
    has_many :cursos_pessoas
    has_many :pessoas, through: :cursos_pessoas
  end
  