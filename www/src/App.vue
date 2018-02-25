<template>
	<div id="app">
		<header><span class="title"><strong><em>nu</em>OS</strong>.org</span></header>
		<nav></nav>
		<router-view/>
		<footer>
			<p class="brought">
				<strong>&copy;</strong> MMXVIII<br>
				<em>brought to you by:</em><br>
				Crop Circle Systems, Inc. &amp;</li><br>
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
body {
	background: Black;
	font-size: 0;
}
#app {
	text-align: center;
	font-family: "Lucida Bright", Georgia, serif;
	color: Gray;
}
header, article
{
	font-size: 1.25rem;
}
header {
	position: fixed;
	top: 0;
	left: 0;
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
footer {
	position: relative;
	bottom: 0;
	width: 100%;
}
.brought {
	text-align: right;
	right: 0;
	bottom: 0;
	margin: 1rem;
}
.brought ul {
	margin: 0;
}
.brought ul li {
	list-style: none;
}
</style>
