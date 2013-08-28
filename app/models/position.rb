class Position < ActiveRecord::Base
  self.table_name = 'acl_position'

  alias_attribute :id,          :acl_position_id
  alias_attribute :title,       :acl_position_title
  alias_attribute :appointment, :acl_position_appointment
  alias_attribute :dismission,  :acl_position_dismission

  belongs_to :user,       primary_key: :user_id,       foreign_key: :acl_position_user
  belongs_to :role,       primary_key: :acl_role_id,   foreign_key: :acl_position_role
  belongs_to :department, primary_key: :department_id, foreign_key: :acl_position_department

  #def self.find_or_create_by_position_id(position_id)
  #  obj = (self.find(position_id) || self.new)
  #  obj.save
  #end
end