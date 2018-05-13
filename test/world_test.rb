require './test/test_helper'
require './lib/world_database'
require './lib/world'

class World::Minitest < Minitest::Test
  def test_a_world_starts_with_no_data
    world = World.new

    assert_nil world.id
    assert_nil world.generation_id
    assert_nil world.row_one
    assert_nil world.row_two
    assert_nil world.row_three
  end

  # This was super tricky for me, so I will give you this one.
  # Your world should have an instance variable like the following:
  # @database = SQLite3::Database.new("./db/world_database.db")
  # For now, we will hard code the DB name into the 'world' model.
  # Once you are in mod 3 we can explore using a config file for this.
  def test_a_world_has_a_reference_to_the_database_by_default
    wdb = WorldDatabase.new
    wdb.setup('world_database')
    world = World.new

    assert File.exists?(world.database.filename)
    wdb.drop('world_database')
  end

  def test_a_world_can_be_instantiated_with_data_from_a_hash
    data = { id: 1,
             generation_id: 1,
             row_one: '101101011',
             row_two: '110101011',
             row_three: '010101011' }
    world = World.new(data)

    assert_equal data[:id], world.id
    assert_equal data[:generation_id], world.generation_id
    assert_equal data[:row_one], world.row_one
    assert_equal data[:row_two], world.row_two
    assert_equal data[:row_three], world.row_three
  end

  def test_a_world_can_be_saved_to_the_database
    wdb = WorldDatabase.new
    wdb.setup('world_database')
    data = { id: 1,
             generation_id: 1,
             row_one: '101101011',
             row_two: '110101011',
             row_three: '010101011' }
    world = World.new(data)

    sqldb = SQLite3::Database.new("./db/world_database.db")
    statement = 'SELECT * FROM worlds'
    result = sqldb.execute(statement)

    # There shouldn't be anything in the database until we call
    # save on the world we just created
    assert_equal [], result

    world.save

    sqldb = SQLite3::Database.new("./db/world_database.db")
    statement = 'SELECT * FROM worlds'
    result = sqldb.execute(statement)
    wdb.drop('world_database')

    assert_equal [[1, 1, "101101011", "110101011", "010101011"]], result
  end

  # Note that .create is being called on the World class
  # This should take data like the other one, but this time
  # it will add the data directly to the database.
  def test_a_world_can_be_created
    wdb = WorldDatabase.new
    wdb.setup('world_database')
    data = { id: 1,
             generation_id: 1,
             row_one: '101101011',
             row_two: '110101011',
             row_three: '010101011' }
    # this method should also return the world object that is created
    # the world object being a plain ol' ruby object
    world = World.create(data)

    sqldb = SQLite3::Database.new("./db/world_database.db")
    statement = 'SELECT * FROM worlds'
    result = sqldb.execute(statement)
    wdb.drop('world_database')

    assert_equal 1, world.id
    assert_equal [[1, 1, "101101011", "110101011", "010101011"]], result
  end

  # This one was really tricky for me as well.  Let me know
  # when you get here and we can pair on it.  Or you can give
  # it a whirl on your own at first.
  def test_a_world_can_be_updated
    wdb = WorldDatabase.new
    wdb.setup('world_database')
    data = { id: 1,
             generation_id: 1,
             row_one: '101101011',
             row_two: '110101011',
             row_three: '010101011' }
    updated_data = {
             row_one: '101100011',
             row_two: '111110111',
             row_three: '010000011' }
    world = World.new(data)
    world.save
    world.update(updated_data)

    sqldb = SQLite3::Database.new("./db/world_database.db")
    statement = 'SELECT * FROM worlds'
    result = sqldb.execute(statement)
    wdb.drop('world_database')

    assert_equal [[1, 1, '101100011', '111110111', '010000011']], result
  end

  # Once the test before this is complete, this one will be a bit
  # more straightforward.
  def test_a_world_can_be_destroyed
    wdb = WorldDatabase.new
    wdb.setup('world_database')
    data = { id: 1,
             generation_id: 1,
             row_one: '101101011',
             row_two: '110101011',
             row_three: '010101011' }
    world = World.new(data)
    world.save

    sqldb = SQLite3::Database.new("./db/world_database.db")
    statement = 'SELECT * FROM worlds'
    result = sqldb.execute(statement)

    assert_equal [[1, 1, "101101011", "110101011", "010101011"]], result

    world.destroy
    result = sqldb.execute(statement)
    wdb.drop('world_database')

    assert_equal [], result
  end
end
