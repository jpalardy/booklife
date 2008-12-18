class Ownership < ActiveRecord::Base
  belongs_to :user
  belongs_to :book

  validates_presence_of :user, :book, :status, :isbn
  validates_inclusion_of :status, :in => Status.all

  before_validation_on_create :cache_isbn

  after_create  :create_event
  after_update  :update_event
  after_destroy :destroy_event

  ############################################################

  def self.find_with_ferret(*args)
    book_ids = Book.find_with_ferret(*args).collect(&:id)

    self.find_all_by_book_id(book_ids, :include => [:book, :user])
  end

  ############################################################
  private
  ############################################################

  def cache_isbn
    self.isbn = self.book.isbn if self.book
  end

  #-------------------------------------------------

  def create_event
    self.user.events.create(:description => "CREATED: status '#{self.status}'", :book => self.book)
  end

  def update_event
    if self.changed?
      self.user.events.create(:description => "UPDATED: status changed from '#{self.changes["status"].first}' to '#{self.changes["status"].last}'", :book => self.book)
    end
  end

  def destroy_event
    self.user.events.create(:description => "DELETED", :book => self.book)
  end

end
