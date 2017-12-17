require 'sinatra'
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
    @markdown = ""
    @html = ""
    erb :index
  end

  post '/' do
    renderer = Redcarpet::Markdown.new(
      SkipParagraphHTMLRender,
      autolink: true, fenced_code_blocks: true
    )
    @markdown = params[:markdown].to_s
    @html = renderer.render(@markdown)
    erb :index
  end
end
