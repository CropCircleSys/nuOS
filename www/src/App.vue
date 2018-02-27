<template>
	<div id="app">
		<header>
			<nav>
				<div class="title"><strong><em>nu</em>OS</strong><span class="sm-cap">.org</span></div>
				<ul class="west">
					<li>home</li>
					<li>info</li>
					<li>log</li>
					<li>get</li>
					<li>src</li>
				</ul>
				<ul class="sm-cap east">
					<li>sign in</li>
					<li>sign up</li>
				</ul>
			</nav>
		</header>
		<router-view class="router-view"/>
		<footer>
			<p class="brought">
				<strong>&copy;</strong> MMXVIII<br/>
				<em>brought to you by:</em><br/>
				<a href="https://ccsys.com/">Crop Circle Systems, Inc.</a> &amp;<br/>
				the <strong>society</strong> of <strong>independent</strong><br/>
				or <strong>anonymous ethical hackers</strong>
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
html {
	font-size: 12pt;
	line-height: 1.125;
	text-size-adjust: none;
	-webkit-text-size-adjust: none;
	-ms-text-size-adjust: none;
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
.brought a:hover {
	color: DarkGray;
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
header .title {
	font-size: 2.5vmax;
	display: block;
	margin: -0.1875em 0.875em 0 0;
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
.sm-cap {
	font-variant: small-caps;
}
.title .sm-cap {
	font-size: 87.5%;
	font-weight: 600;
}
nav {
	display: inline-block;
/*
	display: none;
 */
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
	header .title {
		font-size: 3.75vw;
		display: inline-block;
	}
	nav ul {
		font-size: 3vw;
		display: inline;
	}
	nav ul li {
		display: inline-block;
	}
	.router-view {
		margin: 8vw 0 0 0;
	}
}
@media screen and (max-width: 768px) {
	nav ul.east li {
		margin: 0;
	}
}
</style>
