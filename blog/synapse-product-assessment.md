---
title: Is Synapse a Product? An Honest Internal Assessment
summary: An unsparing read of the platform you're reading this on — what got built, whether the big engineering bet paid off (with measured numbers), the market it would have to survive, and the three cheap changes that turned "invisible and unmeasurable" into something you can actually decide about.
publishedAt: 2026-07-22
tags: [product, engineering, performance, retrospective]
readMinutes: 14
eyebrow: Internal Assessment · Published Openly
meta: Read Time=14 min; Lessons=442; Words of prose=757k; Verdict=Not a business, yet
---

<header class="blog-post__hero">
  <div class="blog-post__hero-copy">
    <div class="blog-post__hero-eyebrow">Internal Assessment · Published Openly</div>
    <h1 class="blog-post__hero-title">Is Synapse <em>a product?</em></h1>
    <p class="blog-post__hero-sub">An honest read of what was built, whether the one big engineering bet paid off, and the market it would have to survive. Written for myself, published because the interesting parts are the uncomfortable ones.</p>
    <div class="blog-post__hero-meta">
      <div class="blog-post__hero-meta-item"><span>Read Time</span><span>14 min</span></div>
      <div class="blog-post__hero-meta-item"><span>Lessons</span><span>442</span></div>
      <div class="blog-post__hero-meta-item"><span>Words of Prose</span><span>757,000</span></div>
      <div class="blog-post__hero-meta-item"><span>Verdict</span><span>Not yet</span></div>
    </div>
  </div>
  <div class="blog-post__hero-art" aria-hidden="true">
    <svg viewBox="0 0 600 700" fill="none" xmlns="http://www.w3.org/2000/svg">
      <circle cx="300" cy="350" r="260" fill="currentColor" opacity="0.16"/>
      <circle cx="300" cy="350" r="200" fill="currentColor" opacity="0.26"/>
      <text x="300" y="176" font-family="serif" font-size="15" fill="currentColor" text-anchor="middle" opacity="0.75" font-style="italic">Time to first words</text>
      <rect x="150" y="215" width="300" height="54" rx="6" fill="currentColor" opacity="0.55"/>
      <text x="166" y="248" font-family="monospace" font-size="15" fill="currentColor" opacity="0.95">before</text>
      <text x="434" y="248" font-family="monospace" font-size="17" fill="currentColor" text-anchor="end" opacity="0.95">7.2s</text>
      <rect x="150" y="290" width="78" height="54" rx="6" fill="currentColor" opacity="0.95"/>
      <text x="166" y="323" font-family="monospace" font-size="15" fill="currentColor" opacity="0.6">after</text>
      <text x="246" y="323" font-family="monospace" font-size="17" fill="currentColor" opacity="0.9">1.9s</text>
      <text x="300" y="392" font-family="serif" font-size="13" fill="currentColor" text-anchor="middle" opacity="0.6" font-style="italic">mid-range phone · slow 3G</text>
      <path d="M150 424 H450" stroke="currentColor" stroke-width="1" opacity="0.25"/>
      <text x="300" y="464" font-family="serif" font-size="15" fill="currentColor" text-anchor="middle" opacity="0.75" font-style="italic">JavaScript to reach them</text>
      <rect x="150" y="496" width="300" height="42" rx="6" fill="currentColor" opacity="0.55"/>
      <text x="434" y="523" font-family="monospace" font-size="15" fill="currentColor" text-anchor="end" opacity="0.95">641 KiB</text>
      <rect x="150" y="552" width="22" height="42" rx="6" fill="currentColor" opacity="0.95"/>
      <text x="190" y="579" font-family="monospace" font-size="15" fill="currentColor" opacity="0.9">47 KiB</text>
    </svg>
  </div>
</header>

<nav class="blog-post__toc" aria-label="On this page">
  <ul>
    <li><a href="#numbers">Four Numbers</a></li>
    <li><a href="#astro">Did the Rebuild Pay Off?</a></li>
    <li><a href="#gap">The Shape of the Gap</a></li>
    <li><a href="#market">The Market</a></li>
    <li><a href="#field">The Field</a></li>
    <li><a href="#backlog">The Backlog</a></li>
    <li><a href="#dont">What Not to Build</a></li>
    <li><a href="#what">What This Actually Is</a></li>
  </ul>
</nav>

<p class="blog-post__lede">"The engineering is genuinely excellent and the product does not exist yet. Both are true, and they are not in tension."</p>

Synapse is the platform serving you this page — prose lessons with runnable code, judged practice problems, and step-through visualisations of your own code executing. I built it as a learning exercise, with a working reference implementation as the oracle, and it succeeded completely at that.

But the things that make software a *product* — someone can find it, someone comes back, someone pays — were never in scope, so they were never built. This is the assessment I wrote for myself about that gap. I'm publishing it because the flattering parts are boring and the uncomfortable parts are the ones worth reading.

<aside class="blog-post__pullquote">
  <p>Three cheap changes turned this from invisible-and-unmeasurable into something you can make a real decision about. They have since been made, and the read path was rebuilt from scratch. The product is now measurable, findable and fast — whether it is a <em>business</em> is the same open question the market section leaves standing.</p>
  <cite>The short version, if you read nothing else</cite>
</aside>

<div class="blog-post__divider"><span>Where It Stands</span></div>

<h2 id="numbers" class="blog-post__section">Four Numbers That Frame Everything</h2>

Every honest assessment starts with counting rather than feeling. These four numbers set up every argument that follows.

<div class="blog-post__benefits">
  <div class="blog-post__benefit">
    <span class="blog-post__pill blog-post__pill--good">The Real Asset</span>
    <span class="blog-post__benefit-icon">📚</span>
    <h4>757,000 Words of Prose</h4>
    <p>442 lessons across 7 books. Years of writing that no amount of engineering substitutes for — and the single hardest thing here to replicate.</p>
  </div>
  <div class="blog-post__benefit">
    <span class="blog-post__pill blog-post__pill--bad">Thin</span>
    <span class="blog-post__benefit-icon">🎯</span>
    <h4>30 Judged Problems</h4>
    <p>In the entire corpus; 29 of them in one book. LeetCode has roughly 3,500. This is not a gap that can be closed by trying harder.</p>
  </div>
  <div class="blog-post__benefit">
    <span class="blog-post__pill blog-post__pill--bad">Narrow</span>
    <span class="blog-post__benefit-icon">🔬</span>
    <h4>2 of 11 Languages Traced</h4>
    <p>The visualiser — the one genuinely differentiated feature — follows execution in Python and Java only. That's 18% of the languages the sandbox runs.</p>
  </div>
  <div class="blog-post__benefit">
    <span class="blog-post__pill blog-post__pill--good">Fixed</span>
    <span class="blog-post__benefit-icon">🔎</span>
    <h4>442 Indexable Page Titles</h4>
    <p>This was <strong>1</strong> — a single hardcoded title across every lesson, making all 442 identical in a search result. The rebuild below fixed it structurally.</p>
  </div>
</div>

<div class="blog-post__divider"><span>The Big Bet</span></div>

<h2 id="astro" class="blog-post__section">Did Rebuilding the Read Path Pay Off?</h2>

The reader originally shipped as a client-rendered WebAssembly application: about 20,000 lines of Rust compiled to a bundle that had to download, compile and boot **before a single word of prose appeared**. Measured on production, content was readable at 1.25 s on broadband and **7.2 s on a mid-range phone over slow 3G** — for lessons whose actual text is around 2 KiB.

That is an absurd trade, and the workload table made it indefensible: reads are ~99% of all traffic. The architecture of the read path had to answer to that number. So it was rebuilt — server-rendered pages, with the editor, diagrams and visualiser hydrating as lazy per-feature islands only on pages that use them.

Here is what actually changed, measured on the live site rather than modelled:

<div class="blog-post__benefits">
  <div class="blog-post__benefit">
    <span class="blog-post__pill blog-post__pill--good">Measured on Production</span>
    <span class="blog-post__benefit-icon">⚡</span>
    <h4>2.4× Faster — Broadband</h4>
    <p>1.25 s → 0.52 s to first content. Median of three runs. The model predicted ~3×; the model was an upper bound.</p>
  </div>
  <div class="blog-post__benefit">
    <span class="blog-post__pill blog-post__pill--good">Measured on Production</span>
    <span class="blog-post__benefit-icon">📱</span>
    <h4>3.9× Faster — Mid-Range Phone</h4>
    <p>7.2 s → 1.86 s on throttled 3G with a 4× CPU penalty. The slowest path saw the biggest absolute win, which is the right way round.</p>
  </div>
  <div class="blog-post__benefit">
    <span class="blog-post__pill blog-post__pill--good">Structural</span>
    <span class="blog-post__benefit-icon">📉</span>
    <h4>~93% Less JavaScript</h4>
    <p>641 KiB gzipped of WebAssembly that blocked all prose → ~47 KiB of eager JS per page. Everything heavy is now lazy and optional.</p>
  </div>
</div>

<div class="blog-post__table-wrap">
  <table class="blog-post__table">
    <thead><tr><th>Measure</th><th>Before (WASM client)</th><th>After (server-rendered)</th><th>Change</th></tr></thead>
    <tbody>
      <tr><td><strong>First content — broadband</strong></td><td>1.25 s</td><td>0.52 s</td><td><span class="blog-post__pill blog-post__pill--good">2.4× faster</span></td></tr>
      <tr><td><strong>First content — phone / slow 3G</strong></td><td>7.2 s</td><td>1.86 s</td><td><span class="blog-post__pill blog-post__pill--good">3.9× faster</span></td></tr>
      <tr><td><strong>Blocking JS before prose</strong></td><td>641 KiB gz</td><td>~47 KiB gz</td><td><span class="blog-post__pill blog-post__pill--good">~93% less</span></td></tr>
      <tr><td><strong>Prose arrives as</strong></td><td>Output of a compiler, after boot</td><td>HTML in the first response</td><td><span class="blog-post__pill blog-post__pill--good">Structural</span></td></tr>
      <tr><td><strong>Distinct page titles</strong></td><td>1 (hardcoded)</td><td>442, server-rendered</td><td><span class="blog-post__pill blog-post__pill--good">Indexable</span></td></tr>
      <tr><td><strong>Works without JavaScript</strong></td><td>No — blank page</td><td>Yes — reading is plain HTML</td><td><span class="blog-post__pill blog-post__pill--good">Resilient</span></td></tr>
    </tbody>
  </table>
</div>

The delivered 2.4× / 3.9× lands slightly under the modelled 3× / 5×, and that is worth stating plainly rather than rounding up. But the model was always the ceiling, and the structural change is the real headline: **time-to-content is no longer a function of how fast a compiler boots.** A per-page JavaScript budget now fails the build if any island ever goes eager again, so the win cannot quietly erode.

It also closed a product gap for free. Server rendering made per-page metadata real — every lesson emits its own title, description, social card and canonical URL, with a sitemap and robots file generated from the same in-memory index. That was a ranked backlog item; it arrived as a side effect.

<div class="blog-post__callout blog-post__callout--info">
  <p>💡 <strong>What the migration is, and what it isn't:</strong> it is an <strong>enabler, not a mover</strong>. It made the read path fast and findable — the preconditions a product needs before growth is even measurable. It did not, and could not, change the market realities below, deepen the corpus, or create a revenue mechanism. The right technical bet, executed and verified in production, on a project whose <em>product</em> verdict is unchanged.</p>
</div>

<div class="blog-post__divider"><span>The Gap</span></div>

<h2 id="gap" class="blog-post__section">Everything Works. Nothing Compounds.</h2>

The gaps here are not bugs or half-finished features — every shipped surface works. They are whole categories of product machinery that were never in scope, which is exactly why none of them ever appeared in a backlog as unfinished business. You do not notice the absence of a growth loop when you never planned one.

<div class="blog-post__rules">
  <div class="blog-post__rules-do">
    <h4>✅ Built, and built well</h4>
    <ul>
      <li><span>✅</span>Architecture enforced by CI, not by review discipline — a conventions gate that fails in seconds, before any toolchain installs</li>
      <li><span>✅</span>Cross-language port fidelity pinned by golden differential tests</li>
      <li><span>✅</span>A Java in-sandbox recompile tracer with trace-stable heap identity — genuinely weeks of specialist work</li>
      <li><span>✅</span>A real sandbox container in CI, not a stub; database integration tests with prove-it-ran guards</li>
      <li><span>✅</span>A server-rendered read path with a per-page JS budget, and a headless browser suite that fails the build if a widget stops mounting</li>
    </ul>
  </div>
  <div class="blog-post__rules-dont">
    <h4>❌ Still out of scope</h4>
    <ul>
      <li><span>❌</span>No organic acquisition channel — indexing is now <em>possible</em>, but nobody is driving traffic</li>
      <li><span>❌</span>No product analytics beyond an anonymous lesson-view counter</li>
      <li><span>❌</span>No billing, plans or quotas anywhere in the codebase</li>
      <li><span>❌</span>Single-tenant, git-push authoring; production is architecturally invite-only</li>
      <li><span>❌</span>No spaced repetition or long-horizon learning loop — progress is remembered, never scheduled</li>
    </ul>
  </div>
</div>

<div class="blog-post__divider"><span>The Market</span></div>

<h2 id="market" class="blog-post__section">The Category Is Contracting, and Investors Have Named It</h2>

Nothing in the rebuild touches this section. It is included unchanged because it remains the binding constraint on any product decision, and because it is the part I would most like to be wrong about.

Crunchbase News reported in late 2025 that investors are keen on healthcare education and AI-enabled K-12, while *"coding academies and teaching platforms"* face headwinds. That is this category, named explicitly.

<div class="blog-post__table-wrap">
  <table class="blog-post__table">
    <thead><tr><th>Period</th><th>Global edtech venture funding</th><th>Note</th></tr></thead>
    <tbody>
      <tr><td><strong>2021</strong></td><td>$16.7B</td><td>The peak</td></tr>
      <tr><td><strong>2024</strong></td><td>$2.8B</td><td>~83% below peak</td></tr>
      <tr><td><strong>2025</strong></td><td>$2.8B</td><td>Flat — no recovery</td></tr>
      <tr><td><strong>H1 2026</strong></td><td>$1.0B</td><td><span class="blog-post__pill blog-post__pill--bad">−26% YoY</span> against the equivalent H1 2025</td></tr>
    </tbody>
  </table>
</div>

Company formation tells the same story: roughly 10,500 edtech launches in 2020, down to 645 in 2025. And the structural evidence is unambiguous. Skillsoft laid off Codecademy's entire curriculum team. 2U filed Chapter 11 on the back of a 40% drop in bootcamp enrollments. Chegg is down roughly 99% from its peak and cut 45% of staff. Coursera and Udemy announced a defensive merger for cost synergies. Stack Overflow questions fell about 76% from their peak — developers simply stopped going to websites to learn things.

Two counter-signals, stated honestly, because a one-sided case is a useless one: AI *content* demand is booming, and LeetCode traffic grew 19% month-over-month in mid-2026. Interview prep is holding up. Demand is rotating from "learn to code" toward "learn to use AI."

<div class="blog-post__callout blog-post__callout--warn">
  <p>⚠️ <strong>Python Tutor is the most important datapoint here.</strong> Philip Guo has run the closest analog to my visualiser since 2010 — now 25M+ users. In his UIST 2021 paper he writes that he could not secure long-term funding and sustained it by "sneaking it into" a conventional academic career, and observes that despite billions in venture and big-tech money, no company has built its own code visualization tool. That is simultaneously the strongest differentiation argument available to me and the strongest evidence the capability has never supported a business.</p>
</div>

<div class="blog-post__callout blog-post__callout--bad">
  <p>🎓 <strong>Runestone Academy needs an answer.</strong> Open-source, self-hostable, prose-first interactive textbooks with embedded runnable code and trace visualisation — grant-supported, running since 2011. That is close to a feature-for-feature match minus the AI coach and the diagrams. "Ours is nicer" is not an answer to fifteen years of funded open source, though "ours is 4× faster on a phone and every lesson is indexable" is at least a sharper one than it was a week ago.</p>
</div>

<div class="blog-post__divider"><span>The Field</span></div>

<h2 id="field" class="blog-post__section">Where Synapse Actually Sits</h2>

The one genuine differentiator is tracing **the learner's own code** inside a prose lesson — shared only with Python Tutor and Runestone's CodeLens, which is Python Tutor embedded.

<div class="blog-post__table-wrap">
  <table class="blog-post__table">
    <thead><tr><th>Player</th><th>Traces your own code</th><th>Prose + execution</th><th>Judged problems</th><th>Commercial outcome</th></tr></thead>
    <tbody>
      <tr><td><strong>Synapse</strong></td><td><span class="blog-post__pill blog-post__pill--good">Yes · 2 langs</span></td><td><span class="blog-post__pill blog-post__pill--good">Yes</span></td><td>30</td><td>No revenue mechanism</td></tr>
      <tr><td>Python Tutor</td><td><span class="blog-post__pill blog-post__pill--good">Yes</span></td><td><span class="blog-post__pill blog-post__pill--neutral">No</span></td><td>—</td><td>25M users, never monetized</td></tr>
      <tr><td>Runestone</td><td><span class="blog-post__pill blog-post__pill--good">Yes</span></td><td><span class="blog-post__pill blog-post__pill--good">Yes</span></td><td>Parsons etc.</td><td>Grant-funded</td></tr>
      <tr><td>Educative</td><td><span class="blog-post__pill blog-post__pill--neutral">No</span></td><td><span class="blog-post__pill blog-post__pill--good">Yes, + AI tutor</span></td><td>Some</td><td>~$14.6M raised, none since 2021</td></tr>
      <tr><td>Exercism</td><td><span class="blog-post__pill blog-post__pill--neutral">No</span></td><td><span class="blog-post__pill blog-post__pill--good">Yes</span></td><td>Many</td><td>2M users, couldn't make payroll</td></tr>
      <tr><td>freeCodeCamp</td><td><span class="blog-post__pill blog-post__pill--neutral">No</span></td><td><span class="blog-post__pill blog-post__pill--good">Yes</span></td><td>Many</td><td>Donations; sets the price floor at zero</td></tr>
      <tr><td>LeetCode</td><td><span class="blog-post__pill blog-post__pill--neutral">No</span></td><td><span class="blog-post__pill blog-post__pill--neutral">No</span></td><td>~3,500</td><td>Growing 19% MoM</td></tr>
      <tr><td>AlgoExpert</td><td><span class="blog-post__pill blog-post__pill--neutral">No</span></td><td><span class="blog-post__pill blog-post__pill--neutral">No</span></td><td>Many</td><td>$1.9M ARR, 14 people</td></tr>
    </tbody>
  </table>
</div>

Revenue figures circulating for several of these contradict each other by up to 10× across sources, so they are omitted rather than guessed.

<div class="blog-post__divider"><span>The Work</span></div>

<h2 id="backlog" class="blog-post__section">The Backlog — Ranked by Leverage, Now Largely Shipped</h2>

Order carried real information here: item 1 was first because nothing below it could be prioritised until it existed. Four of the five have since been built. The ranking is preserved so the reasoning stays legible.

<div class="blog-post__timeline">
  <div class="blog-post__timeline-item">
    <span class="blog-post__timeline-week">01 · Shipped</span>
    <h5>Measurement — you cannot prioritise what you cannot see</h5>
    <p>There was no way to answer "does anyone read this, and what?" Every item below it was a guess until that changed. The cheap version needed no third party, no client JavaScript and no cookie banner, because every lesson view already flows through one endpoint I own. An append-only row keyed on the lesson path. No user id, no IP address.</p>
  </div>
  <div class="blog-post__timeline-item">
    <span class="blog-post__timeline-week">02 · Shipped</span>
    <h5>Discoverability — delivered by the rebuild</h5>
    <p>442 identical titles made every page indistinguishable in search, and social preview cards do not run JavaScript at all. The original plan was server-side meta injection as a string substitution; the rebuild did the deeper thing instead, so the fix is structural rather than a patch.</p>
  </div>
  <div class="blog-post__timeline-item">
    <span class="blog-post__timeline-week">03 · Shipped</span>
    <h5>A reason to come back</h5>
    <p>The instinct was a progress table behind a login — the wrong first move, since the reader <em>is</em> anonymous and an invite-only account reaches almost nobody. Instead: local read/complete state, "continue where you left off", completion ticks. All anonymous, all client-side.</p>
  </div>
  <div class="blog-post__timeline-item">
    <span class="blog-post__timeline-week">04 · Shipped</span>
    <h5>A browser smoke suite — the biggest rigour gap</h5>
    <p>For a product whose entire value is interactive widgets, every "verified live" note was a human in a browser tab, and the existing gates structurally could not catch a widget that silently stopped mounting. Now ten specs run against a production-shaped serve, plus the per-page JS budget. It caught real regressions during the rebuild.</p>
  </div>
  <div class="blog-post__timeline-item">
    <span class="blog-post__timeline-week">05 · Open</span>
    <h5>Deepen the 30 problems — emphatically not more of them</h5>
    <p>Problem volume is the most commoditized axis in this market and it cannot be won. Thirty problems where you can watch <em>your own code</em> build the data structure is a better story than three hundred generic ones, and it plays to the one asset nobody else has. This is the only item still open — and it is a content bet, not an engineering one.</p>
  </div>
</div>

<h2 id="dont" class="blog-post__section">What Not to Build — the Expensive Instincts</h2>

Deciding what not to do is the higher-leverage half of a roadmap, and every line here is something I have actively wanted to build at some point.

<div class="blog-post__table-wrap">
  <table class="blog-post__table">
    <thead><tr><th>The instinct</th><th>Why it's wrong, for now</th></tr></thead>
    <tbody>
      <tr><td><strong>More tracer languages</strong></td><td>Each is multi-week work, and the corpus is already 99% Python and Java — the marginal value against existing content is near zero. Build a third only when a real reader asks for it.</td></tr>
      <tr><td><strong>Multi-tenancy, a CMS, an authoring UI</strong></td><td>Only pays off if there will be other authors. There won't be, unless the positioning changes first.</td></tr>
      <tr><td><strong>Scaling past one replica</strong></td><td>The current concurrency budget is correct for current load. The rebuild made reads edge-cacheable and origin-light, which pushes that trigger further out, not closer. Know the trigger; don't pre-solve it.</td></tr>
      <tr><td><strong>An investor deck</strong></td><td>Not as a consumer learn-to-code product. The category is named as out of favour, the closest analogs are dead or unfunded, and there is no traction to show. A faster site does not change this.</td></tr>
    </tbody>
  </table>
</div>

<div class="blog-post__divider"><span>Honestly</span></div>

<h2 id="what" class="blog-post__section">What This Project Actually Is</h2>

Worth saying plainly, because the list above is unrelenting and could be read as a verdict on the work rather than on its scope.

Synapse is an exceptional portfolio artifact and a genuinely good personal learning platform. As a demonstration of engineering judgement it is stronger than most production systems I have worked in: the architecture is enforced by CI rather than by review discipline, port fidelity is pinned by cross-language differential tests, and every significant decision is documented with the reasoning that produced it. The in-sandbox recompile tracer, and the read-path rebuild that made the site multiples faster while it stayed live in production, are both the kind of work that gets someone hired.

It is not a business, it was never built to be one, and the backlog above has now been executed — which means, for the first time, the project can tell me whether anyone is reading it. That was the entire point of doing those items: not to make it a product, but to make the question *answerable*.

<div class="blog-post__callout blog-post__callout--green">
  <p>🌱 <strong>The closing thought:</strong> the rebuild removed the last excuse the read path had for being slow and invisible. What it cannot do — what no amount of engineering can do — is change the answer the market section keeps giving. I would rather know that clearly than discover it slowly.</p>
</div>

<footer class="blog-post__post-footer">
  <p>Performance figures were measured against the live production deployment rather than a local build: median of three runs, throttled to Fast-3G with a 4× CPU penalty for the mobile numbers. Funding and market data from HolonIQ and Crunchbase News; competitor commercial outcomes from public reporting.</p>
  <p>This assessment was written for internal decision-making and published with the confidential diligence section removed. The verdict, the numbers and the market analysis are otherwise unchanged.</p>
</footer>
