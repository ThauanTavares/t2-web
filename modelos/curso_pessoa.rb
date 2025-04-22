class CursosPessoa < ActiveRecord::Base
    self.table_name = 'cursos_pessoas'
    belongs_to :pessoa
    belongs_to :curso
  end
  