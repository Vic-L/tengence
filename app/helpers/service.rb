module Service
  extend ActiveSupport::Concern
  include ApplicationHelper

  included do
    def self.call(*args)
      new(*args).call
    end
  end
end