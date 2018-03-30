class User
  attr_accessor :first_name, :last_name, :email
  def initialize (attributes = {})
    @first_name = attributes[:first_name]
    @last_name = attributes[:last_name]
  end
  def full_name
    @first_name + " " + @last_name
  end
  def formatted_email
    full_name
  end
  def alphabetical_name
     @last_name.to_s + ',' + @first_name.to_s
  end
end
