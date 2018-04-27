class StaticController < ApplicationController
  before_action :read_locations_csv_file, only: %w(index)
  respond_to :js, :html

  def index
    @distributors = ["DISTRIBUTOR1", "DISTRIBUTOR2", "DISTRIBUTOR3"]
  end

  def distributor_permission
    included_contries = ["India", "United States"]
    excluded_cities = ["Karnataka", "Tamil Nadu"]
    # condition for checking country permission
    if included_contries.include? params[:country]
      location = params[:location].split("-")[1].strip
      # condition for checking the location for selected country
      @message = (excluded_cities.include? location) ? "You don't have permission to distribute to #{location}." : "You have permission to distribute #{location} location."
    else
      @message = "You don't have permission to distribute #{params[:country]} country."
    end
  end
  
  private
    def read_locations_csv_file
      # creating related cities and countries as array list
      @countries, @cities = [], []
      # reading the csv
      csv_text = File.read("#{Rails.root.join('cities.csv')}")
      csv = CSV.parse(csv_text, headers: true)
      csv.each do |row|
        # collecting all countries names
        @countries << row["Country Name"]
        # collecting the cities those belongs to IN and US
        @cities << "#{row['City Name']} - #{row['Province Name']}" if (row["Country Code"] == "IN" || row["Country Code"] == "US")
      end
      # return array of countries and cities with alphabitical order
      return @countries.uniq!.sort_by!{ |country| country }, @cities.uniq!.sort_by!{ |city| city }
    end
end