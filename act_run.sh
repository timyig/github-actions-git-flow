# Sanity check
echo "🧪🧪🧪 Sanity Check 🧪🧪🧪"
act --list
act --dryrun
act --workflows .github/workflows/dev-pr.yml --actor timyig

# Testing triggers
echo "🧪🧪🧪 Testing Triggers 🧪🧪🧪"
echo "This should not trigger the workflow"
act release --workflows .github/workflows/dev-pr.yml --actor timyig
echo "This should trigger the workflow"
act pull_request --workflows .github/workflows/dev-pr.yml --actor timyig
