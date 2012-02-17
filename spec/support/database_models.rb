# Rails 3.1 needs to do some introspection around the base class, which requires
# the model be a descendent of ActiveRecord::Base.
class BlankModel < ActiveRecord::Base; end;

#The user class is just sharded, not replicated
class User < ActiveRecord::Base
  def awesome_queries
    Octopus.using(:canada) do
      User.create(:name => "teste")
    end
  end
end

#The client class isn't replicated
class Client < ActiveRecord::Base
  has_many :items
  has_many :comments, :as => :commentable
end

#This class is replicated
class Cat < ActiveRecord::Base
  replicated_model()
  #sharded_model()
end

#This class sets its own connection
class CustomConnection < ActiveRecord::Base
  octopus_establish_connection(:adapter => "mysql2", :database => "octopus_shard2", :username => "root", :password => "")
end

#This items belongs to a client
class Item < ActiveRecord::Base
  belongs_to :client
  has_many :parts
end

class Part < ActiveRecord::Base
  belongs_to :item
end

class Keyboard < ActiveRecord::Base
  replicated_model
  validates_uniqueness_of :name
  belongs_to :computer
end

class Computer < ActiveRecord::Base
  has_one :keyboard
end

class Role < ActiveRecord::Base
  has_and_belongs_to_many :permissions
end

class Permission < ActiveRecord::Base
  has_and_belongs_to_many :roles
end

class Assignment < ActiveRecord::Base
  belongs_to :programmer
  belongs_to :project
end

class Programmer < ActiveRecord::Base
  has_many :assignments
  has_many :projects, :through => :assignments
end

class Project < ActiveRecord::Base
  has_many :assignments
  has_many :programmers, :through => :assignments
end

class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
end


class Bacon < ActiveRecord::Base
  octopus_set_table_name "yummy"
end
