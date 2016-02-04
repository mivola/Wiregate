#!/usr/bin/perl -w
##################
# Logikprozessor AddOn: create an RSS Log entry using curl; this is executed asynchronous to avoid performance problems 
# that might occur using HTTP::Request
##################
#
# COMPILE_PLUGIN
#
# benoetigt einen Konfigurationseintrag in Logikprozessor.conf:
# %settings=(
#  rssLog => {
#    url => 'http://wiregateXYZ/cometvisu/plugins/rsslog/rsslog.php' # URL to rsslog.php which writes the entry to the database
#  }
# );
# 
# weitere Erklaerungen: http://knx-user-forum.de/code-schnipsel/19912-neues-plugin-logikprozessor-pl-36.html#post384199
#

sub addRssLogViaCurl {
    my (%parameters)=@_;
    my ($title, $content, $tags, $mapping, $url);

	my $settings=$plugin_cache{"Logikprozessor.pl"}{settings};
	
    # Parameter ermitteln
    # dom, 2012-11-05: $settings auch hier auswerten. Damit kann addRssLog() direkt aus der Logik aufgerufen werden!
    $title = $parameters{title} || $settings->{rssLog}{title} || '';
    $content = $parameters{content} || $settings->{rssLog}{content} || '';
    $tags = $parameters{tags} || $settings->{rssLog}{tags} || '';
    $mapping = $parameters{mapping} || $settings->{rssLog}{mapping} || '';
    $url = $parameters{url} || $settings->{rssLog}{url} || '';
    
	# HTTP Request aufsetzen
	my $requestURL = sprintf($url."?h=%s&c=%s&t[]=%s&mapping=%s",
		uri_escape(encode("utf8", $title)),
		uri_escape(encode("utf8", $content)),
		uri_escape(encode("utf8", $tags)),
		uri_escape(encode("utf8", $mapping)));

	my $systemCall = "curl -s -g \"$requestURL\" &";
	plugin_log($plugname, "RSSLog systemCall: $systemCall") if $parameters{debug};
	my $curlResult = system($systemCall);
	plugin_log($plugname, "RSSLog curlResult: $curlResult") if $parameters{debug};

    return undef;
}
