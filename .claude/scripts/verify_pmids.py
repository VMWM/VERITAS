#!/usr/bin/env python3
"""
PMID Verification Script for VERITAS Research Constitution
Ensures all PMIDs in documents match the actual cited papers
"""

import re
import sys
import json
import requests
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Tuple
import os

class PMIDVerifier:
    def __init__(self):
        self.base_url = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils"
        
        # Find .claude directory - check current dir, parent dirs, or use env variable
        claude_dir = self._find_claude_dir()
        self.log_file = claude_dir / "logs" / "pmid_verification.log"
        self.log_file.parent.mkdir(parents=True, exist_ok=True)
        self.errors = []
    
    def _find_claude_dir(self) -> Path:
        """Find the .claude directory in current or parent directories"""
        # Check environment variable first
        if os.environ.get('VERITAS_ROOT'):
            return Path(os.environ['VERITAS_ROOT']) / '.claude'
        
        # Check current directory and parents for .claude
        current = Path.cwd()
        while current != current.parent:
            claude_path = current / '.claude'
            if claude_path.exists():
                return claude_path
            current = current.parent
        
        # Default to current directory
        default_path = Path.cwd() / '.claude'
        default_path.mkdir(parents=True, exist_ok=True)
        return default_path
        
    def extract_citations(self, text: str) -> List[Tuple[str, str, str]]:
        """Extract all citations with format (Author et al., Year, PMID: XXXXXXXX)"""
        # Match both "et al." and single author citations in one pattern
        pattern = r'\(([^,]+?)(?:\s+et\s+al\.)?,\s+(\d{4}),\s+PMID:\s+(\d+)\)'
        citations = re.findall(pattern, text)
        
        # Remove duplicates while preserving order
        seen = set()
        unique_citations = []
        for citation in citations:
            if citation not in seen:
                seen.add(citation)
                unique_citations.append(citation)
        
        return unique_citations
    
    def fetch_pmid_data(self, pmid: str) -> Dict:
        """Fetch paper data from PubMed"""
        try:
            # Fetch summary
            url = f"{self.base_url}/esummary.fcgi"
            params = {
                'db': 'pubmed',
                'id': pmid,
                'retmode': 'json'
            }
            response = requests.get(url, params=params, timeout=10)
            data = response.json()
            
            if 'result' in data and pmid in data['result']:
                return data['result'][pmid]
            return None
        except Exception as e:
            self.log_error(f"Failed to fetch PMID {pmid}: {str(e)}")
            return None
    
    def verify_citation(self, author: str, year: str, pmid: str) -> bool:
        """Verify that PMID matches the cited author and year"""
        data = self.fetch_pmid_data(pmid)
        
        if not data:
            self.errors.append(f"PMID {pmid} not found in PubMed")
            return False
        
        # Extract first author from PubMed data
        authors = data.get('authors', [])
        if not authors:
            self.errors.append(f"PMID {pmid}: No authors found")
            return False
        
        first_author = authors[0].get('name', '').split()[0] if authors else ""
        pub_year = data.get('pubdate', '').split()[0]
        title = data.get('title', '')
        
        # Verify author matches (case-insensitive, partial match)
        author_clean = author.strip().lower()
        first_author_clean = first_author.lower()
        
        if author_clean not in first_author_clean and first_author_clean not in author_clean:
            self.errors.append(
                f"PMID {pmid}: Author mismatch\n"
                f"  Cited: {author} et al., {year}\n"
                f"  Actual: {first_author} et al., {pub_year}\n"
                f"  Title: {title}"
            )
            return False
        
        # Verify year matches
        if year != pub_year:
            self.errors.append(
                f"PMID {pmid}: Year mismatch\n"
                f"  Cited: {author} et al., {year}\n"
                f"  Actual: {first_author} et al., {pub_year}\n"
                f"  Title: {title}"
            )
            return False
        
        return True
    
    def verify_file(self, filepath: Path) -> bool:
        """Verify all PMIDs in a file"""
        try:
            with open(filepath, 'r') as f:
                content = f.read()
            
            citations = self.extract_citations(content)
            
            if not citations:
                print(f"No citations found in {filepath}")
                return True
            
            print(f"Verifying {len(citations)} citations in {filepath}...")
            
            all_valid = True
            for author, year, pmid in citations:
                if not self.verify_citation(author, year, pmid):
                    all_valid = False
                    print(f"  ✗ {author} et al., {year}, PMID: {pmid} - MISMATCH")
                else:
                    print(f"  ✓ {author} et al., {year}, PMID: {pmid} - verified")
            
            # Log results
            self.log_verification(filepath, citations, all_valid)
            
            return all_valid
            
        except Exception as e:
            self.log_error(f"Failed to verify {filepath}: {str(e)}")
            return False
    
    def log_verification(self, filepath: Path, citations: List, success: bool):
        """Log verification results"""
        with open(self.log_file, 'a') as f:
            f.write(f"\n{'='*60}\n")
            f.write(f"Verification at {datetime.now().isoformat()}\n")
            f.write(f"File: {filepath}\n")
            f.write(f"Citations verified: {len(citations)}\n")
            f.write(f"Status: {'SUCCESS' if success else 'FAILED'}\n")
            if self.errors:
                f.write("Errors:\n")
                for error in self.errors:
                    f.write(f"  - {error}\n")
    
    def log_error(self, message: str):
        """Log an error message"""
        self.errors.append(message)
        with open(self.log_file, 'a') as f:
            f.write(f"ERROR [{datetime.now().isoformat()}]: {message}\n")

def main():
    if len(sys.argv) < 2:
        print("Usage: python verify_pmids.py <file_path>")
        print("\nOptional: Set VERITAS_ROOT environment variable to specify project root")
        sys.exit(1)
    
    filepath = Path(sys.argv[1])
    
    if not filepath.exists():
        print(f"Error: File {filepath} does not exist")
        sys.exit(1)
    
    verifier = PMIDVerifier()
    success = verifier.verify_file(filepath)
    
    if not success:
        print("\n⚠️  VERIFICATION FAILED")
        print("Errors found:")
        for error in verifier.errors:
            print(f"  {error}")
        sys.exit(1)
    else:
        print("\n✓ All citations verified successfully")

if __name__ == "__main__":
    main()