require 'pry'
class World
  attr_reader :id,
              :generation_id,
              :row_one,
              :row_two,
              :row_three,
              :database

  def initialize(data = {})
    @id = data[:id]||nil
    @generation_id = data[:generation_id]||nil
    @row_one = data[:row_one]||nil
    @row_two = data[:row_two]||nil
    @row_three = data[:row_three]||nil
    @database = SQLite3::Database.new("./db/world_database.db")
  end

  def update(data)
    @id = data[:id] if data[:id]
    @generation_id = data[:generation_id] if data[:generation_id]
    @row_one = data[:row_one] if data[:row_one]
    @row_two = data[:row_two] if data[:row_two]
    @row_three = data[:row_three] if data[:row_three]
    update_record
  end

  def update_record
    @database.execute("UPDATE worlds
       SET id = #{@id},
           generation_id = #{@generation_id},
           row_one = '#{@row_one}',
           row_two = '#{@row_two}',
           row_three = '#{@row_three}'
      WHERE id = #{@id}")
  end

  def attributes
    [@id, @generation_id, @row_one, @row_two, @row_three]
  end

  def self.create(data)
    World.new(data).save
  end

  def destroy
    @database.execute("DELETE from worlds
                  WHERE id = #{@id}")
  end

  def save
    @database.execute("INSERT INTO worlds
                VALUES (?, ?, ?, ?, ?)", attributes)
  end
end
