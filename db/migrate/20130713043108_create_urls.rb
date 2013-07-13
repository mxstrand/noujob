class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.string :job_seeker_url
      t.string :job_descrip_url

      t.timestamps
    end
  end
end
