class AddDataToCalls < ActiveRecord::Migration[5.1]
  def change
    add_column :calls, :from, :string
    add_column :calls, :to, :string
    add_column :calls, :direction, :string
    add_column :calls, :duration, :integer
    add_column :calls, :status, :string
    add_column :calls, :sid, :string
    add_column :calls, :recording_url, :string
    add_column :calls, :recording_duration, :integer
  end
end
