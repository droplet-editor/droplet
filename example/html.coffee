readFile = (name) ->
  q = new XMLHttpRequest()
  q.open 'GET', name, false
  q.send()
  return q.responseText

require.config
  baseUrl: '../js'
  paths: JSON.parse readFile '../requirejs-paths.json'

require ['droplet'], (droplet) ->

  # Example palette
  window.editor = new droplet.Editor document.getElementById('editor'), {
    # CSV TESTING:
    mode: 'html'
    palette: [
      {
        name: 'Basic'
        color: 'violet'
        blocks: [
        ]
      }
    ]
  }

  # Example program (fizzbuzz)
  examplePrograms = {
    descriptive: '''
      <!DOCTYPE html PUBLIC "-//IETF//DTD HTML 2.0//EN">
      <HTML>
        <HEAD>
          <TITLE>
            A Small Hello
          </TITLE>
        </HEAD>
        <BODY>
          <H1>Hi</H1>
          <P>This is very minimal <b>hello world</b> HTML document.</P>
        </BODY>
      </HTML>

      '''

    davidbau_dot_com: '''
      <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

      <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
      <meta http-equiv="author" content="David Bau" />
          <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
      <!--<meta http-equiv="description" content="A Dabbler's Weblog" />-->
      <meta http-equiv="keywords" content="programming, xml, java" />
      <meta name="ROBOTS" content="NOODP">
      <meta name="verify-v1" content="qMLTGZOiEBdB4nuOxCUMS+aAaDdlWW9x6h+QDOdY8KE=">
      <link rel="openid.server" href="http://www.myopenid.com/server" />
      <link rel="openid.delegate" href="http://davidbau.myopenid.com/" />
      <link rel="me" type="text/html" href="http://www.google.com/profiles/david.bau" />

      <title>davidbau.com</title>

      <link rel="stylesheet" href="http://davidbau.com/styles-site.css" type="text/css" />
      <link rel="alternate" type="application/rss+xml" title="RSS" href="/index.rdf" />
      <link rel="EditURI" type="application/rsd+xml" title="RSD" href="/rsd.xml" />

      <script language="javascript" type="text/javascript">
      function OpenComments (c) {
                window.open(c,
                          'comments',
                          'width=480,height=480,scrollbars=yes,status=yes');
            }
            
            function OpenTrackback (c) {
                window.open(c,
                          'trackback',
                          'width=480,height=480,scrollbars=yes,status=yes');
            }
      </script>



      <!-- MWJ 20021228: http://philringnalda.com/phpblogroll/  -->
      <script type="text/javascript">
      /* MWJ 20021231: this is Phil Ringnalda's script.txt (v0.5.4) from
         http://philringnalda.com/phpblogroll/
         $Id: blogroll-js.txt,v 1.2 2002/12/31 22:37:21 mwjames Exp $
         called by the blogroll select list produced by blogroll.php,
         in a DOM-compliant browser creates a link and clicks it to
         set the referrer, otherwise just changes location.href */   
      function gothere(where) {
        if(document.createElement){
          newLink = document.createElement("A");
          if (newLink.click){
            newLink.href = where.options[where.selectedIndex].value;
            theBod = document.getElementsByTagName("BODY");
            theBod[0].appendChild(newLink);
            newLink.click();
            }
          else{
            location.href = where.options[where.selectedIndex].value;
            }
          }
        else {
          location.href = where.options[where.selectedIndex].value;
          }
      }
      </script>

      </head>

      <body bgcolor="#FFFFFF">

      <div id="banner">

      <!--
      <div class="pullquote">Gadgets and Programming</div>
      -->

      <h1><a href="http://davidbau.com/" accesskey="1">davidbau.com</a></h1>
      <span class="description">A Dabbler's Weblog</span>
      </div>

      <div id="container">
      <table><tr style="height:0"><td>
      <!-- IE's implementation of the box model is way too buggy - let's use tables... davidbau -->
      <td rowspan=2 id="centercontent">



          <h2 class="date">
        October 17, 2014
        </h2>
       

        <div class="blogbody">
       
        <a name="000456"></a>
        <h3 class="title">Making a $400 Linux Laptop</h3>
       
        <p>At some point, every programmer should learn how to use the Unix command-line.  </p>

      <p>So I started teaching Piper a bit about how to use a command line shell this week.  We installed <a href="https://github.com/dnschneid/crouton">crouton</a> on her Chromebook, and we used it to look at a couple files and build little shell script.  That continuing adventure is a story for another time.</p>

      <p>But crouton was the surprise for me.  I immediately fell in love it.  The Linux-on-chromebook setup was so great that a few days later, I made another one.  It's an amazing deal: for about $400, I got a lightweight linux box with 4GB RAM, 128G SSD mostly empty, 8 hours of battery, and a touchscreen!  Here is what I bought:</p>

      <p><a href="http://www.amazon.com/Acer-C720P-Chromebook-Touchscreen-micro-architecture/dp/B00KDQYJUI?tag=dqsd-20">The new C720P with 4GB ram, but the cheap configuration with a 16G SSD</a>

      <p><center><img src="http://static.acer.com/up/Resource/Acer/Chromebook/AGW2%20C/Images/20131021/C720-gray-touch-photo-gallery-04.png" height=120></center>

      <p><a href="http://www.amazon.com/gp/product/B00EZ2E8NO?tag=dqsd-20">MyDigitalSSD SC2 Super Cache 2 42mm SATA III 6G M.2 NGFF M2 SSD Solid State Drive (128GB)</a>

      <p><center><img src="http://www.thessdreview.com/wp-content/uploads/2014/02/MyDigitalSSD-SuperCache-2-M.2-128GB-SSD-Front.png" height=80></center>

      <p>It was a terrific little project, very easy.  The basic idea is to follow <a href="http://www.androidcentral.com/how-upgrade-ssd-your-acer-c720-chromebook">the SSD upgrade instructions here</a></p>

      <p>There are only a couple gotchas.  One is at the start: you want to begin by burning a recovery image on a USB stick, which should just take a couple minutes.  But the instructions above say to use the URL "chrome://imageburner" to make this, and it doesn't actually work on the c720p (it runs, but then it hangs).  Instead, go to the Chrome App store and search for the <a href="https://chrome.google.com/webstore/detail/chromebook-recovery-utili/jndclpdbaamdhonoechobihbbiimdgai">Chromebook Recovery Utility</a>.  That will make a recovery image quickly.</p>

      <p>Then you're ready to upgrade the disk! Piper and I unscrewed the laptop and followed <a href="http://www.androidcentral.com/how-upgrade-ssd-your-acer-c720-chromebook">the instructions here</a> - it was a great chance for us to take a look at all the innards of the computer, and it was a very easy upgrade.</p>

      <p>The only other gotcha is that he M2 SSD card doesn't go in either way: there is a "right" and a "left" - one side with four gold connectors and the other side with five.  The big brand-name sticker on the new SSD we got was on the opposite side as the old one, which confused us; it just needed to be flipped upside-down, sticker down.</p>

      <p>Then we reassembled and rebooted the computer, stuck in the recovery USB drive, and then followed <a href="http://www.chromium.org/chromium-os/developer-information-for-chrome-os-devices/acer-c720-chromebook">this page's advice on how to enable developer mode</a>.  In short: ESC-F3 and Power.  Then control-D, and then wait.  Apparently converting the huge 128G SSD to developer mode, takes a little while; but there is an ASCII art progress bar at the top of the screen.</p>

      <p>Finally, we downloaded crouton from <a href="http://goo.gl/fd3zc">goo.gl/fd3zc</a>, and then we used ctrl-alt-T to bring up a crosh tab; entered shell; then ran the crouton script to install a command-line-only debian.</p>

      <p>It's terrifically functional - I used it to build a current build of node.js and some other things.  It's not terribly secure, because anybody who can log into the machine can get root access.  But for student work, it's great!</p>
       
       
        <br clear=all />
        <div class="posted">Posted by David at <a href="http://davidbau.com/archives/2014/10/17/making_a_400_linux_laptop.html">08:27 PM</a>
          | <a href="http://davidbau.com/archives/2014/10/17/making_a_400_linux_laptop.html#comments">Comments (0)</a>
       
       
        </div>
       
        </div>
       




          <h2 class="date">
        October 03, 2014
        </h2>
       

        <div class="blogbody">
       
        <a name="000455"></a>
        <h3 class="title">Teaching About Data</h3>
       
        <p>How do you teach beginning programmers about data in the internet age?</p>

      <ul><li>Teach the kids how to learn on their own: for example, can you find and use technical data sources using Google?  Self-teaching is a key hallmark of successful students.
      <li>Teach using real-world mainstream idioms: Javascript, jQuery, HTML5.  This lets kids directly apply code examples from the web.  We take advantage of <a href="http://pencilcode.net">Pencil Code</a> to make this easy.
      <li>Keep things real: it is more meaningful if we use real data to answer real-world questions!</ul>

      <p>It is a real pleasure to see students learning to learn independently this way.</p>

      <p><center><img src="/images/photo/hackclubirene.jpg" width=400></center>

      <p>Last week I taught a class about data that went very well.  It was interesting enough that maybe others might want to try to do the same.</p>

      <p><b>Using Google to find a Technical Article</b></p>

      <p>The class started with an acronym: JSON. A lot of data on the internet is made available using a technology called JSON, so we began by searching Google for code ideas by using the query [<a href="http://www.google.com/search?q=using+json+to+get+public+data">Using JSON to get public data</a>].  That query lead us to a few articles, including a blog post by Mark Lee....</p>
       
          <span class="extended"><a href="http://davidbau.com/archives/2014/10/03/teaching_about_data.html#more">Continue reading "Teaching About Data"</a></span>
       
        <br clear=all />
        <div class="posted">Posted by David at <a href="http://davidbau.com/archives/2014/10/03/teaching_about_data.html">12:54 PM</a>
          | <a href="http://davidbau.com/archives/2014/10/03/teaching_about_data.html#comments">Comments (0)</a>
       
       
        </div>
       
        </div>
       




          <h2 class="date">
        July 10, 2014
        </h2>
       

        <div class="blogbody">
       
        <a name="000453"></a>
        <h3 class="title">Code Gym</h3>
       
        <div style="display:table;float:right;padding-left:5px">
      <img src="/images/photo/ioy_pair.jpg"><br>
      <br>
      <img src="/images/photo/ioy_googler.jpg"><br>
      </div>

      <p><p>At the first Google I/O Youth program this year, we used a new open-source website, the Pencil <a href="http://codegym.pencilcode.net/">Code Gym</a>, and it was a smashing success!</p>

      <p>The website is a place where beginners can create open-ended creative projects in graphics, music, or interactive fiction, all using a little bit of simple code.</p>

      <p>It is based on <a href="http://pencilcode.net">Pencil Code</a>, which means that you program in CoffeeScript with the Pencil Code editor and turtle library.  It comes with lots of ideas, hints, and a nice on-line reference.  The students who came through to use it had a wide range of backgrounds and knowledge, with many first-time coders and also a few experienced code-jockeys.</p>

      <p>The kids were bold and tried every project we had to offer.  I was surprised by the musical talent of some of the kids (check out the projects), and I particularly enjoyed working with the deaf kids who attended - some of the deaf kids even did musical projects.</p>

      <p>You can see the projects put together by code gym students here, at the <a href="http://gymstage.pencilcode.net/home/">Code Gym Stage</a>.</p>

      <p><center><img src="/images/photo/ioy_arrival.jpg" width="240"> <img src="/images/photo/ioy_music.jpg" width="240"> <img src="/images/photo/ioy_alison.jpg" width="240"> <img src="/images/photo/ioy_rainbow.jpg" width="240"> <img src="/images/photo/ioy_signing.jpg" width="240"> <img src="/images/photo/ioy_together.jpg" width="240"> <img src="/images/photo/ioy_david.jpg" width="240"> <img src="/images/photo/ioy_sharing.jpg" width="240"> <br />
      </center>
       
       
        <br clear=all />
        <div class="posted">Posted by David at <a href="http://davidbau.com/archives/2014/07/10/code_gym.html">05:18 PM</a>
          | <a href="http://davidbau.com/archives/2014/07/10/code_gym.html#comments">Comments (0)</a>
       
       
        </div>
       
        </div>
       




          <h2 class="date">
        May 23, 2014
        </h2>
       

        <div class="blogbody">
       
        <a name="000452"></a>
        <h3 class="title">Musical.js</h3>
       
        <p><a href="https://github.com/PencilCode/musical.js"><img src="/images/art/turtlekeyboard.png" width=200 align=right class=imgright></a>Here is <a href="https://github.com/PencilCode/musical.js">musical.js</a>, which is a small (<a href="https://raw.githubusercontent.com/PencilCode/musical.js/master/musical.min.js">less than 17K minified</a>) javascript library that can translate from ABC notation into WebAudio, for playing simple tunes on any modern browser.  It has no dependencies, and it can be used as a plain script, an AMD module, or as a node.js module.  It also includes a simple synthesizer for creating your own instrument, including a basic electric piano sound.</p>

      <p>The library is really simple to use.  Basically, include the script musical.js, and then:</p>

      <pre style="background:lavender;padding:5px;">
      piano = new Instrument('piano');
      piano.play('ccggaag2');
      </pre>

      <p>Then with any WebAudio browser, you will be Baahing with the Black Sheep, Twinkling with the Stars, or singing your ABCs with me.  The notation used is called <a href="http://abcnotation.com/">ABC Notation</a>, and it is used for a lot of simple sheet music online.</p>

      <p>Less-simple music can be played just as easily.  Here are some short examples: <a href="https://rawgit.com/PencilCode/musical.js/master/test/demo/minuet.html">Minuet</a>, <a href="https://rawgit.com/PencilCode/musical.js/master/test/demo/september.html">September</a>, <a href="https://rawgit.com/PencilCode/musical.js/master/test/demo/sonata.html">Sonata</a> and <a href="https://rawgit.com/PencilCode/musical.js/master/test/demo/moonlight.html">Moonlight</a>.</p>

      <p>The library comes out of work from beefing up music support in <a href="http://pencilcode.net/">Pencil Code</a>. The WebAudio sequencer in that library has improved enough that it deserves to be a separate library.</p>

      <p>You can also <a href="http://event.pencilcode.net/edit/mhack/piano">play with it as part of the turtle library on pencil code here</a>: that example is a simple interactive piano keyboard where you can see the keys.</p>

      <p>Have fun.  Let me know if you encounter any problems, or if you have any ideas for improvements.  Always looking for open-source contributions.</p>
       
       
        <br clear=all />
        <div class="posted">Posted by David at <a href="http://davidbau.com/archives/2014/05/23/musicaljs.html">03:39 PM</a>
          | <a href="http://davidbau.com/archives/2014/05/23/musicaljs.html#comments">Comments (1)</a>
       
       
        </div>
       
        </div>
       




          <h2 class="date">
        January 31, 2014
        </h2>
       

        <div class="blogbody">
       
        <a name="000451"></a>
        <h3 class="title">Pencil Code at Worcester Technical High School</h3>
       
        <p>I spent a day last week at <a href="http://worcestertechnicalhigh.com/">Worcester Technical High School</a> with all their CS students, using Pencil Code as a teaching tool.</p>

      <p>Vocational students are motivated by real-world applications, and the teachers at WTHS are amazing.  They bring their entire group of students through four years of rigorous CS classes, ending with AP computer science in their Senior year.  "There is a difference," the teachers explain, "between offering CS exposure and teaching mastery.  We teach mastery."</p>

      <p>For this group of CS-focused students who have been learning Java, ASP.NET, and HTML, Pencil Code is a terrific tool.  The instant feedback lets them apply and experiment with difficult concepts quickly.  And because it is so open, Pencil Code is lets them assemble concepts from varied areas.</p>

      <p>Here are the worksheets we used in Worcester:</p>

      <p><a href="http://activity.pencilcode.net/home/worksheet/html.html">Combining Three Languages using HTML</a><br />
      <a href="http://activity.pencilcode.net/home/worksheet/recursion.html">Exploring Recursion with Fractals</a><br />
      <a href="http://activity.pencilcode.net/home/worksheet/classes.html">Using Subclasses to make Moving Sprites</a></p>

      <p>In all three of these lessons, the turtle is a starting point, but it is just a stepping stone into real-world applications and deeper concepts.</p>

      <p>The day was terrific.  We found that we taught some unexpected lessons.  The teachers pointed out that the indent-based syntax of CoffeeScript (and the instant-error checking in the IDE) connected with several kids for the first time who now could really "get" how scoping works. Some kids never indent their blocks, but with CoffeeScript, they have to!  And surprise - once it is indented, they can see clearly how it works.</p>

      <p>After the day, the AP students in the group suggested "We should start with Pencil Code!"</p>

      <p>I am holding hackathons to build more lessons and materials that take advantage of the Pencil Code environment, and to improve the tool itself based on what we are seeing in classrooms.  The first hackathon is on February 14 - sign up at <a href="http://hack.pencilcode.net/">hack.pencilcode.net</a>.</p>
       
       
        <br clear=all />
        <div class="posted">Posted by David at <a href="http://davidbau.com/archives/2014/01/31/pencil_code_at_worcester_technical_high_school.html">08:56 AM</a>
          | <a href="http://davidbau.com/archives/2014/01/31/pencil_code_at_worcester_technical_high_school.html#comments">Comments (0)</a>
       
       
        </div>
       
        </div>
       




          <h2 class="date">
        January 19, 2014
        </h2>
       

        <div class="blogbody">
       
        <a name="000450"></a>
        <h3 class="title">A Bad Chrome Bug</h3>
       
        <p>The latest version of Chrome has a bad bug that seems specific to the GPU in my (Samsung series 9) laptop.  It actually took me a couple days to notice the problem and realize it was Chrome's fault and not the fault of the underlying website.</p>

      <p>Here is the bug: when you visit a fast website that has no images (and no javascript-rendered changing content), Chrome does not render anything.  It just leaves the page blank.  It will render as soon as you scroll or cause something to redraw.</p>

      <p>My laptop does not have an exotic configuration - it is a 2012-era windows laptop with a very vanilla Windows 7 setup, so I suspect many people may be affected by the bug.</p>

      <p>The funny thing, the bug is something you may not have noticed because almost every webpage we might visit day-to-day contains an image.  And pages that do not have images - well, as soon as you scroll, they render, so you might have thought that the webpage was slow and then popped in when you scrolled.</p>

      <p>If you use Chrome, try it out on your computer.  Does it happen to you?  To test, here are a couple links to webpages that have no images.  If they render for you, try pressing "refresh" to see if they render once they're cached and fast:</p>

      <p><a href="http://www.htmlandcssbook.com/code-samples/chapter-01/example.html">http://www.htmlandcssbook.com/code-samples/chapter-01/example.html</a></p>

      <p><a href="http://davidbau.com/bugreport/simplest-document-broken.html">http://davidbau.com/bugreport/simplest-document-broken.html</a></p>

      <p>If you see the problem, put in information about your hardware, and vote for the bug to be fixed here:</p>

      <p>(<b>Update</b>: found an old issue that appears to have reported the same problem in beta - <a href="https://code.google.com/p/chromium/issues/detail?id=325309">https://code.google.com/p/chromium/issues/detail?id=325309</a>)<br />
      </p>
       
       
        <br clear=all />
        <div class="posted">Posted by David at <a href="http://davidbau.com/archives/2014/01/19/a_bad_chrome_bug.html">10:58 AM</a>
          | <a href="http://davidbau.com/archives/2014/01/19/a_bad_chrome_bug.html#comments">Comments (1)</a>
       
       
        </div>
       
        </div>
       




          <h2 class="date">
        January 09, 2014
        </h2>
       

        <div class="blogbody">
       
        <a name="000449"></a>
        <h3 class="title">PhantomJS and Node.JS</h3>
       
        <p>I'm setting up a <a href="https://github.com/PencilCode/pencilcode-site">guide for contributing to PencilCode</a>.</p>

      <p>There are now integration tests.  In about 20 seconds, the "grunt test" command starts a local development server, starts a headless webkit, and tests most of the core functionality on the website, including browsing users and directories, loading, editing, running, saving, and deleting programs, and using passwords to log in.  You get this all for free by just installing node.js and the grunt build tool, and building the source.</p>

      <p>The integration tests look like this: <a href="https://github.com/PencilCode/pencilcode-site/blob/master/test/edit_code.js">edit_code.js</a> - they are low-level but surprisingly clean and quick.  The tests are designed to be run by <a href="http://visionmedia.github.io/mocha/">mocha</a> (a command-line javascript test runner), and they depend on <a href="https://npmjs.org/package/node-phantom-simple">node-phantom-simple</a>, which is the lightest-weight headless webkit I could drive from a node.js build environment.  The <a href="https://github.com/PencilCode/pencilcode-site/blob/master/Gruntfile.js">Gruntfile</a> sets up everything.  One of the curious things is that the <a href="https://github.com/PencilCode/pencilcode-site/blob/master/dev/server.js">development server</a> actually runs as a proxy server.  This allows it to intercept test-browser requests to full DNS names even though it doesn't own the DNS name.</p>

      <p><b>Why Tests are Awesome</b></p>

      <p>The test setup is designed to maximize developer productivity: the default test target runs tests very similar to production, with all the code compiled and minified, but the "devtest" target runs the same tests directly against unminified unoptimized source code, for easier debugging.</p>

      <p>The beauty of a good integration test is that the code can now be aggressively changed without fear that the change will break something important.  If some change breaks something, we can know in 20 seconds.</p>

      <p>Right now my integration tests run quickly, because my test matrix is small.  As the test matrix grows larger, many open source projects use <a href="https://travis-ci.org/">Travis</a> continuous integration.  Travis is a coud service that runs integration tests automatically on every git push.  Anybody interested in trying out Travis?  It sounds neat.</p>

      <p>Next step is to add more thorough tests for <a href="https://github.com/PencilCode/jquery-turtle">jquery-turtle</a> as well; then it will be time to refactor the code so some interesting features can be added.</p>
       
       
        <br clear=all />
        <div class="posted">Posted by David at <a href="http://davidbau.com/archives/2014/01/09/phantomjs_and_nodejs.html">07:29 PM</a>
          | <a href="http://davidbau.com/archives/2014/01/09/phantomjs_and_nodejs.html#comments">Comments (1)</a>
       
       
        </div>
       
        </div>
       




          <h2 class="date">
        January 03, 2014
        </h2>
       

        <div class="blogbody">
       
        <a name="000448"></a>
        <h3 class="title">Integration Testing in Node.js</h3>
       
        <p>What's the best way to run integration tests on an AJAX-heavy website?</p>

      <p>I have been toughening up the <a href="pencilcode.net">pencilcode.net</a> deployment environment.  (<a href="https://github.com/PencilCode">git repos here</a>.)  While the pencilcode server is an <a href="http://nginx.org/en/">nginx</a> webserver backed by a small <a href="http://en.wikipedia.org/wiki/Web_Server_Gateway_Interface">python</a>-<a href="http://uwsgi-docs.readthedocs.org/en/latest/">uwsgi app server</a>, the pencilcode development environment is 100% javascript, with a <a href="http://nodejs.org/">node.js</a> and <a href="https://npmjs.org/">npm</a> and <a href="http://gruntjs.com/">grunt</a>-based build, and a small <a href="http://expressjs.com/guide.html">express.js</a> test server that proxies backend calls to the production server.</p>

      <p>If you think that's just a lot of hipster coder buzwords, wait... there's more.</p>

      <p>This morning I broke pencilcode.net due to a code change: while refactoring the editor source code to use proper <a href="http://requirejs.org/">require.js</a> organization, I messed up by bringing in an old version of <a href="https://github.com/davidbau/seedrandom">seedrandom</a> that wasn't compatible with <a href="https://github.com/amdjs/amdjs-api/wiki/AMD">AMD loading</a>.  Seedrandom is my own library, and so it was doubly my own fault!  The result was that all password checking was broken on the site for a few hours.  The bug took about 10 minutes to fix: I just had to use <a href="https://npmjs.org/package/grunt-bowercopy">bowercopy</a> to upgrade seedrandom to its latest <a href="http://bower.io/">bower</a> package, then run the requirejs <a href="https://github.com/gruntjs/grunt-contrib-requirejs">optimizer</a>, then redeploy.</p>

      <p>But the real bug?  I don't have any integration tests on pencilcode.net.  I should have never pushed broken passwords in the first place.  While I have some little unit tests, I really need end-to-end integration tests that bring up the whole website, browse it with a headless browser, and click around authenticating and editing and running and saving, to make sure it all works as expected.</p>

      <p>The 2010 way of doing this used to be a big system like <a href="http://docs.seleniumhq.org/">Selenium</a>.  But it feels like in 2013 I should be able to do this in lighter-weight way.  I have seen that <a href="https://github.com/gruntjs/grunt-lib-phantomjs">grunt-phantomjs</a> works pretty well with <a href="http://qunitjs.com/">QUnit</a> unit tests.  But almost all the javascript-based tools I've seen are designed for tiny unit tests.</p>

      <p>How do I run tests that exercise the whole system end-to-end?  Maybe something like travist's <a href="https://github.com/travist/jquery.go.js">jquery.go.js</a>?  Has anybody found the right way to do integration tests in the node.js world?<br />
      </p>
       
       
        <br clear=all />
        <div class="posted">Posted by David at <a href="http://davidbau.com/archives/2014/01/03/integration_testing_in_nodejs.html">06:52 PM</a>
          | <a href="http://davidbau.com/archives/2014/01/03/integration_testing_in_nodejs.html#comments">Comments (0)</a>
       
       
        </div>
       
        </div>
       




          <h2 class="date">
        December 20, 2013
        </h2>
       

        <div class="blogbody">
       
        <a name="000447"></a>
        <h3 class="title">Second Edition of Pencil Code</h3>
       
        <p><p>The best parenting advice: before your children grow up, teach them something.  They will remember it forever.</p>

      <p><p>So in that spirit, here is an activity to do with your daughter or son over the holidays: give and play with the <a href="http://pencilcode.net/book">second edition of Pencil Code</a> (just released).  Teach them how to write little computer programs.</p>

      <p><p>The <a href="http://pencilcode.net/book">new edition</a> adds a 20 page appendix with a CoffeeScript tutorial, which is particularly helpful if Mom and Dad do not create software for a living.  If you already got the first edition and you wish you had the tutorial, do not worry - <a href="http://davidbau.com/coffeescript/">get the tutorial on the web here</a> and print it.</p>

      <p><p>While you are playing with <a href="http://pencilcode.net">Pencil Code</a>, also be sure to look at the <a href="http://guide.pencilcode.net/">extra free materials on guide.pencilcode.net</a> - there are handy printable protractors, reference sheets, activities, and videos.  And almost all the material in the book is available online for free.  If you do not want to use paper, you can just go to <a href="http://pencilcode.net/">pencilcode.net</a> and play for free.</p>

      <p><p>Still, the book makes a terrific present.  Children show their incredible sense of wonder <a href="https://www.google.com/search?tbm=isch&q=pencil+code+2013+amsa5#facrc=_&imgrc=TTyR1F91VjTUqM%3A%3BgrNixKRPMTJ0CM%3Bhttp%253A%252F%252Fevent.pencilcode.net%252Fhome%252Fhoc2013%252Fpics%252Famsa5.jpg%3Bhttp%253A%252F%252Fevent.pencilcode.net%252F%3B512%3B705">when leafing through</a> a <a href="http://instagram.com/p/iJPts3kSJz/">little handbook of examples</a> of magical code, each one illustrated in color.  Each page is a map to a <a href="http://guide.pencilcode.net/home/recursion/trees">little adventure</a>, a puzzle and a discovery waiting to unfold.</p>

      <p><p><a href="http://books.google.com/books/about?id=kJRhAgAAQBAJ">The book has more than 100 little programming projects</a>, and they range in depth and ability from 1st grade up to 12th grade.  The first page hows how to make a webpage that draws a simple line.  The last one shows how to make an artificial intelligence that will beat you at tic-tac-toe.  In between, draw a flower, make a game of tag, or draw the Mandelbrot set.</p>

      <p><p>It is a little book crammed with ideas, designed to last for a decade. As long as it is in your house, it is a reminder: there is something much cooler than playing computer games: <em>making your own</em>.</p>

      <p><p>(Also, while you're getting the book - Amazon didn't bring the <a href="http://www.amazon.com/Pencil-Code-David-Bau-III/product-reviews/1494280787?showViewpoints=1">reviews of the first edition</a> along to the <a href="http://www.amazon.com/Pencil-Code-A-Programming-Primer/dp/149434744X">second edition</a>, so leave a nice review!)</p>
       
       
        <br clear=all />
        <div class="posted">Posted by David at <a href="http://davidbau.com/archives/2013/12/20/second_edition_of_pencil_code.html">12:22 PM</a>
          | <a href="http://davidbau.com/archives/2013/12/20/second_edition_of_pencil_code.html#comments">Comments (0)</a>
       
       
        </div>
       
        </div>
       




          <h2 class="date">
        December 18, 2013
        </h2>
       

        <div class="blogbody">
       
        <a name="000446"></a>
        <h3 class="title">Learning to Program with CoffeeScript</h3>
       
        <p>Is CoffeeScript a good first programming language to learn?

      <p>Absolutely!

      <p>I have written a new <a href="/coffeescript/">tutorial for beginners to learn to program with CoffeeScript</a>.

      <p>Like Python, CoffeeScript has a punctuation-light syntax that is easy to type so that beginners can get straight to the essential concepts instead of fiddling with semicolons and matching curly braces.  And yet it is a real language used by pros, so you can learn the essential concepts that you will see in other languages: variables, algebraic expressions, control flow, functions, lists, objects, classes, closures, exceptions, and (if you use Iced) even continuations.

      <p><a href="/coffeescript/"><img style="float:left;padding-right:5px;border:0" style="imgleft" src="/coffeescript/hangman.png"></a>The big advantage of learning CoffeeScript over Python is that you can start <a href="http://pencilcode.net/first" target="_blank">right now</a> in your browser, without installing anything!  Although CoffeeScript doesn't have the same full-featured standard library that Python has, <a href="http://jquery.org">jQuery</a> makes a fine standard library.  To help beginners, I have put together jQuery, a turtle graphics plugin <a href="http://plugins.jquery.com/turtle/">jQuery-turtle</a>, and a syntax coloring editor on <a href="http://pencilcode.net/">pencilcode.net</a>.

      <p>The tutorial teaches you how to program in CoffeeScript by building a game of hangman from scratch. It takes a couple hours to learn enough programming to make hangman.  You will learn about:

      <ul>
      <li>Memory and naming
      <li>Computer arithmetic
      <li>Using functions
      <li>Simple graphics
      <li>How to make a program
      <li>Input and output
      <li>Loops and choices
      <li>Delays and synchronization
      <li>Connecting to the internet
      </ul>

      <p>At the end we will have a game we can play.

      <p>Here is the tutorial: <a href="/coffeescript/">Learning to Program with CoffeeScript</a>.
       
       
        <br clear=all />
        <div class="posted">Posted by David at <a href="http://davidbau.com/archives/2013/12/18/learning_to_program_with_coffeescript.html">10:30 AM</a>
          | <a href="http://davidbau.com/archives/2013/12/18/learning_to_program_with_coffeescript.html#comments">Comments (0)</a>
       
       
        </div>
       
        </div>
       




          <h2 class="date">
        December 16, 2013
        </h2>
       

        <div class="blogbody">
       
        <a name="000445"></a>
        <h3 class="title">Teaching Math Through Pencil Code</h3>
       
        <p>How young is too young to teach programming?

      <p>I have been using <a href="http://pencilcode.net">Pencil Code</a> with children from 1st grade to 12th grade over the last few weeks.  All ages have a lot in common: they all need to learn the same programming concepts at the beginning.  Even before learning control flow, they need to understand sequencing, debugging, and how to think about the state of the computer.  However, there is one big difference between younger kids and older kids: the younger kids have not yet learned a lot of math fundamentals.

      <p><b>Using Programming to Reinforce Math Curriculum</b>

      <p>When a fourth grader asks "what is the command to make the turtle go that way?" it is really a math question.  The idea of estimating degrees for a turn seems perfectly concrete to an older student, but if you are a 4th grader, measurement of angles is a new idea that is hard to grasp.  The fourth grader wrestling with the turtle's direction is really asking, "how do I measure the angle that I want?"

      <p>The problem of getting the turtle to turn the right way is a valuable math teaching moment. Do not give away the answer. Instead, give the student a <a href="http://pencilcode.net/material/measuring.pdf">protractor</a>, and the student will align it with the turtle on the screen and pick out the angle they want.

      <p>Pointing the turtle requires an extra level of care beyond math class, because the student will need to note not only the degrees, but also whether they want a "right turn" or "left turn."  But once the proper angle is found and the student has entered "rt 60," they they are rewarded with a working program as well as an insight: angle measurements are pretty useful!

      <p>When teaching classrooms of fourth graders, I have been using handouts with paper "<a href="http://pencilcode.net/material/measuring.pdf">turtle protractors</a>" that illustrate the turtle in the middle of a compass rose.  The printable measurement sheet also includes a "<a href="http://pencilcode.net/material/measuring.pdf">turtle number line</a>" so that younger kids can do the same exercise with linear measurements.  These paper supplements are invaluable.

      <p><b>Programming Motivates a Range of Math Curriculum</b>

      <p>Computers speak the language of math, so learning to program your computer is a good reason to learn a bit of math.

      <p>Math topics that tie directly in with Pencil Code include:
      <ul>
      <li><a href="http://www.corestandards.org/Math/Content/1/NBT">Number comparisons &lt; &gt; =, which is a 1st grade concept</a>.
      <li><a href="http://www.corestandards.org/Math/Content/2/MD">Distance on the number line, which is a 2nd grade concept</a>.
      <li><a href="http://www.corestandards.org/Math/Content/2/MD">Perimeter of polygons, which is a 3rd grade concept</a>.
      <li><a href="http://www.corestandards.org/Math/Content/4/MD">Measurement of angles, which is a 4th grade concept</a>.
      <li><a href="http://www.corestandards.org/Math/Content/5/MD">Cartesian coordinate systems, which is a 5th grade concept</a>.
      <li><a href="http://www.corestandards.org/Math/Content/6/EE">Variables and expressions, which are 6th grade concepts</a>.
      <li><a href="http://www.corestandards.org/Math/Content/7/SP">Randomness</a>, and also <a href="http://www.corestandards.org/Math/Content/7/G">supplementary angles, which are 7th grade concepts</a>.
      <li><a href="http://www.corestandards.org/Math/Content/8/F">Functions</a>, and <a href="http://www.corestandards.org/Math/Content/8/G">transformations and Pythagorean distance, which are 8th grade concepts</a>.
      </ul>

      <p>Programming is a good way to learn about to the importance of precision in measurements and the use of numbers to quantify many things.  Normally this is hard-won knowledge, gained through years of teachers marking mistakes on math homework.  But in programming, the purpose of math is not to get a good score on a test.  The purpose of the math is to get your program to work.  It is a self-teaching lesson.

      <p><b>Programming Motivates Advanced Concepts</b>

      <p>Programming draws kids in to playing with concepts that would normally be considered too abstract and dry for math class.

      <p>For example, kids particularly love creating programs that draw circles and curves.  However, since arc measurements are (sadly) considered an advanced <a href="http://www.corestandards.org/Math/Content/HSG/C">High School</a> concept, they will not have been covered before most beginning programmers try Pencil Code.

      <p>With Pencil Code we have been introducing arcs using an <a href="http://pencilcode.net/material/arc.pdf">arc-measurement sheet</a> that is similar to the protractor sheet.  Kids can hold it up to the screen it to visualize (for example) the fact that the bottom of a "U" is 180 degrees of an arc of a circle.  Fourth graders enjoy measuring arcs as part of their programs: arcs make it possible to create beautiful <a href="http://pencilcode.net/material/flower.pdf">flowers</a> and <a href="http://pencilcode.net/material/car.pdf">sports cars</a> and <a href="http://pencilcode.net/material/initial.pdf">inscriptions</a>.

      <p>Perhaps when these Pencil Code fourth graders arrive in high school geometry class years from now, arc measurements will be less of a mystery and more of a "cool" topic.
       
       
        <br clear=all />
        <div class="posted">Posted by David at <a href="http://davidbau.com/archives/2013/12/16/teaching_math_through_pencil_code.html">03:37 PM</a>
          | <a href="http://davidbau.com/archives/2013/12/16/teaching_math_through_pencil_code.html#comments">Comments (0)</a>
       
       
        </div>
       
        </div>
       




          <h2 class="date">
        December 09, 2013
        </h2>
       

        <div class="blogbody">
       
        <a name="000444"></a>
        <h3 class="title">Hour of Code at Lincoln</h3>
       
        <img class="imgright" style="float:right; width:250px; clear:right; padding-bottom:3px;" src="http://event.pencilcode.net/home/hoc2013/pics/lincoln1.jpg"><img class="imgright" style="float:right; width:250px; clear:right; padding-bottom:3px;" src="http://event.pencilcode.net/home/hoc2013/pics/lincoln2.jpg"><div class="imgright" style="float:right; width:250px; clear:right; padding-bottom:3px;">Lincoln classrooms participating in the Hour of Code 2013.</div>
      <p>Today I spent the day at Lincoln public school, helping grade school classes participating in the Hour of Code.  We were hosted by teachers Cindy Matthes and Terry Green, who both have a long history of championing technology education for young kids.  Terry literally <a href="http://terrygreenscienceteacher.com/Buy_The_Book.html">wrote the book on teaching engineering to K-2 kids</a>.
      <p>Here are some of the fourth-grade creations - as you can see, at
      this level, coding is mostly about learning about quantities and careful sequencing.<ul>
      <li><a href="http://izzyr.pencilcode.net/edit/house">izzr/house</a>
      <li><a href="http://kittykat13277.pencilcode.net/edit/house">kittykat13277/house</a>
      <li><a href="http://jwoods.pencilcode.net/edit/housedoe">jwoods/housedoe</a>
      <li><a href="http://posey18818.pencilcode.net/edit/Smileface">posey18818/Smileface</a>
      </ul>
      <p>Several of the fourth grade girls were the natural leaders their Hour of Code classes: they had a ton of ideas of what they wanted to draw.  They wanted to know how to get the colors they wanted, how to draw curves, how to draw text, and how to make the turtle wear a different colored shell.  There were very few preconceptions about what they could or could not do with a computer at that age, and they were persistent in getting things to work.
      <p>The middle-school group was self-selected (and, in an odd contrast with the experience in the fourth grade group, they were mostly boys).  They were able to speed through Lesson 1 at <a href="http://event.pencilcode.net/hoc2013/">event.pencilcode.net</a> in 30 minutes, and we did a bit of Lesson 2 as well.  In middle school, there is a pretty broad spectrum of styles - some kids wanted to try small experiments of their own invention, and other kids wanted to type in a complicated ambitious program from the book to see if they could get it to work.  The <a href="http://www.amazon.com/Pencil-Code-David-Bau-III/dp/1494280787">book of 100 example projects</a> was a useful tool for this older group.

       
          <span class="extended"><a href="http://davidbau.com/archives/2013/12/09/hour_of_code_at_lincoln.html#more">Continue reading "Hour of Code at Lincoln"</a></span>
       
        <br clear=all />
        <div class="posted">Posted by David at <a href="http://davidbau.com/archives/2013/12/09/hour_of_code_at_lincoln.html">05:32 PM</a>
          | <a href="http://davidbau.com/archives/2013/12/09/hour_of_code_at_lincoln.html#comments">Comments (0)</a>
       
       
        </div>
       
        </div>
       




          <h2 class="date">
        December 08, 2013
        </h2>
       

        <div class="blogbody">
       
        <a name="000443"></a>
        <h3 class="title">Hour of Code at AMSA</h3>
       
        <img class="imgright" style="float:right; width:250px; clear:right; padding-bottom:3px;" src="http://event.pencilcode.net/home/hoc2013/pics/amsa1.jpg"><img class="imgright" style="float:right; width:250px; clear:right; padding-bottom:3px;" src="http://event.pencilcode.net/home/hoc2013/pics/amsa3.jpg"><div class="imgright" style="float:right; width:250px; clear:right; padding-bottom:3px;">Families participating in the AMSA Hour of Code 2013.</div>
      <p>Yesterday I participated in a wonderful <a href="http://www.amsacs.org/news/hour-of-code-amsa/">Hour of Code event at AMSA</a>.  The AMSA and Marlboro teachers there are absolutely amazing, dynamic teachers.  I brought some new <a href="http://pencilcode.net/">Pencil Code</a> materials and books to use.  Within 15 minutes they had things copied and stapled together; they had reviewed the new materials; and they were ready to roll.

      <p><a href="http://event.pencilcode.net/home/hoc2013/">Here are the materials we used yesterday.</a>

      <p>Attendance was terrific, overflowing the reserved classroom.  So they opened up a second classroom and divided kids by level.  The higher level kids went through "Lesson 3", which covers topics such as variables, control flow, arrays, randomness, synchronization, and network requests.

      <p>The beginner kids started with "Lesson 1", which gets you going with basic sequencing and turtle drawing.  At the 30 minute point, they were doing well, so I showed them the video for "Lesson 2", which is a nudge to get you to be thoughtful and creative.  Lesson 2 also demonstrates arcs, which are a great tool for students to use to make beautiful things.

      <p>A few creations from the rank beginner kids - a lot of understanding in just one hour!
      <ul>
      <li><a href="http://ginny.pencilcode.net/edit/boat">http://ginny.pencilcode.net/edit/boat</a>
      <li><a href="http://eightquarts.pencilcode.net/edit/Ben">http://eightquarts.pencilcode.net/edit/Ben</a>
      <li><a href="http://pjwd.pencilcode.net/edit/first">http://pjwd.pencilcode.net/edit/first</a>
      </ul>
       
       
        <br clear=all />
        <div class="posted">Posted by David at <a href="http://davidbau.com/archives/2013/12/08/hour_of_code_at_amsa.html">11:35 PM</a>
          | <a href="http://davidbau.com/archives/2013/12/08/hour_of_code_at_amsa.html#comments">Comments (0)</a>
       
       
        </div>
       
        </div>
       




          <h2 class="date">
        November 28, 2013
        </h2>
       

        <div class="blogbody">
       
        <a name="000442"></a>
        <h3 class="title">A New Book and a Thanksgiving Wish</h3>
       
        <style>
      .simgright { border:0; box-shadow: 0 0 16px #333; text-align: right; margin: 6px 0 6px 10px;}
      .simgright:hover { box-shadow: 0 0 24px #008; }
      .simlayout { margin-bottom: 10px; }
      .simlayout td { padding: 0 10px; }
      </style>
      <p><a href="/pencilcode/page-0003.pdf" target=_blank><img class="simgright" align=right src="http://davidbau.com/pencilcode/book-cover-front.jpg"></a>Here is my new book: <a href="http://pencilcode.net/book">Pencil Code</a>, a programming primer for kids.  It is available <a href="http://pencilcode.net/book">on Amazon</a>.

      <p>You can see in the <a href="http://davidbau.com/pencilcode/">thumbnails</a> that it is a slim book that presents more than 100 short example programs, each one illustrated in color.  There is very little text.  This is a book for inductive learning: each important concept is illustrated by an example that is short enough to invite experimentation and exploration.

      <p>Run programs at <a href="http://pencilcode.net/">pencilcode.net</a>.  There you will find an online help system as well as hundreds of other users' projects to explore and copy.  Save your own projects on by creating your own subdomain there.

      <p>I am publishing the book today because I think it will make a good holiday gift for the daughter or son in your family who is just at the edge of being interested in programming computers.  The illustrations are a way to invite a little interest, and the short pieces of code make a good project to sit down and work on together with Mom and Dad or brother or sister.  Since there are more than 100 projects, there is a little something for everybody: art, games, puzzles, humor, or simulations.

      <p>Of course, you can program in Pencil Code without buying or waiting for the book - the online sandbox is free, open-source, and openly available.  Here are a few projects to try:

      <table class="simlayout">
      <tr>
      <td>
      <a href="http://goo.gl/LFv1pu" target="_blank">A square</a><br>
      <a href="http://goo.gl/a9upSR" target="_blank">Drawing a smile</a><br>
      <a href="http://goo.gl/jWzWcY" target="_blank">Simple loop</a><br>
      <a href="http://goo.gl/AOi84x" target="_blank">Catalog of polygons</a><br>
      </td>
      <td>
      <a href="http://goo.gl/ZUtzOV" target="_blank">Guess my number</a><br>
      <a href="http://goo.gl/HGJwV6" target="_blank">Fractal fern</a><br>
      <a href="http://goo.gl/NXGY3O" target="_blank">Fractal trees</a><br>
      <a href="http://goo.gl/6S3Y8W" target="_blank">Turtle race</a><br>
      </td>
      <td>
      <a href="http://goo.gl/Z01dZI" target="_blank">Chase game</a><br>
      <a href="http://goo.gl/TLYl76" target="_blank">Orbit (click to move the sun)</a><br>
      <a href="http://guide.pencilcode.net/edit/networking/hangman" target="_blank">Hangman</a><br>
      <a href="http://guide.pencilcode.net/edit/intelligence/toetactic" target="_blank">Bizarro tic-tac-toe (try to lose)</a><br>
      </td>
      </tr>
      </table>

      <p><b>Programming as an Artistic Pursuit</b>

      <p><a href="/pencilcode/page-0007.pdf" target=_blank><img class="simgright" align=right src="http://davidbau.com/pencilcode/book-page-0007.jpg"></a>How did you learn your profession?

      <p>When I was growing up, my father brought home an Atari 800 and subscribed our family to <a href="https://archive.org/stream/1983-02-compute-magazine/Compute_Issue_033_1983_Feb#page/n123/mode/2up">COMPUTE! magazine</a>.  Like several other computer hobbyist periodicals of the era, every issue of the magazine was chock-full of source code for <a href="https://archive.org/stream/1982-07-compute-magazine/Compute_Issue_026_1982_Jul#page/n27/mode/2up">games</a>, <a href="https://archive.org/stream/1982-12-compute-magazine/Compute_Issue_031_1982_Dec#page/n97/mode/2up">algorithms</a>, and <a href="https://archive.org/stream/1983-02-compute-magazine/Compute_Issue_033_1983_Feb#page/n157/mode/2up">utility software</a>.

      <p>
      The printed programs were magic.  I would type these programs, not understanding much of how they worked, and I would be rewarded with an amazing piece of running software.  Soon I recruited my Mom to type with me.  She didn't understand much about the code either.  However, she brought an essential skill to the table: she was a trained typist, and so she could help me enter pages of long mysterious code at more than 30 words per minute!

      <p>
      After days of typing and a lot of painstaking typo-checking, a little bit of computer programming wisdom would leak into our heads.  Gems such as how the letter "O" works differently from the number "0" even though they look quite similar, or that the "REM" statement (a comment) doesn't actually do anything.

      <p>
      After typing many games that I didn't comprehend, the first program I actually understood was a 10-line prime number sieve.  That kernel of knowledge let me build and modify many mathematical algorithms and graphing programs.  Then I went back to steal techniques from the magazines to make my own games.  Growing up in the era of printed source code was a formative experience.  Freelance code published in a magazine made it obvious that programming was a creative, personal endeavor.

      <p>
      For me, the computer was a blank sheet of paper, and writing programs was an artistic process.

      <p>
      But the year I graduated from high school, the world also graduated from printed source code.  In <a href="https://archive.org/stream/1988-05-compute-magazine/Compute_Issue_096_1988_May#page/n5/mode/2up">May of 1988, COMPUTE! announced</a> that they would no longer print source code in their magazine.  Their justification: "As computers and software have become more powerful... we also realize that you're less inclined to type those programs."  So by the summer of 1988, the code was gone, and it was replaced by "a complete buyer's guide in each issue to help you find, and then buy, the right software for your computer."

      <p>
      The world had changed.  Before that moment, programs were manifestations of personal creativity, distilled cleverness in the same way that poems or symphonies are specialized creative forms.  After 1988, programs became industrial products, produced by highly trained professionals working in teams cordoned behind secure gates, and distributed to the public as sealed, shrink-wrapped products.

      <p>
      <b>A Return to 1988</b>

      <p><a href="/pencilcode/page-0012.pdf" target=_blank><img class="simgright" align=right src="http://davidbau.com/pencilcode/book-page-0012.jpg"></a>Today there are two trends that make it important to return to the 1988 ethic of personal programming.

      <p>First, the economy has been profoundly transformed by the impact of software.  There are no corners of commerce - from farming to medicine to manufacturing to retail to trade to finance to war - that have not been fundamentally restructured around the analytical and organizational power of automation.  Software infuses everything.  While in 1990 we imagined that it was important for the "Knowledge Worker" to be able to be creative with software, in 2013, it is becoming clear that almost all workers must spend some of their time being "Knowledge Workers."

      <p>So we cannot teach this generation of children to be afraid of writing programs.  They must understand that code is an approachable tool - that it can be used, like a pencil, to do both utterly simple things as well as blindingly complicated things.  Tomorrow's adults must have an intuition for how software is created, how it can work well, how it fails, and what role it should play.  And they must know that, ultimately, they are capable of creating software.  Whether they write a spreadsheet macro to fact-check a statistic, or whether they create an elaborate storefront app to automate their business, tomorrow's workers must be literate in code just as 20th century Americans learned English literacy.  Computer code is becoming an essential tool for understanding, cooperation, and commerce.

      <p><b>The Rise of Pseudocode</b>

      <p><a href="/pencilcode/page-0019.pdf" target=_blank><img class="simgright" align=right src="http://davidbau.com/pencilcode/book-page-0019.jpg"></a>The second trend is that computers have become faster than they need to be, and that is making them easier to program.  In the old COMPUTE! magazines, the experts of the day proudly announced a highly tweaked assembly-language sorting program that was "Capable of sorting 1000 items in 2.1 minutes."  (That is a millisecond operation for a mobile phone today.)  With slow computers, programs needed to be absolutely optimized for the computer, even if that meant the code was incomprehensible to humans.

      <p>Today's computers are so fast that we must make the opposite choice.  Most computers spend most of their CPU clock cycles idle, waiting for the user to decide what they want to click next.  So when optimizing a system, the right design is to spend as much computer effort as possible to simplify and speed things up for the person.  In particular that means that programming languages must be designed to be easy for people to read and write, even at the cost of making programs more difficult for computers to run.

      <p>Modern scripting languages such as Python, Ruby, Javascript, and CoffeeScript are all converging on a very similar idiom which in the 1980's we would have called "Pseudocode".  These languages look like the chicken scratch that a person would naturally write if using a pencil to describe an algorithm to another person.  These languages are readable because they delegate many of the details to the computer.  To run a program written in a modern scripting language, the computer must deal with details such as type checking, memory allocation, compilation, and optimization.  The programmer is free from these minutiae, and can focus on the underlying concepts.

      <p><b>A Holiday Activity</b>

      <p><a href="/pencilcode/page-0030.pdf" target=_blank><img class="simgright" align=right src="http://davidbau.com/pencilcode/book-page-0030.jpg"></a>My hope, in working on <a href="http://pencilcode.net/">Pencil Code</a>, is to do a little bit to help bring these two trends together.  Children should learn how to write programs.  It is good for the world, and it is good for their personal education.  But they should learn how to do it with authentic tools - the same ones used by professionals.  Pencil Code helps you program in CoffeeScript.  Modern languages like CoffeeScript make it easy to program, and they empower the programmer to do interesting things in the real world.  And they let you see through straight though to the real concepts without getting hung up in the boilerplate details.

      <p>My wish is that, during the holidays, you will find a moment to play with <a href="http://pencilcode.net/">Pencil Code</a> together with somebody, and open their eyes to the world of coding as a personal and creative endeavor.

      <p>Happy Thanksgiving.
      <p>
      <br>
      <script type="text/javascript">
      reddit_url='http://davidbau.com/archives/2013/11/28/a_new_book_and_a_thanksgiving_wish.html';
      </script>
      <script type="text/javascript" src="http://www.reddit.com/static/button/button1.js"></script><br>
      Upvote on Reddit.
      <p><script type="text/javascript" src="https://apis.google.com/js/plusone.js"></script>
      <g:plusone href="http://davidbau.com/archives/2013/11/28/a_new_book_and_a_thanksgiving_wish.html"></g:plusone>

      <br>
      <a href="https://twitter.com/share" class="twitter-share-button" data-url="http://davidbau.com/archives/2013/11/28/a_new_book_and_a_thanksgiving_wish.html" data-via="davidbau">Tweet</a>
      <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>

      <br clear=all>
       
       
        <br clear=all />
        <div class="posted">Posted by David at <a href="http://davidbau.com/archives/2013/11/28/a_new_book_and_a_thanksgiving_wish.html">01:09 AM</a>
          | <a href="http://davidbau.com/archives/2013/11/28/a_new_book_and_a_thanksgiving_wish.html#comments">Comments (4)</a>
       
       
        </div>
       
        </div>
       




          <h2 class="date">
        November 09, 2013
        </h2>
       

        <div class="blogbody">
       
        <a name="000441"></a>
        <h3 class="title">Pencil Code: Lesson on Angles</h3>
       
        <p><p>Here is a lesson on <a href="http://www.youtube.com/watch?v=xUTPb0ozy8M">Angles using Pencil Code</a>.  It talks about why a triangle can be made with 120 degree angles.  Using concrete turtle programs, it teaches the mathematical concepts of exterior and interior angle, arcs, and regular polygons.  And it provides a hint for exploring curves with winding number larger than zero.</p>

      <p><p><br />
      <iframe type="text/html" width="640" height="390" src="http://www.youtube.com/embed/xUTPb0ozy8M?autoplay=0&origin=http://davidbau.com" frameborder="0"></iframe></p>

      <p><p>No written companion materials yet, but when they are ready, I will update this blog post.</p>
       
       
        <br clear=all />
        <div class="posted">Posted by David at <a href="http://davidbau.com/archives/2013/11/09/pencil_code_lesson_on_angles.html">10:58 PM</a>
          | <a href="http://davidbau.com/archives/2013/11/09/pencil_code_lesson_on_angles.html#comments">Comments (0)</a>
       
       
        </div>
       
        </div>
       




          <h2 class="date">
        November 05, 2013
        </h2>
       

        <div class="blogbody">
       
        <a name="000440"></a>
        <h3 class="title">Pencil Code: Lesson on Lines</h3>
       
        <p>Here is a first lesson on <a href="http://www.youtube.com/watch?v=edN07wcbj2w">Lines using Pencil Code</a>.  It shows how to use functions by introducing five commands that can be used to create drawings by moving a turtle.  It shows how to test functions and build them into a program, and it shows how to save them on your own website.  It is about five minutes long.

      <p>
      <iframe type="text/html" width="640" height="390" src="http://www.youtube.com/embed/edN07wcbj2w?autoplay=0&origin=http://davidbau.com" frameborder="0"></iframe>

      <p>You can teach by just showing the video, or by using the video for ideas on what to talk about in your class.

      <p>When teaching this material, expect it to take about an hour for first-time programmers to understand how to create a program and to create two or three of their own programs.   Be sure to encourage students to draw out a plan ahead of time.  Have them put in the effort to create a program that accurately follows their written plan.  A sheet of graph paper can help.

      <p>Rachel Nicoll put together a terrific <a href="http://pencilcode.net/material/lesson1-handout.pdf">worksheet</a> to hand out to kids that guides them through a few exercises.  There is also an <a href="http://pencilcode.net/material/lesson1-outline.pdf">outline</a> for teachers and a <a href="http://pencilcode.net/material/reference.pdf">reference page</a> to print out that you can use as a handy one-page guide.

       
       
        <br clear=all />
        <div class="posted">Posted by David at <a href="http://davidbau.com/archives/2013/11/05/pencil_code_lesson_on_lines.html">07:32 AM</a>
          | <a href="http://davidbau.com/archives/2013/11/05/pencil_code_lesson_on_lines.html#comments">Comments (1)</a>
       
       
        </div>
       
        </div>
       




          <h2 class="date">
        October 20, 2013
        </h2>
       

        <div class="blogbody">
       
        <a name="000439"></a>
        <h3 class="title">Pencil Code: a First Look</h3>
       
        <p><a href="http://pencilcode.net/">Pencil Code</a> is the new name of my learn-to-program website.  <p>Piper helped me record a new <a href="http://www.youtube.com/watch?v=JJzFD4EdeuY">video about Pencil Code</a>.  My plan is to follow up with a bunch more videos on specific topics - this one is an overview.

      <p>
      <iframe type="text/html" width="640" height="390" src="http://www.youtube.com/embed/JJzFD4EdeuY?autoplay=0&origin=http://davidbau.com" frameborder="0"></iframe>
       
       
        <br clear=all />
        <div class="posted">Posted by David at <a href="http://davidbau.com/archives/2013/10/20/pencil_code_a_first_look.html">10:18 AM</a>
          | <a href="http://davidbau.com/archives/2013/10/20/pencil_code_a_first_look.html#comments">Comments (0)</a>
       
       
        </div>
       
        </div>
       




          <h2 class="date">
        October 01, 2013
        </h2>
       

        <div class="blogbody">
       
        <a name="000437"></a>
        <h3 class="title">CoffeeScript Syntax for Kids</h3>
       
        <p>CoffeeScript, with its highly intuitive syntax, has been a hit in the classroom.  It is a language that largely gets out of your way.  It works the way you expect it to.  However, there are still some pitfalls.  Here are some findings from looking at CoffeeScript programs written over a couple months in a school, and with my kids:</p>

      <ol>
      <li><b>Iced Coffeescript is helpful</b>.  In modern single-threaded code, all communication - including user input - is inherently asynchronous, involving callbacks.  But it is a heavy lift to learn callbacks: for example, simple loops become complex recursions.  The "await/defer" in Iced fixes this by allowing you to "block" a program without buying the full complexity of preemptive threads.
      <li>But <b>the syntax of await/defer makes it hard to learn</b>.  Ideally, one could use "await" before understanding the concept of "defer".  Whereas waiting for an event is easy to understand, the concept of passing a continuation function is difficult.  Defer should be implicit when there is no variable being received.
      <li><b>The "for" loop is too hard as the first loop</b>, because it requires the concept of a loop variable to have any sort of loop.  It should be possible for kids to make a loop without knowing what a variable is.  LOGO's "repeat" would be perfect.
      <li><b>Allowing the "=" as an expression leads to confusion.</b> It is really common for beginners to write "if a = b" and not notice the problem.  This is a language design flaw that is shared by C/C++, perl, and Javascript.  Python fixes it by making single-equals assignments illegal as expresions, and nobody complains about it.  Coffeescript already has several ways of spelling the same concept; my recommendation would be to have a separate ":=" operator to use as assignment-within-expressions.
      </ol>

      <p>I've started to hack on a light CoffeeScript fork to address these issues, but I'm not sure it's a good idea.  There are advantages to teaching "vanilla Iced CoffeeScript" instead of a custom language.<br />
      </p>
       
       
        <br clear=all />
        <div class="posted">Posted by David at <a href="http://davidbau.com/archives/2013/10/01/coffeescript_syntax_for_kids.html">05:27 AM</a>
          | <a href="http://davidbau.com/archives/2013/10/01/coffeescript_syntax_for_kids.html#comments">Comments (0)</a>
       
       
        </div>
       
        </div>
       




      <h2 class="date"></h2>
      <div class="blogbody">
      <p>
      <a href="http://davidbau.com/about/david_bau.html">About David Bau</a>
      -
      <a href="http://davidbau.com/archives/">List of All Articles</a>
      </p>
      </div>

      </td><!-- end of centercontent -->
      </tr>
      <tr><td id="leftcontent">

      <div class="sidetitle">
      Calendar
      </div>

      <div align="center" class="calendar">

      <table border="0" cellspacing="0" cellpadding="0" summary="Monthly calendar with links to each day's posts">
      <caption class="calendarhead">May 2015</caption>
      <tr>
      <th abbr="Sunday" align="center" class="calday"><span class="calendar">Sun</span></th>
      <th abbr="Monday" align="center" class="calday"><span class="calendar">Mon</span></th>
      <th abbr="Tuesday" align="center" class="calday"><span class="calendar">Tue</span></th>
      <th abbr="Wednesday" align="center" class="calday"><span class="calendar">Wed</span></th>
      <th abbr="Thursday" align="center" class="calday"><span class="calendar">Thu</span></th>
      <th abbr="Friday" align="center" class="calday"><span class="calendar">Fri</span></th>
      <th abbr="Saturday" align="center" class="calday"><span class="calendar">Sat</span></th>
      </tr>

      <tr>

      <td align="center" class="calday"><span class="calendar">
       </span></td>

      <td align="center" class="calday"><span class="calendar">
       </span></td>

      <td align="center" class="calday"><span class="calendar">
       </span></td>

      <td align="center" class="calday"><span class="calendar">
       </span></td>

      <td align="center" class="calday"><span class="calendar">
       </span></td>

      <td align="center" class="calday"><span class="calendar">
      1</span></td>

      <td align="center" class="calday"><span class="calendar">
      2</span></td></tr><tr>

      <td align="center" class="calday"><span class="calendar">
      3</span></td>

      <td align="center" class="calday"><span class="calendar">
      4</span></td>

      <td align="center" class="calday"><span class="calendar">
      5</span></td>

      <td align="center" class="calday"><span class="calendar">
      6</span></td>

      <td align="center" class="calday"><span class="calendar">
      7</span></td>

      <td align="center" class="calday"><span class="calendar">
      8</span></td>

      <td align="center" class="calday"><span class="calendar">
      9</span></td></tr><tr>

      <td align="center" class="calday"><span class="calendar">
      10</span></td>

      <td align="center" class="calday"><span class="calendar">
      11</span></td>

      <td align="center" class="calday"><span class="calendar">
      12</span></td>

      <td align="center" class="calday"><span class="calendar">
      13</span></td>

      <td align="center" class="calday"><span class="calendar">
      14</span></td>

      <td align="center" class="calday"><span class="calendar">
      15</span></td>

      <td align="center" class="calday"><span class="calendar">
      16</span></td></tr><tr>

      <td align="center" class="calday"><span class="calendar">
      17</span></td>

      <td align="center" class="calday"><span class="calendar">
      18</span></td>

      <td align="center" class="calday"><span class="calendar">
      19</span></td>

      <td align="center" class="calday"><span class="calendar">
      20</span></td>

      <td align="center" class="calday"><span class="calendar">
      21</span></td>

      <td align="center" class="calday"><span class="calendar">
      22</span></td>

      <td align="center" class="calday"><span class="calendar">
      23</span></td></tr><tr>

      <td align="center" class="calday"><span class="calendar">
      24</span></td>

      <td align="center" class="calday"><span class="calendar">
      25</span></td>

      <td align="center" class="calday"><span class="calendar">
      26</span></td>

      <td align="center" class="calday"><span class="calendar">
      27</span></td>

      <td align="center" class="calday"><span class="calendar">
      28</span></td>

      <td align="center" class="calday"><span class="calendar">
      29</span></td>

      <td align="center" class="calday"><span class="calendar">
      30</span></td></tr><tr>

      <td align="center" class="calday"><span class="calendar">
      31</span></td>

      <td align="center" class="calday"><span class="calendar">
       </span></td>

      <td align="center" class="calday"><span class="calendar">
       </span></td>

      <td align="center" class="calday"><span class="calendar">
       </span></td>

      <td align="center" class="calday"><span class="calendar">
       </span></td>

      <td align="center" class="calday"><span class="calendar">
       </span></td>

      <td align="center" class="calday"><span class="calendar">
       </span></td></tr>
      </table>

      </div>

      <div class="sidetitle">
      Hacks
      </div>
      <div class="side">
      <a href="http://davidbau.com/about/hacks.html">Collected Hacks &amp; Ideas</a>
      </div>

      <div class="sidetitle">
      Search
      </div>
      <div class="side">
      <form method="get" style="display:inline" action="http://davidbau.com/mt/mt-search.cgi">
      <input type="hidden" name="IncludeBlogs" value="1" />
      <label for="search" accesskey="4">Search this site:</label><br />
      <input id="search" name="search" size="20" />
      <input type="submit" value="Go" />
      </form>
      </div>

      <div class="sidetitle">
      Recent Entries
      </div>

      <div class="side">
      <a href="http://davidbau.com/archives/2014/10/17/making_a_400_linux_laptop.html">Making a $400 Linux Laptop</a><br />
      <a href="http://davidbau.com/archives/2014/10/03/teaching_about_data.html">Teaching About Data</a><br />
      <a href="http://davidbau.com/archives/2014/07/10/code_gym.html">Code Gym</a><br />
      <a href="http://davidbau.com/archives/2014/05/23/musicaljs.html">Musical.js</a><br />
      <a href="http://davidbau.com/archives/2014/01/31/pencil_code_at_worcester_technical_high_school.html">Pencil Code at Worcester Technical High School</a><br />
      <a href="http://davidbau.com/archives/2014/01/19/a_bad_chrome_bug.html">A Bad Chrome Bug</a><br />
      <a href="http://davidbau.com/archives/2014/01/09/phantomjs_and_nodejs.html">PhantomJS and Node.JS</a><br />
      <a href="http://davidbau.com/archives/2014/01/03/integration_testing_in_nodejs.html">Integration Testing in Node.js</a><br />
      <a href="http://davidbau.com/archives/2013/12/20/second_edition_of_pencil_code.html">Second Edition of Pencil Code</a><br />
      <a href="http://davidbau.com/archives/2013/12/18/learning_to_program_with_coffeescript.html">Learning to Program with CoffeeScript</a><br />
      <a href="http://davidbau.com/archives/2013/12/16/teaching_math_through_pencil_code.html">Teaching Math Through Pencil Code</a><br />
      <a href="http://davidbau.com/archives/2013/12/09/hour_of_code_at_lincoln.html">Hour of Code at Lincoln</a><br />
      <a href="http://davidbau.com/archives/2013/12/08/hour_of_code_at_amsa.html">Hour of Code at AMSA</a><br />
      <a href="http://davidbau.com/archives/2013/11/28/a_new_book_and_a_thanksgiving_wish.html">A New Book and a Thanksgiving Wish</a><br />
      <a href="http://davidbau.com/archives/2013/11/09/pencil_code_lesson_on_angles.html">Pencil Code: Lesson on Angles</a><br />
      <a href="http://davidbau.com/archives/2013/11/05/pencil_code_lesson_on_lines.html">Pencil Code: Lesson on Lines</a><br />
      <a href="http://davidbau.com/archives/2013/10/20/pencil_code_a_first_look.html">Pencil Code: a First Look</a><br />
      <a href="http://davidbau.com/archives/2013/10/01/coffeescript_syntax_for_kids.html">CoffeeScript Syntax for Kids</a><br />
      <a href="http://davidbau.com/archives/2013/09/28/css_color_names.html">CSS Color Names</a><br />
      <a href="http://davidbau.com/archives/2013/09/20/for_versus_repeat.html">For Versus Repeat</a><br />
      <a href="http://davidbau.com/archives/2013/09/19/book_sample_page.html">Book Sample Page</a><br />
      <a href="http://davidbau.com/archives/2013/09/13/teaching_programming_and_defending_the_middle_class.html">Teaching Programming and Defending the Middle Class</a><br />
      <a href="http://davidbau.com/archives/2013/09/10/turtlebits_at_beaver_country_day.html">TurtleBits at Beaver Country Day</a><br />
      <a href="http://davidbau.com/archives/2013/09/08/book_writing_progress.html">Book Writing Progress</a><br />
      <a href="http://davidbau.com/archives/2013/09/02/lessons_from_kids.html">Lessons from Kids</a><br />
      <a href="http://davidbau.com/archives/2013/08/22/await_and_defer.html">Await and Defer</a><br />
      <a href="http://davidbau.com/archives/2013/08/20/ticks_animation_and_queueing_in_turtlebits.html">Ticks, Animation, and Queueing in TurtleBits</a><br />
      <a href="http://davidbau.com/archives/2013/08/20/using_the_turtlebits_editor.html">Using the TurtleBits Editor</a><br />
      <a href="http://davidbau.com/archives/2013/08/19/starting_with_turtlebits.html">Starting with Turtlebits</a><br />
      <a href="http://davidbau.com/archives/2013/08/18/turtle_bits.html">Turtle Bits</a><br />
      <a href="http://davidbau.com/archives/2013/08/01/no_threshold_no_limit.html">No Threshold, No Limit</a><br />
      <a href="http://davidbau.com/archives/2013/04/19/local_variable_debugging_with_seejs.html">Local Variable Debugging with see.js</a><br />
      <a href="http://davidbau.com/archives/2013/02/16/mapping_the_earth_with_complex_numbers.html">Mapping the Earth with Complex Numbers</a><br />
      <a href="http://davidbau.com/archives/2013/02/10/conformal_map_viewer.html">Conformal Map Viewer</a><br />
      <a href="http://davidbau.com/archives/2012/10/04/jobs_in_1983.html">Jobs in 1983</a><br />
      <a href="http://davidbau.com/archives/2012/09/22/the_problem_with_china.html">The Problem With China</a><br />
      <a href="http://davidbau.com/archives/2011/12/10/omega_improved.html">Omega Improved</a><br />
      <a href="http://davidbau.com/archives/2011/11/06/made_in_america_again.html">Made In America Again</a><br />
      <a href="http://davidbau.com/archives/2011/10/16/avoiding_selectors_for_beginners.html">Avoiding Selectors for Beginners</a><br />
      <a href="http://davidbau.com/archives/2011/10/15/turtle_graphics_fern_with_jquery.html">Turtle Graphics Fern with jQuery</a><br />
      <a href="http://davidbau.com/archives/2011/10/10/learning_to_program_with_jquery.html">Learning To Program with jQuery</a><br />
      <a href="http://davidbau.com/archives/2011/10/08/jqueryturtle.html">jQuery-turtle</a><br />
      <a href="http://davidbau.com/archives/2011/09/09/python_templating_with_stringfunction.html">Python Templating with @stringfunction</a><br />
      <a href="http://davidbau.com/archives/2011/03/02/put_and_delete_in_calljsonlibcom.html">PUT and DELETE in call.jsonlib.com</a><br />
      <a href="http://davidbau.com/archives/2011/02/24/party_like_its_1789.html">Party like it's 1789</a><br />
      <a href="http://davidbau.com/archives/2011/01/30/using_googl_with_jsonlib.html">Using goo.gl with jsonlib</a><br />
      <a href="http://davidbau.com/archives/2011/01/29/simple_crossdomain_javascript_http_with_calljsonlibcom.html">Simple Cross-Domain Javascript HTTP with call.jsonlib.com</a><br />
      <a href="http://davidbau.com/archives/2011/01/22/dabbler_under_version_control.html">Dabbler Under Version Control</a><br />
      <a href="http://davidbau.com/archives/2011/01/12/snowpocalypse_hits_boston.html">Snowpocalypse Hits Boston</a><br />
      <a href="http://davidbau.com/archives/2010/12/30/heidis_sudoku_hintpad.html">Heidi's Sudoku Hintpad</a><br />
      <a href="http://davidbau.com/archives/2010/12/11/social_responsibility_in_tech.html">Social Responsibility in Tech</a><br />
      <a href="http://davidbau.com/archives/2010/12/08/the_first_permanent_language.html">The First Permanent Language</a><br />
      <a href="http://davidbau.com/archives/2010/12/05/a_new_framework_for_finance.html">A New Framework For Finance</a><br />
      <a href="http://davidbau.com/archives/2010/11/26/box2d_web.html">Box2D Web</a><br />
      <a href="http://davidbau.com/archives/2010/11/25/lincoln_school_construction.html">Lincoln School Construction</a><br />
      <a href="http://davidbau.com/archives/2010/11/22/stuck_pixel_utility.html">Stuck Pixel Utility</a><br />
      <a href="http://davidbau.com/archives/2010/11/14/fixing_the_deficit.html">Fixing the Deficit</a><br />
      <a href="http://davidbau.com/archives/2010/11/14/cancelled_discover_card.html">Cancelled Discover Card</a><br />
      <a href="http://davidbau.com/archives/2010/10/22/tic_toe_tac.html">Tic Toe Tac</a><br />
      <a href="http://davidbau.com/archives/2010/10/20/toe_tac_tic.html">Toe Tac Tic</a><br />
      <a href="http://davidbau.com/archives/2010/09/16/panhandlers.html">Panhandlers</a><br />
      <a href="http://davidbau.com/archives/2010/06/20/tutorial_root_finder.html">Tutorial: Root Finder</a><br />
      <a href="http://davidbau.com/archives/2010/05/28/wiki_javascript_at_dabblerorg.html">Wiki Javascript at dabbler.org</a><br />
      <a href="http://davidbau.com/archives/2010/05/11/what_sat_stands_for.html">What SAT Stands For</a><br />
      <a href="http://davidbau.com/archives/2010/05/01/computer_club.html">Computer Club</a><br />
      <a href="http://davidbau.com/archives/2010/04/17/tutorial_cannon_game.html">Tutorial: Cannon Game</a><br />
      <a href="http://davidbau.com/archives/2010/04/17/tutorial_pascals_triangle.html">Tutorial: Pascal's Triangle</a><br />
      <a href="http://davidbau.com/archives/2010/04/16/tutorial_custom_poem.html">Tutorial: Custom Poem</a><br />
      <a href="http://davidbau.com/archives/2010/04/15/tutorial_concentration.html">Tutorial: Concentration</a><br />
      <a href="http://davidbau.com/archives/2010/04/13/tutorial_histogram.html">Tutorial: Histogram</a><br />
      <a href="http://davidbau.com/archives/2010/04/12/tutorial_maze_maker.html">Tutorial: Maze Maker</a><br />
      <a href="http://davidbau.com/archives/2010/04/10/tutorial_tic_tac_toe.html">Tutorial: Tic Tac Toe</a><br />
      <a href="http://davidbau.com/archives/2010/04/09/tutorial_mastermind.html">Tutorial: Mastermind</a><br />
      <a href="http://davidbau.com/archives/2010/04/06/tutorial_polygon_drawing.html">Tutorial: Polygon Drawing</a><br />
      <a href="http://davidbau.com/archives/2010/04/05/tutorial_caesar_cipher.html">Tutorial: Caesar Cipher</a><br />
      <a href="http://davidbau.com/archives/2010/03/31/tutorial_guess_my_number.html">Tutorial: Guess My Number</a><br />
      <a href="http://davidbau.com/archives/2010/03/30/tutorial_ten_followers.html">Tutorial: Ten Followers</a><br />
      <a href="http://davidbau.com/archives/2010/03/28/tutorial_fifteen_puzzle.html">Tutorial: Fifteen Puzzle</a><br />
      <a href="http://davidbau.com/archives/2010/03/24/handheld_glassesfree_3d.html">Handheld Glasses-Free 3D</a><br />
      <a href="http://davidbau.com/archives/2010/03/21/making_a_time_machine.html">Making a Time Machine</a><br />
      <a href="http://davidbau.com/archives/2010/03/20/the_next_grand_deception.html">The Next Grand Deception</a><br />
      <a href="http://davidbau.com/archives/2010/03/19/there_is_brilliance_in_this_language.html">There is Brilliance in this Language</a><br />
      <a href="http://davidbau.com/archives/2010/03/17/minimum_hint_sudoku_hunt.html">Minimum Hint Sudoku Hunt</a><br />
      <a href="http://davidbau.com/archives/2010/03/15/collected_hacks.html">Collected Hacks</a><br />
      <a href="http://davidbau.com/archives/2010/03/14/python_pipy_spigot.html">Python pi.py Spigot</a><br />
      <a href="http://davidbau.com/archives/2010/03/14/the_mystery_of_355113.html">The Mystery of 355/113</a><br />
      <a href="http://davidbau.com/archives/2010/03/11/its_not_about_the_answer.html">It's Not About The Answer</a><br />
      <a href="http://davidbau.com/archives/2010/03/08/solid_geometry.html">Solid Geometry</a><br />
      <a href="http://davidbau.com/archives/2010/03/04/teaching_is_hard.html">Teaching is Hard</a><br />
      <a href="http://davidbau.com/archives/2010/02/12/a_mathematical_notation_question.html">A Mathematical Notation Question</a><br />
      <a href="http://davidbau.com/archives/2010/02/09/second_coming_of_wydenbennett.html">Second Coming of Wyden-Bennett?</a><br />
      <a href="http://davidbau.com/archives/2010/02/01/reading_jquery_sources.html">Reading JQuery Sources</a><br />
      <a href="http://davidbau.com/archives/2010/01/30/random_seeds_coded_hints_and_quintillions.html">Random Seeds, Coded Hints, and Quintillions</a><br />
      <a href="http://davidbau.com/archives/2010/01/24/xinhua_we_report_you_decide.html">Xinhua: We Report, You Decide</a><br />
      <a href="http://davidbau.com/archives/2010/01/19/my_god_what_have_we_done.html">My God, What Have We Done?</a><br />
      <a href="http://davidbau.com/archives/2010/01/18/campaign_calls.html">Campaign Calls</a><br />
      <a href="http://davidbau.com/archives/2010/01/17/vote.html">Vote</a><br />
      <a href="http://davidbau.com/archives/2010/01/16/ballmer_favors_torture_for_lawyers.html">Ballmer Favors Torture for Lawyers</a><br />
      <a href="http://davidbau.com/archives/2010/01/15/anagram.html">Anagram</a><br />
      <a href="http://davidbau.com/archives/2010/01/14/flawed_security.html">Flawed Security</a><br />

      </div>

      <div class="sidetitle">
      Archives
      </div>

      <div class="side">
      <a href="/archives/">All Articles</a><br />
      <a href="http://davidbau.com/archives/2014/10/index.html">October 2014</a><br />
      <a href="http://davidbau.com/archives/2014/07/index.html">July 2014</a><br />
      <a href="http://davidbau.com/archives/2014/05/index.html">May 2014</a><br />
      <a href="http://davidbau.com/archives/2014/01/index.html">January 2014</a><br />
      <a href="http://davidbau.com/archives/2013/12/index.html">December 2013</a><br />
      <a href="http://davidbau.com/archives/2013/11/index.html">November 2013</a><br />
      <a href="http://davidbau.com/archives/2013/10/index.html">October 2013</a><br />
      <a href="http://davidbau.com/archives/2013/09/index.html">September 2013</a><br />
      <a href="http://davidbau.com/archives/2013/08/index.html">August 2013</a><br />
      <a href="http://davidbau.com/archives/2013/04/index.html">April 2013</a><br />
      <a href="http://davidbau.com/archives/2013/02/index.html">February 2013</a><br />
      <a href="http://davidbau.com/archives/2012/10/index.html">October 2012</a><br />
      <a href="http://davidbau.com/archives/2012/09/index.html">September 2012</a><br />
      <a href="http://davidbau.com/archives/2011/12/index.html">December 2011</a><br />
      <a href="http://davidbau.com/archives/2011/11/index.html">November 2011</a><br />
      <a href="http://davidbau.com/archives/2011/10/index.html">October 2011</a><br />
      <a href="http://davidbau.com/archives/2011/09/index.html">September 2011</a><br />
      <a href="http://davidbau.com/archives/2011/03/index.html">March 2011</a><br />
      <a href="http://davidbau.com/archives/2011/02/index.html">February 2011</a><br />
      <a href="http://davidbau.com/archives/2011/01/index.html">January 2011</a><br />
      <a href="http://davidbau.com/archives/2010/12/index.html">December 2010</a><br />
      <a href="http://davidbau.com/archives/2010/11/index.html">November 2010</a><br />
      <a href="http://davidbau.com/archives/2010/10/index.html">October 2010</a><br />
      <a href="http://davidbau.com/archives/2010/09/index.html">September 2010</a><br />
      <a href="http://davidbau.com/archives/2010/06/index.html">June 2010</a><br />
      <a href="http://davidbau.com/archives/2010/05/index.html">May 2010</a><br />
      <a href="http://davidbau.com/archives/2010/04/index.html">April 2010</a><br />
      <a href="http://davidbau.com/archives/2010/03/index.html">March 2010</a><br />
      <a href="http://davidbau.com/archives/2010/02/index.html">February 2010</a><br />
      <a href="http://davidbau.com/archives/2010/01/index.html">January 2010</a><br />
      <a href="http://davidbau.com/archives/2009/11/index.html">November 2009</a><br />
      <a href="http://davidbau.com/archives/2009/09/index.html">September 2009</a><br />
      <a href="http://davidbau.com/archives/2009/08/index.html">August 2009</a><br />
      <a href="http://davidbau.com/archives/2009/07/index.html">July 2009</a><br />
      <a href="http://davidbau.com/archives/2009/06/index.html">June 2009</a><br />
      <a href="http://davidbau.com/archives/2009/05/index.html">May 2009</a><br />
      <a href="http://davidbau.com/archives/2009/04/index.html">April 2009</a><br />
      <a href="http://davidbau.com/archives/2009/03/index.html">March 2009</a><br />
      <a href="http://davidbau.com/archives/2009/02/index.html">February 2009</a><br />
      <a href="http://davidbau.com/archives/2009/01/index.html">January 2009</a><br />
      <a href="http://davidbau.com/archives/2008/12/index.html">December 2008</a><br />
      <a href="http://davidbau.com/archives/2008/11/index.html">November 2008</a><br />
      <a href="http://davidbau.com/archives/2008/10/index.html">October 2008</a><br />
      <a href="http://davidbau.com/archives/2008/09/index.html">September 2008</a><br />
      <a href="http://davidbau.com/archives/2008/08/index.html">August 2008</a><br />
      <a href="http://davidbau.com/archives/2008/06/index.html">June 2008</a><br />
      <a href="http://davidbau.com/archives/2008/05/index.html">May 2008</a><br />
      <a href="http://davidbau.com/archives/2008/03/index.html">March 2008</a><br />
      <a href="http://davidbau.com/archives/2008/02/index.html">February 2008</a><br />
      <a href="http://davidbau.com/archives/2008/01/index.html">January 2008</a><br />
      <a href="http://davidbau.com/archives/2007/12/index.html">December 2007</a><br />
      <a href="http://davidbau.com/archives/2007/11/index.html">November 2007</a><br />
      <a href="http://davidbau.com/archives/2007/10/index.html">October 2007</a><br />
      <a href="http://davidbau.com/archives/2007/08/index.html">August 2007</a><br />
      <a href="http://davidbau.com/archives/2007/07/index.html">July 2007</a><br />
      <a href="http://davidbau.com/archives/2007/06/index.html">June 2007</a><br />
      <a href="http://davidbau.com/archives/2007/05/index.html">May 2007</a><br />
      <a href="http://davidbau.com/archives/2007/04/index.html">April 2007</a><br />
      <a href="http://davidbau.com/archives/2007/03/index.html">March 2007</a><br />
      <a href="http://davidbau.com/archives/2007/02/index.html">February 2007</a><br />
      <a href="http://davidbau.com/archives/2007/01/index.html">January 2007</a><br />
      <a href="http://davidbau.com/archives/2006/12/index.html">December 2006</a><br />
      <a href="http://davidbau.com/archives/2006/11/index.html">November 2006</a><br />
      <a href="http://davidbau.com/archives/2006/10/index.html">October 2006</a><br />
      <a href="http://davidbau.com/archives/2006/09/index.html">September 2006</a><br />
      <a href="http://davidbau.com/archives/2006/08/index.html">August 2006</a><br />
      <a href="http://davidbau.com/archives/2006/07/index.html">July 2006</a><br />
      <a href="http://davidbau.com/archives/2006/06/index.html">June 2006</a><br />
      <a href="http://davidbau.com/archives/2006/05/index.html">May 2006</a><br />
      <a href="http://davidbau.com/archives/2006/04/index.html">April 2006</a><br />
      <a href="http://davidbau.com/archives/2006/03/index.html">March 2006</a><br />
      <a href="http://davidbau.com/archives/2006/02/index.html">February 2006</a><br />
      <a href="http://davidbau.com/archives/2006/01/index.html">January 2006</a><br />
      <a href="http://davidbau.com/archives/2005/12/index.html">December 2005</a><br />
      <a href="http://davidbau.com/archives/2005/10/index.html">October 2005</a><br />
      <a href="http://davidbau.com/archives/2005/09/index.html">September 2005</a><br />
      <a href="http://davidbau.com/archives/2005/08/index.html">August 2005</a><br />
      <a href="http://davidbau.com/archives/2005/07/index.html">July 2005</a><br />
      <a href="http://davidbau.com/archives/2005/06/index.html">June 2005</a><br />
      <a href="http://davidbau.com/archives/2005/05/index.html">May 2005</a><br />
      <a href="http://davidbau.com/archives/2005/04/index.html">April 2005</a><br />
      <a href="http://davidbau.com/archives/2004/01/index.html">January 2004</a><br />
      <a href="http://davidbau.com/archives/2003/12/index.html">December 2003</a><br />
      <a href="http://davidbau.com/archives/2003/11/index.html">November 2003</a><br />

      </div>

      <div class="sidetitle">
      Links
      </div>

      <div class="side">
      <script language="Javascript">
      <!--
      function strrev(str) {
         if (!str) return '';
         var revstr='';
         for (i = str.length-1; i>=0; i--)
             revstr+=str.charAt(i)
         return revstr;
      }
      linktext = "<a href='mailto:";
      linktext += strrev("moc.liamg@cbd+uab.divad");
      linktext += "'>Send Mail to Dave</a>";
      document.write(linktext);
      -->
      </script>
      </div>

      <div class="side">
      <a href="http://baufamily.net/">Bau family website</a>
      <a href="http://www.eightypercent.net/">Joe</a>
      <a href="http://burd.info/gary/">Gary</a>
      <a href="http://www.ericvasilik.com/">Eric</a>
      <a href="http://www.glaak.com/">Gayle</a>
      <a href="http://www.rezab.com/">Reza</a>
      <a href="http://3goats.com/rod/">Rod</a>
      <a href="http://ulyart.livejournal.com/">Ulysses</a>
      <a href="http://www.jonblossom.com/">Blossom</a>
      <a href="http://www.howardhuang.us/blog/">Howie</a>
      <a href="http://www.somebits.com/weblog/">Nelson</a>
      <a href="http://www.glenncarr.com/blog/">Glenn</a>
      <a href="http://463.blogs.com/">463</a>
      <a href="http://popurls.com/">Pop</a>
      <a href="http://www.valleywag.com/">Wag</a>
      <a href="http://www.physicsweb.org/articles/news/">Physics</a>
      <a href="http://www.nature.com/news/index.html">Nature</a>
      <a href="http://www.mapgirl.net/mfc/">MG</a>
      <a href="http://legoeducation.typepad.com/">LegoEd</a>
      <a href="http://www.anitarowland.com/">Anita</a>
      <a href="http://www.deepfun.com/weblog/">Bernie</a>
      <a href="http://www.pcal.net/">PCal</a>
      <a href="http://www.beust.com/weblog/">Cedric</a>
      <a href="http://www.adambosworth.net/">Adam</a>
      <a href="http://www.andersblog.com/">Mark</a>
      <a href="http://weblogs.asp.net/scottgu/">Scott</a>
      <a href="http://www.sauria.com/blog">Ted</a>
      <a href="http://www.saint-andre.com/blog/">StPeter</a>
      <a href="http://www.joelonsoftware.com/">Joel</a>
      <a href="http://xml.apache.org/xmlbeans">XMLBeans</a>
      <a href="http://dqsd.net/">Quick Search Bar</a>
      <a href="http://battellemedia.com/">Battelle</a>
      <a href="http://www.danbricklin.com/log/">Bricklin</a>
      <a href="http://digg.com/">Digg</a>
      <a href="http://www.bricksonthebrain.com/blog/">Jake</a>
      <a href="http://bayosphere.com/blog/dangillmor">Gilmour</a>
      <a href="http://www.googlersblogs.com/">Googlers</a>
      <a href="http://dev.upian.com/hotlinks/">HotLinks</a>
      <a href="http://minimsft.blogspot.com/">Mini</a>
      <a href="http://blogs.msdn.com/oldnewthing/">Raymond</a>
      <a href="http://www.rocketboom.com/vlog/">RB</a>
      <a href="http://rconversation.blogs.com/">RMack</a>
      <a href="http://www.intertwingly.net/blog/">Sam</a>
      <a href="http://tech.memeorandum.com/">TM</a>
      <a href="http://volokh.com/">Volkh</a>
      <a href="http://www.wonkette.com/">Wonkette</a>
      <a href="http://waxy.org/links/">Waxy</a>
      <a href="http://www.ilenn.com/blogs/stevewitt/">Witt</a>
      <a href="http://xooglers.blogspot.com/">Xooglers</a>
      <a href="http://jeremy.zawodny.com/blog/">Zawodny</a>
      <a href="http://economistsview.typepad.com/">EconView</a>
      <a href="http://uchicagolaw.typepad.com/">UChicagoLaw</a>

      </div>

      <div class="sidetitle">
      Older Writing
      </div>

      <div class="side">
      <a href="http://davidbau.com/old/dabbler/">The Old Dabbler</a>
      </div>

      <div class="side">
      <a href="http://davidbau.com/old/dabbler/stories/storyReader$88
      ">Dave on Microsoft</a>
      </div>

      <div class="side">
      <a href="http://www.sys-con.com/webservices/articleprint.cfm?id=211">Dave on Web Services</a>
      </div>

      <div class="side">
      <a href="http://webword.com/interviews/bau.html">Dave at WebWord</a>
      </div>

      <div class="side">
      <a href="http://www.amazon.com/exec/obidos/tg/detail/-/0898713617/?tag=dqsd-20">Dave's Linear Algebra Book</a>
      </div>

      <div class="sidetitle">
      About
      </div>

      <div class="side">
      <a href="about/david_bau.html">About David Bau</a><br/>
      <a href="about/this_site.html">About This Site</a><br/>
      &nbsp;
      </div>

      <div class="side">
      <a href="http://davidbau.com/index.rdf"><img src="/images/button/rss1_button.gif" border="0"/></a><br/>
      </div>

      <div class="side">
      <a href="http://davidbau.com/index.xml"><img src="/images/button/rss2_button.gif" border="0"/></a><br/>
      </div>

      <div class="side">
      <a href="http://www.movabletype.org"><img src="/images/button/movabletype3.gif" border="0"/></a><br />    
      </div>

      </td> <!-- end of leftcontent -->
      </tr>
      <tr>
      <td colspan=2 class="copyright">
      Copyright 2015 &copy; David Bau. All Rights Reserved.
      </td>
      </tr>
      </table>

      </div> <!-- end of container -->

      <script src="http://www.google-analytics.com/urchin.js" type="text/javascript">
      </script>
      <script type="text/javascript">
      _uacct = "UA-242212-1";
      urchinTracker();
      </script>


      </body>
      </html>
      '''

    empty: ''
  }

  editor.setEditorState false
  editor.aceEditor.getSession().setUseWrapMode true
  editor.aceEditor.getSession().setMode 'ace/mode/html'

  # Initialize to starting text
  startingText = localStorage.getItem 'example'
  editor.setValue startingText or examplePrograms.descriptive

  # Update textarea on ICE editor change
  onChange = ->
    localStorage.setItem 'example', editor.getValue()

  editor.on 'change', onChange

  editor.aceEditor.on 'change', onChange

  # Trigger immediately
  do onChange

  document.getElementById('which_example').addEventListener 'change', ->
    editor.setValue examplePrograms[@value]

  editor.clearUndoStack()

  messageElement = document.getElementById 'message'
  displayMessage = (text) ->
    messageElement.style.display = 'inline'
    messageElement.innerText = text
    setTimeout (->
      messageElement.style.display = 'none'
    ), 2000

  document.getElementById('toggle').addEventListener 'click', ->
    editor.toggleBlocks()
    if $('#palette_dialog').dialog 'isOpen'
      $('#palette_dialog').dialog 'close'
    else
      $("#palette_dialog").dialog 'open'