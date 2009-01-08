class OwnershipObserver < ActiveRecord::Observer

  def after_create(model)
    model.user.events.create(:description => "CREATED: '#{model.status}'", :book => model.book)
  end

  def after_update(model)
    if model.changed?
      model.user.events.create(:description => "UPDATED: '#{model.changes["status"].last}' from '#{model.changes["status"].first}'", :book => model.book)
    end
  end

  def after_destroy(model)
    model.user.events.create(:description => "DELETED", :book => model.book)
  end

end
