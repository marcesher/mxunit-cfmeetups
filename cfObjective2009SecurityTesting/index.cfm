<html>
<head>
<title>cf.Objective() 2009 - Approaches to Automated Security Testing</title>
<style>
body,span,div,a{
 font-family:verdana;
 font-size:11px;
}
h1,h2,h3{
 font-family:verdana;
}
</style>
</head>
<body>
<h1>cf.Objective() 2009 - Approaches to Automated Security Testing </h1>
<h2>Contents</h2>
<li><a href="#examples">Tests and Examples</a></li>
<li><a href="#readme">README</a></li>
<li><a href="#links">Links and Resources</a> -
 These are some of the links to tools and organizations I mentioned</li>
<br />
<hr size="1" noshade="true" />
<a name="examples"></a>
<h2 style="font-family:verdana">Tests and Examples</h2>
<strong style="color:darkred">Important NOTE:</strong> My local config uses <code>dev</code> as the hostname.
If this is not defined in your etc/hosts file, you can (1) add an entry
there or (2) change the assiated code to <code>localhost</code>, or whatever you
use for a host.

<p style="font-weight:bold">Note, you will need <a href="http://mxunit.org">MXUnit</a> to run these examples.
See the README below for details.
</p>
<li><a href="code/fuzzingtests/FirefuzzSmokeTest.cfc?method=runtestremote">
Simple Firefuzz Test
</a></li>
<li><a href="code/exampleapptests/UserValidatorTest.cfc?method=runtestremote">
User Validator Test
</a></li>
<br />
<hr size="1" noshade="true" />
<a name="readme"></a>
<h2 style="font-family:verdana">README (please!)</h2>
<pre>
<cfinclude template="README.txt">
</pre>
<hr size="1" noshade="true" />
<a name="links"></a>
<h2 style="font-family:verdana">Links and Resources</h2>
Note all tools listed below are free, except for Charles. Most are
also open source.
<li><a href="http://owasp.org">OWASP</a></li>
<li><a href="http://www.owasp.org/index.php/Category:OWASP_Enterprise_Security_API">OWASP ESAPI</a></li>
<li><a href="http://www.owasp.org/index.php/Category:OWASP_WebGoat_Project">WebGoat</a> - A Hack Tutorial</li>
<li><a href="http://www.owasp.org/index.php/Category:OWASP_CAL9000_Project">CAL9000</a> - Hacker Swiss Army Knife</li>
<li><a href="http://www.owasp.org/index.php/Category:OWASP_Live_CD_Project">OWASP - LiveCD</a  > - Tons of tools all packaged up</li>
<li><a href="http://www.charlesproxy.com/">Charles</a> - Commercial Web proxy</li>
<li><a href="https://addons.mozilla.org/en-US/firefox/addon/966">TamperData - Firefox Plugin</a></li>
<li><a href="http://www.grendel-scan.com/download.htm">Grendel-Scan</a></li>
<li><a href="http://code.google.com/p/webdriver/">Webdriver</a></li>
<li><a href="http://www.mozilla.com/en-US/firefox/personal.html">Firefox</a> -  Learn to use multiple Firefox profiles for testing</li>
<li><a href="http://ha.ckers.org/xss.html">XSS (Cross Site Scripting) Cheat Sheet</a></li>
<li><a href="http://deblaze-tool.appspot.com/">Deblaze</a> - A remote method enumeration tool for flex servers</li>
<li><a href="https://h30406.www3.hp.com/campaigns/2009/wwcampaign/1-5TUVE/index.php?key=swf&jumpid=go/swfscan">SWFScan</a> - Hewlett Packard Flash scanner </li>
<br />

There're <em>many</em> other worthy tools, both free and commercial. This is by no means a definitive list, but it should be enough to get you started.

<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
</body>
</html>
