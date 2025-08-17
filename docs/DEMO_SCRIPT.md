# Lab Presentation Demo Script

## 12-Minute Live Demo for Lab Meeting

### Pre-Demo Setup (Do Before Presentation)
1. Open VS Code in any project folder
2. Have Obsidian running with both vaults open
3. Clear previous test notes if needed
4. Have this script open on second monitor/iPad

---

## Demo Flow

### 1. Introduction (1 minute)

**Say:**
"I want to show you a research system I've built that transforms how we do literature reviews and manage HLA knowledge. This isn't ChatGPT - it's a specialized HLA research assistant that accesses our actual files and creates real notes."

**Show:**
- VS Code open
- Point to normal project folder (not MCP-specific)

---

### 2. Show the Setup (2 minutes)

**Say:**
"The system works from any folder on any of my machines. Watch how simple this is."

**Do:**
```bash
claude
```

**Say:**
"Now let me show you what's connected."

**Do:**
```bash
/mcp
```

**Show on screen:**
```
Connected MCP servers:
✓ memory (persistent templates and context)
✓ pubmed (medical literature with PMIDs)
✓ obsidian-rest (note creation)
✓ obsidian-file (backup access)
✓ sequential-thinking (complex reasoning)
```

**Say:**
"Each of these servers gives Claude special abilities. Memory means it remembers everything between sessions. PubMed means real citations. Obsidian means it creates actual notes."

---

### 3. Simple Literature Search (3 minutes)

**Say:**
"Let's start with a real question we might have in clinic."

**Do:**
```bash
/agent "What percentage of pediatric kidney recipients develop dnDSA within 5 years?"
```

**While it runs, say:**
"Watch what's happening - it's searching our lecture PDFs, querying PubMed, and extracting real statistics."

**Point out as it appears:**
- "See it found our specialist handouts"
- "Now it's querying PubMed with proper MeSH terms"
- "It's extracting actual numbers from studies"

**When complete, show:**
- Open Obsidian
- Navigate to HLA Antibodies/Research Questions/
- Show the created note with table of studies and PMIDs

**Say:**
"In 2 minutes, it reviewed 20+ papers, extracted statistics, and created this comprehensive note with verified citations. Doing this manually would take me 2-3 hours."

---

### 4. Knowledge Base Search (2 minutes)

**Say:**
"But here's what makes this special - it knows OUR knowledge. Let me search our professor's materials."

**Do:**
```bash
/agent "What does LG say about prozone effect in highly sensitized patients?"
```

**While running:**
"It's searching through all of Professor LG's PDFs, meeting notes, and presentations."

**Show results:**
- Point out quotes from actual lecture slides
- Show how it found specific protocols we use
- Highlight that it compared with published literature

**Say:**
"This found information from 3 different lectures plus our lab protocols, then compared it with current literature. Try doing that with ChatGPT."

---

### 5. Complex Pattern Analysis (3 minutes)

**Say:**
"Let's try something really complex that would normally take a full day."

**Do:**
```bash
/agent "Compare SAB interpretation patterns between One Lambda and Immucor platforms"
```

**While running, explain:**
"This is analyzing technical differences between two testing platforms. It's looking at:
- Our validation data
- Vendor documentation  
- Published comparisons
- Creating a decision matrix"

**When done:**
- Show the comprehensive comparison table
- Point out the concept pages it created
- Show the cross-linking between pages

**Say:**
"Notice it didn't just answer the question - it built a knowledge network. Every [[linked concept]] is now a clickable page with its own information."

---

### 6. Show the Knowledge Graph (1 minute)

**In Obsidian:**
- Open graph view
- Show the interconnected concepts
- Zoom in on HLA Antibodies cluster

**Say:**
"Every query adds to this growing knowledge graph. After 2 weeks of use, I have 200+ interconnected concept pages. It's like having a personalized HLA Wikipedia that grows with my research."

---

### 7. Daily Workflow Integration (1 minute)

**Say:**
"This also handles daily documentation."

**Do:**
```bash
"Create today's research journal entry focusing on virtual crossmatching validation"
```

**Show:**
- Quick creation of formatted daily note
- Automatic date, sections, formatting
- Links to relevant concepts

---

### 8. Key Differentiators (1 minute)

**Say while showing slide or writing:**

"This is fundamentally different from ChatGPT:
- It reads YOUR files, not just general internet
- PubMed citations are REAL with verified PMIDs
- Memory persists forever, not just one conversation
- Creates actual files in Obsidian, not just chat
- Syncs across all machines automatically
- Costs $20/month for unlimited use"

---

## Q&A Preparation

### Anticipated Questions

**Q: How long did this take to set up?**
A: "30 minutes initial setup, then it just works. I have setup scripts that make it even faster for you - about 15 minutes."

**Q: Is this secure/private?**
A: "Everything stays local. Only API calls go out. Your files never leave your machine."

**Q: Can we share configurations?**
A: "Yes! I can give you my exact setup. You just add your own API keys."

**Q: What about errors/hallucinations?**
A: "PubMed integration prevents fake citations. The system only claims what it can verify."

**Q: Can it write papers/grants?**
A: "It can help synthesize literature and organize knowledge. Writing is still your job, but research is 10x faster."

---

## Backup Demos (If Time or If Asked)

### A. Error Detection
```bash
/agent "Find contradictions in MFI threshold recommendations"
```
Shows how it identifies conflicting guidelines

### B. Trend Analysis  
```bash
/agent "How have DSA monitoring protocols changed from 2015 to 2024?"
```
Demonstrates temporal analysis capabilities

### C. Protocol Development
```bash
/agent "Create SOP for prozone effect detection based on best practices"
```
Shows practical protocol generation

---

## Closing (30 seconds)

**Say:**
"I've been using this for 2 weeks and it's transformed my research workflow. Literature reviews that took 6 hours now take 10 minutes. Everything is verified, linked, and searchable.

I have a GitHub repository with everything you need to set this up. It takes 15 minutes and costs about $20/month. Who wants to try it?"

**Show:**
GitHub URL: https://github.com/VMWM/HLA_Agent-MCP_System

---

## Technical Troubleshooting During Demo

If MCP disconnects:
```bash
exit
claude
```

If Obsidian file doesn't appear:
- Check Obsidian is running
- Manually refresh Obsidian vault
- Explain it's using backup file system mode

If PubMed times out:
- Explain rate limiting
- Show it continues with local files
- Results still valuable

---

## Post-Demo Follow-up

**Offer:**
1. Send GitHub link
2. Schedule 30-min 1:1 setup sessions
3. Create lab-specific agents
4. Share your configuration file

**Materials to Distribute:**
- GitHub repository URL
- One-page setup guide
- Example outputs
- Cost-benefit analysis

---

*Remember: Focus on time savings and accuracy. These are busy researchers who want efficiency, not technical details.*