# VERITAS Tests

Test scripts for validating VERITAS installation and functionality.

## Test Scripts

### veritas-test.sh
- **Purpose**: Comprehensive system validation
- **Coverage**: 
  - Hook installation and permissions
  - CLAUDE.md presence and enforcement
  - MCP server connectivity
  - Directory structure validation
  - Configuration file integrity
- **Usage**: Run after installation to verify setup
- **Location**: Gets copied to `$PROJECT/.claude/scripts/` during setup

### verify-installation.sh
- **Purpose**: Quick installation verification
- **Coverage**:
  - Essential file presence
  - Directory structure
  - Basic configuration checks
  - MCP server setup validation
- **Usage**: Run from VERITAS directory to check installation
- **Location**: Remains in VERITAS/tests for global use

## Running Tests

### For New Installations
```bash
cd /path/to/your/project
.claude/scripts/veritas-test.sh
```

### For VERITAS Repository Validation
```bash
cd /path/to/VERITAS
./tests/verify-installation.sh
```

## Test Output

- **Green [OK]**: Component passed validation
- **Yellow [WARNING]**: Non-critical issue detected
- **Red [ERROR]**: Critical failure requiring attention

Test results are logged to:
- Project tests: `$PROJECT/.claude/logs/`
- Repository tests: Console output only

---
Last Updated: 2025-08-27