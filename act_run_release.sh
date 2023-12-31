#!/bin/bash
# Test script for this worklfow:
# .github/workflows/release.yml
# when running this localy by triggering the workflow run this command:
# act -W .github/workflows/act.yml --actor $GITHUB_USER --secret GITHUB_TOKEN=${GITHUB_TOKEN}
# act push --workflows .github/workflows/release.yml --secret GITHUB_TOKEN=${GITHUB_TOKEN} --actor $GITHUB_USER --eventpath .github/workflows/act/event-release.json

# Sanity check
echo "🧪🧪🧪 Sanity Check 🧪🧪🧪"
set -e
if [ -z $GITHUB_TOKEN ] ; then
  echo "GITHUB_TOKEN not set"
  exit 1
fi

if [ -z $GITHUB_USER ] ; then
  echo "GITHUB_USER not set"
  exit 1
fi

# Not running this in ACT
if [ -z "$ACT" ]; then
  echo "Not running in act"
else
  echo "⚠️ Skipping steps when running in act"
fi

echo "🧪🧪🧪 Testing act --list 🧪🧪🧪"
act --list
act push --list
act push --list --eventpath .github/workflows/act/event-release.json

echo "🧪🧪🧪 Testing act --dryrun 🧪🧪🧪"
act --workflows .github/workflows/release.yml --dryrun

echo "🧪🧪🧪 Testing  triggers 🧪🧪🧪"
echo "❓ Check if version is set"
export RESULT=$(act push \
--workflows .github/workflows/release.yml \
--secret GITHUB_TOKEN=${GITHUB_TOKEN} \
--actor $GITHUB_USER \
--eventpath .github/workflows/act/event-release.json 2>&1)

# This test should not return an error
if [[ ${RESULT,,} == *"failure"* || ${RESULT,,} == *"error"* ]]; then
  echo "❌ Release workflow: The run failed"
  echo -e "Result of run: \n ${RESULT}"
  exit 1
else
  echo "✅ Release workflow"
  echo "$RESULT" | grep -o "RELEASE_VERSION: [^ ]*"
  echo "$RESULT"
fi

echo "❓ Check if we catch no version set"
export RESULT=$(act push \
--workflows .github/workflows/release.yml \
--secret GITHUB_TOKEN=${GITHUB_TOKEN} \
--actor $GITHUB_USER \
--eventpath .github/workflows/act/event-release-error.json 2>&1)

# This should fail
if [[ ${RESULT,,} == *"failure"* || ${RESULT,,} == *"error"* ]]; then
  echo "✅ Release workflow successfully failed"
else
  echo "❌ Release workflow: The did not fail"
  echo -e "Result of run: \n ${RESULT}"
  exit 1
fi
