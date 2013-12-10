﻿<%@ Page Language="C#" %>
<%@ Import namespace="System.Configuration" %>

<%
    string appName = ConfigurationManager.AppSettings["auth.appName"];
    string apiKey = ConfigurationManager.AppSettings["auth.apiKey"];
    string googleAnalytics = ConfigurationManager.AppSettings["googleAnalytics"];
%>

<!DOCTYPE html>
<html>
<head>
    <title>JabbR1</title>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <meta name="description" content="A real-time chat application. IRC without the R." />
    <meta name="keywords" content="chat,realtime chat,signalr,jabbr" />
    <link href="Chat.css" rel="Stylesheet" />
    <link href="Chat.nuget.css" rel="Stylesheet" />
    <link href="Chat.bbcnews.css" rel="Stylesheet" />
    <link href="Chat.githubissues.css" rel="Stylesheet" />
    <link href="Chat.dictionary.css" rel="stylesheet" type="text/css" />
    <link href="Content/KeyTips.css" rel="stylesheet" type="text/css" />
    <link href="Content/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="Content/emoji20.css" rel="stylesheet" type="text/css" />
    <% if (!String.IsNullOrEmpty(apiKey)) { %>
    <script type="text/javascript">
        (function () {
            if (typeof window.janrain !== 'object') window.janrain = {};
            window.janrain.settings = {};

            var url = document.location.href;
            var nav = url.indexOf('#');
            url = nav > 0 ? url.substring(0, nav) : url;
            url = url.replace('default.aspx', '');
            janrain.settings.tokenUrl = url + 'Auth/Login.ashx';
            janrain.settings.type = 'embed';

            function isReady() { janrain.ready = true; };
            if (document.addEventListener) {
                document.addEventListener("DOMContentLoaded", isReady, false);
            } else {
                window.attachEvent('onload', isReady);
            }

            var e = document.createElement('script');
            e.type = 'text/javascript';
            e.id = 'janrainAuthWidget';

            if (document.location.protocol === 'https:') {
                e.src = 'https://rpxnow.com/js/lib/<%:appName %>/engage.js';
            } else {
                e.src = 'http://widget-cdn.rpxnow.com/js/lib/<%:appName %>/engage.js';
            }

            var s = document.getElementsByTagName('script')[0];
            s.parentNode.insertBefore(e, s);
        })();
    </script>
    <% } %>
    <% if (!String.IsNullOrEmpty(googleAnalytics)) { %>
    <script type="text/javascript">
        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', '<%:googleAnalytics %>']);
        _gaq.push(['_trackPageview']);

        (function () {
            var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
            ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
            var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        })();

    </script>
    <% } %>
    <script id="new-message-template" type="text/x-jquery-tmpl">
        <li class="message ${highlight} clearfix" id="m-${id}" data-name="${name}" data-timestamp="${date}">
            <div class="left">
                {{if showUser}}
                <img src="http://www.gravatar.com/avatar/${hash}?s=16&d=mm" class="gravatar" />
                <span class="name">${trimmedName}</span>
                {{/if}}
                <span class="state"></span>
            </div>
            <div class="middle">
                {{html message}}
            </div>
            <div class="right">
                <span id="t-${id}" class="time" title="${fulldate}">${when}</span>
            </div>
        </li>
    </script>
    <script id="new-notification-template" type="text/x-jquery-tmpl">
        <li class="${type}" data-timestamp="${date}">
            <div class="content">
                {{html message}}
                <a class="info" href="#"></a>
            </div>
            <div class="right">
                <span class="time" title="${fulldate}">${when}</span>
            </div>
        </li>
    </script>
    <script id="message-separator-template" type="text/x-jquery-tmpl">
        <li class="message-separator">
        </li>
    </script>
    <script id="new-user-template" type="text/x-jquery-tmpl">
        <li class="user" data-name="${name}">
            <img class="gravatar" src="http://www.gravatar.com/avatar/${hash}?s=16&d=mm" />
            <div class="details">
                <span class="name">${name}</span>
                <span class="owner">{{if owner}}(owner){{/if}}</span>
                <span class="note{{if noteClass}} ${noteClass}{{/if}}" {{if note}}title="${note}"{{/if}}></span>
                <span class="flag{{if flagClass}} ${flagClass}{{/if}}" {{if flag}}title="${country}"{{/if}}></span>
            </div>
        </li>
    </script>
    <script id="new-userlist-template" type="text/x-jquery-tmpl">
        <h3 class="userlist-header nav-header">
            ${listname}
        </h3>
        <div>
            <ul id="${id}" />
        </div>
    </script>
    <script id="new-tab-template" type="text/x-jquery-tmpl">
        <li id="tabs-${id}" class="room" data-name="${name}">
            <span class="lock"></span>
            <button> 
                <span class="content">${name}</span>
            </button>
            <div class="close"></div>
        </li>
    </script>
    <!-- TweetContentProvider: Should be extracted out if other content providers need templates -->
    <script id="tweet-template" type="text/x-jquery-tmpl">
        <div class="user">
            <img src="${user.profile_image_url}" />
            <span class="name">${user.screen_name}</span> (${user.name})
        </div>
        {{html text}}
        <time class="js-relative-date" datetime="${created_at}">${created_at}</time> 
    </script>
    <!-- /TweetContentProvider -->
    <!-- /GitHub Issues Content Provider -->
    <script id="github-issues-template" type="text/x-jquery-tmpl">
        <div class="new-comments">
            <div class="avatar-bubble js-comment-container">
                <span class="avatar">
                    <img height="48" width="48" src="${user.avatar_url}">
                    <span class="overlay size-48"></span>
                </span>
                <div class="bubble">
                    <div class="comment starting-comment ">
                        <div class="body">
                            <p class="author">
                                <a href="#" class='github-issue-user-${user.login}' target="_blank">${user.login}</a> opened this issue
                                <time class="js-relative-date" datetime="${created_at}">${created_at}</time>
                            </p>
                            <a href="${html_url}" target="_blank"><h2 class="content-title">${title}</h2></a>
                            <div class="infobar clearfix">
                                <p class="milestone js-milestone-infobar-item-wrapper">No milestone</p>
                                {{if assignee}}
                                    <p class="assignee">
                                        <span class="avatar">
                                            <img height="20" width="20" src="${assignee.avatar_url}">
                                            <span class="overlay size-20"></span>
                                        </span>
                                        <a href="#" class="github-issue-user-${assignee.login}" target="_blank">${assignee.login}</a> is assigned
                                    </p>
                                {{/if}}
                            </div>
                            <div class="formatted-content">
                                <div class="content-body wikistyle markdown-format">
                                    <p>
                                        {{html body}}
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
           
        </div>   
    </script>
    <!-- /Github Issus Content Provider -->
</head>
<body>
    <div id="page">
        <div id="disconnect-dialog" class="modal hide fade">
            <div class="modal-header">
              <a class="close" data-dismiss="modal" >&times;</a>
              <img alt="logo" src="Content/images/logo32.png" /><h3>JabbR Error</h3>
            </div>
            <div class="modal-body">
              <p>There was an error contacting the server, please refresh in a few minutes.</p>
            </div>
        </div>

        <div id="download-dialog" class="modal hide fade">
            <div class="modal-header">
                <a class="close" data-dismiss="modal">&times;</a>
                <h3>Download Messages</h3>
            </div>
            <div class="modal-body">
                <p>Select date range for messages:</p>
                <p>
                    <select id="download-range">
                        <option value="last-hour">Last hour</option>
                        <option value="last-day">Last day</option>
                        <option value="last-week">Last week</option>
                        <option value="last-month">Last month</option>
                        <option value="all">All</option>
                    </select>
                </p>
            </div>
            <div class="modal-footer">
                <a href="#" class="btn btn-primary" id="download-dialog-button">Download</a>
            </div>
        </div>
        <div id="jabbr-update" class="modal hide fade">
            <div class="modal-header">
              <a class="close" data-dismiss="modal" >&times;</a>
              <img alt="logo" src="Content/images/logo32.png" /><h3>JabbR Update</h3>
            </div>
            <div class="modal-body">
              <p>Refresh your browser to get the latest. Auto update will take place in 15 seconds.</p>
            </div>
          </div>

        <a href="https://github.com/davidfowl/JabbR" target="_blank">
            <img style="position: absolute; top: 0; right: 0; border: 0; z-index: 1000" src="https://a248.e.akamai.net/assets.github.com/img/7afbc8b248c68eb468279e8c17986ad46549fb71/687474703a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e732f666f726b6d655f72696768745f6461726b626c75655f3132313632312e706e67"
                alt="Fork me on GitHub">
        </a>
        <div id="heading">
            <div class="banner">
                <h1>
                    Jabb</h1>
                <img alt="logo" src="Content/images/logo32.png" id="logo" />
                <div>
                    Powered by <a href="https://github.com/SignalR/SignalR" target="_blank">SignalR</a></div>
            </div>
            <div style="clear: both">
            </div>
            <ul id="tabs">
                <li id="tabs-lobby" class="current lobby" data-name="Lobby">
                    <button accesskey="l">
                        <span class="content">Lobby</span></button>
                </li>
            </ul>
        </div>
        <div id="jabbr-login" class="modal hide fade">
            <div class="modal-header">
                <a class="close" data-dismiss="modal">&times;</a>
                <h3>JabbR Login</h3>
            </div>
            <div class="modal-body">
                <div id="janrainEngageEmbed">
                </div>
            </div>
        </div>
        <div id="chat-area">
            <ul id="messages-lobby" class="messages current">
            </ul>
            <form id="users-filter-form" action="#">
                <input id="users-filter" class="filter" type="text" />
            </form>
            <ul id="userlist-lobby" class="users current">
            </ul>
            <div id="preferences">
                <a class="sound" title="audible notifications"></a>
                <a class="toast" title="popup notifications"></a>
                <a class="download" title="download messages"></a>
            </div>
            <form id="send-message" action="#">
            <div id="message-box">
                <textarea id="new-message" autocomplete="off" accesskey="m"></textarea>
            </div>
            <input type="submit" id="send" value="Send" class="send" />
            <div id="message-instruction">Type @ then press TAB to auto-complete nicknames</div>
            </form>
        </div>
        <audio src="Content/sounds/notification.wav" id="noftificationSound" hidden="hidden" />

    </div>
    <script src="Scripts/json2.min.js" type="text/javascript"></script>
    <script src="Scripts/jquery-1.7.min.js" type="text/javascript"></script>
    <script src="Scripts/bootstrap.min.js" type="text/javascript"></script>
    <script src="Scripts/jquery.KeyTips.js" type="text/javascript"></script>
    <script src="Scripts/jquery-ui-1.8.17.min.js" type="text/javascript"></script>
    <script src="Scripts/jquery.signalR.js" type="text/javascript"></script>
    <script src="signalr/hubs" type="text/javascript"></script>
    <script src="Scripts/modernizr.js" type="text/javascript"></script>
    <script src="Scripts/jQuery.tmpl.min.js" type="text/javascript"></script>
    <script src="Scripts/jquery.cookie.js" type="text/javascript"></script>
    <script src="Scripts/jquery.autotabcomplete.js" type="text/javascript"></script>
    <script src="Scripts/jquery.timeago.0.10.js" type="text/javascript"></script>
    <script src="Scripts/jquery.captureDocumentWrite.min.js" type="text/javascript"></script>
    <script src="Scripts/jquery.sortElements.js" type="text/javascript"></script>
    <script src="Scripts/quicksilver.js" type="text/javascript"></script>
    <script src="Scripts/jquery.livesearch.js" type="text/javascript"></script>
    <script src="Scripts/Markdown.Converter.js" type="text/javascript"></script>
    <script src="Scripts/jquery.history.js" type="text/javascript"></script>
    <script src="Chat.utility.js" type="text/javascript"></script>
    <script src="Chat.emoji.js" type="text/javascript"></script>
    <script src="Chat.toast.js" type="text/javascript"></script>
    <script src="Chat.ui.js" type="text/javascript"></script>
    <script src="Chat.documentOnWrite.js" type="text/javascript"></script>
    <script src="Chat.twitter.js" type="text/javascript"></script>
    <script src="Chat.pinnedWindows.js" type="text/javascript"></script>
    <script src="Chat.githubissues.js" type="text/javascript"></script>    
    <script src="Chat.js" type="text/javascript"></script>    
</body>
</html>
