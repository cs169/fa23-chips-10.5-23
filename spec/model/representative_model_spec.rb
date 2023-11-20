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
endrequire 'rails_helper'
require 'ostruct'
office = OpenStruct.new({
        name: 'test_office_name',
        division_id: 'test_division_ID',
        official_indices: [
        0
      ]
    })
official =OpenStruct.new({
            name:'test_official_name'
        })
rep_info_test = {
     offices: [
    office
  ],
  officials:
    [
     official
    ]
}
rep_info_test = OpenStruct.new(rep_info_test)

describe Representative do
    describe 'insert with BLANK parameters' do
        it 'calls the model method that insert a representative but with BLANK parameters' do
            rep = Representative.civic_api_to_representative_params(OpenStruct.new({}))
            expect(rep).to eq([])
        end 
    end
    describe 'insert with BLANK offices' do
        it 'calls the model method that insert a representative but with BLANK offices' do
            rep = Representative.civic_api_to_representative_params(OpenStruct.new({
                    offices: [],
                    officials:[
                        official
                    ]
            }))
            expect(rep).to eq([])
        end 
    end
      describe 'insert with BLANK officials' do
        it 'calls the model method that insert a representative but with BLANK officials' do
            rep = Representative.civic_api_to_representative_params(OpenStruct.new({
                    offices: [
                        office
                    ],
                    officials:[]
            }))
            expect(rep).to eq([])
        end 
    end
    describe 'inserting a new representative' do
        it 'calls the model method that insert a new representative' do
            rep=Representative.civic_api_to_representative_params(rep_info_test)[0]
            expect(rep.name).to eq('test_official_name')
            expect(rep.ocdid).to eq('test_division_ID')
            expect(rep.title).to eq('test_office_name')
        end
    end
    describe 'inserting an existing representative' do
        it 'calls the model method that insert an existing representative' do
            rep=Representative.civic_api_to_representative_params(rep_info_test)
            rep += Representative.civic_api_to_representative_params(rep_info_test)
            expect(rep.count).to eq(1)
        end
    end
end