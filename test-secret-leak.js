// TEMPORARY TEST FILE — deliberately committed to validate the secrets-scan
// job and the report-ci-failure ticketing pipeline end to end.
// Revert/delete this before merging anything real.
//
// Second attempt used a fabricated-but-well-formed AWS key — GitHub's own
// native Push Protection (a separate layer from our gitleaks CI job)
// blocked that push server-side before it even reached the repo. This
// value instead matches gitleaks' generic "generic-api-key" fallback rule
// (keyword + separator + high-entropy value), which isn't one of GitHub
// Push Protection's provider-specific patterns — it should reach the repo
// and only get caught by our own CI job.

const API_SECRET_TOKEN = "7f9a2c4e8b1d6f3a0c5e9b2d7f4a1c8e6b3d9f2a5c7e0b4d8f1a6c3e9b2d7f4a";

module.exports = { API_SECRET_TOKEN };
