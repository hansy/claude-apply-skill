# Security Considerations

## Overview

This document outlines the security measures implemented in the Root Ventures Claude Apply Skill and known limitations.

## ✅ Security Measures Implemented

### 1. Input Sanitization
- **JSON Injection Protection**: All user inputs are passed to `jq` using `--arg` flags, which treats them as literal strings and properly escapes special characters
- **No eval/exec**: User input is never executed as code
- **Validation**: Required fields (name, email) are validated before processing

### 2. Secure Temporary Files
- **mktemp**: Uses `mktemp` to create secure temporary files with unpredictable names
- **Cleanup**: Trap ensures temporary files are deleted even on script failure
- **Permissions**: Temporary files inherit secure permissions from mktemp

### 3. HTTPS Downloads
- **Encrypted Transport**: All downloads use HTTPS to prevent man-in-the-middle attacks
- **GitHub Trust**: Files downloaded from GitHub's trusted CDN

### 4. Error Handling
- **set -e**: Script exits immediately on errors to prevent cascading failures
- **Graceful Degradation**: Clear error messages guide users when issues occur

### 5. Limited Scope
- **Read-Only Access**: Script only reads from user's home directory for skill files
- **Write-Only Webhook**: Attio webhook can only create records, not read existing data
- **No Persistent State**: No data stored locally after submission

## ⚠️ Known Limitations

### 1. Webhook URL Exposure
**Status**: Accepted Risk

**Description**: The Attio webhook URL is public in the GitHub repository.

**Why It's Acceptable**:
- Webhook is write-only (can't read existing data)
- Attio provides rate limiting
- Intended for public job applications
- No sensitive data exposure

**Mitigation**: Monitor Attio for spam applications, use webhook secret tokens if needed

### 2. No Download Verification
**Status**: Accepted Risk

**Description**: Downloaded files (skill.json, prompt.txt, apply.sh) are not cryptographically verified.

**Why It's Acceptable**:
- HTTPS provides transport security
- GitHub provides platform security
- Low-value target for attackers
- User can manually inspect files before running

**If You Want Extra Security**:
```bash
# Manually verify downloaded files
cd ~/.claude/skills/root-ventures-apply
cat apply.sh  # Review the script
cat prompt.txt  # Review the prompt
```

### 3. Single-User System Assumption
**Description**: Assumes user running the skill has appropriate permissions on their system.

**Mitigation**: Script only modifies user's home directory (`~/.claude/skills/`)

## 🔒 Data Flow

1. **User Input** → Claude CLI → apply.sh arguments
2. **apply.sh** → jq (sanitizes) → JSON payload
3. **JSON payload** → HTTPS POST → Attio webhook
4. **Attio** → Stores in your workspace

## 🛡️ Best Practices for Users

### Before Installing
1. **Review the code**: Check the GitHub repository
2. **Verify URL**: Ensure you're downloading from `github.com/rootvc/claude-apply-skill`
3. **Check HTTPS**: Browser should show secure connection

### After Installing
1. **Inspect files**: Review what was installed in `~/.claude/skills/root-ventures-apply/`
2. **Understand permissions**: The skill can read/write in your home directory
3. **Monitor submissions**: Check your Attio workspace for unexpected applications

## 🚨 Reporting Security Issues

If you discover a security vulnerability:

**DO NOT** open a public GitHub issue

**DO** email: security@root.vc with:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

We'll respond within 48 hours.

## 🔄 Security Updates

We monitor for:
- Dependency vulnerabilities (jq, curl, bash)
- GitHub security advisories
- Attio API changes

Updates will be pushed to the main branch and noted in commits.

## 📋 Security Checklist

- [x] Input sanitization (jq --arg)
- [x] Secure temporary files (mktemp)
- [x] HTTPS for downloads
- [x] Error handling (set -e)
- [x] No arbitrary code execution
- [x] Minimal file system access
- [x] Clear data flow
- [x] Documentation of risks
- [ ] Cryptographic verification (future enhancement)
- [ ] Webhook secret validation (future enhancement)

## 🔮 Future Enhancements

### Potential Security Improvements

1. **Checksum Verification**
   - Add SHA256 checksums for downloaded files
   - Verify before execution

2. **Webhook Secrets**
   - Add HMAC signature to webhook requests
   - Verify requests are from legitimate skill users

3. **Rate Limiting**
   - Client-side rate limiting to prevent abuse
   - Cooldown between submissions

4. **GPG Signatures**
   - Sign releases with GPG
   - Verify signatures during installation

## 📝 Compliance

### Data Handling
- **No PII Storage**: Application data goes directly to Attio, nothing stored locally
- **User Consent**: Users explicitly provide information through conversation
- **Data Minimization**: Only collects necessary fields

### GDPR Considerations
- Users provide data voluntarily
- Data goes to Attio (processor)
- Root Ventures (controller) has privacy policy
- Users can request deletion from Attio

---

**Last Updated**: January 27, 2026
**Security Contact**: security@root.vc
