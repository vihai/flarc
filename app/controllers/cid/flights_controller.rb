# coding: utf-8

module Cid

class FlightsController < ApplicationController

  def wizard
    catch :done do
      if request.method == 'GET'
        @state = {}
        @state[:state] = :championship_data
        @state[:final] = false
        @state[:flight_id] = params[:flight_id]
 
        @flight = Flight.find(@state[:flight_id])
        if @flight.tags.include?(Tag.find_by_symbol('cid_2011'))
          flash[:error] = "Il volo è già stato inviato al CID"
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

          if params[:cid_tag_id].empty?
            flash.now[:error] = "È necessario selezionare una classe"
            throw :done
          end
          @state[:cid_tag_id] = params[:cid_tag_id]

          if params[:cid_task_eval].empty?
            flash.now[:error] = "È necessario selezionare il tipo di valutazione del tema"
            throw :done
          end
          @state[:cid_task_eval] = params[:cid_task_eval]

          if params[:cid_task_type].empty?
            flash.now[:error] = "È necessario selezionare il tipo di tema"
            throw :done
          end
          @state[:cid_task_type] = params[:cid_task_type]

          if params[:cid_task_completed].empty?
            flash.now[:error] = "È necessario selezionare se il tema è stato o meno completato"
            throw :done
          end
          @state[:cid_task_completed] = params[:cid_task_completed]

          if params[:cid_distance].empty? || !(params[:cid_distance] =~ /^[0-9]+$/)
            flash.now[:error] = "È necessario specificare una distanza valida"
            throw :done
          end
          @state[:cid_distance] = params[:cid_distance]
  
          @state[:state] = :done
  
          @flight = Flight.find(@state[:flight_id])
          @flight.flight_tags << FlightTag.new(
            :flight => @flight,
            :tag => Tag.find(@state[:cid_tag_id]),
            :status => :pending,
            :data => {
              :distance => @state[:cid_distance],
              :task_eval => @state[:cid_task_eval],
              :task_type => @state[:cid_task_type],
              :task_completed => @state[:cid_task_completed]
            })
          @flight.save!
  
        end
      end
    end

    # Prepare wizard data after state change
    case @state[:state]
    when :championship_data
      championship = Championship.find_by_symbol(:cid_2011)
      cp =  auth_person.pilot.championship_pilots.find_by_championship_id(championship.id)

      if cp
        if cp.cid_category == 'prom'
          @cid_available_tags = [
            Tag.find_by_symbol('cid_2011_prom')
          ]
        else
          @cid_available_tags = [
            Tag.find_by_symbol('cid_2011_naz_club'),
            Tag.find_by_symbol('cid_2011_naz_open'),
            Tag.find_by_symbol('cid_2011_naz_15m'),
            Tag.find_by_symbol('cid_2011_naz_13m5')
          ]
        end
      else
        raise "NOT SUBSCRIBED"
      end
    end

    render :template => "cid/flights/wizard/#{@state[:state]}"
  end

end

end
