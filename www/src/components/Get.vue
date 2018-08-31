<template>
	<div class="get">
		<div class="content">
			<h1 class="title"><em>nu</em>OS</h1>
			<h2>0.0.11.2a1</h2>
			<h3>FreeBSD-11.2-RELEASE</h3>
			<h4>amd64/desktop: 9 GB</h4>
			<h4>amd64/server: 5 GB</h4>
			<h4>amd64/base: 2 GB</h4>
		</div>
		<div class="info-xrpt">
		<h1>Notice of Invitation:</h1>
		<p>Due to overwhelming response and our large initial software download, we are currently only distributing to members. We ask that you introduce yourself uniquely, albeit however briefly you choose, (specifically request &ldquo;membership&rdquo; and/or to &ldquo;join&rdquo; the &ldquo;society&rdquo;) using the email link above in order to receive the download link. Also, this actually affords all of us certain protections under the law as a private society, allowing us greater liberty to provide innovative software and services, and you, greater freedom of participation. It is our strict, hereby legally binding, privacy policy to never solicit commercial services to you and never sell your email address for any type of gain, financial or otherwise.</p><p>You may also opt to build the system yourself from the source code link, instead. This also affords the society its greatest liberties to bring you great software!</p>
		</div>
	</div>
</template>

<script>
export default {
	name: 'Get',
	data () {
		return {}
	}
}
</script>

<style scoped>
div.info-xrpt p {
	text-align: left;
}
@media screen and (min-width: 769px) {
	div.info-xrpt {
		position: fixed;
		top: calc(2vmin + 6vw);
		right: 0;
		width: 20vw;
		z-index: 1;
		margin: 0 1em;
	}
}
@media screen and (max-width: 768px) {
	div.info-xrpt {
		margin: 2em 12vw;
	}
}
div.info-xrpt h1 {
	font-size: 1.33em;
}
div.info-xrpt h2 {
	font-size: 1.2em;
}
div.info-xrpt h3 {
	font-size: 1em;
}
div.content {
	font-size: calc(12pt + 0.75vmin);
	color: LightGray;
}
div.info-xrpt {
	font-size: calc(9pt + 0.5vmin);
	color: LightGray;
}
</style>
