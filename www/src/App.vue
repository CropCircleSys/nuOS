<template>
	<div id="app">
		<header>
			<nav>
				<div class="home title"><strong><em>nu</em>OS</strong><span class="sm-cap">.org</span></div>
				<ul class="north west">
					<li><router-link to="/">home</router-link></li>
					<li>info</li>
					<li>log</li>
					<li>get</li>
					<li><a href="https://github.com/CropCircleSys/nuOS/">src</a></li>
				</ul>
				<ul class="sm-cap north east">
					<li><a href="mailto:join@nuos.org">sign up</a></li>
					<li>sign in</li>
				</ul>
				<div class="ext net title"><strong><em>nu</em>OS</strong><span class="sm-cap">.net</span></div>
				<ul class="ext west">
					<li><em>nu</em><span class="cap">.<span class="sqz x-zone">zone</span></span></li>
					<li><em>nu</em><span class="cap">.<span class="sqz x-place">place</span></span></li>
					<li><em>nu</em><span class="cap">.<span class="sqz x-email">email</span></span></li>
					<li><em>nu</em><span class="cap">.<span class="sqz x-chat">chat</span></span></li>
					<li><em>nu</em><span class="cap">.<span class="sqz x-team">team</span></span></li>
					<li><em>nu</em><span class="cap">.<span class="sqz x-show">show</span></span></li>
					<li><em>nu</em><span class="cap">.<span class="sqz x-live">live</span></span></li>
					<li><em>nu</em><span class="cap">.<span class="sqz x-lol">lol</span></span></li>
					<li><em>nu</em><span class="cap">.<span class="sqz x-parts">parts</span></span></li>
					<li><em>nu</em><span class="cap">.<span class="sqz x-software">software</span></span></li>
					<li><em>nu</em><span class="cap">.<span class="sqz x-click">click</span></span></li>
					<li><em>nu</em><span class="cap">.<span class="sqz x-money">money</span></span></li>
					<li><em>nu</em><span class="cap">.<span class="sqz x-cash">cash</span></span></li>
					<li><em>nu</em><span class="cap">.<span class="sqz x-gold">gold</span></span></li>
				</ul>
			</nav>
		</header>
		<router-view class="router-view"/>
		<footer>
			<p class="brought">
				<strong>&copy;</strong> MMXVIII<br/>
				<em>brought to you by:</em><br/>
				<a href="https://ccsys.com/">Crop Circle Systems</a><br/>
				&amp; the <strong>society</strong> of <br/>
				<strong>private</strong> or <strong>anonymous</strong><br/>
				<strong>independent <em>ethical</em> hackers</strong>
			</p>
		</footer>
	</div>
</template>

<script>
import 'normalize.css'
export default {
	name: 'App'
}
</script>

<style>
.sqz {
	display: inline-block;
	transform-origin: 0 50% 0;
}
.sqz.x-zone { transform: scaleX(0.956); }
.sqz.x-place { transform: scaleX(0.855); }
.sqz.x-software { transform: scaleX(0.5); }
.sqz.x-parts { transform: scaleX(0.882); }
.sqz.x-email { transform: scaleX(0.840); }
.sqz.x-chat { transform: scaleX(0.973); }
.sqz.x-team { transform: scaleX(0.937); }
.sqz.x-show { transform: scaleX(0.882); }
.sqz.x-live { transform: scaleX(1.174); }
.sqz.x-lol { transform: scaleX(1.340); }
.sqz.x-click { transform: scaleX(0.834); }
.sqz.x-money { transform: scaleX(0.706); }
.sqz.x-gold { transform: scaleX(0.929); }
.sqz.x-cash { transform: scaleX(1.011); }
html {
	font-size: 12pt;
	line-height: 1.125;
	text-size-adjust: none;
	-webkit-text-size-adjust: none;
	-ms-text-size-adjust: none;
}
body {
	background: Black;
	font-size: 0;
	color: Gray;
}
#app {
	text-align: center;
	font-family: "Lucida Bright", Georgia, serif;
}
a {
	color: LightGray;
}
a:hover {
	color: WhiteSmoke;
}
.brought a {
	color: Gray;
}
.brought {
	z-index: -1;
}
.brought a:hover {
	color: DarkGray;
}
nav a {
	text-decoration: none;
}
header, article
{
	font-size: 1.25rem;
}
nav, aside, footer {
	font-size: 1rem;
}
header {
	position: fixed;
	top: 0;
	width: 100%;
	text-align: left;
	margin: 1rem;
}
header .home {
	font-size: 2.5vmax;
	display: block;
	margin: -0.1875em 0.875em 0 0;
}
header .net {
	font-size: 1.75vmax;
	display: block;
	margin: 1em 0.875em 0 0.5em;
}
header .title strong {
	color: LightGray;
}
header .title em {
	color: White;
}
.title, header {
	font-family: Baskerville, "Times New Roman", serif;
}
.title em {
	font-size: 137.5%;
}
.sm-cap {
	font-variant: small-caps;
}
.cap {
	text-transform: uppercase;
}
.title .sm-cap {
	font-size: 87.5%;
	font-weight: 600;
}
nav {
	display: inline-block;
}
nav ul {
	margin: 0;
	padding: 0;
	font-size: 2vmax;
}
header nav {
	position: fixed;
}
header nav ul.east {
	position: fixed;
	text-align: right;
	right: 0;
	top: 0;
	margin: 1rem;
}
nav ul li {
	list-style: none;
	margin: 0 0.5em;
	font-weight: bold;
}
nav ul.ext {
	margin: 0.125em 0 0;
}
nav ul.ext li {
	margin: 0;
	display: block;
}
nav ul.ext li em {
	font-size: 125%;
	line-height: 66.67%;
}
footer {
	bottom: 0;
	width: 100%;
	margin-top: 4rem;
}
.brought {
	color: DimGray;
	text-align: right;
	right: 0;
	margin: 1rem;
}
@media screen and (min-width: 769px) {
	footer {
		position: fixed;
		z-index: -1;
	}
	header .ext.net {
		font-size: 3.5vmin;
	}
	header .home {
		font-size: 3.75vw;
		display: inline-block;
	}
	nav ul {
		font-size: 2.75vw;
	}
	nav .ext {
		font-size: 4vmin;
	}
	nav ul.north {
		display: inline-block;
	}
	nav ul li {
		display: inline-block;
	}
	.router-view {
		margin: 8vw 0 0 0;
	}
}
@media screen and (max-width: 768px) {
	.net:before {
		content: '⟵⟶';
		font-size: 125%;
		letter-spacing: -0.15em;
		display: block;
		margin: 1em -0.25em 0;
	}
	nav ul.east li {
		margin: 0;
	}
	.router-view {
		margin: 0 0 0 12.5vw;
	}
}
</style>
