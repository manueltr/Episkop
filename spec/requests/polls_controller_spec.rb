require 'rails_helper'

RSpec.describe "PollsControllers", type: :request do

    describe "index" do
        it "all polls in database" do
          
          get '/polls'
          expect(response).to render_template "index"

        end
      end
end
