# Sanity check
echo "🧪🧪🧪 Sanity Check 🧪🧪🧪"
act --list
# Not running this in ACT as this is causing an error
if [$ACT = false] ; then
    act --dryrun
fi
act --dryrun
act --workflows .github/workflows/dev-pr.yml --actor timyig

# Testing triggers
echo "🧪🧪🧪 Testing Triggers 🧪🧪🧪"
echo "This should not trigger the workflow"
act release --workflows .github/workflows/dev-pr.yml --actor timyig
echo "This should trigger the workflow"
act pull_request --workflows .github/workflows/dev-pr.yml --actor timyig
act pull_request --workflows .github/workflows/dev-pr.yml --actor timyig --eventpath .github/workflows/act/event-dev-pr.json
