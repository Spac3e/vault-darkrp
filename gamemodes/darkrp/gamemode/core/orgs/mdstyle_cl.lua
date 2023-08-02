-- return lpakr()()

rp.orgs=rp.orgs||{}rp.orgs.MDStyleBase=[[

@import url('https://fonts.googleapis.com/css?family=Roboto:400,400i,900');



h1, h2, h3, h4, h5, p {

    margin-bottom: 24px;

    padding: 0;

}

h1 {

    font-size: 48px;

}

h2 {

    font-size: 40px;

    /* The bottom margin is small. It's designed to be used with gray meta text

     * below a post title. */

    margin: 36px 0 6px;

}

h3 {

    font-size: 36px;

}

h4 {

    font-size: 24px;

}

h5 {

    font-size: 21px;

}

ul, ol {

    padding: 0;

    margin: 0;

}

li {

    line-height: 24px;

}

li ul, li ul {

    margin-left: 24px;

}

p, ul, ol {

    font-size: 18px;

    line-height: 24px;

}

pre {

    padding: 0px 24px;

    white-space: pre-wrap;

}

code {

    font-family: Consolas, Monaco, Andale Mono, monospace;

    line-height: 1.5;

    font-size: 18px;

}

aside {

    display: block;

    float: right;

}

blockquote cite:before {

    content: '\2014 \00A0';

}



/* Code below this line is copyright Twitter Inc. */



button,

input,

select,

textarea {

  font-size: 100%;

  margin: 0;

  vertical-align: baseline;

  *vertical-align: middle;

}

button, input {

  line-height: normal;

  *overflow: visible;

}

button::-moz-focus-inner, input::-moz-focus-inner {

  border: 0;

  padding: 0;

}

button,

input[type="button"],

input[type="reset"],

input[type="submit"] {

  cursor: pointer;

  -webkit-appearance: button;

}

input[type=checkbox], input[type=radio] {

  cursor: pointer;

}

/* override default chrome & firefox settings */

input:not([type="image"]), textarea {

  -webkit-box-sizing: content-box;

  -moz-box-sizing: content-box;

  box-sizing: content-box;

}



input[type="search"] {

  -webkit-appearance: textfield;

  -webkit-box-sizing: content-box;

  -moz-box-sizing: content-box;

  box-sizing: content-box;

}

input[type="search"]::-webkit-search-decoration {

  -webkit-appearance: none;

}

label,

input,

select,

textarea {

  font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;

  font-size: 15px;

  font-weight: normal;

  line-height: normal;

  margin-bottom: 18px;

}

input[type=checkbox], input[type=radio] {

  cursor: pointer;

  margin-bottom: 0;

}

input[type=text],

input[type=password],

textarea,

select {

  display: inline-block;

  padding: 4px;

  font-size: 15px;

  font-weight: normal;

  line-height: 18px;

  height: 18px;

  color: #808080;

  border: 1px solid #ccc;

  -webkit-border-radius: 3px;

  -moz-border-radius: 3px;

  border-radius: 3px;

}

select, input[type=file] {

  height: 27px;

  line-height: 27px;

}

textarea {

  height: auto;

}



/* grey out placeholders */

:-moz-placeholder {

  color: #bfbfbf;

}

::-webkit-input-placeholder {

  color: #bfbfbf;

}



input[type=text],

input[type=password],

select,

textarea {

  -webkit-transition: border linear 0.2s, box-shadow linear 0.2s;

  -moz-transition: border linear 0.2s, box-shadow linear 0.2s;

  transition: border linear 0.2s, box-shadow linear 0.2s;

  -webkit-box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.1);

  -moz-box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.1);

  box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.1);

}

input[type=text]:focus, input[type=password]:focus, textarea:focus {

  outline: none;

  border-color: rgba(82, 168, 236, 0.8);

  -webkit-box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.1), 0 0 8px rgba(82, 168, 236, 0.6);

  -moz-box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.1), 0 0 8px rgba(82, 168, 236, 0.6);

  box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.1), 0 0 8px rgba(82, 168, 236, 0.6);

}



/* buttons */

button {

  display: inline-block;

  padding: 4px 14px;

  font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;

  font-size: 15px;

  line-height: 18px;

  -webkit-border-radius: 4px;

  -moz-border-radius: 4px;

  border-radius: 4px;

  -webkit-box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.2), 0 1px 2px rgba(0, 0, 0, 0.05);

  -moz-box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.2), 0 1px 2px rgba(0, 0, 0, 0.05);

  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.2), 0 1px 2px rgba(0, 0, 0, 0.05);

  background-color: #0064cd;

  background-repeat: repeat-x;

  background-image: -khtml-gradient(linear, left top, left bottom, from(#049cdb), to(#0064cd));

  background-image: -moz-linear-gradient(top, #049cdb, #0064cd);

  background-image: -ms-linear-gradient(top, #049cdb, #0064cd);

  background-image: -webkit-gradient(linear, left top, left bottom, color-stop(0%, #049cdb), color-stop(100%, #0064cd));

  background-image: -webkit-linear-gradient(top, #049cdb, #0064cd);

  background-image: -o-linear-gradient(top, #049cdb, #0064cd);

  background-image: linear-gradient(top, #049cdb, #0064cd);

  color: #fff;

  text-shadow: 0 -1px 0 rgba(0, 0, 0, 0.25);

  border: 1px solid #004b9a;

  border-bottom-color: #003f81;

  -webkit-transition: 0.1s linear all;

  -moz-transition: 0.1s linear all;

  transition: 0.1s linear all;

  border-color: #0064cd #0064cd #003f81;

  border-color: rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.25);

}

button:hover {

  color: #fff;

  background-position: 0 -15px;

  text-decoration: none;

}

button:active {

  -webkit-box-shadow: inset 0 3px 7px rgba(0, 0, 0, 0.15), 0 1px 2px rgba(0, 0, 0, 0.05);

  -moz-box-shadow: inset 0 3px 7px rgba(0, 0, 0, 0.15), 0 1px 2px rgba(0, 0, 0, 0.05);

  box-shadow: inset 0 3px 7px rgba(0, 0, 0, 0.15), 0 1px 2px rgba(0, 0, 0, 0.05);

}

button::-moz-focus-inner {

  padding: 0;

  border: 0;

}



::-webkit-scrollbar {

    width: 7px;

    height: 7px

}



::-webkit-scrollbar-button {

    height: 0;

    background-color: transparent

}



::-webkit-scrollbar-track {

    background-color: #333

}



::-webkit-scrollbar-track-piece {

    background-color: transparent

}



::-webkit-scrollbar-thumb {

    height: 5px;

    background-color: rgb(51,128,255);

    border-radius: 0

}



::-webkit-scrollbar-corner {

    background-color: #999

}

]]rp.orgs.MDStyleDark=rp.orgs.MDStyleBase..[[

body{

    margin: 0 auto;

    font-family: Roboto;

    color: #bbb;

    line-height: 1;

    padding: 30px;

    background-color: rgba(0, 0, 0, 0);

}

h1, h2, h3, h4 {

    color: #ddd;

    font-weight: 400;

}

a {

    color: #0099ff;

    margin: 0;

    padding: 0;

    vertical-align: baseline;

}

a:hover {

    text-decoration: none;

    color: #ff6600;

}

a:visited {

    color: purple;

}

blockquote {

    border-left:.5em solid #eee;

    padding: 0 2em;

    margin-left:0;

}

blockquote  cite {

    font-size:16px;

    line-height:20px;

    color:#bfbfbf;

}

blockquote p {  

    color: #777;

}

hr {

    text-align: left;

    margin: 0 auto 0 0;

    color: #4c4c4c;

}

]]rp.orgs.MDStyleLight=rp.orgs.MDStyleBase..[[

body{

    margin: 0 auto;

    font-family: Roboto;

    color: #444444;

    line-height: 1;

    padding: 30px;

    background-color: rgba(0, 0, 0, 0);

}

h1, h2, h3, h4 {

    color: #111111;

    font-weight: 400;

}

a {

    color: #0099ff;

    margin: 0;

    padding: 0;

    vertical-align: baseline;

}

a:hover {

    text-decoration: none;

    color: #ff6600;

}

a:visited {

    color: purple;

}

blockquote {

    border-left:.5em solid #555;

    padding: 0 2em;

    margin-left:0;

}

blockquote  cite {

    font-size:16px;

    line-height:20px;

    color:#bfbfbf;

}

blockquote p {  

    color: #666;

}

hr {

    text-align: left;

    margin: 0 auto 0 0;

    color: #999;

}

]]