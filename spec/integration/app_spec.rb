require "spec_helper"
require "rack/test"
require_relative "../../app"

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  def reset_tables
    seed_sql = File.read("spec/seeds.sql")
    connection = PG.connect({ host: "127.0.0.1", dbname: "chitter-dms-test" })
    connection.exec(seed_sql)
  end

  before(:each) { reset_tables }

  context "GET /" do
    it "returns the homepage with list of DMs if user is logged in with valid handle" do
      response = get("/")
      expect(response.status).to eq 200
      expect(response.body).to include "<h2>You are not logged in<h2>"

      response = post("/login", handle: "Bob")
      expect(response.status).to eq 302

      response = get("/")
      expect(response.status).to eq 200
      expect(response.body).to include "You are logged in"
    end

    it "returns homepage with flash message if user tries to log in with invalid handle" do
      response = get("/")
      expect(response.status).to eq 200
      expect(response.body).to include "<h2>You are not logged in<h2>"

      response = post("/login", handle: "Natasha")
      expect(response.status).to eq 302

      response = get("/")
      expect(response.status).to eq 200
      expect(response.body).to include "Handle Does Not Exist"
    end

    it "returns homepage with log in form if user is not logged in" do
      response = get("/")

      expect(response.status).to eq 200
      expect(response.body).to include "<h2>You are not logged in<h2>"
    end
  end

  context "get /send_message" do
    it "returns the send message view" do
      response = get("/send_message")

      expect(response.status).to eq 200
      expect(response.body).to include "Send Message"
    end
  end

  context "post /send_message" do
    it "returns 'Message sent' when message sent successfully" do
      response = get("/")
      expect(response.status).to eq 200
      expect(response.body).to include "<h2>You are not logged in<h2>"

      response = post("/login", handle: "Bob")
      expect(response.status).to eq 302

      response = get("/")
      expect(response.status).to eq 200
      expect(response.body).to include "You are logged in"

      response = post("/send_message", recipient_handle: "Sam", contents: "Hello")
      expect(response.status).to eq 302

      response = get("/send_message")
      expect(response.status).to eq 200
      expect(response.body).to include "Message sent"
    end

    it "tells user they can't send a message to a user who has blocked them" do
      response = get("/")
      expect(response.status).to eq 200
      expect(response.body).to include "<h2>You are not logged in<h2>"

      response = post("/login", handle: "Bob")
      expect(response.status).to eq 302

      response = get("/")
      expect(response.status).to eq 200
      expect(response.body).to include "You are logged in"

      response = post("/send_message", recipient_handle: "Lucy", contents: "Hello")
      expect(response.status).to eq 302

      response = get("/send_message")
      expect(response.status).to eq 200
      expect(response.body).to include "You are blocked by this user, message can't be sent"
    end
  end
end
