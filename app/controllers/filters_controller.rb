class FiltersController < ApplicationController

	skip_before_filter :verify_authenticity_token, only: [:create, :update, :destroy, :change_check]

	def index
		filters = Filter.where(widgets_id: params[:widgetid]).order("created_at ASC")
		data = {success:{filters: filters}}
		render json: data
	end

	def create
		new_filter = Filter.new
	    new_filter.filter = params[:filtername]
	    new_filter.widgets_id = params[:widgetid]
	    new_filter.is_applied = true

	    if new_filter.save
	      data = {success:{filter: new_filter}}
	    else
	      data = {failure:{msg: new_filter.errors.full_messages.first}}
	    end

	    render json: data
	end

	def update
		update_filter = Filter.find(params[:id])
		update_filter.filter = params[:filtername]
		
		if update_filter.save
			data = {success:{filter: update_filter}}
		else
	      data = {failure:{msg: new_filter.errors.full_messages.first}}
		end
		render json: data
	end

	def destroy
		delete_filter = Filter.find(params[:id])
		
		if delete_filter.destroy
			data = {success:{msg: "delete success"}}
		else
	      data = {failure:{msg: new_filter.errors.full_messages.first}}
		end
		render json: data
	end

	def change_check
		check_filter = Filter.find(params[:id])
		if check_filter
			check_filter.is_applied = params[:checked]
			if check_filter.save
				data = {success:{msg: "change success"}}
			else
				data = {failure:{msg: new_filter.errors.full_messages.first}}
			end
		else
			data = {failure:{msg: "can't find the filter"}}
		end
		
		render json: data
	end
end
