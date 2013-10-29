require 'spec_helper'

describe SiteLoadProfile do
	
	
	before { @site_load_profile = SiteLoadProfile.new(meter_read_date: "2013-09-23", tou: "All",
														demand: "100", usage: "10000", 
														interval_date_time: "2013-09-23 00:00:00.0",
														site_id: "1") }

	subject { @site_load_profile }

	it { should respond_to(:meter_read_date) }
	it { should respond_to(:tou) }
	it { should respond_to(:demand) }
	it { should respond_to(:usage) }
	it { should respond_to(:interval_date_time) }
	it { should respond_to(:site_id) }

	it { should be_valid }

# meter_read_date
	describe "when meter_read_date is not present" do
		before { @site_load_profile.meter_read_date = " " }
		it { should_not be_valid }
	end

# tou
	describe "when tou is not present" do
		before { @site_load_profile.tou = " " }
		it { should_not be_valid }
	end

# demand
	describe "when demand is not present" do
		before { @site_load_profile.demand = " " }
		it { should_not be_valid }
	end

# usage
	describe "when usage is not present" do
		before { @site_load_profile.usage = " " }
		it { should_not be_valid }
	end

# site_id
	describe "when site_id is not present" do
		before { @site_load_profile.site_id = nil }
		it { should_not be_valid }
	end

end
