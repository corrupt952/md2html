require 'sinatra'
require 'sinatra/json'
require 'redcarpet'

if development?
  require 'sinatra/reloader'
end

configure {
  set :server, :puma
}

class SkipParagraphHTMLRender < Redcarpet::Render::HTML
  def paragraph(text)
    "#{text}\n"
  end
end

class Markdown2Html < Sinatra::Base
  get '/' do
    erb :index
  end

  post '/' do
    renderer = Redcarpet::Markdown.new(
      SkipParagraphHTMLRender,
      autolink: true, fenced_code_blocks: true
    )
    json content: renderer.render(params[:markdown].to_s)
  end
end
