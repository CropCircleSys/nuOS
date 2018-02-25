<template>
	<div id="app">
		<header>
			<span class="title"><strong><em>nu</em>OS</strong>.org</span>
			<nav>
				<ul>
					<li>home</li>
					<li>information</li>
					<li>download</li>
					<li>source-code</li>
				</ul>
			</nav>
		</header>
		<router-view/>
		<footer>
			<p class="brought">
				<strong>&copy;</strong> MMXVIII<br>
				<em>brought to you by:</em><br>
				<a href="https://ccsys.com/">Crop Circle Systems, Inc.</a> &amp;<br>
				the <strong>society</strong> of <strong>independent</strong><br>
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
}
a {
	color: Gray;
}
a:hover {
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
header {
	position: fixed;
	top: 0;
	left: 0;
	text-align: left;
	margin: 1rem;
}
header .title strong {
	color: LightGray;
}
header .title em {
	color: White;
}
nav, aside, footer {
	font-size: 1rem;
}
.title {
	font-family: Baskerville, "Times New Roman", serif;
}
nav {
	display: inline-block;
}
nav ul {
	margin: 0;
	padding: 0 0 0 1em;
}
nav ul li {
	display: inline-block;
	list-style: none;
	margin: 0 1em;
	font-weight: bold;
	color: LightGray;
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
}
</style>
