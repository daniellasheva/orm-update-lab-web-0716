require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(id=nil, name, grade)
    @id=id
    @name=name
    @grade=grade
  end

  def self.create_table
    sql =<<-SQL
      CREATE TABLE students(
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT);
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
      sql =<<-SQL
      DROP TABLE students 
      SQL
     DB[:conn].execute(sql)
  end

  def save
    if self.id #if object is already in db
      self.update #this saves you if accidentally call save on an already existing instance 
    else
    sql =<<-SQL
      INSERT INTO students (name, grade) VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id=DB[:conn].execute("SELECT last_insert_rowid() FROM students").first.first
    end
  end


  def self.create(name, grade)
    student=Student.new(name, grade)
    student.save  #puts it in the database
    student
  end

  def self.new_from_db (array)
    student= Student.new(array[0], array[1], array[2])
    student
  end

  def self.find_by_name (name)
    sql= <<-SQL
      SELECT * FROM students WHERE name= ?
    SQL
    student= DB[:conn].execute(sql, name).first
    self.new_from_db(student)
  end

  def update
    sql= "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

end
