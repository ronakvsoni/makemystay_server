class Api::V1::RoomsController < ApplicationController

    def index
      if !params[:address].blank?
        rooms = Room.where(active: true).near(params[:address], 5, order: 'distance')
      else
        rooms = Room.where(active: true)
      end
  
      if !params[:start_date].blank? && !params[:end_date].blank?
        start_date = DateTime.parse(params[:start_date])
        end_date = DateTime.parse(params[:end_date])
  
        rooms = rooms.select { |room|
            # Check #1: Check if there are any approved reservations overlap this date range
            reservations = Reservation.where(
              "room_id = ? AND (start_date <= ? AND end_date >= ?) AND status = ?",
              room.id, end_date, start_date, 1
            ).count
  
            # Check #2: Check if there are any unavailable dates within that date range
            calendars = Calendar.where(
              "roomd_id = ? AND status = ? and day BETWEEN ? AND ?",
              room.id, 1, start_date, end_date
            ).count
  
            reservations == 0 && calendars == 0
        }
      end
  
      render json: {
        rooms: rooms.map { |room| room.attributes.merge(image: room.cover_photo('medium'), instant: room.instant != "Request") },
        is_success: true
      }, status: :ok
  
    end
end