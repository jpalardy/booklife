class Ownership < ActiveRecord::Base
  belongs_to :user
  belongs_to :book

  validates_presence_of :user, :book, :status, :isbn
  validates_inclusion_of :status, :in => Status.all

  before_validation_on_create :cache_isbn

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

end
