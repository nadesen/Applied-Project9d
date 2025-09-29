class TagsController < ApplicationController
  def show
    @tag = Tag.find_by(name: params[:id])
    @books = @tag.books.order(created_at: :desc)
  end
end
