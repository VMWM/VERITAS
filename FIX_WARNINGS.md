# Fix Test Warnings - Quick Guide

## Summary of Fixes

All 4 warnings from your test can be fixed with these steps:

### Warning 1: Obsidian REST API (HLA Vault) Not Responding

**Root Cause**: Missing API token for HLA vault authentication

**Fix**:
1. Open Obsidian HLA Antibodies vault
2. Go to Settings → Community Plugins → Local REST API
3. Click the settings icon for Local REST API
4. Copy the API Key shown
5. Save it to your system:
   ```bash
   echo 'YOUR_HLA_TOKEN_HERE' > ~/.obsidian_api_token_hla
   ```

### Warning 2: Obsidian REST API (Journal Vault) Not Responding

**Root Cause**: Missing API token for Journal vault authentication

**Fix**:
1. Open Obsidian Research Journal vault
2. Go to Settings → Community Plugins → Local REST API
3. Click the settings icon for Local REST API
4. Copy the API Key shown
5. Save it to your system:
   ```bash
   echo 'YOUR_JOURNAL_TOKEN_HERE' > ~/.obsidian_api_token_journal
   ```

### Warning 3: CLAUDE_PROJECT_DIR Not Set

**Status**: FIXED - The setup-env.sh script now sets this

### Warning 4: OBSIDIAN_API_TOKEN Not Set

**Status**: Now handles TWO tokens (one for each vault)

## Complete Fix Process

Run these commands in order:

```bash
# 1. Get your HLA vault token from Obsidian (see instructions above)
# 2. Save the HLA token (replace with your actual token)
echo 'YOUR_HLA_TOKEN_HERE' > ~/.obsidian_api_token_hla

# 3. Get your Journal vault token from Obsidian
# 4. Save the Journal token (replace with your actual token)
echo 'YOUR_JOURNAL_TOKEN_HERE' > ~/.obsidian_api_token_journal

# 5. Source the environment setup (loads both tokens)
source /Users/vmwm/VERITAS/setup-env.sh

# 6. Run the test again
cd /Users/vmwm/VERITAS/tests
./veritas-test.sh
```

## Expected Results After Fix

You should see:
- CLAUDE_PROJECT_DIR is set ✓
- OBSIDIAN_API_TOKEN is set ✓
- Obsidian REST API (main vault) responding and authenticated ✓
- Obsidian REST API (journal vault) responding and authenticated ✓

All 4 warnings will be resolved!

## Make It Permanent (Optional)

Add to your shell profile (`~/.zshrc` or `~/.bash_profile`):

```bash
# VERITAS Environment
export CLAUDE_PROJECT_DIR="/Users/vmwm/Library/CloudStorage/Box-Box/VM_F31_2025"
[ -f ~/.obsidian_api_token ] && export OBSIDIAN_API_TOKEN=$(cat ~/.obsidian_api_token)
```

Then reload:
```bash
source ~/.zshrc  # or source ~/.bash_profile
```