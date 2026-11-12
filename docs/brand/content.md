# Content inventory

Status: inputs from Eduard, 2026-11-12 (TASKS T0.4). The site copy comes from this file; [`identity.md`](identity.md) sets the voice.

Rules from the [brief](brief.md) apply: no employer or client names, nothing under NDA, no "hire me".

## Identity line

| English | Italian |
|---|---|
| Code is cheap now. Knowing what to build, and keeping it standing, is the work. | Il codice oggi costa poco. Il lavoro è sapere cosa costruire e farlo reggere. |

## Bio

**English.** Full stack developer in Catania, Sicily. I build e-learning platforms and European research projects, from the database to the interface. When a production system stops, I'm the one they call: it's the part of the job that has taught me the most.

**Italian.** Full stack developer a Catania. Costruisco piattaforme e-learning e progetti di ricerca europei, dal database all'interfaccia. Quando un sistema in produzione si ferma, chiamano me: è la parte del lavoro che mi ha insegnato di più.

## Experience

No company names; roles and years only.

| Years | Role | What |
|---|---|---|
| 2025 – now | Full stack developer | E-learning platforms and EU-funded research projects: AI features in a production LMS, agents that take repetitive work off colleagues, a licence purchase and management portal, a port digital twin, the company IoT network |
| 2023 – 2024 | Founder and developer, my own studio | Client sites from first call to maintenance: custom WordPress, hosting, security, technical SEO |
| 2022 – 2024 | Front end, then full stack developer | Angular interfaces, GraphQL with Apollo, backend services, reporting tools in Node-RED |
| 2020 | Diploma in computer science (perito informatico) | |

Left out for now: board roles (2026). They can come back as one line in About if useful.

## Projects

The case studies are company or client work: the problem and the decisions, no confidential detail, no images.

| # | Project | Named | Status |
|---|---|---|---|
| 1 | **Agents for the work that repeats**: agents built around colleagues' repetitive tasks | No | Ready: text below |
| 2 | **GeminiPort**: a digital twin for ports, 3D map, NGSI-LD context broker, for port authorities | Yes (project name only, no partners) | Ready: text below |
| 3 | **eduardiacob.dev**: this site. Static, zero monthly cost, everything as code, decisions written down | Yes | Ready: the repo and `docs/adr/` are the material |

Left out: the AI features in the LMS stay an experience line; the database migration is not shown.

## Case study: agents for the work that repeats

### English

**Agents for the work that repeats**

The problem: colleagues spending hours on tasks that repeat the same way. Finding projects and partners, following European projects, preparing content for search.

What I built: agents around those tasks, mostly on ChatGPT. Three families:

- support for project managers running European projects;
- scouting of projects and stakeholders;
- SEO and GEO for the marketing team.

Some start from a chat when they are needed, others run on their own when the task allows it.

Safety, from the OWASP guidance for LLM and agentic applications:

1. read-only tools: the agent reads, it does not change anything;
2. no destructive actions;
3. a person confirms every action that changes something;
4. what the agent reads, pages or documents, is material, not instructions.

Decision: what to give an agent and what to leave to people. The agent searches, gathers and writes the first draft. Choosing and acting stay with whoever answers for it.

Result: scouting goes from 3–4 hours of work to 5–6 minutes of agent time.

### Italian

**Agenti per il lavoro che si ripete**

Il problema: colleghi che passano ore su compiti che si ripetono uguali. Cercare progetti e partner, seguire progetti europei, preparare contenuti per la ricerca.

Cosa ho costruito: agenti attorno a quei compiti, soprattutto su ChatGPT. Tre famiglie:

- supporto ai project manager nella gestione di progetti europei;
- scouting di progetti e stakeholder;
- SEO e GEO per il team marketing.

Alcuni partono in chat quando servono, altri da soli quando il compito lo permette.

Sicurezza, dalle linee guida OWASP per LLM e agenti:

1. strumenti in sola lettura: l'agente legge, non modifica;
2. nessuna azione distruttiva;
3. conferma di una persona prima di ogni azione che cambia qualcosa;
4. quello che l'agente legge, pagine o documenti, è materiale e non istruzioni.

Decisione: cosa dare a un agente e cosa lasciare alle persone. L'agente cerca, raccoglie e prepara la prima bozza. Scegliere e agire resta a chi ne risponde.

Risultato: lo scouting passa da 3-4 ore di lavoro a 5-6 minuti di agente.

### Notes

The safety points map to risks named by OWASP: Excessive Agency and Tool Misuse (points 1–3), Prompt Injection and Agent Goal Hijack (point 4). Cite them by name: the LLM list numbers differ between editions.

## Case study: GeminiPort

### English

**GeminiPort, a digital twin for ports**

A real-time 3D map of a port's ships, quays, buildings and traffic, for port authorities. Each authority sees only its own ports and the modules in its contract.

Constraint: open standards and no paid services. NGSI-LD, CesiumJS and 3D Tiles, OpenStreetMap, EMODnet, AIS.

My part:

- NGSI-LD integration with the context broker, publishing and periodically republishing the port data;
- buildings generated from open data: OSM, then CityGML and 3DCityDB, then 3D Tiles;
- automatic onboarding: a new port is configuration;
- bringing the first two ports live;
- audit log and security hardening;
- a full revision of the interface and the visual identity;
- a PR and deploy pipeline with a 3D Tiles smoke test.

Built with AI-assisted coding too.

Decisions:

- a port is configuration, not code: the hand-made data of the first port was deleted;
- Overpass only to propose the area, then import from Geofabrik extracts with osmium;
- one manual step, for the secrets; the rest of the provisioning re-runs on its own.

Result: two ports live with no port-specific code, 3D Tiles refreshed every 5 minutes.

### Italian

**GeminiPort, un gemello digitale per i porti**

Una mappa 3D in tempo reale di navi, banchine, edifici e traffico di un porto, per le autorità portuali. Ogni ente vede solo i suoi porti e i moduli del suo contratto.

Vincolo: standard aperti e nessun servizio a pagamento. NGSI-LD, CesiumJS e 3D Tiles, OpenStreetMap, EMODnet, AIS.

Il mio ruolo:

- integrazione NGSI-LD con il context broker, pubblicazione e ripubblicazione periodica dei dati del porto;
- edifici generati da dati aperti: OSM, poi CityGML e 3DCityDB, poi 3D Tiles;
- onboarding automatico: un nuovo porto è configurazione;
- attivazione dei primi due porti;
- audit log e hardening di sicurezza;
- revisione completa di interfaccia e identità visiva;
- pipeline di PR e deploy con smoke test dei 3D Tiles.

Sviluppato anche con coding assistito dall'AI.

Decisioni:

- un porto è configurazione, non codice: i dati fatti a mano del primo porto sono stati eliminati;
- Overpass solo per proporre l'area, poi import da estratti Geofabrik con osmium;
- un solo passaggio manuale, sui segreti; il resto del provisioning riparte da solo.

Risultato: due porti attivati senza codice dedicato, 3D Tiles aggiornati ogni 5 minuti.

## Decisions (the trails)

1. Zero monthly cost on AWS and Cloudflare: what that forces, and what it buys (from this repo).
2. What to give an agent, and what to leave to people (from the agents case study).
3. A port is configuration, not code (from GeminiPort).

## Links

- GitHub: `github.com/eduardiacobdev`
- LinkedIn: `linkedin.com/in/eduard-alexandru-iacob`
- Contact: the form only (T3.7). No email address or phone number on the site.

## Photo

Yes. The current portrait is 400 × 400 px: enough for a small portrait up to about 200 CSS px. A larger original is needed for anything bigger. Strip metadata before it goes in the repo. The social image uses the monogram, not the photo.
