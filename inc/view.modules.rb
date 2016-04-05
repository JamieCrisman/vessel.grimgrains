#!/bin/env ruby
# encoding: utf-8

class Layouts

  def googleAnalytics

  	return "
    <script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-53987113-1', 'auto');
  ga('send', 'pageview');
  </script>
  "

  end
  
  def googleAdsSDK
    
    return '<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>'
    
  end
  
  def googleAdSidebar1
    
    return '
    <ins class="adsbygoogle" style="display:inline-block;width:300px;height:250px" data-ad-client="ca-pub-1054608213472784" data-ad-slot="3810083554"></ins>
    <script>(adsbygoogle = window.adsbygoogle || []).push({});</script>'
    
  end
  
  def googleAdSidebar2
    
    return '
    <ins class="adsbygoogle" style="display:inline-block;width:728px;height:90px" data-ad-client="ca-pub-1054608213472784" data-ad-slot="9647807555"></ins>
    <script>(adsbygoogle = window.adsbygoogle || []).push({});</script>'
    
  end
  
  def googleAdSidebar3
    
    return'<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle"style="display:inline-block;width:300px;height:250px"data-ad-client="ca-pub-1054608213472784"data-ad-slot="9638657559"></ins>
    <script>
    (adsbygoogle = window.adsbygoogle || []).push({});</script>'
    
  end
  
  def widgetInstagram
   
    return '
    <h1 class="center">Latest instagram snaps</h1><iframe src="http://snapwidget.com/in/?u=Z3JpbWdyYWluc3xpbnwxNDV8MnwyfHxub3w1fG5vbmV8b25TdGFydHx5ZXN8bm8=&ve=270814" title="Instagram Widget" class="snapwidget-widget" allowTransparency="true" frameborder="0" scrolling="no" style="border:none; overflow:hidden; width:300px; height:300px"></iframe>'  
    
  end

  def donate
    
    return '
    <link href="//cdn-images.mailchimp.com/embedcode/classic-081711.css" rel="stylesheet" type="text/css">
    <style type="text/css">
    	#donate{background: #fff;border: #000000 dashed 2px;clear: left;font: 12px Helvetica,Arial,sans-serif;width: 300px;margin-bottom: 30px;border-radius: 6px}
      #donate form { margin: 15px; padding:0px}
      #donate .d-field-group { width:100%; margin-bottom:0px; min-height:0px}
      #donate .indicates-required { margin-right:0px}
      
    </style>
  
    <div id="donate">
        <center><h1>Want to help?</h1>
    <form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
    <input type="hidden" name="cmd" value="_s-xclick">
    <input type="hidden" name="encrypted" value="-----BEGIN PKCS7-----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-----END PKCS7-----
    ">
    <input type="image" src="http://grimgrains.com/img/interface/pages/donate_button.png" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!">
    <img alt="" border="0" src="https://www.paypalobjects.com/en_US/i/scr/pixel.gif" width="1" height="1">
    </form>
    <form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
    <input type="hidden" name="cmd" value="_s-xclick">
    <input type="hidden" name="encrypted" value="-----BEGIN PKCS7-----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-----END PKCS7-----
    ">
    <input type="image" src="http://grimgrains.com/img/interface/pages/donate_button_choose.png" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!">
    <img alt="" border="0" src="https://www.paypalobjects.com/en_US/i/scr/pixel.gif" width="1" height="1">
<br>
    <a href="http://grimgrains.com/donate">(Why donate?)</a> <img src="http://grimgrains.com/img/interface/pages/paypal.png">
    </form></center>
    </div>
   '
    
  end
  
  def mailinglist
    
    return '
    <link href="//cdn-images.mailchimp.com/embedcode/classic-081711.css" rel="stylesheet" type="text/css">
    <style type="text/css">
    	#mc_embed_signup{background: #fff;border: #000000 dashed 2px;clear: left;font: 12px Helvetica,Arial,sans-serif;width: 296px;margin-bottom: 30px;border-radius: 6px}
      #mc_embed_signup form { margin: 15px; padding:0px}
      #mc_embed_signup .mc-field-group { width:100%; margin-bottom:0px; min-height:0px}
      #mc_embed_signup .indicates-required { margin-right:0px}
    	/* Add your own MailChimp form style overrides in your site stylesheet or in this style block.
    	   We recommend moving this block and the preceding CSS link to the HEAD of your HTML file. */
    </style>
    <div id="mc_embed_signup">
    <form action="//grimgrains.us9.list-manage.com/subscribe/post?u=689cf3ea1e99d4680a274f6f0&amp;id=2db26af007" method="post" id="mc-embedded-subscribe-form" name="mc-embedded-subscribe-form" class="validate" target="_blank" novalidate>
        <div id="mc_embed_signup_scroll">
    <h1 class="center">Mailing list</h1>
    <div class="mc-field-group">
    	<input type="email" value="" name="EMAIL" placeholder="your_email@address.com" class="required email" id="mce-EMAIL" style="display: block;padding: 8px 5px;width: 165px;float:left;border:1px solid #000;border-top-left-radius: 5px;border-bottom-left-radius: 5px; text-indent:10px">
      <input type="submit" value="Subscribe" name="subscribe" id="mc-embedded-subscribe" class="button" style="width: 88px;clear: none;border-radius: 0px;margin: 0px;line-height: 16px;font-size: 12px;border-bottom-right-radius: 5px;border-top-right-radius: 5px;background: #000">
    </div>
    	<div id="mce-responses" class="clear">
    		<div class="response" id="mce-error-response" style="display:none"></div>
    		<div class="response" id="mce-success-response" style="display:none"></div>
    	</div>    <!-- real people should not fill this in and expect good things - do not remove this or risk form bot signups-->
        <div style="position: absolute; left: -5000px;"><input type="text" name="b_689cf3ea1e99d4680a274f6f0_2db26af007" tabindex="-1" value=""></div>
        </div>
    </form>
    </div>
    <script type="text/javascript" src="//s3.amazonaws.com/downloads.mailchimp.com/js/mc-validate.js"></script><script type="text/javascript">(function($) {window.fnames = new Array(); window.ftypes = new Array();fnames[0]="EMAIL";ftypes[0]="email";fnames[1]="FNAME";ftypes[1]="text";fnames[2]="LNAME";ftypes[2]="text";}(jQuery));var $mcj = jQuery.noConflict(true);</script>'
    
  end
  
  # Pinterest

  def sharePinterestSDK
    
    return '<script type="text/javascript" async src="//assets.pinterest.com/js/pinit.js"></script>'

  end
  
  def sharePinterest
    
    return '
    <a href="//www.pinterest.com/pin/create/button/" data-pin-do="buttonBookmark" >
      <img src="//assets.pinterest.com/images/pidgets/pinit_fg_en_rect_gray_20.png" />
    </a>
    '
    
  end
  
  # Facebook

  def shareFacebookSDK
    
    return '<div id="fb-root"></div>
<script>(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.0";
  fjs.parentNode.insertBefore(js, fjs);
}(document, \'script\', \'facebook-jssdk\'));</script>'
    
  end

  def shareFacebook location
    
    return '<div class="fb-like" data-href="http://grimgrains.com/'+location+'" data-layout="button_count" data-action="like" data-show-faces="false" data-share="false"></div>'

  end

  # Twitter

  def shareTwitterSDK

    return '<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?\'http\':\'https\';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+\'://platform.twitter.com/widgets.js\';fjs.parentNode.insertBefore(js,fjs);}}(document, \'script\', \'twitter-wjs\');</script>'
    
  end

  def shareTwitter
    
    return '<a href="https://twitter.com/share" class="twitter-share-button" data-text="Try this deliciously dark Grim Grains recipe!" data-via="RekkaBell" data-hashtags="grimgrains">Tweet</a>'

  end
  
  def commentDisqus
    
    return "<div id='disqus_thread'></div>
    <script type='text/javascript'>
        var disqus_shortname = 'grimgrains'; // required: replace example with your forum shortname
        (function() {
            var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
            dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
            (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
        })();
    </script>"
    
  end

end