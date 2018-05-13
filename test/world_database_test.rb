require './test/test_helper'
require './lib/world_database'

class WorldDatabase::Minitest < Minitest::Test
  def test_it_initializes_with_no_file_storage
    skip
    wdb = WorldDatabase.new

    assert_nil wdb.file
  end

  # The second test will require that we can
  # create and drop the db.  It will need
  # to take an argument of a database name for both operations
  def test_it_can_create_and_drop_the_db
    skip
    wdb = WorldDatabase.new

    wdb.create('database_name')
    assert File.exists?('./db/database_name.db')
    wdb.drop('database_name')
    refute File.exists?('./db/database_name.db')
  end

  # This method should set up the 'schema', the schema
  # being the column names and datatypes.  This should write
  # it to the database.
  def test_it_can_migrate_database_schema
    skip
    wdb = WorldDatabase.new
    wdb.create('database_name')
    wdb.migrate

    assert File.exists?('./db/database_name.db')

    sqldb = SQLite3::Database.new("./db/database_name.db")
    statement = 'SELECT * FROM worlds'
    result = sqldb.execute(statement)

    assert_equal([], result)
    wdb.drop('database_name')
  end

  # setup will roll all of the creative commands into one go
  # running db.setup should do all of the things above except drop the DB
  def test_it_can_run_the_setup_command
    skip
    db = WorldDatabase.new
    db.setup('database_name')

    assert File.exists?('./db/database_name.db')

    sqldb = SQLite3::Database.new("./db/database_name.db")
    statement = 'SELECT * FROM worlds'
    result = sqldb.execute(statement)

    assert_equal([], result)
    db.drop('database_name')
  end

  # The reset method should take a database name as an argument
  # and drop the database, recreate the database, and migrate a
  # database schema to it
  def test_it_can_run_the_reset_command
    skip
    db = WorldDatabase.new
    db.create('database_name')

    assert File.exists?('./db/database_name.db')

    db.reset('database_name')

    assert File.exists?('./db/database_name.db')

    sqldb = SQLite3::Database.new("./db/database_name.db")
    statement = 'SELECT * FROM worlds'
    result = sqldb.execute(statement)

    assert_equal([], result)
    db.drop('database_name')
  end

  def test_it_can_have_data_inserted
    skip
    wdb = WorldDatabase.new
    wdb.setup('database_name')
    table_name = 'worlds'
    data = [1, 1, '101101001', '1101000111', '101101101']
    more_data = [1, 2, '101101101', '1100000111', '101111101']
    and_more_data = [1, 3, '101101011', '110100011', '101101000']

    wdb.insert_world(data)
    wdb.insert_world(more_data)
    wdb.insert_world(and_more_data)

    assert File.exists?('./db/database_name.db')

    sqldb = SQLite3::Database.new("./db/database_name.db")
    statement = 'SELECT * FROM worlds'
    result = sqldb.execute(statement)

    assert_equal result, [[1, 1, "101101001", "1101000111", "101101101"],
                          [1, 2, "101101101", "1100000111", "101111101"],
                          [1, 3, "101101011", "110100011", "101101000"]]
    wdb.drop('database_name')
  end
end
