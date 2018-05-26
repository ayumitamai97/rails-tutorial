class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost  = current_user.microposts.build
      # newメソッドと同様に、buildメソッドはオブジェクトを返しますがデータベースには反映されません。
      # これは新しいMicropostオブジェクト！！

      @feed_items = current_user.feed.paginate(page: params[:page])
      # これは既存のmicropostsをpaginateしたもの!!!!!!!

    end
  end

  def help
  end

  def about
  end

  def contact
  end

end
