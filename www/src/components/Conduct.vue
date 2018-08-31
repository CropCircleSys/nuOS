<template>
	<div class="coc">
		<div class="content">
			<h1>Code of Conduct</h1>
			<h2>Responsibilities of Membership</h2>
			<h3>A society is represented by its members.</h3>
			<h4><em>All</em> members and participants are expected to abide by <em>and enforce</em> the following standard of diplomatic, polite and civil behavior in <em>any</em> forum of communication, <em>not only</em> within our society, <em>whenever</em> and <em>wherever</em> representing or regarding it:</h4>
			<div class="body-copy">
				<div class="coc-meat">
					<p>Support, protect, encourage, celebrate and herald:</p>
					<ol>
						<li>Merit,</li>
						<li>Diplomacy, and</li>
						<li>Diversity.</li>
					</ol>
					<p>Do <strong>not</strong> behave in a manner such as a:</p>
					<ol>
						<li>Dick, an</li>
						<li>Asshole, or a</li>
						<li>Pussy.</li>
					</ol>
				</div>
				<h4>Addendum:</h4>
				<p>With any who may violate the CoC:</p>
				<ol>
					<li>Make sure they&rsquo;ve seen our CoC,</li>
					<li>Give them the opportunity to take a good long look at our CoC, really let them take our CoC in, <span class="light">then if that doesn&rsquo;t seem to solve the issue,</span></li>
					<li>Put a lasting boot print squarely on their <em>[proverbial]</em> ass cheek, <em>(no violence whatsoever shall be tolerated)</em> <span class="light">or if absolutely necessary,</span></li>
					<li>Boot their whole ass the hell out of our otherwise inclusive and welcoming society.</li>
				</ol>
				<h4>Epilogue:</h4>
				<p>This CoC should not be hard. We pride ourselves on our tiny, little CoC. At the risk of our CoC swelling to unmanageable enormity, it may be worth adding, to please, always remember:</p>
				<ol>
					<li>Hate comes from fear.</li>
					<li>Fear can, more often than not, come from stupidity.</li>
					<li>Stupidity itself, while maybe worthy of counteraction, is another human right, some might say, just an inescapable component of the human condition.</li>
				</ol>
				<p>Some voices are loud and some are quiet. Intelligent minds are usually gentle, often restrained. Wisdom is usually reserved in its discourse. Arrogance, less so.</p>
				<p>Freedom of speech is the most sacred and fragile human right. Its protection, one of humanity&rsquo;s most fundamental, natural laws. However, slanderous or libelous speech can many times incite action and activity far beyond the scope of conversation, completely disassociated from original intention or comprehension. Thus it is also natural law that societies, legal or private, can find a speaker to be liable for the ideas manifest and actions taken, even by those well outside of one&rsquo;s own control.</p>
				<h3>Summary:</h3>
				<p>Follow your heart. Use your brain. Watch your mouth. Own your words; they can echo further than you may even imagine.</p>
			</div>
		</div>
		<div class="coc-xrpt">
		<h1>Notice of Delegation:</h1>
		<p>Enforcement of conduct is seldom a simple matter. Authority centralized is authority corrupted. Now and forever, hereby, the authority to enforce <strong>the CoC is placed <em>in you</em></strong>.</p>
		<p>Before you exercise this authority, always pause to first ask if yourself abides the CoC. Recommended activities include but are not limited to:</p>
		<ul>
			<li>slow, deep breathing</li>
			<li>enjoyment of a long walk</li>
			<li>partake, savor and appreciate a serene natural setting</li>
		</ul>
		<p>Then these answers will present themselves: Have you firmly taken hold of the base of the CoC? Have you felt the true essence of the CoC? Have you grappled the full weight of the CoC?</p>
		<p>To put it another way: lighten up.</p>
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
.content {
	width: 50vw;
	margin-left: 25vw;
}
.coc-meat {
	border-style: double;
	border-radius: 1em;
	border-width: thick;
	padding: 0.25em 1em;
}
.light {
	font-weight: lighter;
	display: block;
	font-size: smaller;
	font-style: italic;
	margin: 0.125em 0 0.25em;
}
.light:before {
	content: '...';
}
.body-copy {
	display: table;
	margin-left: auto;
	margin-right: auto;
	width: 33.33vw;
}
.body-copy p, .body-copy ol {
	text-align: left;
}
div.coc-xrpt p, div.coc-xrpt ul {
	text-align: left;
}
@media screen and (min-width: 769px) {
	div.coc-xrpt {
		position: fixed;
		top: calc(2vmin + 6vw);
		right: 0;
		width: 20vw;
		z-index: 1;
		margin: 0 1em;
	}
}
@media screen and (max-width: 768px) {
	div.coc-xrpt {
		margin: 2em 12vw;
	}
}
div.coc-xrpt h1 {
	font-size: 1.33em;
}
div.coc-xrpt h2 {
	font-size: 1.2em;
}
div.coc-xrpt h3 {
	font-size: 1em;
}
div.content {
	font-size: calc(12pt + 0.75vmin);
	color: LightGray;
}
div.coc-xrpt {
	font-size: calc(9pt + 0.5vmin);
	color: LightGray;
}
</style>
