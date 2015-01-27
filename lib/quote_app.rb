require 'sinatra'
class QuoteApp < Sinatra::Application
  def h(html)
    ERB::Util.h html
  end

  before { @google_property_id = ENV['GOOGLE_PROPERTY_ID'] }

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

    <script type="text/javascript">

      var _gaq = _gaq || [];
      _gaq.push(['_setAccount', '<%= @google_property_id %>']);
      _gaq.push(['_trackPageview']);

      (function() {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
      })();

    </script>
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
<p class="quote">"<%= @quote %>"</p>
<p class="author"><%= @author %></p>
