class SearchesController < ApplicationController
  def search
    @content = params[:content]
    if params[:tag_search]
      @model = 'tag'
      @records = Book.joins(:tags).where('tags.name LIKE ?', "%#{@content}%").distinct
    elsif params[:model] == "user"
      @model = 'user'
      @records = User.where("name LIKE ?", search_query(@content, params[:method]))
    elsif params[:model] == "book"
      @model = 'book'
      @records = Book.search_for(@content, params[:method])
    else
      @records = []
    end
  end

  private

  def search_query(content, method)
    case method
    when "perfect"
      content
    when "forward"
      "#{content}%"
    when "backward"
      "%#{content}"
    else
      "%#{content}%"
    end
  end
end
