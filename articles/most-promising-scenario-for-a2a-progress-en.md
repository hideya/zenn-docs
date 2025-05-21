---
title: "WIP: A2A Protocol Rollout Senario"
emoji: "👭"
type: "idea"
topics: ["A2A", "AIエージェント", "業界動向", "AI", "Agent2Agent" ]
published: false
---

# WIP

A2A Protocol Rollout Senario — Predictions Based on Concrete Evidence

## Quick Summary

* Unlike the community-driven development of the [Model Context Protocol (MCP)](https://modelcontextprotocol.io/introduction), **the practical rollout of the [A2A (Agent-to-Agent) Protocol](https://cloud.google.com/blog/products/ai-machine-learning/a2a-a-new-era-of-agent-interoperability) will really accelerate once successful enterprise PoC cases emerge via system integrators (SIers).**
* The fastest path to commercial agent-to-agent communication is via [AWS Bedrock Agents](https://aws.amazon.com/bedrock/agents/) (since it is self-contained within AWS Cloud).
* At the same time, the [OpenAI Agents SDK](https://techcrunch.com/2025/03/11/openai-launches-new-tools-to-help-businesses-build-ai-agents/) will drive a proliferation of SaaS integrations and PoCs.
* In the first half of 2026, **A2A General Availability in [Microsoft Copilot Studio](https://www.microsoft.com/en-us/microsoft-copilot/microsoft-copilot-studio) and [Salesforce Agentforce](https://www.salesforce.com/jp/agentforce/), changing the landscape.**
* From the second half of 2026 onward, **cross-cloud requirements** will become prominent, and **A2A’s ability to seamlessly integrate with existing enterprise infrastructure, security, and governance capabilities** will give it the advantage.
* Based on the evidence, **the fastest to deliver cross-cloud A2A integration will be combination of Microsoft + SAP / Salesforce + Accenture / Deloitte / PwC**

Below, I’ll examine this A2A progress scenario in detail, drawing on concrete pieces of evidence.

![robots-at-a-table](/images/most-promising-scenario-for-a2a-progress/robots-at-table.png)

## Why Agent-to-Agent Communication Is Inevitable

* Many SaaS products are—or will be—replaced by “Agent as a Service.” Major SaaS vendors have already begun building agent layers.
* In the future, tasks currently performed by humans, such as accessing internal company data and using a SaaS accounting web application, will be completely handed off to an "Accounting Processing Agent."
* When a company needs to coordinate between Salesforce (CRM) and SAP (ERP), employees will simply delegate the job to their internal AI assistant (agent). That agent will then communicate with the Salesforce and SAP agents to get the work done.
* In such a world, Agent-to-Agent communication becomes essential. Enterprise governance is initially a high barrier, but **A2A significantly mitigates these challenges** (see below).

## Why A2A Will Not Evolve Community-Driven Like MCP

* With MCP, the minimum viable elements—open spec, a local MCP Server, and ready-to-use clients (e.g., Claude for Desktop, IDE plugins)—were available from day one, giving you instant payoff and fueling community adoption.
* A2A today lacks a generic A2A client and any GUI client that end users can directly interact with.
* Implementation is primarily focused on local A2A Servers, offering little advantage over MCP.
* In short, **without the “instant convenience” of a GUI client and a cloud-hosted generic server, community-driven growth is difficult.**

## Why Collaboration Among Microsoft, SAP, and Salesforce Is the Most Likely Path to A2A Adoption

* Realizing cross-company agent collaboration requires meeting enterprise governance needs—especially audit and responsibility demarcation—for cross-cloud scenarios.
* Based on the evidence, the Microsoft + SAP + Salesforce combination appears most likely to reach “production readiness,” so we’ll dive deeper around these three.

### Key Fact Checks: A2A-Related Moves by Microsoft, Salesforce, and SAP

| Aspect                          | Verified Primary Source                                                                                                                                                              | Notes                                                                                       |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------- |
| **Official Commitments**        | *Microsoft* announced that Copilot Studio/Azure AI Foundry will offer an A2A public preview “soon” and joined the A2A working group. [Microsoft](https://www.microsoft.com/en-us/microsoft-cloud/blog/2025/05/07/empowering-multi-agent-apps-with-the-open-agent2agent-a2a-protocol/) | Announcement date: 2025-05-07. Not yet GA.                                                  |
|                                 | *Salesforce* declared that “A2A is the standard to extend Agentforce to other ecosystems.” [Computerworld](https://www.computerworld.com/article/3981391/googles-ai-agent-protocol-is-becoming-the-language-for-digital-labor.html)            | Early Agentforce adopters (e.g., Disney, Kaiser) are public, but no A2A integration examples yet. |
|                                 | *SAP* stated that its Joule agent will be integrated with other platforms via A2A. [Google Developers Blog](https://developers.googleblog.com/en/a2a-a-new-era-of-agent-interoperability/)                                               | Joule has been in production since Q4 2024.                                                |
| **Two-Vendor Collaboration**    | Microsoft × SAP joint blog: Demoed calling Joule from Copilot for Microsoft 365 and vice versa at SAP Sapphire. [Microsoft Azure](https://azure.microsoft.com/es-es/blog/unlock-ai-innovation-with-new-joint-capabilities-from-microsoft-and-sap/) | Didn’t explicitly mention A2A, but showcased bidirectional agent calls.                    |
|                                 | Microsoft Learn docs: Guides mutual invocation between Copilot Studio agents and Salesforce Einstein Bot via Direct Line API (2024-11-19). [Microsoft Learn](https://learn.microsoft.com/en-us/microsoft-copilot-studio/customer-copilot-salesforce-handoff)              | Currently Bot Framework–based; expected to swap in A2A support.                             |
| **PoC Indications**             | Walt Disney, Kaiser Permanente, etc., named as early Agentforce adopters. [Investor's Business Daily](https://www.investors.com/news/technology/salesforce-stock-dreamforce-autonomous-ai-agents/)                                         |                                                                                             |
|                                 | Microsoft noted Fortune 500 companies are testing multi-agent collaboration in its Azure AI Foundry A2A early-access program. [Microsoft](https://www.microsoft.com/en-us/microsoft-cloud/blog/2025/05/07/empowering-multi-agent-apps-with-the-open-agent2agent-a2a-protocol/)            | These are single-vendor PoCs; no three-way case published.                                |

### PoC and Technical Stack Alignment in Progress

* Microsoft–SAP and Microsoft–Salesforce proofs of concept are already in motion.
* The Joule–Copilot demo can be extended by swapping in A2A under the hood.
* The Microsoft–Salesforce Bot Framework integration can transition by replacing endpoints once the A2A SDK goes GA.
* **We expect many “two-vendor + SIer” PoCs through 2025, leading to “cross-cloud ecosystem PoCs” surfacing around 2026.**

### Six Leading Global System Integrators / Consulting Firms

| SIer               | Microsoft Copilot / Azure AI Foundry                   | SAP Joule / BTP                                | Salesforce Agentforce                         | Proprietary Framework / PoC Trends                                                                                                                                         |
| ------------------ | ------------------------------------------------------ | ----------------------------------------------- | ---------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Accenture**      | Established a dedicated Copilot transformation practice | Demonstrated “Autonomous ERP” at SAP Sapphire 2025 | Announced an Agentforce + Gemini accelerator   | **AI Refinery**: Provides industry-specific “Agentization Kits.” [Source](https://news.microsoft.com/2024/11/14/accenture-microsoft-and-avanade-help-enterprises-reinvent-business-functions-and-industries-with-generative-ai-and-copilot/?utm_source=chatgpt.com) |
| **Deloitte**       | Expanded Copilot Studio/Power Platform team            | Officially added Joule adoption support to its roadmap | Strategic partnership with Salesforce; published industry Agentforce templates | Tech Trends 2025: Declared “Agent mass-production phase.” [Source](https://www2.deloitte.com/us/en/pages/about-deloitte/articles/press-releases/deloitte-expands-strategic-alliance-with-salesforce.html?utm_source=chatgpt.com)                 |
| **PwC**            | Collaborating with Microsoft on “Agents Factory,” large-scale Copilot rollouts | Offers Joule Studio assessment services        | Demonstrated multi-agent collaboration on its **agent OS** platform | Global Partner of the Year (“Building with AI”). [PwC](https://www.pwc.com/gx/en/news-room/press-releases/2025/pwc-and-microsoft-strategic-collaboration.html)                                                                    |
| **Capgemini**      | Support for Copilot/Dynamics CX & EX agent adoption    | Launch partner for SAP Business Data Cloud      | Official sponsor of Agentforce World Tour      | TechnoVision 2025: Featured “Agentic AI × Business Transformation.” [Capgemini](https://www.capgemini.com/gb-en/news/events/capgemini-at-agentforce-world-tour-2025/?utm_source=chatgpt.com)                                      |
| **Wipro**          | Combined Copilot + ServiceNow Now Assist for IT-Ops    | Driving SAP S/4HANA AI modernization projects   | Recognized Agentforce Partner Network member   | Industry-specific healthcare/finance agents via Lab45. [Wipro](https://www.wipro.com/about-us/awards-and-recognitions/2025/wipro-recognized-as-part-of-salesforces-agentforce-partner-network/?utm_source=chatgpt.com)               |
| **IBM Consulting** | Launched a Microsoft-focused Copilot practice          | Showcased RISE on IBM Cloud + Joule extension at SAP Sapphire | Jointly developing “Pre-built Agents” with Salesforce | Positions watsonx/Hybrid Integration as an “Agent Bus.” [IBM Newsroom](https://newsroom.ibm.com/2025-04-29-ibm-launches-microsoft-practice-to-deliver-transformative-business-value-for-clients?utm_source=chatgpt.com)                |

### Three-Stage Roadmap: Tools → Agents → Multi-Ecosystem

* Every SIer envisions: PoC within Copilot/Joule/Agentforce → cross-cloud integration with A2A → multi-ecosystem rollout.
* Accenture, Deloitte, and PwC, in particular, have **in-house “Agent Factory/Refinery” platforms** designed for multi-cloud deployment.

### Signals Toward PoC

* **Accenture**: Testing bidirectional workflows between Copilot and Joule with Disney, Mondelez, etc.
* **Deloitte**: Launched healthcare/public-sector digital labor pilots using Agentforce templates.
* **PwC**: Demonstrated Microsoft+SAP multi-agent collaboration on agent OS, verified connectivity with the A2A registry.

### Categorization Among SIers

* **“Agent Production Line” Leaders**: Accenture / Deloitte / PwC  
* **Strong in Business Apps & Data Platforms**: Capgemini / IBM  
* **Differentiation via Cost Efficiency & Offshore Development**: Wipro (+Infosys, TCS, etc.)

### Upcoming Events to Watch

| Timeframe | Highlights                                                                                                  |
| --------- | ----------------------------------------------------------------------------------------------------------- |
| 2025 Q3   | Dreamforce: Agentforce implementation sessions by Deloitte, Capgemini, and Wipro                           |
| 2025 Q4   | Microsoft Ignite: “Cross-Cloud Agent Mesh” demo by Accenture and PwC                                        |
| 2026 H1   | SAP Sapphire: Will IBM and Deloitte showcase a three-way Joule + Copilot + Agentforce PoC?                 |

### Summary of This Section

* The shortest path to multi-vendor agent collaboration across Microsoft, SAP, and Salesforce appears to lie with “production-line” SIers: Accenture, Deloitte, and PwC.
* Capgemini, Wipro, and IBM are also mass-producing PoCs with industry templates and hybrid platforms; by late 2025, cross-cloud PoCs are likely to surface.
* All SIers have begun adopting architectures built on A2A and the Task Lifecycle API. It’s reasonable to expect real commercial use cases that seamlessly hand off tasks between Copilot, Joule, and Agentforce in 2026.

## Why Are “Production-Line” SIers Such as Accenture / Deloitte / PwC Most Likely to Realize A2A Agent Collaboration First?

* For each global SI/consulting firm, we prioritized potential PoC candidates based on news releases, case studies, industry templates featuring specific companies, and major contracts that technically enable Microsoft-SAP-Salesforce collaboration.
* Whether these candidate companies are actually running official PoCs using A2A/A3A protocols has not been publicly disclosed—please read this as an informed hypothesis based on publicly available information.

| Global SI / Consulting Firm | Catch-Up & Core Products                                  | Strengths / Differentiation Points              | Recent Agent Collaborations / Announcements                 | High-Potential Candidate Companies for PoC (Evidence)                                                            |
| --------------------------- | ---------------------------------------------------------- | ----------------------------------------------- | ---------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| **Accenture**               | Azure AI Foundry / Copilot Studio + “Joule Rapid Sprint”    | Microsoft/SAP/Google triple alliance; 75,000+ AI professionals | Accelerating enterprise multi-agent rollouts with GenAI Studio + Delivery Factory | **Mondelez International**: Co-building a global AI marketing platform and deploying large-scale generative AI workflows ([Accenture Newsroom](https://newsroom.accenture.com/news/2024/mondelez-international-joins-forces-with-accenture-and-publicis-groupe-to-advance-ai-powered-marketing-capabilities)) |
| **Deloitte**                | ConvergeHEALTH / Vertical Agentforce Templates             | Industry IP (healthcare, public sector, finance) | Delivered healthcare/public sector Agentforce templates with Salesforce | **Kaiser Permanente**: Early Agentforce adopter, aligned with Deloitte’s healthcare expertise ([AInvest](https://www.ainvest.com/news/stifel-expects-salesforce-s-agentforce-to-unlock-multi-billion-dollar-ai-market-opportunity-24101010b35f47bc66b3fd53/)) |
| **PwC**                     | **agent OS** (MCP-compatible orchestration layer)           | 200+ internal AI agents; integrated risk & compliance governance | agent OS v1.1 natively supports Model Context Protocol   | **Wyndham Hotels & Resorts**: Production rollout of brand standards management and contact center agents with PwC and Agentforce/agent OS ([PwC Case Study](https://www.pwc.com/us/en/library/case-studies/wyndham-agentic-ai.html)) |
| **Capgemini**               | Azure Intelligent App Factory + Clean-Core for SAP         | SAP Joule × Copilot bidirectional integration IP; industry-specific RAG knowledge graphs | Launched SAP Joule agent + Microsoft Copilot integration acceleration program | **Eneco eMobility**: Revamped CX/call center with Dynamics 365 + Copilot, implemented by Capgemini ([Capgemini](https://www.capgemini.com/us-en/news/client-stories/eneco-emobility-supercharges-its-customer-care-with-generative-ai/?utm_source=chatgpt.com)) |
| **Wipro**                   | FullStride Cloud + “Agentforce Sector Agents”              | Industry LLMs via Lab45; Summit Partner for Microsoft & Salesforce | Released healthcare provider autonomous agents for Agentforce (2025/3) | **Phoenix Group**: £500m / 10-year digital BPO deal, planning Salesforce+SAP+Azure integration ([Wipro](https://www.wipro.com/newsroom/press-releases/2025/wipro-wins-a-pound500m-strategic-deal-with-uk-insurance-giant-phoenix-group/?utm_source=chatgpt.com)) |
| **IBM Consulting**          | RISE with SAP on IBM Power + watsonx                      | 90-day migration for SAP S/4HANA/Joule on PowerVS; integrated AI foundation models | Introduced watsonx-Joule PoC package in Q1 2025            | **AUDI AG**: Joint SAP S/4HANA rollout with IBM, exploring Joule/agent use next ([IBM Case Study](https://www.ibm.com/case-studies/audi)) |

### Primary Information Supporting “Public Calls for PoC Partners / SIers Publicly Announcing Roadmaps”

| Company        | Form of Call / Preview                                           | Primary Evidence (Key Points)                                                                                                                                                                                                                                      |
| -------------- | ---------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Google Cloud** | **Vertex AI Agent Builder**: “Start your proof of concept” button + “Contact Sales” flow for PoC sign-ups. A2A blog named 50+ partners including Accenture, Deloitte, Capgemini… developing production version by year-end. | PoC signup button and description ([Google Cloud](https://cloud.google.com/products/agent-builder)); partner list in A2A blog ([Google Developers Blog](https://developers.googleblog.com/en/a2a-a-new-era-of-agent-interoperability/)). |
| **Microsoft**    | **Copilot Studio Early Access Preview**: Limited-company testing of agent features. **Enterprise Agent Challenge**: Hackathon for enterprises to build agents in 2 weeks. | Early Access Preview details ([Microsoft](https://www.microsoft.com/en-us/microsoft-copilot/blog/copilot-studio/microsoft-copilot-studio-building-copilots-with-agent-capabilities/)); Enterprise Agent Challenge registration ([Microsoft](https://www.microsoft.com/en-us/microsoft-copilot/blog/copilot-studio/register-now-for-the-upcoming-copilot-studio-enterprise-agent-challenge/)). |
| **Salesforce**   | **Agentforce Partner Network / Dev & ISV Program**: Launch press release inviting partners to provide agents/actions + “Agentforce Partner Pocket Guide” in Partner Community for Slack/Community onboarding. | Partner Network announcement ([Salesforce](https://www.salesforce.com/news/press-releases/2024/09/12/agentforce-announcement/)); Pocket Guide onboarding flow ([Salesforce Cloud Mail](https://cloud.mail.salesforce.com/agentforcepartnerpocketguide?utm_source=chatgpt.com)). |
| **SAP**          | **Joule Early Adopter Care (EAC)**: SAP Community blog with registration links and deadlines for multiple products/modules. | Datasphere EAC signup; Sales Cloud EAC registration deadline ([SAP Community](https://community.sap.com/t5/technology-blog-posts-by-sap/become-an-early-adopter-for-joule-in-sap-datasphere/ba-p/14096474?utm_source=chatgpt.com), [SAP News Center](https://news.sap.com/2025/02/sap-sales-cloud-joule-intelligent-selling-now-available/?utm_source=chatgpt.com)). |
| **Accenture**    | **AI Refinery™ for Industry**: Declared that 12 industry agents are immediately available for PoC, expanding to 100+ by year-end. | “Rapidly build and deploy a network of AI agents… first 12 will be available… expand to 100+ by year-end.” ([Accenture Newsroom](https://newsroom.accenture.com/news/2025/accenture-launches-ai-refinery-for-industry-to-reinvent-processes-and-accelerate-agentic-ai-journeys?utm_source=chatgpt.com)). |
| **Deloitte**     | 1. **Agentforce Accelerator**: “Next events with limited seats—reserve your seat” demos in 3–4 cities. 2. **AI Labs 8-week PoC**: Invites companies to “design, test, and safely deploy generative AI in just 8 weeks.” | Demo signup buttons ([Deloitte](https://www.deloitte.com/ce/en/services/consulting/services/agentforce-accelerators.html)); 8-week AI Labs program details ([LivePerson](https://www.liveperson.com/resources/webinars/deloitte-ai-labs/)). |
| **PwC**          | 1. **Agent Powered Performance**: “Ready to see it in action? Connect with your PwC partner to schedule a discovery session.” 2. Press release with “Contact us” CTA. | LinkedIn post inviting demos ([LinkedIn](https://www.linkedin.com/posts/themza_new-excited-to-announce-pwcs-agent-powered-activity-7329113411093438464-wbsz)). |
| **Capgemini**    | **Intelligent App Factory / Agentic Gallery**: Press release stating enterprises will get access to a dedicated agentic gallery and rapid prototyping/deployment—inviting PoC participants. | Enterprise PoC invitation text ([Capgemini](https://www.capgemini.com/news/press-releases/capgemini-accelerates-enterprise-adoption-of-agentic-ai-for-industries-with-nvidia/)). |
| **Wipro**        | **Agentforce for Healthcare**: “Customers can now leverage Wipro’s deep expertise…” inviting healthcare PoC signups. | Healthcare PoC invitation text ([Wipro](https://www.wipro.com/newsroom/press-releases/2025/wipro-announces-ai-agent-solutions-across-the-healthcare-industry-powered-by-agentforce/)). |
| **IBM Consulting** | **watsonx Orchestrate Partner Program**: “We’re also launching a new program which will allow any IBM partner to build directly with watsonx Orchestrate.” | Official announcement. |

* All of Google, Microsoft, Salesforce, and SAP are recruiting PoC partners via early access, partner programs, hackathons, and EACs.
* Major SIers like Accenture explicitly outline roadmaps to deploy with customers first and then scale.
* All six SIers have publicly or semi-publicly invited PoC participation through accelerators, early access, hackathons, demo slots, and partner programs.
* These findings are based on primary sources (official websites, blogs, LinkedIn posts, press releases), giving them high credibility.
* Therefore, there is ample evidence to support the view that enterprises and SIers will lead the A2A/multi-agent wave.

## Why Will A2A’s Multi-Cloud Approach Gain the Advantage Once Cross-Cloud Requirements Emerge?

* First, compare A2A vs. competing protocols on time to reach practical production.
* Based on that, consider the scenario for reaching a “production” phase and A2A’s prospects.

| Evaluation Criteria                             | A2A (Google-led + Microsoft/Salesforce/SAP, etc.)                          | Amazon Bedrock Agents                                | OpenAI Agents SDK / Assistant-mesh                         | LangChain Agent Protocol                                    | Reference: MCP (Model Context Protocol)                  |
| ----------------------------------------------- | --------------------------------------------------------------------------- | ---------------------------------------------------- | ----------------------------------------------------------- | ---------------------------------------------------------- | -------------------------------------------------------- |
| **Scope**                                       | “Agent-to-Agent” coordination (Discovery / Task Lifecycle / Audit)         | Multi-agent collaboration within AWS Cloud           | Model-centric agents + orchestration around OpenAI LLMs     | Minimal API set for any LLM/framework                       | LLM ⇄ external tool invocation (single-function)        |
| **Specification Openness / Governance**         | Public draft + GitHub WG; multi-vendor specification development            | Not public (AWS docs only)                          | SDK under MIT license; protocol unpublished; OpenAI-dependent | Open source & OpenAPI definition; community-driven          | Open spec (JSON-RPC); planned IETF draft                |
| **Production Use Cases**                        | Copilot Studio ↔ Joule demos; Salesforce Agentforce PoCs (preview stage)    | AWS internal & select financial/retail pilots         | Box, Coinbase PoCs                                           | α operations in OSS PaaS (LangGraph Cloud)                 | Production in VS Code, Replit, Cursor                   |
| **Ecosystem Momentum**                          | GitHub a2a-directory: 276★ (growing)                                       | AWS Bedrock user base >100k (estimated)             | Agents SDK GitHub stars 4k+ in 2 months                      | LangGraph 12.8k★ (rapid growth)                            | MCP Server 40k★; many IDE integrations                  |
| **Enterprise Adoption Barriers**                | ☑ OAuth 2.1/JWT standards ☑ Task Audit API ✖ Lack of GUI clients              | ☑ AWS IAM integration ◎ Fully managed ✖ No cross-cloud support | ☑ Built-in OpenAI Auth ☑ Rich SDK ✖ Vendor lock-in           | ☑ Lightweight REST ☑ Cross-cloud ✖ Security guidelines unclear | ☑ Very simple ☑ Many GUIs/IDEs ✖ No multi-agent coordination |
| **2025 H2 → 2026 Roadmap**                      | v1 schema freeze → Microsoft GA → SIer deployments                         | GA + Bedrock Guardrails → AWS Marketplace            | Agents SDK GA → Assistant-to-Assistant API?                  | Agent Protocol v0.3 draft → OSS runtime integration        | IETF standardization → expanded A2A bridges             |

### Practical Phase Scenarios

1. **Short-term (~ through Q4 2025)**  
   * The fastest to commercialize is **AWS Bedrock Agents** (self-contained within AWS Cloud). AWS announced [“Strands Agents”](https://aws.amazon.com/blogs/opensource/introducing-strands-agents-an-open-source-ai-agents-sdk/) in May 2025 and will soon add A2A protocol support.  
   * The [OpenAI Agents SDK](https://techcrunch.com/2025/03/11/openai-launches-new-tools-to-help-businesses-build-ai-agents/) will drive a surge of SaaS integrations and PoCs, eliciting real-world developer feedback.

2. **Mid-term (2026 H1)**  
   * **A2A** will reach GA in Microsoft Copilot Studio and Salesforce Agentforce → first core-business PoCs will debut.  
   * The **LangChain Agent Protocol** will be embedded in OSS PaaS, aiming to become the “startup standard.”

3. **Long-term (2026 H2+)**  
   * **Cross-cloud requirements** (audit, responsibility demarcation, latency) will become critical → **A2A’s ability to seamlessly integrate with existing enterprise infrastructure and security/governance features** will prevail.

### A2A Could Establish an Advantage Through Cross-Cloud + Enterprise Infrastructure

* **A2A’s strengths** are its open specification and its ability to leverage existing enterprise security, monitoring, governance, and identity management frameworks—no one else has a comprehensive set of guidelines for audit and identity management.  
  * The protocol behaves as a standard HTTP-based enterprise application rather than introducing a new proprietary format, enabling enterprises to reuse their existing tools seamlessly.  
* However, its developer experience—being able to “get something up and running immediately”—is weaker, so AWS/OpenAI currently lead the developer ecosystem.  
* The decisive factor will be whether SIers can deliver enterprise-grade production use cases first.  
* If a Microsoft-SAP-Salesforce PoC goes GA in 2026 H1, the standardization phase could accelerate rapidly.  
* Ultimately, it’s a battle of **“AWS/OpenAI: closed and fast” vs. “A2A: open and heavyweight.”** A2A must showcase real production scenarios that only enterprises can provide—and that is precisely the scenario SIers are moving to execute now.

## Conclusion

Above is a concise summary (as concise as possible, but still quite lengthy…) of my exploration into A2A trends using ChatGPT. If there are any misunderstandings or unclear points, please feel free to comment 🙇‍♂️. If you found any of this helpful, I’d be delighted 😀

---

#### Note: What I Learned About Using AI for Research This Time

In the past, I used ChatGPT’s Deep Research to gather a wide range of information—including consulting reports—digest it, and create a report. While such reports are educational, I felt they often lacked a certain spark of novelty.

> It’s obvious if you think about it: feed too much information, and sharp insights get buried among common opinions. If you asked for “a compilation of cutting-edge viewpoints unique to specific sources,” you might see a different landscape.

This time, I began with the intuition that for AI Agents to become practical, we need to pursue feasibility across multiple companies. With that idea, I formulated hypotheses and used o3 to dive deep, relying on situational evidence as the primary basis. I think this resulted in a report that has a bit more of that spark of interest (I hope you think so too…).

That said, the key to leveraging AI is how you frame the question: when you ask questions anyone might think of, you often get a mundane answer. But o3 is surprisingly powerful: if you tell it to go into full brainstorming mode and think leaps ahead, it can offer remarkably interesting perspectives. It might be closer than you think to the level where you can just leave everything up to it…
