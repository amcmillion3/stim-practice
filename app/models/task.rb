class Task < ApplicationRecord
  before_create :set_default_status

  private

  def set_default_status
    self.status ||= 'pre-planning'
  end
end
