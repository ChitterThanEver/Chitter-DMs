require 'spec_helper'
require 'rack/test'
require_relative '../../app'

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  def reset_tables
    seed_sql = File.read('spec/seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter-dms-test' })
    connection.exec(seed_sql)
  end

  before(:each) do
    reset_tables
  end

  context "GET /" do
    it "returns the homepage with list of DMs if user is logged in with valid handle" do
      response = get("/")
      expect(response.status).to eq 200
      expect(response.body).to include '<h2>You are not logged in<h2>'

      response = post("/login", handle: 'Bob')
      expect(response.status).to eq 302

      response = get("/")
      expect(response.status).to eq 200
      expect(response.body).to include 'You are logged in'
    end

    it "returns homepage with flash message if user tries to log in with invalid handle" do
      response = get("/")
      expect(response.status).to eq 200
      expect(response.body).to include '<h2>You are not logged in<h2>'

      response = post("/login", handle: 'Natasha')
      expect(response.status).to eq 302

      response = get("/")
      expect(response.status).to eq 200
      expect(response.body).to include 'Handle Does Not Exist'
    end

    it "returns homepage with log in form if user is not logged in" do
      response = get("/")

      expect(response.status).to eq 200
      expect(response.body).to include '<h2>You are not logged in<h2>'
    end

    it "returns the homepage with list of DMs if user is logged in" do
      response = get("/")
      expect(response.status).to eq 200
      expect(response.body).to include '<h2>You are not logged in<h2>'

      response = post("/login", handle: 'Bob')
      expect(response.status).to eq 302

      response = get("/")
      expect(response.status).to eq 200
      expect(response.body).to include 'You are logged in'
      expect(response.body).to include "<h2>Sam DM'd you On 13/4/2023 At 12:33:29 PM</h2>"
      expect(response.body).to include "<h3>Hello Bob</h3>"
    end
  end

  context "get /blocked_list" do
    it "shows a list of users and their blocked status" do
      response = get("/")
      expect(response.status).to eq 200
      expect(response.body).to include '<h2>You are not logged in<h2>'

      response = post("/login", handle: 'Lucy')
      expect(response.status).to eq 302

      response = get('/blocked_list')

      expect(response.status).to eq(200)
      expect(response.body).to include('<input type ="checkbox" name="blocked[]" value=Bob checked>Bob<br>')
      expect(response.body).to include('<input type ="checkbox" name="blocked[]" value=Sam checked>Sam<br>')
      expect(response.body).to include('<input type ="checkbox" name="blocked[]" value=Lucy>Lucy<br>')
    end
  end

    context "post /blocked_list" do
      it "updates a user blocked list" do
        response = get("/")
        expect(response.status).to eq 200
        expect(response.body).to include '<h2>You are not logged in<h2>'
  
        response = post("/login", handle: 'Lucy')
        expect(response.status).to eq 302

        response = get('/blocked_list')
        expect(response.status).to eq(200)
        expect(response.body).to include('<input type ="checkbox" name="blocked[]" value=Bob checked>Bob<br>')
        expect(response.body).to include('<input type ="checkbox" name="blocked[]" value=Sam checked>Sam<br>')
        expect(response.body).to include('<input type ="checkbox" name="blocked[]" value=Lucy>Lucy<br>')

        # Now Lucy will uncheck Bob

        post('/blocked_list', blocked: ['Sam'])
        expect(response.status). to eq(200)

        response = get('/blocked_list')
        expect(response.body).to include('<input type ="checkbox" name="blocked[]" value=Bob>Bob<br>')
        expect(response.body).to include('<input type ="checkbox" name="blocked[]" value=Sam checked>Sam<br>')
        expect(response.body).to include('<input type ="checkbox" name="blocked[]" value=Irene>Irene<br>')
        
        # Now Lucy will uncheck Sam and check Irene
        post('/blocked_list', blocked: ['Irene'])
        expect(response.status). to eq(200)

        response = get('/blocked_list')
        expect(response.body).to include('<input type ="checkbox" name="blocked[]" value=Bob>Bob<br>')
        expect(response.body).to include('<input type ="checkbox" name="blocked[]" value=Sam>Sam<br>')
        expect(response.body).to include('<input type ="checkbox" name="blocked[]" value=Irene checked>Irene<br>')
      end
  end
end
