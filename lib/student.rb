require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name, :grade
  
  attr_reader :id

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    
    new_student = self.new(row[1],row[2],row[0])
    new_student
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def self.create(name, grade)
    student = self.new(name, grade)
    student.save
    student
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    
    sql = "SELECT * FROM students WHERE name = ?"
    row = DB[:conn].execute(sql, name).flatten
    self.new_from_db(row)
    
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    
    DB[:conn].execute(sql, @name, @grade, @id)
  end
  

end






