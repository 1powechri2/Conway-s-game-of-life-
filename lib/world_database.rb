require "sqlite3"

class WorldDatabase
  attr_reader :file

  def initialize
    @file = nil
  end

  def create(db_name)
    @file = SQLite3::Database.new "./db/#{db_name}.db"
  end

  def drop(db_name)
    `rm ./db/#{db_name}.db`
  end

  def migrate
    @file.execute "CREATE TABLE worlds(id INT, generation INT, row_1 VARCHAR(9),
                                      row_2 VARCHAR(9), row_3 VARCHAR(9))"
  end

  def setup(db_name)
    create(db_name)
    migrate
  end

  def reset(db_name)
    drop(db_name)
    setup(db_name)
  end

  def insert_world(data)
    @file.execute("INSERT INTO worlds(id,
                 generation, row_1, row_2,
                 row_3) VALUES (#{data[0]},
                 #{data[1]}, #{data[2]},
                 #{data[3]}, #{data[4]})")
  end
end
