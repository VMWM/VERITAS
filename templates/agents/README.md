# Creating Your Domain Expert

## What is a Domain Expert?

A domain expert file is your specialized knowledge module that works with the VERITAS Constitution (CLAUDE.md) to provide domain-specific templates, workflows, and expertise.

Think of it as:
- **Constitution** = Universal rules (same for everyone)
- **Domain Expert** = Your specific research knowledge

## Quick Start

1. **Copy the template**:
   ```bash
   cp example-domain-expert.md ~/.claude/agents/[your-domain]-expert.md
   ```

2. **Edit your domain expert** to include:
   - Your research aims
   - Your grant type (NIH R01, NSF CAREER, etc.)
   - Your field-specific templates
   - Your folder organization

3. **Update CLAUDE.md** Article 2 to reference your file:
   ```markdown
   2. Read `.claude/agents/[your-domain]-expert.md` for domain-specific templates
   ```

## Essential Sections

### 1. Role Definition (Required)
```markdown
## Role Definition
- **Type**: Domain Expert Module
- **Activated By**: CLAUDE.md Constitution when research tasks detected
- **Purpose**: [Your specific purpose]
- **Authority**: Implements constitutional requirements for [your domain]
```

### 2. Domain Configuration (Required)
```markdown
## Domain Configuration
- **Research Focus**: [Your specific area]
- **Grant Target**: [NIH R01, NSF, DoD, etc.]
- **Timeline**: [Your milestones]
- **Primary Database**: [PubMed, arXiv, etc.]
```

### 3. Research Aims (Required)
Your specific research objectives. These guide how VERITAS helps you.

### 4. Templates (Required)
At minimum, include:
- Research Question template
- Concept Note template
- Daily Journal template

## Examples by Domain

### Neuroscience Researcher
```markdown
# Domain Expert: Neuroscience Research Director

## Domain Configuration
- **Research Focus**: Synaptic plasticity in Alzheimer's disease
- **Grant Target**: NIH R01
- **Timeline**: Submission March 2026
- **Primary Database**: PubMed

## Research Aims
**Aim 1:** Characterize tau-induced synaptic dysfunction...
**Aim 2:** Test therapeutic interventions...
```

### Computer Science Researcher
```markdown
# Domain Expert: Machine Learning Research Expert

## Domain Configuration
- **Research Focus**: Explainable AI for healthcare
- **Grant Target**: NSF CAREER Award
- **Timeline**: Submission July 2025
- **Primary Database**: arXiv, ACM Digital Library

## Research Aims
**Aim 1:** Develop interpretable neural architectures...
**Aim 2:** Validate in clinical decision support...
```

### Climate Science Researcher
```markdown
# Domain Expert: Climate Modeling Expert

## Domain Configuration
- **Research Focus**: Regional climate predictions
- **Grant Target**: NSF Climate Dynamics
- **Timeline**: LOI January 2026
- **Primary Database**: AGU Publications, NOAA datasets

## Research Aims
**Aim 1:** Improve regional precipitation models...
**Aim 2:** Validate against historical data...
```

## Domain-Specific Rules

Add any special requirements for your field:

### For Medical Research
```markdown
## Domain-Specific Rules
- All human subjects research requires IRB approval numbers
- Clinical trials must include ClinicalTrials.gov IDs
- Use ICD-10 codes for diagnoses
```

### For Genomics Research
```markdown
## Domain-Specific Rules
- Use HUGO gene nomenclature
- Include GenBank accession numbers
- Follow MIAME standards for microarray data
```

### For Engineering Research
```markdown
## Domain-Specific Rules
- Include patent numbers where applicable
- Use SI units consistently
- Follow IEEE citation format
```

## File Organization

Your domain expert should specify your Obsidian vault structure:

```markdown
## Folder Structure
- Research Questions: `Research/Questions/[Topic]/[Question].md`
- Literature: `Literature/[Year]/[FirstAuthor].md`
- Experiments: `Experiments/[Date]/[Protocol].md`
- Analysis: `Analysis/[Dataset]/[Method].md`
```

## Testing Your Domain Expert

After creating your domain expert:

1. **Test research question creation**:
   ```
   "Create a research question about [your topic]"
   ```

2. **Test concept creation**:
   ```
   "Create a concept note for [key concept in your field]"
   ```

3. **Test journal entry**:
   ```
   "Create today's journal entry"
   ```

## Common Mistakes to Avoid

1. **Don't modify CLAUDE.md** - Keep it as the universal constitution
2. **Don't skip required sections** - Role Definition and Configuration are mandatory
3. **Don't forget your templates** - At least include the three basic templates
4. **Don't hardcode paths** - Use relative paths or variables

## Need Help?

- Review `example-domain-expert.md` for the complete structure
- Check existing implementations in the community
- Open an issue on GitHub with questions

## Sharing Your Domain Expert

Consider sharing your domain expert with the community:
1. Remove any personal information
2. Generalize paths and specific project details
3. Submit a PR to add it to `templates/agents/community/`

This helps other researchers in your field get started quickly!