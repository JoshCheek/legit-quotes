require 'sinatra'
class QuoteApp < Sinatra::Application
  def h(html)
    ERB::Util.h html
  end

  get '/' do
    @title = "Totally for real quotes"
    erb :main
  end

  get '/:author/:quote' do
    @author = h params[:author]
    @quote  = h params[:quote]
    @title  = "A quote by #@author"
    erb :template
  end
end

__END__
@@layout
<!DOCTYPE html>
<html>
  <head>
    <title><%= @title %></title>
    <style>
      a {
        color:               white;
        text-decoration:     none;
      }
      body {
        background-color:    #659EC7;
        font-family:         sans-serif;
        color:               white;
        margin:              0px;
      }
      #content {
        font-size:           200%;
        background-color:    #2B547E;
        margin:              10%;
        padding:             5%;
        -moz-border-radius:  25px;
        border-radius:       25px;
        border-width:        5px;
        border-color:        #A0CFEC;
        border-style:        solid;
      }
      #footer {
        background-color:    #2B547E;
        width:               100%;
        padding:             0px;
        padding-left:        20px;
        padding-top:         20px;
        border-style:        solid;
        border-width:        0px;
        border-top-width:    5px;
        border-color:        #A0CFEC;
        margin:              0%;
        height:              50px;
        position:            fixed;
        bottom:              0px;
      }
      .quote {
        padding-bottom:      5%;
      }
      .author {
        margin-left:         60%;
        color:               #659EC7;
        font-style:          italic;
      }
    </style>
  </head>
  <body>
    <div id="content">
      <%= yield %>
    </div>
    <div id="footer">
      <a href="https://github.com/JoshCheek/legit-quotes">Get the source</a>
    </div>
  </body>
</html>

@@main
<p>Totally for real actual quotes.</p>

@@template
<p class="quote">"<%= h @quote %>"</p>
<p class="author"><%= h @author %></p>
