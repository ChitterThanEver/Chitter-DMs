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
    it "returns the homepage with list of DMs if user is logged in" do
      response = get("/")
      expect(response.status).to eq 200
      expect(response.body).to include '<h2>You are not logged in<h2>'

      response = post("/login", handle: 'Bob')
      expect(response.status).to eq 302

      response = get("/")
      expect(response.status).to eq 200
      expect(response.body).to include 'You are logged in'
    end

    it "returns homepage with log in form if user is not logged in" do
      response = get("/")

      expect(response.status).to eq 200
      expect(response.body).to include '<h2>You are not logged in<h2>'
    end
  end

  it "gets user by handle" do
    repo = UserRepository.new
    user = repo.all.first
    expect(app.get_user_by_handle('Bob')).to eq user
  end
end