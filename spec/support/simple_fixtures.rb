module SimpleFixtures
  def setup_models
    @luke = User.create(first_name: 'Luke',     last_name: 'Skywalker', age: 25, active: true)
    @han  = User.create(first_name: 'Han',      last_name: 'Solo',      age: 35, active: true)
    @leia = User.create(first_name: 'Princess', last_name: 'Leia',      age: 25, active: false)

    @luke.profile = Profile.new(avatar: 'picard.jpg', homepage: 'lukasarts.com')
    @luke.profile.save!

    @destroy_deathstar = @luke.tasks.create(heading: 'Destroy Deathstar', description: 'XWing, Shoot, BlowUp', time_spent: 30,  done: true)
    @study_with_yoda   = @luke.tasks.create(heading: 'Study with Yoda',   description: 'Jedi Stuff, ya know',  time_spent: 60,  done: true)
    @win_rebellion     = @luke.tasks.create(heading: 'Win Rebellion',     description: 'no idea yet...',       time_spent: 180, done: false)

    @luke.save!
    @han.save!
    @leia.save!
  end

  def clean_up_models
    User.delete_all
  end

  def setup_objects
    @luke = PlainObject.new(first_name: 'Luke',     last_name: 'Skywalker', age: 25, active: true)
    @han  = PlainObject.new(first_name: 'Han',      last_name: 'Solo',      age: 35, active: true)
    @leia = PlainObject.new(first_name: 'Princess', last_name: 'Leia',      age: 25, active: false)
  end
end

RSpec.configure do |c|
  c.include SimpleFixtures
end
