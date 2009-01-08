class OwnershipObserver < ActiveRecord::Observer

  def after_create(model)
    model.user.events.create(:description => "CREATED: status '#{model.status}'", :book => model.book)
  end

  def after_update(model)
    if model.changed?
      model.user.events.create(:description => "UPDATED: status changed from '#{model.changes["status"].first}' to '#{model.changes["status"].last}'", :book => model.book)
    end
  end

  def after_destroy(model)
    model.user.events.create(:description => "DELETED", :book => model.book)
  end

end
