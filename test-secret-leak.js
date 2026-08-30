// TEMPORARY TEST FILE — deliberately committed to validate the secrets-scan
// job and the report-ci-failure ticketing pipeline end to end.
// Revert/delete this before merging anything real.
//
// The values below are AWS's own well-known public example credentials
// (used throughout AWS's official documentation) — not a real secret, but
// they match the exact pattern gitleaks' default ruleset detects.

const AWS_ACCESS_KEY_ID = "AKIAIOSFODNN7EXAMPLE";
const AWS_SECRET_ACCESS_KEY = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY";

module.exports = { AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY };
