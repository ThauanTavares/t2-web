class Pessoa < ActiveRecord::Base
    has_one :documento, dependent: :destroy
    has_many :cursos_pessoas
    has_many :cursos, through: :cursos_pessoas
  end
  