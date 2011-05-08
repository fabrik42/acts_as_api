module SimpleFixtures
  
  def setup_models(orm)
    
    if orm == :active_record
      @user_model       = User
      @task_model       = Task
      @profile_model    = Profile
      @untouched_model  = Untouched
    end
    
    
    @luke = @user_model.create({ :first_name => 'Luke',      :last_name => 'Skywalker', :age => 25, :active => true  })  
    @han  = @user_model.create({ :first_name => 'Han',       :last_name => 'Solo',      :age => 35, :active => true  })
    @leia = @user_model.create({ :first_name => 'Princess',  :last_name => 'Leia',      :age => 25, :active => false })

    @luke.profile = @profile_model.create({ :avatar => 'picard.jpg', :homepage => 'lukasarts.com' })

    @destroy_deathstar = @luke.tasks.create({ :heading => "Destroy Deathstar", :description => "XWing, Shoot, BlowUp",  :time_spent => 30,  :done => true })
    @study_with_yoda   = @luke.tasks.create({ :heading => "Study with Yoda",   :description => "Jedi Stuff, ya know",   :time_spent => 60,  :done => true })
    @win_rebellion     = @luke.tasks.create({ :heading => "Win Rebellion",     :description => "no idea yet...",        :time_spent => 180, :done => false })    
  end
  
  def clean_up
    @user_model.delete_all
    @task_model.delete_all    
  end
  
  
end


RSpec.configure do |c|
  c.include SimpleFixtures
end