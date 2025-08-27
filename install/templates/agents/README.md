# Domain Expert Templates

Domain expert files configure VERITAS for specific research fields. They define templates, citation requirements, and workflows tailored to your domain.

## Currently Included Templates

### Medical Research
- **File**: `hla-research-director.md`
- **Focus**: HLA antibody testing, transplant immunology
- **Citation**: PMID-based from PubMed
- **Grant Type**: NIH F31 NRSA
- **Templates**: Research questions, concept notes, daily journals with clinical focus

## Creating Your Own Domain Expert

To adapt VERITAS for your field:

1. **Copy the template**:
   ```bash
   cp hla-research-director.md [your-domain]-expert.md
   ```

2. **Modify key sections**:

   ### Role Definition
   - Update the purpose for your field
   - Adjust authority and expertise areas

   ### Domain Configuration
   - **Research Focus**: Your specific area
   - **Grant Target**: Your funding source (NSF, DoD, etc.)
   - **Primary Database**: arXiv, IEEE, ACM, etc.
   - **Citation Format**: DOI, arXiv ID, etc.

   ### Research Aims
   - Replace with your research goals
   - Align with your grant requirements

   ### Templates
   - Adjust research question format
   - Modify concept note structure
   - Customize journal entries

3. **Update citation requirements**:
   - For software: Use DOI or repository links
   - For social sciences: APA/MLA format
   - For engineering: IEEE citations

4. **Reference in your project**:
   - Copy to `.claude/agents/` in your project
   - Update CLAUDE.md Article 2 to reference your file

## Example Adaptations

### Software Development
```markdown
## Domain Configuration
- **Research Focus**: Open source security tools
- **Primary Database**: GitHub, CVE database
- **Citation Format**: Repository URL, commit hash
- **Verification**: Code review, security audit trails
```

### Social Sciences
```markdown
## Domain Configuration
- **Research Focus**: Qualitative research methods
- **Primary Database**: Google Scholar, JSTOR
- **Citation Format**: APA 7th edition
- **Verification**: Peer review status, impact factor
```

### Engineering
```markdown
## Domain Configuration
- **Research Focus**: Materials science
- **Primary Database**: IEEE Xplore, Patents
- **Citation Format**: DOI, Patent numbers
- **Verification**: Experimental validation data
```

## Best Practices

1. **Keep constitutional rules**: Don't modify Articles 1-8
2. **Adapt verification levels**: Define what counts as "verified" in your field
3. **Maintain structure**: Keep the same section headings for consistency
4. **Test thoroughly**: Verify templates work with your workflow

## Contributing

If you create a well-tested domain expert template, consider contributing it back to VERITAS via pull request to help others in your field.