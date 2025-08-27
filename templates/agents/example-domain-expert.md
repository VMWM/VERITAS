# Domain Expert: [Your Research Domain]

## Role Definition
- **Type**: Domain Expert Module
- **Activated By**: CLAUDE.md Constitution when research tasks detected
- **Purpose**: Provides [domain]-specific templates, grant expertise, and specialized knowledge
- **Authority**: Implements constitutional requirements for [your domain]

## Domain Configuration
- **Research Focus**: [Your specific research area]
- **Grant Target**: [Your grant type - NIH R01, NSF CAREER, F31, K99, etc.]
- **Timeline**: [Key milestones and deadlines]
- **Primary Database**: [PubMed, arXiv, ChemRxiv, etc.]

## Research Aims
**Aim 1:** [Your first research aim with specific objectives]

**Aim 2:** [Your second research aim with specific objectives]

**Aim 3:** [Your third research aim with specific objectives]

## Folder Structure
Specify your Obsidian vault organization:
- Research Questions: `Research Questions/[Title_Without_Question_Mark].md`
- Concepts: `Concepts/[Noun_Phrase].md`
- Literature: `Literature/[Author_Year].md`
- Daily Journal: `Daily/YYYY-MM-DD.md`

## Templates

### Research Question Template
**File naming**: Question without "?" (e.g., `How does X affect Y.md`)
**Location**: `[Your vault path]/Research Questions/`

**Template Structure:**

Front matter:
- tags: [research-question, your-domain, specific-topics]
- created: YYYY-MM-DD
- status: DRAFT | IN-PROGRESS | VERIFIED | NEEDS-UPDATE

Required sections:
1. **Direct Answer** - 2-3 narrative paragraphs with embedded citations
2. **Evidence-Based Key Points** - Major findings with citations
3. **Quantitative Impact** - Key statistics and metrics
4. **Knowledge Gaps** - What remains unknown
5. **Grant Writing Applications** - Significance, Innovation, Approach
6. **References** - Full citations with PMIDs
7. **Related Concepts** - Wiki links to concept pages

### Concept Note Template
**File naming**: Noun phrase (e.g., `Machine_Learning.md`, `Gene_Expression.md`)
**Location**: `[Your vault path]/Concepts/`

**Template Structure:**

Front matter:
- tags: [concept, primary-topic, secondary-topics]
- created: YYYY-MM-DD
- status: DRAFT | VALIDATED | NEEDS-UPDATE
- aliases: ["Alternative Name 1", "Alternative Name 2"]

Required sections:
1. **Concept Name** (main heading)
2. **Overview** - 2-3 sentences with quantitative context
3. **Key Innovation/Mechanism** - Core technical details
4. **Applications** - How it's used in your field
5. **Current Understanding** - State of the art with citations
6. **Technical Details** - Specifications, protocols, methods
7. **Validation Data** - Supporting evidence with PMIDs
8. **Research Integration** - How concept supports your aims
9. **Related Concepts** - Wiki links to related pages
10. **Key References** - Primary papers with PMIDs

### Daily Journal Template
**File path**: `[Your journal vault]/Daily/YYYY-MM-DD.md`
**Use system date**: `date +"%Y-%m-%d"`

**Template Structure:**

Front matter:
- date: YYYY-MM-DD
- tags: [daily-log, your-project]

Sections:
1. **Daily Research Log: [Date]**
2. **Session Summary** - Focus, duration, key achievement
3. **Technical Work** - What you implemented/analyzed
4. **Research Insights** - Key findings and implications
5. **Problems Solved** - Issues encountered and solutions
6. **Metrics** - Papers reviewed, notes created, experiments run
7. **Next Actions** - Tomorrow's priorities
8. **References** - Papers and resources used today

## Domain-Specific Rules
[Add any special requirements for your field]
- Example: "All protein names must use standard nomenclature"
- Example: "Include ClinicalTrials.gov IDs for clinical studies"
- Example: "Use HUGO gene symbols for genetic variants"

## Verification Requirements
[Specific to your domain]
- Required databases: [PubMed, specific repositories]
- Minimum evidence level: [RCT, meta-analysis, etc.]
- Statistical thresholds: [p-values, confidence intervals]

## Key Resources
- Primary literature database: [URL]
- Domain-specific tools: [List]
- Standard references: [Textbooks, guidelines]
- Professional organizations: [Relevant societies]

## Notes
- Update this file as your research evolves
- Maintain consistency with CLAUDE.md Constitution
- All templates must follow Article 5 formatting laws