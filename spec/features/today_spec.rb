# require 'today_app'
# require 'rack/test'
require 'rails_helper'

# looks_like_a_date_to_me = /^\d\d\d\d-\d\d-\d\d$/
# web_client = Jsl::TodayJson::WebClients::NetHttp.new('http://localhost:3003')
# today_json = Jsl::TodayJson::Client.new(web_client)

RSpec.feature 'api spec' do
  it 'can render the outlines' do
    page.visit '/outlines/2015-04-21'
    expect(page.status_code).to eq 200

    # renders markdown
    h2s = page.all('h2').map(&:text)
    expect(h2s).to include 'All'

    # for the expected file
    expect(page.body).to include 'TechHire will have a Hangout with Jeff at 1:30'

    # doesn't render frontmatter
    expect(page.body).to_not include 'layout: outline'

    # outline layout from haml
    h1s = page.all('h1').map(&:text)
    expect(h1s).to include '2015-04-21'

    # partial for the title
    expect(page.title.strip).to eq '2015-04-21'
  end

  # TODO: change to a redirect to /all
  it 'renders a 404 page when asked for an unknown path' do
    page.visit '/outlines/9999-99-99'
    expect(page.status_code).to eq 404
    expect(page.body).to include 'The page you were looking for doesn\'t exist.'
  end

  it 'can render all the outlines' do
    outline_dir = File.expand_path '../../app/views/outlines', __dir__
    pattern     = File.join outline_dir, '*'
    Dir[pattern].each do |filename|
      date = File.basename(filename).chomp(".markdown")
      page.visit "/outlines/#{date}"
      expect(page.status_code).to eq 200
    end
  end

  def today_is(string_date)
    date = Date.parse string_date
    allow(Date).to receive(:today).and_return(date)
    allow(Date).to receive(:current).and_return(date)
  end

  it 'redirects from the root path to todays page' do
    today_is '2015-04-22'
    page.visit '/'
    expect(page.current_path).to eq '/outlines/2015-04-22'
  end

  it 'can render all.html.haml'
  # something about index.html.erb
end