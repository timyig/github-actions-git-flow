# Sanity check
echo "🧪🧪🧪 Sanity Check 🧪🧪🧪"
act --list
# Not running this in ACT as this is causing an error
if [ "$ACT" = false ]; then
    act --dryrun
fi

act --workflows .github/workflows/release.yml --actor $GITHUB_USER

# Testing triggers
echo "🧪🧪🧪 Testing Triggers 🧪🧪🧪"
echo "This should not trigger the workflow"
echo "Github user var: ${GITHUB_USER}"
act pull_request --workflows .github/workflows/release.yml --actor $GITHUB_USER --eventpath .github/workflows/act/event-release.json
echo "This should trigger the workflow"
act push --workflows .github/workflows/release.yml --actor $GITHUB_USER --eventpath .github/workflows/act/event-release.json
