class Dog

  attr_accessor :id

  def initialize(dog)
    dog.each do |key, value|
      self.class.attr_accessor(key)
      self.send("#{key}=", value)
    end
    @id = nil
  end

  def self.create_table
    sql_create = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
      )
    SQL

    DB[:conn].execute(sql_create)
  end

  def self.drop_table
    sql_drop = <<-SQL
      DROP TABLE IF EXISTS dogs
    SQL

    DB[:conn].execute(sql_drop)
  end

  def save
    sql = <<-SQL
      INSERT INTO dogs (name, breed)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.breed)

    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]

    self
  end

  def self.create(dog)
    new_dog = Dog.new(dog)
    new_dog.save
  end

end
