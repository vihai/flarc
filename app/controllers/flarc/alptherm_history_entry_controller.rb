module Flarc

class AlpthermHistoryEntryController < ApplicationController
  def show
    @entry = AlpthermHistoryEntry.find(params[:id])

    render :layout => false
  end
end

end
