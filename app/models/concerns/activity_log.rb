module ActivityLog
  extend ActiveSupport::Concern

  included do
    include PublicActivity::Model
    include PublicActivity::Common
  end
end
