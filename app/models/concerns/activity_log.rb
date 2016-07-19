module ActivityLog
  extend ActiveSupport::Concern

  included do
    include PublicActivity::Model
    include PublicActivity::Common
    tracked owner: Proc.new{ |controller| controller.current_user }
  end
end
