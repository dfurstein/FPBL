require 'ostruct'

#
class Search < OpenStruct
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  def persisted?
    false
  end
end
