class StreamingXrbController < ApplicationController
  def beer
    @count = request.params["count"].to_i
    if @count.zero?
      @count = 10
    end
    
    render stream: true
  end
end
