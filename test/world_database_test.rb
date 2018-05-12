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

# This isn't real data yet, since we are only testing that the DB can hold stuff
# Once we get a better idea of how to work with ruby Matrices we can change how
# this works
  def test_it_can_have_data_inserted
    skip
    wdb = WorldDatabase.new
    wdb.setup('database_name')
    table_name = 'worlds'
    data = {
      'world_id' => 1,
      'generation_id' => 1,
      'row_one' => '101101011',
      'row_two' => '110101011',
      'row_three' => '010101011'
    }
    more_data = {
      'world_id' => 1,
      'generation_id' => 2,
      'row_one' => '101101011',
      'row_two' => '110101011',
      'row_three' => '110101011'
    }
    more_data = {
      'world_id' => 1,
      'generation_id' => 2,
      'row_one' => '101101011',
      'row_two' => '110101011',
      'row_three' => '110101011'
    }
    wdb.insert(table_name, data)
  end
end
