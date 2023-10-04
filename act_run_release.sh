# Sanity check
echo "🧪🧪🧪 Sanity Check 🧪🧪🧪"
act --list
# Not running this in ACT as this is causing an error
if [ "$ACT" = false ]; then
    act --dryrun
fi

# Testing triggers
echo "🧪🧪🧪 Testing Triggers 🧪🧪🧪"
echo "Github user var: ${GITHUB_USER}"
echo "❓ Check if version is set"
RESULT=$(act push --workflows .github/workflows/release.yml --actor $GITHUB_USER --eventpath .github/workflows/act/event-release.json  2>&1)
# This test should not return an error
if [[ ${RESULT,,} == *"failure"* ]]; then
  echo "❌ Release workflow: The run failed"
  echo -e "Result of run: \n ${RESULT}"
else
  echo "✅ Release workflow"
fi

echo "❓ Check if we catch no versions set"
RESULT=$(act push --workflows .github/workflows/release.yml --actor $GITHUB_USER --eventpath .github/workflows/act/event-release-error.json  2>&1)
# This should fail
if [[ ${RESULT,,} == *"Error"* || ${RESULT,,} == *"failure"*  ]]; then
  echo "✅ Release workflow successfully failed"
else
  echo "❌ Release workflow: The did not fail"
  echo -e "Result of run: \n ${RESULT}"
fi
