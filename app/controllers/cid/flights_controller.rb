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
        if @flight.championships.include?(Championship.find_by_symbol(:cid_2011))
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

          if params[:cid_ranking].empty?
            flash.now[:error] = "È necessario selezionare una classe"
            throw :done
          end
          @state[:cid_ranking] = params[:cid_ranking]

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

          if params[:cid_distance].empty? || !(params[:cid_distance] =~ /^[0-9.,]+$/)
            flash.now[:error] = "È necessario specificare una distanza valida"
            throw :done
          end
          @state[:cid_distance] = params[:cid_distance].to_f * 1000

          @state[:state] = :done

          @flight = Flight.find(@state[:flight_id])
          @flight.championship_flights << Championship::Flight::Cid2011.new(
            :championship => Championship.find_by_symbol(:cid_2011),
            :status => :pending,
            :cid_ranking => @state[:cid_ranking],
            :distance => @state[:cid_distance],
            :data => {
              :task_eval => @state[:cid_task_eval].to_sym,
              :task_type => @state[:cid_task_type].to_sym,
              :task_completed => @state[:cid_task_completed] == 'true'
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
          @cid_available_rankings = {
                 'Promozione' => :prom,
          }
        else
          @cid_available_rankings = {
                 'Nazionale Club' => :naz_club,
                 'Nazionale Open' => :naz_open,
                 'Nazionale 15 m' => :naz_15m,
                 'Nazionale 13.5 m' => :naz_13m5
          }
        end
      else
        raise "NOT SUBSCRIBED"
      end
    end

    render :template => "cid/flights/wizard/#{@state[:state]}"
  end

end

end
