require 'spec_helper'

describe TariffUtility do

	before do
		@tariff_utility = TariffUtility.new(name: "AAA", state: "AA")
	end

	describe "when state is too long" do
		before { @tariff_utility.state = "a" * 3 }
		it { should_not be_valid }
  	end
end
