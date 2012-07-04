module SimpleFixtures

  def setup_models
    @luke = User.create({ :first_name => 'Luke',      :last_name => 'Skywalker', :age => 25, :active => true  })
    @han  = User.create({ :first_name => 'Han',       :last_name => 'Solo',      :age => 35, :active => true  })
    @leia = User.create({ :first_name => 'Princess',  :last_name => 'Leia',      :age => 25, :active => false })

    @luke.profile = Profile.new({ :avatar => 'picard.jpg', :homepage => 'lukasarts.com' })
    @luke.profile.save

    @destroy_deathstar = @luke.tasks.create({ :heading => "Destroy Deathstar", :description => "XWing, Shoot, BlowUp",  :time_spent => 30,  :done => true })
    @study_with_yoda   = @luke.tasks.create({ :heading => "Study with Yoda",   :description => "Jedi Stuff, ya know",   :time_spent => 60,  :done => true })
    @win_rebellion     = @luke.tasks.create({ :heading => "Win Rebellion",     :description => "no idea yet...",        :time_spent => 180, :done => false })

    @luke.save!
    @han.save!
    @leia.save!
  end

  def clean_up_models
    User.delete_all
  end

  # def setup_roflscale_models
  #   @orm_for_testing  = :vanilla
  #   @user_model       = VanillaUser
  #   @task_model       = VanillaTask
  #   @profile_model    = VanillaProfile
  #   @untouched_model  = VanillaUntouched
  #
  #   @luke = @user_model.new({ :first_name => 'Luke',      :last_name => 'Skywalker', :age => 25, :active => true  })
  #   @han  = @user_model.new({ :first_name => 'Han',       :last_name => 'Solo',      :age => 35, :active => true  })
  #   @leia = @user_model.new({ :first_name => 'Princess',  :last_name => 'Leia',      :age => 25, :active => false })
  #
  #   @luke.profile = @profile_model.new({ :user => @luke, :avatar => 'picard.jpg', :homepage => 'lukasarts.com' })
  #
  #   @destroy_deathstar = @task_model.new({ :user => @luke, :heading => "Destroy Deathstar", :description => "XWing, Shoot, BlowUp",  :time_spent => 30,  :done => true })
  #   @study_with_yoda   = @task_model.new({ :user => @luke, :heading => "Study with Yoda",   :description => "Jedi Stuff, ya know",   :time_spent => 60,  :done => true })
  #   @win_rebellion     = @task_model.new({ :user => @luke, :heading => "Win Rebellion",     :description => "no idea yet...",        :time_spent => 180, :done => false })
  #
  #   @luke.tasks << @destroy_deathstar << @study_with_yoda << @win_rebellion
  # end
  #
  # def clean_up_roflscale_models
  #   # nothing to do ;)
  # end

end


RSpec.configure do |c|
  c.include SimpleFixtures
end
