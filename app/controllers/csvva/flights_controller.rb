# coding: utf-8

module Csvva

class FlightsController < ApplicationController

  def wizard
    catch :done do
      if request.method == 'GET'
        @state = {}
        @state[:state] = :championship_data
        @state[:final] = false
        @state[:flight_id] = params[:flight_id]
 
        @flight = Flight.find(@state[:flight_id])
        if @flight.tags.include?(Tag.find_by_symbol('csvva_2011'))
          flash[:error] = "Il volo è già stato inviato al campionato CSVVA"
          throw :done
        end

      else
        @state = ActiveSupport::JSON.decode(params[:state]).symbolize_keys!
        @state[:state] = @state[:state].to_sym
        @state[:final] = false
  
        case @state[:state]
        when :championship_data
#        if @igc_file.takeoff_time < Time.now - 15.days
#          flash.now[:error] = "Il volo ha una data di decollo (#{@igc_file.takeoff_time}) "+
#                              "precedente al limite massimo di invio volo"
#          @state[:state] = :permanent_error
#          throw :done
#        end

          if !(params[:csvva_distance] =~ /^[0-9,.]*$/)
            flash.now[:error] = "È necessario specificare una distanza valida"
            throw :done
          end
          @state[:csvva_distance] = params[:csvva_distance].to_f * 1000

          @state[:state] = :flight_data

        when :flight_data
          @state[:passenger] = params[:passenger]

          @state[:notes] = params[:notes]

          @state[:state] = :done

          Ygg::Core::Transaction.new 'Flight submission' do
            @flight = Flight.find(@state[:flight_id])
            @flight.flight_tags << FlightTag::Csvva2011.new(
              :flight => @flight,
              :tag => Tag.find_by_symbol(:csvva_2011),
              :status => :pending,
              :distance => @state[:csvva_distance])

            @flight.passenger = Ygg::Core::Person.where([ "first_name || ' ' || COALESCE(middle_name || ' ','') || " +
                                           'last_name ILIKE ?', @state[:passenger] ] ).first
            @flight.passenger_name = @state[:passenger]
            @flight.notes_public = @state[:notes]

            @flight.save!
          end
        end
      end
    end

    # Prepare wizard data after state change
    case @state[:state]
    when :championship_data
    end

    render :template => "csvva/flights/wizard/#{@state[:state]}"
  end

  def autocomplete_passenger

    @items = Ygg::Core::Person.where([ 'LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ?',
                       params['passenger'].downcase + '%',
                       params['passenger'].downcase + '%' ]).
                         order('last_name ASC, first_name ASC').
                         limit(10)

    render :inline => "<%= auto_complete_result @items, 'name' %>"
  end


end

end
