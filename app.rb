require 'sinatra'
require 'sinatra/json'
require 'redcarpet'

if development?
  require 'sinatra/reloader'
end

configure {
  set :server, :puma
}

class NoParagraphHTMLRender < Redcarpet::Render::HTML
  def paragraph(text)
    "\n#{text}\n"
  end
end

class Markdown2Html < Sinatra::Base
  get '/' do
    erb :index
  end

  post '/' do
    renderClass = if params[:no_paragraph] == "true"
                    NoParagraphHTMLRender
                  else
                    Redcarpet::Render::HTML
                  end
    renderer = Redcarpet::Markdown.new(
      renderClass,
      autolink: true,
      fenced_code_blocks: true
    )
    json content: renderer.render(params[:markdown].to_s)
  end
end
