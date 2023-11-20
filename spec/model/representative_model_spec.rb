require 'rails_helper'

describe Representative do

    describe 'insert with BLANK parameters' do
        it 'calls the model method that insert a representative but with BLANK parameters' do
            rep = Representative.civic_api_to_representative_params({})
            expect(rep).to eq([])
        end 
    end
    describe 'inserting a new representative' do
        it 'calls the model method that insert a new representative' do
            
        end
    end
    describe 'inserting an existing representative' do
        it 'calls the model method that insert an existing representative' do
            
        end
    end
end